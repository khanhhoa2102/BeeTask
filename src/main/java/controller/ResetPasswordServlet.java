
import context.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || newPassword == null || confirmPassword == null ||
            token.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("message", "❌ Thiếu thông tin bắt buộc.");
            request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "❌ Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT UserId, ExpiryTime, IsUsed FROM TokenForgetPassword WHERE Token = ?");
            checkStmt.setString(1, token);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                boolean isUsed = rs.getBoolean("IsUsed");
                Timestamp expiry = rs.getTimestamp("ExpiryTime");

                if (isUsed || expiry.before(new Timestamp(System.currentTimeMillis()))) {
                    request.setAttribute("message", "❌ Token không hợp lệ hoặc đã hết hạn.");
                    request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
                    return;
                }

                int userId = rs.getInt("UserId");
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                // Cập nhật mật khẩu
                PreparedStatement updatePwd = conn.prepareStatement("UPDATE Users SET PasswordHash = ? WHERE UserId = ?");
                updatePwd.setString(1, hashedPassword);
                updatePwd.setInt(2, userId);
                updatePwd.executeUpdate();

                // Đánh dấu token đã dùng
                PreparedStatement markUsed = conn.prepareStatement("UPDATE TokenForgetPassword SET IsUsed = 1 WHERE Token = ?");
                markUsed.setString(1, token);
                markUsed.executeUpdate();

                response.sendRedirect("Login.jsp?msg=reset_success");
            } else {
                request.setAttribute("message", "❌ Token không tồn tại.");
                request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
        }
    }
}

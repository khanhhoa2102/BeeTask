package controller;

import context.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String token = session != null ? (String) session.getAttribute("resetToken") : null;

        System.out.println("[GET] >> Session resetToken: " + token);
        if (token == null || token.isEmpty()) {
            request.setAttribute("message", "❌ Token không hợp lệ.");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        } else {
            request.setAttribute("token", token); // truyền sang JSP nếu cần
            request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String token = session != null ? (String) session.getAttribute("resetToken") : null;
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        System.out.println("[POST] >> Received token: " + token);
        System.out.println("[POST] >> New Password: " + newPassword);

        if (token == null || newPassword == null || confirmPassword == null
                || token.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("message", "❌ Thiếu thông tin bắt buộc.");
            request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "❌ Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT UserId, ExpiryTime, IsUsed FROM TokenForgetPassword WHERE Token = ?"
            );
            checkStmt.setString(1, token);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                boolean isUsed = rs.getBoolean("IsUsed");
                Timestamp expiry = rs.getTimestamp("ExpiryTime");

                if (isUsed || expiry.before(new Timestamp(System.currentTimeMillis()))) {
                    request.setAttribute("message", "❌ Token không hợp lệ hoặc đã hết hạn.");
                    request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
                    return;
                }

                int userId = rs.getInt("UserId");

               
                PreparedStatement updatePwd = conn.prepareStatement(
                    "UPDATE Users SET PasswordHash = ? WHERE UserId = ?"
                );
                updatePwd.setString(1, newPassword); // Plain password
                updatePwd.setInt(2, userId);
                updatePwd.executeUpdate();

                PreparedStatement markUsed = conn.prepareStatement(
                    "UPDATE TokenForgetPassword SET IsUsed = 1 WHERE Token = ?"
                );
                markUsed.setString(1, token);
                markUsed.executeUpdate();

                session.removeAttribute("resetToken");
                System.out.println("✅ Password updated for UserId: " + userId);

                response.sendRedirect("Login.jsp?msg=reset_success");
            } else {
                request.setAttribute("message", "❌ Token không tồn tại.");
                request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
        }
    }
}

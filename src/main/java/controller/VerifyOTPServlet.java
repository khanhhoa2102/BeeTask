package controller;

import context.DBConnection;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;
import java.sql.*;
import java.util.UUID;

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verify-code"})
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputCode = request.getParameter("verificationCode");
        HttpSession session = request.getSession(false);

        if (session == null) {
            request.setAttribute("message", "❌ Phiên làm việc không hợp lệ.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        String sessionOTP = (String) session.getAttribute("otp");
        Timestamp otpExpiry = (Timestamp) session.getAttribute("otpExpiry");
        String purpose = (String) session.getAttribute("otpPurpose");

        if (sessionOTP == null || otpExpiry == null || inputCode == null || purpose == null) {
            request.setAttribute("message", "❌ Thiếu dữ liệu để xác minh.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        if (new Timestamp(System.currentTimeMillis()).after(otpExpiry)) {
            request.setAttribute("message", "❌ Mã OTP đã hết hạn.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        if (!sessionOTP.trim().equals(inputCode.trim())) {
            request.setAttribute("message", "❌ Mã OTP không chính xác.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        if ("register".equals(purpose)) {
            // ✅ Luồng đăng ký
            try {
                String name = (String) session.getAttribute("name");
                String email = (String) session.getAttribute("email");
                String password = (String) session.getAttribute("password");

                if (name == null || email == null || password == null) {
                    request.setAttribute("message", "❌ Thiếu thông tin người dùng.");
                    request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
                    return;
                }

                User user = new User();
                user.setUsername(name);
                user.setEmail(email);
                user.setPasswordHash(password); // nếu đã hash sẵn từ trước
                user.setLoginProvider("Local");
                user.setEmailVerified(true);
                user.setActive(true);

                UserDAO dao = new UserDAO();
                dao.insert(user);

                // 🟢 Dọn dẹp session nhưng vẫn giữ lại để set thông báo
                session.removeAttribute("otp");
                session.removeAttribute("otpExpiry");
                session.removeAttribute("otpPurpose");
                session.removeAttribute("name");
                session.removeAttribute("email");
                session.removeAttribute("password");

                // 🟢 Đặt thông báo đăng ký thành công vào session và redirect
                session.setAttribute("successMessage", "🎉 Login successfull!");
                response.sendRedirect("Authentication/Login.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "❌ Lỗi khi đăng ký người dùng.");
                request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            }
        } else if ("forgot-password".equals(purpose)) {
            // ✅ Luồng quên mật khẩu
            String resetEmail = (String) session.getAttribute("resetEmail");
            if (resetEmail == null) {
                request.setAttribute("message", "❌ Can't not find email.");
                request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement getUserStmt = conn.prepareStatement("SELECT UserId FROM Users WHERE Email = ?");
                getUserStmt.setString(1, resetEmail);
                ResultSet rs = getUserStmt.executeQuery();

                if (!rs.next()) {
                    request.setAttribute("message", "❌ Người dùng không tồn tại.");
                    request.getRequestDispatcher("Authentication/EnterOTP.js12p").forward(request, response);
                    return;
                }

                int userId = rs.getInt("UserId");
                String token = UUID.randomUUID().toString();
                Timestamp expiry = new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000);

                PreparedStatement insertToken = conn.prepareStatement(
                        "INSERT INTO TokenForgetPassword (Token, ExpiryTime, IsUsed, UserId) VALUES (?, ?, 0, ?)");
                insertToken.setString(1, token);
                insertToken.setTimestamp(2, expiry);
                insertToken.setInt(3, userId);
                insertToken.executeUpdate();

                session.removeAttribute("otp");
                session.removeAttribute("otpExpiry");
                session.setAttribute("resetToken", token);

                response.sendRedirect("reset-password");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "❌ Lỗi hệ thống.");
                request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("message", "❌ Mục đích OTP không hợp lệ.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
        }
    }
}

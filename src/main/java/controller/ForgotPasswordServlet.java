package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import context.DBConnection;
import utils.EmailSender;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private static final int OTP_EXPIRY_MINUTES = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/ForgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "❌ Vui lòng nhập email!");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement checkStmt = conn.prepareStatement("SELECT UserId FROM Users WHERE Email = ?")) {

            checkStmt.setString(1, email.trim());
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("UserId");

                    // Sinh mã OTP và thời gian hết hạn
                    EmailSender sender = new EmailSender();
                    String otp = sender.getRandom();
                    Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + OTP_EXPIRY_MINUTES * 60 * 1000);

                    // Lưu OTP vào session
                    HttpSession session = request.getSession();
                    session.setAttribute("otp", otp);
                    session.setAttribute("otpExpiry", expiryTime);
                    session.setAttribute("resetEmail", email);

                    // Gửi mã OTP đến email
                    boolean emailSent = EmailSender.sendOTP(email, otp);

                    if (emailSent) {
                        request.setAttribute("message", "✅ Mã OTP đã được gửi đến email của bạn!");
                        request.getRequestDispatcher("EnterOTP.jsp").forward(request, response);
                    } else {
                        request.setAttribute("message", "❌ Gửi email thất bại. Vui lòng thử lại!");
                        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("message", "❌ Email không tồn tại trong hệ thống!");
                    request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        }
    }
}

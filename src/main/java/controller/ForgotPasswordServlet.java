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
        response.sendRedirect(request.getContextPath() + "/Authentication/ForgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "❌ Please enter your email address.");
            request.getRequestDispatcher("Authentication/ForgotPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement("SELECT UserId FROM Users WHERE Email = ?")) {

            checkStmt.setString(1, email.trim());
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("UserId");

                    // Generate OTP and expiry
                    String otp = EmailSender.getRandom();
                    Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + OTP_EXPIRY_MINUTES * 60 * 1000);

                    // Store in session
                    HttpSession session = request.getSession();
                    session.setAttribute("otp", otp);
                    session.setAttribute("otpExpiry", expiryTime);
                    session.setAttribute("resetEmail", email);
                    session.setAttribute("otpPurpose", "forgot-password");

                    // Send OTP email
                    boolean emailSent = EmailSender.sendOTP(email, otp);

                    if (emailSent) {
                        request.setAttribute("message", "✅ OTP has been sent to your email address.");
                        request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
                    } else {
                        request.setAttribute("message", "❌ Failed to send OTP. Please try again.");
                        request.getRequestDispatcher("Authentication/ForgotPassword.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("message", "❌ The email address does not exist in our system.");
                    request.getRequestDispatcher("Authentication/ForgotPassword.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ A system error occurred. Please try again later.");
            request.getRequestDispatcher("Authentication/ForgotPassword.jsp").forward(request, response);
        }
    }
}

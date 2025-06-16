package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import utils.EmailSender;

@WebServlet(name = "ResendOTPServlet", urlPatterns = {"/resend-otp"})
public class ResendOTPServlet extends HttpServlet {

    private static final int OTP_EXPIRY_MINUTES = 10;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("resetEmail") == null) {
            out.print("{\"success\": false, \"message\": \"Session expired. Please try again.\"}");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String otp = new EmailSender().getRandom();
        Timestamp expiry = new Timestamp(System.currentTimeMillis() + OTP_EXPIRY_MINUTES * 60 * 1000);

        // Cập nhật session
        session.setAttribute("otp", otp);
        session.setAttribute("otpExpiry", expiry);

        boolean sent = EmailSender.sendOTP(email, otp);

        if (sent) {
            out.print("{\"success\": true, \"message\": \"OTP resent successfully!\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"Failed to resend OTP. Try again later.\"}");
        }
    }
}

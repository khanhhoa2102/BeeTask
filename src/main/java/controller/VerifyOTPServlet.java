package controller;

import context.DBConnection;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

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
            request.setAttribute("message", "❌ Invalid session.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        String sessionOTP = (String) session.getAttribute("otp");
        Timestamp otpExpiry = (Timestamp) session.getAttribute("otpExpiry");
        String purpose = (String) session.getAttribute("otpPurpose");

        if (sessionOTP == null || otpExpiry == null || inputCode == null || purpose == null) {
            request.setAttribute("message", "❌ Missing verification data.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        if (new Timestamp(System.currentTimeMillis()).after(otpExpiry)) {
            request.setAttribute("message", "❌ OTP has expired.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        if (!sessionOTP.trim().equals(inputCode.trim())) {
            request.setAttribute("message", "❌ Invalid OTP code.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            return;
        }

        if ("register".equals(purpose)) {
            try {
                String name = (String) session.getAttribute("name");
                String email = (String) session.getAttribute("email");
                String rawPassword = (String) session.getAttribute("password");

                if (name == null || email == null || rawPassword == null) {
                    request.setAttribute("message", "❌ Missing user information.");
                    request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
                    return;
                }

                // ✅ Hash password with BCrypt
                String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());

                User user = new User();
                user.setUsername(name);
                user.setEmail(email);
                user.setPasswordHash(hashedPassword);
                user.setLoginProvider("Local");
                user.setEmailVerified(true);
                user.setActive(true);

                new UserDAO().insert(user);

                // 🧹 Clean session
                session.removeAttribute("otp");
                session.removeAttribute("otpExpiry");
                session.removeAttribute("otpPurpose");
                session.removeAttribute("name");
                session.removeAttribute("email");
                session.removeAttribute("password");

                session.setAttribute("successMessage", "🎉 Registration successful! You can now log in.");
                response.sendRedirect("Authentication/Login.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "❌ Error while creating account.");
                request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            }

        } else if ("forgot-password".equals(purpose)) {
            String resetEmail = (String) session.getAttribute("resetEmail");
            if (resetEmail == null) {
                request.setAttribute("message", "❌ Cannot find email.");
                request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement getUserStmt = conn.prepareStatement("SELECT UserId FROM Users WHERE Email = ?");
                getUserStmt.setString(1, resetEmail);
                ResultSet rs = getUserStmt.executeQuery();

                if (!rs.next()) {
                    request.setAttribute("message", "❌ User not found.");
                    request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
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
                request.setAttribute("message", "❌ System error occurred.");
                request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("message", "❌ Invalid OTP purpose.");
            request.getRequestDispatcher("Authentication/EnterOTP.jsp").forward(request, response);
        }
    }
}

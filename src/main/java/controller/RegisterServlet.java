package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import utils.EmailSender;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO userDAO = new UserDAO();
            if (userDAO.isEmailExist(email)) {
                request.setAttribute("emailError", "This email is already registered.");
                request.setAttribute("name", name);
                request.setAttribute("email", email);
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            // Send OTP
            String otp = EmailSender.getRandom();
            boolean mailSent = EmailSender.sendOTP(email, otp);

            if (!mailSent) {
                request.setAttribute("emailError", "Failed to send OTP. Please try again.");
                request.setAttribute("name", name);
                request.setAttribute("email", email);
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            // Store info in session
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("otpExpiry", new java.sql.Timestamp(System.currentTimeMillis() + 10 * 60 * 1000));
            session.setAttribute("otpPurpose", "register");
            session.setAttribute("name", name);
            session.setAttribute("email", email);
            session.setAttribute("password", password);

            response.sendRedirect("EnterOTP.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}

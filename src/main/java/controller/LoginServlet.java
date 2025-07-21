package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Authentication/Login.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.findByEmail(email); // ✅ chỉ lấy user theo email

            if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {
                if (!user.isActive()) {
                    request.setAttribute("errorMessage", "Your account has been locked.");
                    request.getRequestDispatcher("Authentication/Login.jsp").forward(request, response);
                    return;
                }

                if (!user.isEmailVerified()) {
                    request.setAttribute("errorMessage", "Your email has not been verified. Please check your inbox.");
                    request.getRequestDispatcher("Authentication/Login.jsp").forward(request, response);
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("loginPassword", password);
              
            
            // ✅ Chuyển hướng tùy theo vai trò
                if ("Admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/user-stats");
                } else {
                    response.sendRedirect(request.getContextPath() + "/Home/Home.jsp");
                }

            
            
            
            
            
            } else {
                request.setAttribute("errorMessage", "Incorrect email or password. Please try again.");
                request.getRequestDispatcher("Authentication/Login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again later.");
            request.getRequestDispatcher("Authentication/Login.jsp").forward(request, response);
        }
    }
}

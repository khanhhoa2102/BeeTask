package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user); // lưu vào session
                response.sendRedirect(request.getContextPath() + "/Home/TemplateHome.jsp");
            } else {
                request.setAttribute("errorMessage", "Sai email hoặc mật khẩu!");
                request.getRequestDispatcher("Login.jsp").forward(request, response); // quay lại login.jsp
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}

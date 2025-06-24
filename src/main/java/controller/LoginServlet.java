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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.login(email, password);

            if (user != null) {
                if (!user.isActive()) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa.");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                    return;
                }

                if (!user.isEmailVerified()) {
                    request.setAttribute("errorMessage", "Email chưa được xác thực. Vui lòng kiểm tra hộp thư.");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("loginPassword", password); 
                response.sendRedirect(request.getContextPath() + "/Home/Home.jsp");

            } else {
                request.setAttribute("errorMessage", "Sai email hoặc mật khẩu.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}

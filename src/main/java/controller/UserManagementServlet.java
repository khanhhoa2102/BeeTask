package controller;

import dao.UserManagementDao;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;



@WebServlet("/UserManagementServlet")

public class UserManagementServlet extends HttpServlet {

    private UserManagementDao dao;

    @Override
    public void init() throws ServletException {
        dao = new UserManagementDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");

    List<User> allUsers;
    if (keyword != null && !keyword.trim().isEmpty()) {
        allUsers = dao.searchUsers(keyword.trim());  // THÊM HÀM NÀY DƯỚI DAO
    } else {
        allUsers = dao.getAllUsers();
    }

    List<User> lockedUsers = dao.getLockedUsers();

    req.setAttribute("allUsers", allUsers);
    req.setAttribute("lockedUsers", lockedUsers);
    req.setAttribute("keyword", keyword); // để hiện lại từ khóa trong ô input
    req.getRequestDispatcher("UserManagement.jsp").forward(req, resp);
        
        
        
//        List<User> allUsers = dao.getAllUsers();
//        List<User> lockedUsers = dao.getLockedUsers();

//        req.setAttribute("allUsers", allUsers);
//        req.setAttribute("lockedUsers", lockedUsers);
//        req.getRequestDispatcher("UserManagement.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userIdStr = req.getParameter("userId");
        String action = req.getParameter("action");

        try {
            int userId = Integer.parseInt(userIdStr);
            boolean isActive = action.equals("unlock");
            dao.updateUserStatus(userId, isActive);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        resp.sendRedirect("UserManagementServlet");
    }
}

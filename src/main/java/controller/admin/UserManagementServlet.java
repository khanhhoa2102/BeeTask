package controller.admin;

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
            allUsers = dao.searchUsers(keyword.trim());
        } else {
            allUsers = dao.getAllUsers();
        }

        List<User> lockedUsers = dao.getLockedUsers();

        req.setAttribute("allUsers", allUsers);
        req.setAttribute("lockedUsers", lockedUsers);
        req.setAttribute("keyword", keyword); // để hiển thị lại từ khóa khi tìm kiếm

        req.getRequestDispatcher("/Admin/UserManagement.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userIdStr = req.getParameter("userId");
        String action = req.getParameter("action");

        if (userIdStr != null && action != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                boolean isActive = action.equalsIgnoreCase("unlock"); // unlock: true, lock: false
                dao.updateUserStatus(userId, isActive);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                // Có thể log hoặc chuyển sang trang lỗi
            }
        }

        resp.sendRedirect("UserManagementServlet");
    }
}

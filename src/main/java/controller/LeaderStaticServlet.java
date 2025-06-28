package controller;

import dao.ProjectOverviewDao;
import model.ProjectOverview;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/leaderstaticservlet")
public class LeaderStaticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

//        // 👉 Nếu chưa đăng nhập, tạo user test tạm thời
//        if (user == null) {
//            user = new User();
//            user.setUserId(1); // ID của leader thật trong DB
//            user.setUsername("testleader");
//            session.setAttribute("user", user);
//        }

        int leaderUserId = user.getUserId();

        try {
            ProjectOverviewDao dao = new ProjectOverviewDao();
            List<ProjectOverview> overviewList = dao.getProjectsByLeaderId(leaderUserId);

            request.setAttribute("overviewList", overviewList);
            request.getRequestDispatcher("Static.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể load dữ liệu Leader overview.");
        }
    }
}

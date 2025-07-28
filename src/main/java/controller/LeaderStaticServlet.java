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
import java.util.ArrayList;
import java.util.List;




@WebServlet(name = "LeaderStaticServlet", urlPatterns = {"/leaderstaticservlet"})
public class LeaderStaticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getUserId();

        try {
            ProjectOverviewDao dao = new ProjectOverviewDao();

            // Lấy tất cả các dự án user tham gia, không phân biệt vai trò
            List<ProjectOverview> overviewList = dao.getAllProjectsByUser(userId);

            request.setAttribute("overviewList", overviewList);
            request.getRequestDispatcher("Home/Statistic.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không thể load dữ liệu dự án.");
        }
    }
}





























//@WebServlet("/leaderstaticservlet")
//public class LeaderStaticServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//
//        if (user == null) {
//            response.sendRedirect("login.jsp");
//            return;
//        }
//
//        int userId = user.getUserId();
//        String userRole = user.getRole(); // "User", "Premium", "Admin"
//
//        try {
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//            List<ProjectOverview> overviewList = new ArrayList<>();
//
//            List<String> rolesInProject = dao.getUserRolesInProjects(userId);
//
//            if ("Premium".equals(userRole)) {
//                if (rolesInProject.contains("Leader")) {
//                    overviewList.addAll(dao.getProjectsByUserAndRole(userId, "Leader"));
//                }
//                if (rolesInProject.contains("Member")) {
//                    overviewList.addAll(dao.getProjectsByUserAndRole(userId, "Member"));
//                }
//
//            } else if ("User".equals(userRole)) {
//                if (rolesInProject.contains("Leader")) {
//                    overviewList.addAll(dao.getProjectsByUserAndRole(userId, "Leader"));
//                } else if (rolesInProject.contains("Member")) {
//                    // User thường + Member → không có quyền xem
//                    request.setAttribute("errorMessage", "Bạn cần nâng cấp lên Premium để xem các dự án tham gia.");
//                }
//            }
//            
//            
//            
//            
//            System.out.println("UserId: " + userId);
//System.out.println("User Role: " + userRole);
//System.out.println("Roles in project: " + rolesInProject);
//System.out.println("Dự án trả về: " + overviewList.size());
//            
//            
//
//            request.setAttribute("overviewList", overviewList);
//            request.getRequestDispatcher("Home/Statistic.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
//                    "Không thể load dữ liệu dự án.");
//        }
//        
//      
//
//        
//      
//    }
//}
//
//
//
//
//
//
//













//package controller;
//
//import dao.ProjectOverviewDao;
//import model.ProjectOverview;
//import model.User;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/leaderstaticservlet")
//public class LeaderStaticServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//
//
//        int leaderUserId = user.getUserId();
//
//        try {
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//            List<ProjectOverview> overviewList = dao.getProjectsByLeaderId(leaderUserId);
//
//            request.setAttribute("overviewList", overviewList);
//            request.getRequestDispatcher("Home/Statistic.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể load dữ liệu Leader overview.");
//        }
//    }
//}

package controller.admin;

import dao.admin.UserStatsDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/user-stats")
public class UserStatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UserStatsDAO dao = new UserStatsDAO();  // DAO sẽ tự lấy Connection từ DBConnection
            List<Map<String, Object>> stats = dao.getWeeklyUserRegistrations(8); // lấy 8 tuần

            request.setAttribute("stats", stats);

            List<Map<String, Object>> projectStats = dao.getWeeklyProjectsCreated(8);
            request.setAttribute("projectStats", projectStats);

            
             // Lấy dữ liệu biểu đồ tròn: Active/Blocked theo Role
            Map<String, Integer> userStatusPieData = dao.getUserStatusDistribution();
            request.setAttribute("userStatusPieData", userStatusPieData);
           
            
            
            
            
            
            
            
            
            
            
            List<String> weekLabels = stats.stream()
    .map(row -> row.get("week").toString())
    .collect(Collectors.toList());

List<Integer> userCounts = stats.stream()
    .map(row -> (Integer) row.get("userCount"))
    .collect(Collectors.toList());

List<Integer> premiumCounts = stats.stream()
    .map(row -> (Integer) row.get("premiumCount"))
    .collect(Collectors.toList());

request.setAttribute("weekLabels", weekLabels);
request.setAttribute("userCounts", userCounts);
request.setAttribute("premiumCounts", premiumCounts);

            
            
            
            
            
            
            
            
            
            
            //biểu đồ tròn số dự án bị khóa và mở
            Map<String, Integer> projectLockStatusData = dao.getProjectLockStatusDistribution();
request.setAttribute("projectLockStatusData", projectLockStatusData);
            



Map<String, Integer> userSummaryStats = dao.getUserSummaryStats();
request.setAttribute("userSummaryStats", userSummaryStats);

            





Map<String, Integer> projectSummaryStats = dao.getProjectSummaryStats();
request.setAttribute("projectSummaryStats", projectSummaryStats);

            
            request.getRequestDispatcher("/Admin/SystemAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("DB error: " + e.getMessage(), e);
        }
    }
}

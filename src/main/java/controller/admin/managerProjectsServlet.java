package controller.admin;

import dao.ProjectOverviewDao;
import model.ProjectOverview;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet("/allprojects")
public class managerProjectsServlet extends HttpServlet {
    private final ProjectOverviewDao projectDao = new ProjectOverviewDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Xử lý hành động khóa/mở nếu có
            String action = request.getParameter("action");
            String projectIdParam = request.getParameter("projectId");

            if (action != null && projectIdParam != null) {
                int projectId = Integer.parseInt(projectIdParam);
                if ("lock".equalsIgnoreCase(action)) {
                    projectDao.setProjectLockStatus(projectId, true);  //  khóa
                } else if ("unlock".equalsIgnoreCase(action)) {
                    projectDao.setProjectLockStatus(projectId, false); // mở khóa
                }
            }

            // Lấy danh sách tất cả các dự án cho admin
            List<ProjectOverview> allProjects = projectDao.getAllProjectsBasicForAdmin();
            
            
            
            
                        
            
            
            
            
            
            
            //Tiềm kiếm  và lọc
          // Xử lý tìm kiếm / lọc
        String keyword = request.getParameter("keyword");
        String lockStatus = request.getParameter("status");

      
        if ((keyword != null && !keyword.isEmpty()) || (lockStatus != null && !lockStatus.isEmpty())) {
            allProjects = projectDao.searchProjectsForAdmin(keyword, lockStatus);
        } else {
            allProjects = projectDao.getAllProjectsBasicForAdmin();
        }
            
            
            
            
            
            
            

            request.setAttribute("projects", allProjects);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Admin/ManagementProject.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading projects");
        }
    }
    
    
    
    
    @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            boolean isLocked = Boolean.parseBoolean(request.getParameter("isLocked"));

            projectDao.setProjectLockStatus(projectId, isLocked);
            response.sendRedirect("allprojects"); // quay lại trang danh sách
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to update lock status.");
        }
    }

}
package controller;

import dao.ProjectDAO;
import model.Project;
import model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet("/project")
public class ProjectController extends HttpServlet {
    private final ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Authentication/Login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createProject(request, user);
                    break;
                case "update":
                    updateProject(request, user);
                    break;
                case "delete":
                    deleteProject(request, user);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace(); // You can improve this by logging
        }

        response.sendRedirect("Projects.jsp");
    }

    private void createProject(HttpServletRequest request, User user) throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        if (name != null && !name.trim().isEmpty()) {
            Project project = new Project();
            project.setName(name);
            project.setDescription(description);
            project.setCreatedBy(user.getUserId());

            int projectId = projectDAO.insert(project);  // Lấy ID vừa insert
            if (projectId != -1) {
                projectDAO.addProjectMember(projectId, user.getUserId(), "Leader");  // Gán quyền Leader
            }
        }
    }

    private void updateProject(HttpServletRequest request, User user) throws Exception {
        int id = Integer.parseInt(request.getParameter("projectId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Project project = projectDAO.getProjectById(id);
        if (project != null && project.getCreatedBy() == user.getUserId()) {
            project.setName(name);
            project.setDescription(description);
            projectDAO.update(project);
        }
    }

    private void deleteProject(HttpServletRequest request, User user) throws Exception {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        System.out.println("🔔 Received delete request for projectId = " + projectId);

        if (projectDAO.isLeaderOfProject(user.getUserId(), projectId)) {
            System.out.println("✅ User is project leader. Proceeding to delete...");
            try {
                projectDAO.delete(projectId);
            } catch (Exception e) {
                System.err.println("❌ Error during deletion: " + e.getMessage());
                throw new Exception("Failed to delete project. Please try again.");
            }
        } else {
            System.out.println("🚫 User is not the leader of this project. Deletion denied.");
            throw new SecurityException("You don't have permission to delete this project!");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        if ("getMembers".equals(action)) {
            String rawProjectId = request.getParameter("projectId");

            try {
                int projectId = Integer.parseInt(rawProjectId);

                // Lấy danh sách thành viên từ DAO
                var members = projectDAO.getMembersByProjectId(projectId); // Bạn cần tạo hàm này

                // Trả JSON về client
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                new com.google.gson.Gson().toJson(members, response.getWriter());

            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

}

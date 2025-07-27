package dao;

import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Project;
import model.ProjectNotification;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ManageNotificationServlet", urlPatterns={"/managenotifications"})
public class ManageNotificationServlet extends HttpServlet {
    
    private ProjectNotificationDAO projectNotificationDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        projectNotificationDAO = new ProjectNotificationDAO();
        projectDAO = new ProjectDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            switch (action) {
                case "add": {
                    int projectId = Integer.parseInt(request.getParameter("projectId"));
                    String message = request.getParameter("message");

                    ProjectNotification notification = new ProjectNotification();
                    notification.setProjectId(projectId);
                    notification.setMessage(message);
                    notification.setCreatedAt(new Timestamp(System.currentTimeMillis()));

                    projectNotificationDAO.addProjectNotification(notification);
                    break;
                }
                
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String message = request.getParameter("message");

                    ProjectNotification notification = new ProjectNotification();
                    notification.setProjectNotificationId(id);
                    notification.setMessage(message);

                    projectNotificationDAO.editNotification(notification);
                    break;
                }


                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    projectNotificationDAO.deleteNotificationById(id);
                    break;
                }

                case "getByProjectId": {
                    int projectId = Integer.parseInt(request.getParameter("projectId"));
                    List<ProjectNotification> notifications = projectNotificationDAO.getNotificationsByProjectId(projectId);
                    String json = new Gson().toJson(notifications);
                    response.getWriter().write(json);
                    break;
                }
                
                case "getByCreatedUser": {
                    List<Project> projects = projectDAO.getProjectsByLeaderId(userId);

                    Map<String, Object> responseMap = new LinkedHashMap<>();

                    for (Project p : projects) {
                        Map<String, Object> entry = new LinkedHashMap<>();
                        entry.put("projectId", p.getProjectId());
                        entry.put("notifications", projectNotificationDAO.getNotificationsByProjectId(p.getProjectId()));
                        responseMap.put(p.getName(), entry);
                    }

                    String json = new Gson().toJson(responseMap);
                    response.getWriter().write(json);
                    break;
                }


                default:
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    } 

}

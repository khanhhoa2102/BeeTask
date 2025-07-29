/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.ProjectNotificationDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
import model.ProjectNotification;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ProjectNotificationServlet", urlPatterns={"/projectnotifications"})
public class ProjectNotificationServlet extends HttpServlet {
   
    private ProjectNotificationDAO projectNotificationDAO;

    @Override
    public void init() {
        projectNotificationDAO = new ProjectNotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
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
                case "markRead": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    projectNotificationDAO.markAsRead(userId, id);
                    break;
                }

                case "markUnread": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    projectNotificationDAO.markAsUnread(userId, id);
                    break;
                }

                case "markAllRead": {
                    projectNotificationDAO.markAllAsRead(userId);
                    break;
                }

                case "markAllUnread": {
                    projectNotificationDAO.markAllAsUnread(userId);
                    break;
                }

                case "deleteByUser": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    projectNotificationDAO.deleteNotificationByUser(userId, id);
                    break;
                }
                
                case "getTotalUnread":{
                    int total = projectNotificationDAO.getTotalUnreadCount(userId);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    String json = "{\"unreadCount\":" + total + "}";
                    response.getWriter().write(json);
                    break;
                }

                case "getByUserId": {
                    List<ProjectNotification> notifications = projectNotificationDAO.getNotificationsByUserId(userId);
                    Map<String, Object> responseMap = new LinkedHashMap<>();
                    for (ProjectNotification n : notifications) {
                        Map<String, Object> entry = new LinkedHashMap<>();
                        entry.put("notifications", notifications);
                        int pId = projectNotificationDAO.getProjectIdByNotificationId(n.getProjectNotificationId());
                        String pName = projectNotificationDAO.getProjectNameByProjectId(pId);
                        responseMap.put(pName, entry);
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

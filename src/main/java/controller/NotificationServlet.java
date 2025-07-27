/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.google.gson.Gson;
import dao.NotificationDAO;
import model.Notification;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="NotificationServlet", urlPatterns={"/notifications"})
public class NotificationServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        response.setContentType("application/json");
        Gson gson = new Gson();

        switch (action) {
            case "view":
            case "refresh": {
                List<Notification> notifications = notificationDAO.getNotificationsByUserId(userId);
                String json = gson.toJson(notifications);
                response.getWriter().write(json);
                break;
            }
            
            case "viewall": {
                List<Notification> allNotifications = notificationDAO.getAllNotifications();
                String json = gson.toJson(allNotifications);
                response.getWriter().write(json);
                break;
            }

            case "markAsRead": {
                int notificationId = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markAsRead(notificationId);
                response.getWriter().write("OK");
                break;
            }
            case "markAsUnread": {
                int notificationId = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markAsUnread(notificationId);
                response.getWriter().write("OK");
                break;
            }

            case "create": {
                int targetId = Integer.parseInt(request.getParameter("targetId"));
                String message = request.getParameter("message");
                Notification n = new Notification();
                n.setUserId(targetId);
                n.setMessage(message);
                n.setIsRead(false);
                n.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

                notificationDAO.addNotification(n);

                response.getWriter().write("{\"status\":\"created\"}");
                break;
            }
            
            case "edit": {
                int id = Integer.parseInt(request.getParameter("notificationId"));
                String newMessage = request.getParameter("message");

                Notification existing = notificationDAO.getNotificationById(id);
                if (existing != null) {
                    existing.setMessage(newMessage);
                    notificationDAO.updateNotification(existing);
                    response.getWriter().write("{\"status\":\"updated\"}");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notification not found");
                }
                break;
            }
            
            case "delete": {
                int notificationId = Integer.parseInt(request.getParameter("id"));
                notificationDAO.deleteNotification(notificationId);
                response.getWriter().write("OK");
                break;
            }


            default: {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
            }
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

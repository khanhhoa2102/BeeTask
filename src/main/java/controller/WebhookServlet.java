/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import dao.NotificationDAO;
import model.Notification;
import dao.UserDAO;
import java.io.IOException;
import java.util.stream.Collectors;
import java.sql.Timestamp;
/**
 *
 * @author ADMIN
 */
@WebServlet(name="WebhookServlet", urlPatterns={"/webhook"})
public class WebhookServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet WebhookServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet WebhookServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Step 1: Read raw request body
        String body = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        System.out.println("🔔 Webhook received:\n" + body);

        // Step 2: Parse JSON
        JSONObject root = new JSONObject(body);
        JSONObject data = root.getJSONObject("data");

        // Step 4: Extract payment data
        long orderCode = data.getLong("orderCode");
        String statusCode = data.getString("code"); // "00" = success
        String desc = data.optString("description");

        if ("00".equals(statusCode) && orderCode!=123) {
            try{
                int id = Integer.parseInt(desc.split(" ")[5]);
                System.out.println("✅ Order " + orderCode + " marked as PAID: " + desc);
                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                new NotificationDAO().addNotification(new Notification(0, id, "You have become a premium user", false, timestamp));
                new UserDAO().updateRole(id);
            } catch(Exception e){

            }
        } else {
            System.out.println("⚠️ Payment failed or pending. Code: " + statusCode + " - " + desc);
        }

        // Step 5: Acknowledge webhook
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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

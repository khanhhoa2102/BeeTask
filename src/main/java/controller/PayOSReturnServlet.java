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
import dao.PayOSDAO;
import model.Notification;
import dao.UserDAO;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
/**
 *
 * @author ADMIN
 */
@WebServlet(name="ReturnServlet", urlPatterns={"/return"})
public class PayOSReturnServlet extends HttpServlet {
   
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            String orderCodeStr = request.getParameter("orderCode");
            if (orderCodeStr == null) {
                response.getWriter().write("❌ Missing orderCode");
                return;
            }
            
            long orderCode = Long.parseLong(orderCodeStr);
            PayOSDAO payos = new PayOSDAO();
            String jsonResponse = payos.getPayOSOrderStatus(orderCode);
            
            JSONObject json = new JSONObject(jsonResponse);
            String status = json.getJSONObject("data").getString("status");
            
            if ("PAID".equalsIgnoreCase(status)) {
                response.getWriter().write("✅ Payment successful!");
                int id = (int) session.getAttribute("userId");
                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                new NotificationDAO().addNotification(new Notification(0, id, "You have become a premium user", false, timestamp));
                new UserDAO().updateRole(id);
                
                session.removeAttribute("user");
                UserDAO dao = new UserDAO();
                User updatedUser = dao.findById(id);
                session.setAttribute("user", updatedUser);
                System.out.println(updatedUser.getRole());
            } else {
                response.getWriter().write("❌ Payment failed or not completed. Status: " + status);
            }
            request.getRequestDispatcher("Home/Home.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(PayOSReturnServlet.class.getName()).log(Level.SEVERE, null, ex);
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

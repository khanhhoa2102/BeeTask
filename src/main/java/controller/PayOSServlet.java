/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.PrintWriter;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import dao.PayOSDAO;
import org.json.JSONObject;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="PayOSServlet", urlPatterns={"/payment"})
public class PayOSServlet extends HttpServlet {
   
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
            out.println("<title>Servlet PayOSServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PayOSServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Step 1: Get amount from request
            long amount = Long.parseLong(request.getParameter("amount")); // e.g., from form
            long orderCode = System.currentTimeMillis(); // unique ID for order
            HttpSession session = request.getSession();
            int id = (int)session.getAttribute("userId");
            String originalURL = request.getHeader("referer");
            session.setAttribute("returnUrl", originalURL);
            
            // Step 2: Define redirect URLs
            String returnUrl = "http://localhost:8080/BeeTask/return";
            String cancelUrl = "http://localhost:8080/BeeTask/Home/Home.jsp";
            
            // Step 3: Call PayOS API
            PayOSDAO payos = new PayOSDAO();
            String jsonResponse = payos.createPayOSOrder(orderCode, amount, returnUrl, cancelUrl, id);
            System.out.println("PayOS JSON response: " + jsonResponse);

            
            // Step 4: Get checkoutUrl
            JSONObject json = new JSONObject(jsonResponse);
            String checkoutUrl = json.getJSONObject("data").getString("checkoutUrl");
            
            // Step 5: Redirect user
            response.sendRedirect(checkoutUrl);
        } catch (IOException | InterruptedException ex) {
            Logger.getLogger(PayOSServlet.class.getName()).log(Level.SEVERE, null, ex);
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

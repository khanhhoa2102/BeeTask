/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="RefreshUserServlet", urlPatterns={"/refreshuser"})
public class RefreshUserServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            
            // Step 1: Remove old user attribute if it exists
            session.removeAttribute("user");
            
            // Step 2: Create the updated user (e.g., from database or based on session data)
            // Let's say you already know the user ID from session or webhook
            int userId = (int) session.getAttribute("userId");  // or retrieve from payment data
            UserDAO dao = new UserDAO(); // assuming you have a DAO class
            User updatedUser = dao.findById(userId);         // fetch latest info
            System.out.println(updatedUser.getRole());
            
            // Step 3: Set the updated user in session
            session.setAttribute("user", updatedUser);
            
            // Step 4: Forward to dashboard or success page
            request.getRequestDispatcher("Home/Home.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(RefreshUserServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    } 
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}

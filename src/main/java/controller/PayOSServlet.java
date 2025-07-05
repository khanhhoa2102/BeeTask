/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

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
    
    private static final String CLIENT_ID = "cb45fe26-130b-4787-bede-d416e4db40ea";
    private static final String API_KEY = "ae7f40b3-2cb2-4bc6-9476-8e87b50b2988";
    private static final String CHECKSUM_KEY = "ceb75266b7dc5063f44dfa3530d911ecf8ba15b0a9e0b5ec8677645d46a09ff8";

    private final PayOS payOS = new PayOS(CLIENT_ID, API_KEY, CHECKSUM_KEY);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String domain = "http://localhost:8080/BeeTask"; // Adjust to your project path

        // Generate a unique order code
        Long orderCode = System.currentTimeMillis() / 1000;

        // Build item information
        ItemData itemData = ItemData.builder()
                .name("Nâng cấp tài khoản VIP")
                .quantity(1)
                .price(2000)
                .build();

        // Build payment information
        PaymentData paymentData = PaymentData.builder()
                .orderCode(orderCode)
                .amount(2000)
                .description("Thanh toán đơn hàng")
                .returnUrl(domain + "/Home/Home.jsp")
                .cancelUrl(domain + "/LandingPage.jsp")
                .item(itemData)
                .build();

        // Create payment link via PayOS
        CheckoutResponseData result = null;
        try {
            result = payOS.createPaymentLink(paymentData);
        } catch (Exception ex) {
            Logger.getLogger(PayOSServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Redirect user to PayOS checkout page
        response.setStatus(HttpServletResponse.SC_SEE_OTHER); // 303 See Other
        response.setHeader("Location", result.getCheckoutUrl());
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

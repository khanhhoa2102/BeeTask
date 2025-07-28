<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="./Header.jsp"%>
        <title>VIP account</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/VIP.css">
    </head>
    <body class="dashboard-body">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="user-profile">
                    <div class="avatar">
                        <% if (headerUser.getAvatarUrl() != null && !headerUser.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= headerUser.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                        <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #ccc;"></div>
                        <% } %>
                    </div>
                    <div class="info">
                        <span class="username"><%= headerUser.getUsername() %></span>
                        <span class="email"><%= headerUser.getEmail() %></span>
                    </div>
                </div>

                <%@include file="./Sidebar.jsp"%>
                <%@include file="./Help.jsp" %>
            </aside>
            <main class="main-content">
                <div class="premium-container">
                    <div class="premium-card">
                        <h1>Upgrade to <span class="highlight">VIP</span></h1>
                        <p class="subtitle">Unlock powerful features to boost your productivity and workflow.</p>

                        <ul class="benefits">
                            <li>📄 Export reports as PDF</li>
                            <li>📊 Advanced progress analytics</li>
                            <li>🤖 Priority access to AI features</li>
                        </ul>

                        <form action="${pageContext.request.contextPath}/payment" method="post">
                            <input type="hidden" name="amount" value="2000" />
                            <button type="submit" class="payment-btn">Upgrade Now</button>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>

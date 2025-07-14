<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="./Header.jsp"%>
        <title>Manage Notifications</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ManageNotification.css">
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
                
                <h2>All Notifications</h2>

                <!-- Create form -->
                <form id="createForm" onsubmit="createNotification(event)">
                    <input type="number" id="targetIdInput" placeholder="User ID" required>
                    <input type="text" id="messageInput" placeholder="Enter message" required>
                    <button type="submit">Send Notification</button>
                </form>


                <!-- Notifications table -->
                <table id="notificationTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Message</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Populated by JavaScript -->
                    </tbody>
                </table>
            </main>
        </div>
        <script src="${pageContext.request.contextPath}/ManageNotification.js"></script>
    </body>
</html>

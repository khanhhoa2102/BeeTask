<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview, model.User" %>
<%@ include file="../session-check.jspf" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="HeaderAdmin.jsp" %>
    <title>All Projects - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/SystemAdmin.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
     <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="dashboard-body">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="user-profile">
                <div class="avatar">
                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                    <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #ccc;"></div>
                    <% } %>
                </div>
                <div class="info">
                    <span class="username"><%= user.getUsername() %></span>
                    <span class="email"><%= user.getEmail() %></span>
                </div>
            </div>

            <%@ include file="SidebarAdmin.jsp" %>
            <%@ include file="../Help.jsp" %>
        </aside>

            <!-- Main -->
            <main class="main-content">
                <h1>Dashboard</h1>

                <div class="stats">
                    <div class="stat-card">
                        <i class="fas fa-users"></i>
                        <div>
                            <h4>Total user</h4>
                            <p id="total-users">--</p>
                        </div>
                    </div>

                    

                    <div class="stat-card">
                        <i class="fas fa-chart-pie"></i>
                        <div>
                            <h4>Visitors</h4>
                            <p id="visits">--</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <i class="fas fa-user-lock"></i>
                        <div>
                            <h4>The account is locked</h4>
                            <p id="locked-users">--</p>
                        </div>
                    </div>
                </div>

                <div class="charts-row">
                    <div class="chart-section">
                        <h2>Number of new users by week</h2>
                        <canvas id="weeklyUsersChart"></canvas>
                    </div>
                    <div class="chart-section">
                        <h2>Time visits</h2>
                        <canvas id="hourlyVisitsChart"></canvas>
                    </div>
                </div>
            </main>
        </div>
        
        
      
<!--  <script type="module" src="SystemAdmin.js"></script>-->

<!--        <script src="SystemAdmin.js"></script>-->

<script>document.addEventListener('DOMContentLoaded', () => {
    const lockedUsers = [
        {email: "user1@example.com", status: "Đã khóa"},
        {email: "user2@example.com", status: "Đã khóa"},
        {email: "user3@example.com", status: "Đã khóa"}
    ];

    const totalUsers = 100;
    const visits = 120000;

    document.getElementById("total-users").textContent = totalUsers;
    document.getElementById("locked-users").textContent = lockedUsers.length;
    document.getElementById("visits").textContent = visits.toLocaleString();

    const weeklyCtx = document.getElementById("weeklyUsersChart").getContext("2d");
    if (!weeklyCtx) {
    console.error("Không tìm thấy phần tử weeklyUsersChart");
}
    new Chart(weeklyCtx, {
        type: 'line',
        data: {
            labels: ["Tuần 1", "Tuần 2", "Tuần 3", "Tuần 4"],
            datasets: [{
                    label: "Người dùng mới",
                    data: [10, 25, 18, 35],
                    borderColor: "#3b82f6",
                    backgroundColor: "rgba(59, 130, 246, 0.1)",
                    tension: 0.4,
                    fill: true
                }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {display: false}
            }
        }
    });

    const hourlyCtx = document.getElementById("hourlyVisitsChart").getContext("2d");
    new Chart(hourlyCtx, {
        type: 'bar',
        data: {
            labels: ["0h", "3h", "6h", "9h", "12h", "15h", "18h", "21h"],
            datasets: [{
                    label: "Lượt truy cập",
                    data: [120, 80, 50, 150, 300, 200, 220, 160],
                    backgroundColor: "#10b981"
                }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {display: false}
            }
        }
    });
});
</script>
    </body>
</html>

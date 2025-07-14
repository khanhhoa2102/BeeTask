<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview, model.User" %>
<%@ include file="../session-check.jspf" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="HeaderAdmin.jsp" %>
    <title>All Projects - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/UserManagement.css">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

    <main class="main-content">
        <h1>User Management</h1>

<!--         Tìm kiếm người dùng -->
        <div class="search-box">
            <form action="UserManagementServlet" method="get">
                <%
                    String keyword = (String) request.getAttribute("keyword");
                    if (keyword == null) keyword = "";
                %>
                <input type="text" name="keyword" placeholder="Tìm theo ID, tên, email..." value="<%= keyword %>">
                <button type="submit">Search</button>
            </form>
        </div>

<!--         Khóa/Mở tài khoản -->
        <section id="account-actions">
            <h2>Lock or Unlock Account</h2>
            <form action="UserManagementServlet" method="post">
                <input type="text" name="userId" placeholder="Nhập User ID">
                <select name="action">
                    <option value="lock">Lock Account</option>
                    <option value="unlock">Unlock Account</option>
                </select>
                <button type="submit">Execute</button>
            </form>
        </section>

        <!-- Locked users -->
        <section id="locked">
            <h2>Locked Users</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Created Date</th>
                    </tr>
                </thead>
                <tbody>
                   <%-- Locked Users --%>
<%
    List<User> lockedUsers = (List<User>) request.getAttribute("lockedUsers");
    if (lockedUsers != null) {
        for (User lockedUser : lockedUsers) {
%>
<tr>
    <td><%= lockedUser.getUserId() %></td>
    <td><%= lockedUser.getUsername() %></td>
    <td><%= lockedUser.getEmail() %></td>
    <td><%= lockedUser.getCreatedAt() %></td>
</tr>
<%
        }
    }
%>

                </tbody>
            </table>
        </section>

        <!-- All users -->
        <section id="all-users">
            <h2>All Users</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Created Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- All Users --%>
<%
    List<User> allUsers = (List<User>) request.getAttribute("allUsers");
    if (allUsers != null) {
        for (User listedUser : allUsers) {
%>
<tr>
    <td><%= listedUser.getUserId() %></td>
    <td><%= listedUser.getUsername() %></td>
    <td><%= listedUser.getEmail() %></td>
    <td><%= listedUser.getCreatedAt() %></td>
    <td><%= listedUser.isActive() ? "Active" : "Locked" %></td>
</tr>
<%
        }
    }
%>

                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>



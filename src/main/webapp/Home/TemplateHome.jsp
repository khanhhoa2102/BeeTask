<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="../Header.jsp" %>
    <title>Template Selection Page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/TemplateIndividual.css">
</head>
<body>
<div class="container">
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

        <%@include file="../Sidebar.jsp"%>
        <%@include file="../Help.jsp" %>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <%@include file="../HeaderContent.jsp" %>

        <!-- Content Area -->
        <div class="content">
            <h2>Template</h2>
            <div class="template-grid">
                <div class="template-card">
                    <div class="template-image"><img src="${pageContext.request.contextPath}/Asset/image1.png" alt="Kanban Thumbnail"></div>
                    <div class="template-title">Kanban Template</div>
                </div>
                <div class="template-card">
                    <div class="template-image"><img src="${pageContext.request.contextPath}/Asset/image2.png" alt="To Do Thumbnail"></div>
                    <div class="template-title">To Do Template</div>
                </div>
                <div class="template-card">
                    <div class="template-image"><img src="${pageContext.request.contextPath}/Asset/image3.png" alt="V Model Thumbnail"></div>
                    <div class="template-title">V model Template</div>
                </div>
                <div class="template-card">
                    <div class="template-image"><img src="${pageContext.request.contextPath}/Asset/image4.png" alt="Agile Thumbnail"></div>
                    <div class="template-title">Agile Template</div>
                </div>
                <div class="template-card">
                    <div class="template-image"><img src="${pageContext.request.contextPath}/Asset/image5.png" alt="Waterfall Thumbnail"></div>
                    <div class="template-title">Waterfall Template</div>
                </div>
                <div class="template-card">
                    <div class="template-image"><img src="${pageContext.request.contextPath}/Asset/image3.png" alt="Scrum Thumbnail"></div>
                    <div class="template-title">Scrum Template</div>
                </div>
            </div>
            <div class="view-all">
                <a href="${pageContext.request.contextPath}/AllTemplates.jsp">View all Template</a>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/TemplateIndividual.js"></script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Template Selection Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/TemplateIndividual.css">
    <script>
    window.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme') || 'dark-mode';
        if (savedTheme === 'dark-mode') {
            document.body.classList.add('dark-mode');
            const toggle = document.getElementById('darkModeToggle');
            if (toggle) toggle.checked = true;
        } else {
            document.body.classList.remove('dark-mode');
            const toggle = document.getElementById('darkModeToggle');
            if (toggle) toggle.checked = false;
        }

        const savedSidebarState = localStorage.getItem('sidebarState') || 'expanded';
        const sidebar = document.querySelector('.sidebar');
        if (sidebar) {
            sidebar.classList.toggle('collapsed', savedSidebarState === 'collapsed');
        }

        const darkModeToggle = document.getElementById('darkModeToggle');
        if (darkModeToggle) {
            darkModeToggle.addEventListener('change', () => {
                const isDark = darkModeToggle.checked;
                document.body.classList.toggle('dark-mode', isDark);
                localStorage.setItem('theme', isDark ? 'dark-mode' : 'light-mode');
            });
        }
    });
    </script>
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
                <span class="username"><%= user.getFullName() %></span>
                <span class="email"><%= user.getEmail() %></span>
            </div>
        </div>

        <button class="toggle-btn"><i class="fas fa-bars"></i></button>

        <ul class="menu">
            <li>
                <a href="${pageContext.request.contextPath}/Home/Home.jsp">
                    <i class="fas fa-home"></i><span>Home</span>
                </a>
            </li>
            <li class="active">
                <a href="${pageContext.request.contextPath}/Home/TemplateHome.jsp">
                    <i class="fas fa-copy"></i><span>Templates</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/Home/CalendarHome.jsp">
                    <i class="fas fa-calendar-day"></i><span>Today</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/Home/Table.jsp">
                    <i class="fas fa-calendar-alt"></i><span>Calendar</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/Home/Setting.jsp">
                    <i class="fas fa-cog"></i><span>Setting</span>
                </a>
            </li>
        </ul>

        <ul class="help-menu">
            <li class="help-item">
                <a href="${pageContext.request.contextPath}/Help.jsp">
                    <i class="fas fa-question-circle"></i><span>Help</span>
                </a>
            </li>
        </ul>
        <div class="drag-handle"></div>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <header class="header">
            <div class="header-content-wrapper">
                <div class="header-left">
                    <button class="icon-btn">
                        <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="Logo">
                    </button>
                </div>
                <div class="header-center">
                    <input type="text" class="search-box" placeholder="Search">
                    <button class="create-btn">Create Project</button>
                </div>
                <div class="header-right">
                    <label class="switch">
                        <input type="checkbox" id="darkModeToggle">
                        <span class="slider"></span>
                    </label>
                    <span class="dark-label">Dark Mode</span>
                </div>
            </div>
        </header>

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

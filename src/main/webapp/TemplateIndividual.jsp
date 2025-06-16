<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/Header.jsp"%>
    <title>Template Selection Page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/TemplateIndividual.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="user-profile">
                <div class="avatar"></div>
                <div class="info">
                    <span class="username">Nguyễn Hữu Sơn</span>
                    <span class="email">nguyenhuusona6@gmail.com</span>
                </div>
            </div>

            <button class="toggle-btn"><i class="fas fa-bars"></i></button>

            <ul class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/DashboardProject.jsp">
                        <i class="fas fa-tachometer-alt"></i><span>Dash Board</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Task.jsp">
                        <i class="fas fa-tasks"></i><span>Task</span>
                    </a>
                </li>
                <li class="active">
                    <a href="${pageContext.request.contextPath}/CalendarProject.jsp">
                        <i class="fas fa-calendar-alt"></i><span>Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Table.jsp">
                        <i class="fas fa-table"></i><span>Table</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Table.jsp">
                        <i class="fas fa-table"></i><span>Statitics</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Setting.jsp">
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
            <!-- Header -->
            <%@include file="/HeaderContent.jsp" %>

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
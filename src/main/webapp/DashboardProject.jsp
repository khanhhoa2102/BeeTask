<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/Header.jsp"%>
    <title>Project Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/DashboardProject.css">
</head>

<body>
    <div class="container">
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
                <li class="active">
                    <a href="${pageContext.request.contextPath}/DashboardProject.jsp">
                        <i class="fas fa-tachometer-alt"></i><span>Dash Board</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Task.jsp">
                        <i class="fas fa-tasks"></i><span>Task</span>
                    </a>
                </li>
                <li>
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
            <ul class="menu help-menu">
                <li class="help-item"><i class="fas fa-question-circle"></i> <span>Help</span></li>
            </ul>
            <div class="drag-handle"></div>
        </aside>

        <main class="main-content">
            <%@include file="/HeaderContent.jsp" %>

            <div class="project-header-bar">
                <div class="project-header-name">Tên Project</div>
                <div class="project-header-actions">
                    <div class="project-user-avatar"></div>
                    <button class="project-action-btn project-filter-btn"><i class="fas fa-filter"></i></button>
                    <button class="project-action-btn project-pin-btn"><i class="fas fa-thumbtack"></i></button>
                    <button class="project-action-btn project-visibility-btn">Change visibility</button>
                    <button class="project-action-btn project-share-btn">Share</button>
                    <button class="project-action-btn project-more-btn"><i class="fas fa-ellipsis-v"></i></button>
                </div>
            </div>

            <div class="dashboard-container">
                <h2 class="dashboard-title">DashBoard</h2>
                <div class="charts">
                    <div class="chart-card">
                        <h4>User participation</h4>
                        <canvas id="userChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <h4>Time Dynamics</h4>
                        <canvas id="timeChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <h4>Tasks Numbers</h4>
                        <canvas id="taskChart"></canvas>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/DashboardProjectScript.js"></script>
</body>

</html>
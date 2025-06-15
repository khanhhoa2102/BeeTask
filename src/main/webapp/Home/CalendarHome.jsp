<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="../Header.jsp" %>
    <title>Project Calendar</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CelendarProject.css">
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
            <%@include file="../Sidebar.jsp" %>
            <%@include file="../Help.jsp" %>
        </aside>
        <main class="main-content">
            <%@include file="../HeaderContent.jsp" %>
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
            <div class="calendar-box">
                <div class="calendar-header">
                    <select id="month-year"></select>
                    <button id="prev-month"><</button>
                    <span id="current-week">This day</span>
                    <button id="next-month">></button>
                    <div class="view-mode">
                        <select id="view-mode-select">
                            <option value="month">Month</option>
                            <option value="week">Week</option>
                            <option value="day">Day</option>
                        </select>
                    </div>
                </div>
                <div class="calendar-content">
                    <div class="sidebar-calendar">
                        <div class="calendar-header">
                            <button id="prev-month-sidebar"><</button>
                            <span id="sidebar-month-year">May, 2025</span>
                            <button id="next-month-sidebar">></button>
                        </div>
                        <table class="sidebar-calendar-table">
                            <thead>
                                <tr>
                                    <th>Sun</th>
                                    <th>Mon</th>
                                    <th>Tue</th>
                                    <th>Wed</th>
                                    <th>Thu</th>
                                    <th>Fri</th>
                                    <th>Sat</th>
                                </tr>
                            </thead>
                            <tbody id="sidebar-calendar-body"></tbody>
                        </table>
                    </div>
                    <div class="calendar-wrapper">
                        <table class="calendar">
                            <thead>
                                <tr>
                                    <th>Sunday</th>
                                    <th>Monday</th>
                                    <th>Tuesday</th>
                                    <th>Wednesday</th>
                                    <th>Thursday</th>
                                    <th>Friday</th>
                                    <th>Saturday</th>
                                </tr>
                            </thead>
                            <tbody id="calendar-body"></tbody>
                        </table>
                    </div>
                </div>
                <button id="add-event-btn" class="add-btn">Add</button>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/CelendarProjectScript.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.ProjectOverview" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/Header.jsp" %>
    <title>Project Overview</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Static.css">
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
                <li><a href="${pageContext.request.contextPath}/DashboardProject.jsp"><i class="fas fa-tachometer-alt"></i><span>Dash Board</span></a></li>
                <li><a href="${pageContext.request.contextPath}/Task.jsp"><i class="fas fa-tasks"></i><span>Task</span></a></li>
                <li><a href="${pageContext.request.contextPath}/CalendarProjectLeader.jsp"><i class="fas fa-calendar-alt"></i><span>Calendar</span></a></li>
                <li><a href="${pageContext.request.contextPath}/Table.jsp"><i class="fas fa-table"></i><span>Table</span></a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/Static.jsp"><i class="fas fa-table"></i><span>Statistics</span></a></li>
                <li><a href="${pageContext.request.contextPath}/Setting.jsp"><i class="fas fa-cog"></i><span>Setting</span></a></li>
            </ul>
            <ul class="help-menu">
                <li class="help-item"><i class="fas fa-question-circle"></i><span>Help</span></li>
            </ul>
        </aside>

        <main class="main-content">
            <div class="calendar-box">
                <%
                    List<ProjectOverview> overviewList = (List<ProjectOverview>) request.getAttribute("overviewList");
                    if (overviewList != null && !overviewList.isEmpty()) {
                        ProjectOverview project = overviewList.get(0); // Lấy thông tin dự án từ dòng đầu
                %>
                    <h2 style="margin-bottom: 1rem;">
                        Dự án: <%= project.getProjectId() %> - <%= project.getProjectName() %><br>
                        Mô tả: <%= project.getProjectDescription() %><br>
                        Người tạo: <%= project.getProjectCreatedBy() %> |
                        Ngày tạo: <%= project.getProjectCreatedAt() %> |
                        Leader: <%= project.getUsername() %>
                    </h2>
                <%
                    }
                %>

                <table class="calendar">
                    <thead>
                        <tr>
                            <th>Thành viên</th>
                            <th>Vai trò</th>
                            <th>Tên công việc</th>
                            <th>Mô tả</th>
                            <th>Hạn</th>
                            <th>Ngày tạo</th>
                            <th>Người tạo</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (overviewList != null && !overviewList.isEmpty()) {
                                String currentUsername = "";
                                for (ProjectOverview po : overviewList) {
                                    boolean showUser = !po.getUsername().equals(currentUsername);
                                    currentUsername = po.getUsername();
                        %>
                        <tr>
                            <td><%= showUser ? po.getUsername() : "" %></td>
                            <td><%= showUser ? po.getRole() : "" %></td>
                            <td><%= po.getTaskTitle() %></td>
                            <td><%= po.getTaskDescription() %></td>
                            <td><%= po.getDueDate() %></td>
                            <td><%= po.getTaskCreatedAt() %></td>
                            <td><%= po.getTaskCreatedBy() %></td>
                            <td><%= po.getTaskStatus() %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="8" style="text-align:center;">Không có dữ liệu</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                  <form action="${pageContext.request.contextPath}/exportPDF" method="get">
    <button type="submit">Xuất PDF</button>
</form>
  
            </div>
        </main>
    </div>
</body>
</html>

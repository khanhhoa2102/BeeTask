<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview" %>
<%@ include file="../session-check.jspf" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/Header.jsp" %>
        <title>Project Overview</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Statistic.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body class="dashboard-body">
        <div class="dashboard-container">
                <!-- Sidebar -->
                <%@include file="../Sidebar.jsp"%>

            <main class="main-content">
                <div class="calendar-box">

    <%
// Lấy danh sách tổng quan dự án
List<ProjectOverview> overviewList = (List<ProjectOverview>) request.getAttribute("overviewList");

// Lấy thông báo lỗi nếu có (ví dụ: yêu cầu nâng cấp Premium)
String errorMessage = (String) request.getAttribute("errorMessage");
if (errorMessage != null) {
                    %>
                    <div class="error-message" style="color: red; margin-bottom: 15px;">
                        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                    </div>
                    <%
                        }

   // Nếu có danh sách dự án
                        if (overviewList != null && !overviewList.isEmpty()) {
                            Map<Integer, List<ProjectOverview>> projectMap = new LinkedHashMap<>();
                            for (ProjectOverview po : overviewList) {
                                projectMap.computeIfAbsent(po.getProjectId(), k -> new ArrayList<>()).add(po);
                            }

                            for (Map.Entry<Integer, List<ProjectOverview>> entry : projectMap.entrySet()) {
                                ProjectOverview project = entry.getValue().get(0);
                    %>
<div class="project-block">
                        <div class="project-header-card">
                            <div class="project-icon"><i class="fas fa-project-diagram"></i></div>
                            <div class="project-info">
                                <h1 class="project-title">
                                    <span class="project-id">#<%= project.getProjectId() %></span>
                                    <%= project.getProjectName() %>
                                </h1>
                                <p class="project-description">
                                    <i class="fas fa-info-circle"></i>
                                    <%= project.getProjectDescription() %>
                                </p>
                                <div class="project-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-user-plus"></i>
                                        Artist: <strong><%= project.getProjectCreatedBy() %></strong>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-calendar-alt"></i>
                                        Day creation: <strong><%= project.getProjectCreatedAt() %></strong>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-crown"></i>
                                        Leader: <strong><%= project.getUsername() %></strong>
                                    </div>
                                </div>
                            </div>
                        </div>
<div class="table-footer">
    <div class="footer-content">
        <!-- Các thống kê bên trái -->
        <div class="table-stats">
            <span class="stats-item">
                <i class="fas fa-tasks"></i>
                Total number of jobs: <strong><%= entry.getValue().size() %></strong>
            </span>
            <span class="stats-item">
                <i class="fas fa-users"></i>
                Member: <strong><%= entry.getValue().stream().map(ProjectOverview::getUsername).distinct().count() %></strong>
            </span>
            <span class="stats-item">
                <i class="fas fa-check-circle"></i>
                Complete: <strong><%= entry.getValue().stream().filter(po -> "Done".equals(po.getTaskStatus())).count() %></strong>
            </span>
        </div>

        <!-- Nút PDF bên phải -->
        <form action="${pageContext.request.contextPath}/exportPDF" method="post">
            <input type="hidden" name="projectId" value="<%= project.getProjectId() %>" />
            <button type="submit" class="export-btn">
                <i class="fas fa-file-pdf"></i> PDF export for this project
            </button>
        </form>
    </div>
</div>



                        <button class="detail-btn" onclick="toggleDetails('<%= project.getProjectId() %>')">Detail</button>

                        <div id="details-<%= project.getProjectId() %>" class="table-container" style="display: none;">

                            <div class="filter-bar" style="margin-bottom: 15px;">
                                <!-- Thanh 1: Tìm theo tên task -->
                                <input type="text" class="task-search-input" placeholder="Search task..." onkeyup="filterTasks(<%= project.getProjectId() %>)" />

                                <!-- Thanh 2: Lọc theo trạng thái -->
                                <select class="status-filter" onchange="filterTasks(<%= project.getProjectId() %>)">
                                    <option value="All">All Statuses</option>
                                    <option value="Done">Done</option>
                                    <option value="In Progress">In Progress</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Review">Review</option>
                                    <option value="To Do">To Do</option>
                                </select>

                                <!-- Thanh 3: Lọc theo thành viên -->
                                <select class="member-filter" onchange="filterTasks(<%= project.getProjectId() %>)">
                                    <option value="All">All Members</option>
                                    <% 
                                        Set<String> members = new HashSet<>();
                                        for (ProjectOverview po : entry.getValue()) {
                                            if (members.add(po.getUsername())) {
                                    %>
                                    <option value="<%= po.getUsername() %>"><%= po.getUsername() %></option>
                                    <% 
                                            }
                                        } 
                                    %>
                                </select>
                            </div>
 <table class="calendar">
                                <thead>
                                    <tr>
                                        <th>Member</th>
                                        <th>Role</th>
                                        <th>Task</th>
                                        <th>Description</th>
                                        <th>Deadline</th>
                                        <th>Assigned Date</th>
                                        <th>Assignee</th>
                                        <th>Status</th>

                                    </tr>
                                </thead>

                                <tbody><% 
Map<String, List<ProjectOverview>> userMap = new LinkedHashMap<>();
for (ProjectOverview po : entry.getValue()) {
    userMap.computeIfAbsent(po.getUsername(), k -> new ArrayList<>()).add(po);
}

for (Map.Entry<String, List<ProjectOverview>> userEntry : userMap.entrySet()) {
    List<ProjectOverview> tasks = userEntry.getValue();
    boolean firstRow = true;

    for (ProjectOverview po : tasks) {
                                    %>
                                    <tr class="task-row" 
                                        data-task="<%= po.getTaskTitle().toLowerCase() %>" 
                                        data-status="<%= po.getTaskStatus().toLowerCase() %>" 
                                        data-member="<%= po.getUsername().toLowerCase() %>" 
                                        data-username="<%= po.getUsername().toLowerCase() %>">

                                        <td class="member-cell"><%= po.getUsername() %></td>
                                        <td class="role-cell"><%= po.getRole() %></td>
                                        <td><%= po.getTaskTitle() %></td>
                                        <td><%= po.getTaskDescription() %></td>
                                        <td><%= po.getDueDate() %></td>
                                        <td><%= po.getTaskCreatedAt() %></td>
                                        <td><%= po.getTaskCreatedBy() %></td>
                                        <td><%= po.getTaskStatus() %></td>
                                    </tr>
                                    <%
                                        }
                                    }
                                    %>

                                </tbody>

                            </table>
                        </div>
                    </div>
                    <% } } else { %>
                    <p>There is no project.</p>
                    <% } %>
                </div>
            </main>
        </div>
        <script src="${pageContext.request.contextPath}/Home/Statistic.js"></script>
        <script>
                                    function toggleDetails(projectId) {
                                        const el = document.getElementById("details-" + projectId);
                                        el.style.display = el.style.display === "none" ? "block" : "none";
                                    }
        </script>

<script>
            function filterTasks(projectId) {
                const container = document.querySelector("#details-" + projectId);
                const searchInput = container.querySelector(".task-search-input").value.toLowerCase();
                const status = container.querySelector(".status-filter").value.toLowerCase();
                const member = container.querySelector(".member-filter").value.toLowerCase();
                const rows = Array.from(container.querySelectorAll(".task-row"));

                // Bước 1: reset display
                rows.forEach(row => {
                    row.style.display = "";
                    row.querySelector(".member-cell").style.display = "";
                    row.querySelector(".role-cell").style.display = "";
                });

                // Bước 2: áp dụng filter
                rows.forEach(row => {
                    const task = row.dataset.task;
                    const rowStatus = row.dataset.status;
                    const rowMember = row.dataset.member;

                    const matchTask = task.includes(searchInput);
                    const matchStatus = (status === "all" || rowStatus === status);
                    const matchMember = (member === "all" || rowMember === member);

                    if (!(matchTask && matchStatus && matchMember)) {
                        row.style.display = "none";
                    }
                });

                // Bước 3: hide member/role cho dòng liên tiếp cùng username
                const visibleRows = rows.filter(r => r.style.display !== "none");
                let lastUsername = null;

                visibleRows.forEach(row => {
                    const username = row.dataset.username;
                    const memberCell = row.querySelector(".member-cell");
                    const roleCell = row.querySelector(".role-cell");

                    if (username === lastUsername) {
                        if (memberCell)
                            memberCell.style.display = "none";
                        if (roleCell)
                            roleCell.style.display = "none";
                    } else {
                        lastUsername = username;
                    }
                });
            }
        </script>
 </body>
</html>
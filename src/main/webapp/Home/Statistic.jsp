<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<body>
    <div class="container">
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

        <main class="main-content">
            <div class="calendar-box">
                <%
                    List<ProjectOverview> overviewList = (List<ProjectOverview>) request.getAttribute("overviewList");
                    if (overviewList != null && !overviewList.isEmpty()) {
                        ProjectOverview project = overviewList.get(0); // Lấy thông tin dự án từ dòng đầu
                %>
                
                <!-- Project Header Card -->
                <div class="project-header-card">
                    <div class="project-icon">
                        <i class="fas fa-project-diagram"></i>
                    </div>
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
                                <span>Người tạo: <strong><%= project.getProjectCreatedBy() %></strong></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <span>Ngày tạo: <strong><%= project.getProjectCreatedAt() %></strong></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-crown"></i>
                                <span>Leader: <strong><%= project.getUsername() %></strong></span>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>

                <!-- Table Controls -->
                <div class="table-controls">
                    <div class="search-filter-section">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Tìm kiếm công việc..." />
                        </div>
                        <div class="filter-group">
                            <select id="statusFilter" class="filter-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Pending">Pending</option>
                                <option value="In Progress">In Progress</option>
                                <option value="Completed">Completed</option>
                            </select>
                            <select id="memberFilter" class="filter-select">
                                <option value="">Tất cả thành viên</option>
                            </select>
                        </div>
                    </div>
                    <div class="action-buttons">
                        <button class="export-btn" onclick="exportPDF()">
                            <i class="fas fa-file-pdf"></i>
                            Xuất PDF
                        </button>
                        <button class="refresh-btn" onclick="refreshData()">
                            <i class="fas fa-sync-alt"></i>
                        </button>
                    </div>
                </div>

                <!-- Enhanced Table -->
                <div class="table-container">
                    <table class="calendar" id="projectTable">
                        <thead>
                            <tr>
                                <th class="sortable" data-column="member">
                                    <div class="th-content">
                                        <span>Thành viên</span>
                                        <i class="fas fa-sort sort-icon"></i>
                                    </div>
                                </th>
                                <th class="sortable" data-column="role">
                                    <div class="th-content">
                                        <span>Vai trò</span>
                                        <i class="fas fa-sort sort-icon"></i>
                                    </div>
                                </th>
                                <th class="sortable" data-column="task">
                                    <div class="th-content">
                                        <span>Tên công việc</span>
                                        <i class="fas fa-sort sort-icon"></i>
                                    </div>
                                </th>
                                <th>Mô tả</th>
                                <th class="sortable" data-column="due">
                                    <div class="th-content">
                                        <span>Hạn</span>
                                        <i class="fas fa-sort sort-icon"></i>
                                    </div>
                                </th>
                                <th class="sortable" data-column="created">
                                    <div class="th-content">
                                        <span>Ngày tạo</span>
                                        <i class="fas fa-sort sort-icon"></i>
                                    </div>
                                </th>
                                <th>Người tạo</th>
                                <th class="sortable" data-column="status">
                                    <div class="th-content">
                                        <span>Trạng thái</span>
                                        <i class="fas fa-sort sort-icon"></i>
                                    </div>
                                </th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <%
                                if (overviewList != null && !overviewList.isEmpty()) {
                                    String currentUsername = "";
                                    for (ProjectOverview po : overviewList) {
                                        boolean showUser = !po.getUsername().equals(currentUsername);
                                        currentUsername = po.getUsername();
                            %>
                            <tr class="table-row" data-member="<%= po.getUsername() %>" data-status="<%= po.getTaskStatus() %>">
                                <td class="member-cell">
                                    <% if (showUser) { %>
                                    <div class="member-info">
                                        <div class="member-avatar">
                                            <%= po.getUsername().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <span class="member-name"><%= po.getUsername() %></span>
                                    </div>
                                    <% } %>
                                </td>
                                <td class="role-cell">
                                    <% if (showUser) { %>
                                    <span class="role-badge role-<%= po.getRole().toLowerCase().replace(" ", "-") %>">
                                        <%= po.getRole() %>
                                    </span>
                                    <% } %>
                                </td>
                                <td class="task-cell">
                                    <div class="task-info">
                                        <span class="task-title"><%= po.getTaskTitle() %></span>
                                    </div>
                                </td>
                                <td class="description-cell">
                                    <span class="description-text" title="<%= po.getTaskDescription() %>">
                                        <%= po.getTaskDescription() %>
                                    </span>
                                </td>
                                <td class="date-cell">
                                    <span class="date-text"><%= po.getDueDate() %></span>
                                </td>
                                <td class="date-cell">
                                    <span class="date-text"><%= po.getTaskCreatedAt() %></span>
                                </td>
                                <td class="creator-cell">
                                    <span class="creator-name"><%= po.getTaskCreatedBy() %></span>
                                </td>
                                <td class="status-cell">
                                    <span class="status-badge status-<%= po.getTaskStatus().toLowerCase().replace(" ", "-") %>">
                                        <i class="status-icon"></i>
                                        <%= po.getTaskStatus() %>
                                    </span>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr class="empty-row">
                                <td colspan="8">
                                    <div class="empty-state">
                                        <i class="fas fa-inbox"></i>
                                        <p>Không có dữ liệu</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Table Footer with Stats -->
                <div class="table-footer">
                    <div class="table-stats">
                        <span class="stats-item">
                            <i class="fas fa-tasks"></i>
                            Tổng số công việc: <strong id="totalTasks">0</strong>
                        </span>
                        <span class="stats-item">
                            <i class="fas fa-users"></i>
                            Thành viên: <strong id="totalMembers">0</strong>
                        </span>
                        <span class="stats-item">
                            <i class="fas fa-check-circle"></i>
                            Hoàn thành: <strong id="completedTasks">0</strong>
                        </span>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/Home/Statistic.js"></script>
</body>
</html>
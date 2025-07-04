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

        <aside class="sidebar">
<!--            <div class="user-profile">
                <div class="avatar">
                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar">
                    <% } else { %>
                        <div class="default-avatar"></div>
                    <% } %>
                </div>
                <div class="info">
                    <span class="username"><%= user.getUsername() %></span>
                    <span class="email"><%= user.getEmail() %></span>
                </div>
            </div>-->
                    
                    
                    <div class="user-profile">
                    <div class="avatar">
                        <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                        <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color:#111726;"></div>
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
                    
                    
<!--                    <div class="action-buttons">
                        <form action="${pageContext.request.contextPath}/exportPDF" method="post">
                            <button type="submit" class="export-btn">
                                <i class="fas fa-file-pdf"></i> Xuất PDF
                            </button>
                        </form>
                        <button type="button" class="refresh-btn" onclick="refreshData()">
                            <i class="fas fa-sync-alt"></i>
                        </button>
                    </div>-->



                </div>

                <%
                    List<ProjectOverview> overviewList = (List<ProjectOverview>) request.getAttribute("overviewList");
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
                                    Người tạo: <strong><%= project.getProjectCreatedBy() %></strong>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    Ngày tạo: <strong><%= project.getProjectCreatedAt() %></strong>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-crown"></i>
                                    Leader: <strong><%= project.getUsername() %></strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="table-footer">
                        <div class="table-stats">
                            <span class="stats-item">
                                <i class="fas fa-tasks"></i>
                                Tổng số công việc: <strong><%= entry.getValue().size() %></strong>
                            </span>
                            <span class="stats-item">
                                <i class="fas fa-users"></i>
                                Thành viên: <strong><%= entry.getValue().stream().map(ProjectOverview::getUsername).distinct().count() %></strong>
                            </span>
                            <span class="stats-item">
                                <i class="fas fa-check-circle"></i>
                                Hoàn thành: <strong><%= entry.getValue().stream().filter(po -> "Completed".equals(po.getTaskStatus())).count() %></strong>
                            </span>
                        </div>
                            
                            
                            
                            
                            
                            <form action="${pageContext.request.contextPath}/exportPDF" method="post" style="margin-top: 10px;">
    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>" />
    <button type="submit" class="export-btn">
        <i class="fas fa-file-pdf"></i> Xuất PDF cho dự án này
    </button>
</form>

                            
                            
                            
                    </div>

                    <button class="detail-btn" onclick="toggleDetails('<%= project.getProjectId() %>')">Chi tiết</button>

                    <div id="details-<%= project.getProjectId() %>" class="table-container" style="display: none;">
                        <table class="calendar">
                            <thead>
                                <tr>
                                    <th>Thành viên</th>
                                    <th>Vai trò</th>
                                    <th>Công việc</th>
                                    <th>Mô tả</th>
                                    <th>Hạn</th>
                                    <th>Ngày giao</th>
                                    <th>Người giao</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ProjectOverview po : entry.getValue()) { %>
                                    <tr>
                                        <td><%= po.getUsername() %></td>
                                        <td><%= po.getRole() %></td>
                                        <td><%= po.getTaskTitle() %></td>
                                        <td><%= po.getTaskDescription() %></td>
                                        <td><%= po.getDueDate() %></td>
                                        <td><%= po.getTaskCreatedAt() %></td>
                                        <td><%= po.getTaskCreatedBy() %></td>
                                        <td><%= po.getTaskStatus() %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% } } else { %>
                <p>Không có dự án nào.</p>
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
</body>
</html>

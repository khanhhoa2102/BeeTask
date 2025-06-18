<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Template, model.TemplateBoard, model.TemplateTask" %>
<%@ page import="dao.TemplateDAO" %>
<%@ page import="java.util.*" %>

<%
    int templateId = Integer.parseInt(request.getParameter("templateId"));
    TemplateDAO dao = new TemplateDAO();
    Template template = dao.getTemplateById(templateId);
    List<TemplateBoard> boards = dao.getTemplateBoards(templateId);
    Map<Integer, List<TemplateTask>> tasksMap = dao.getTemplateTasksByTemplateId(templateId);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/Header.jsp"%>
        <title>BeeTask - <%= template.getName() %></title>
        <link rel="stylesheet" href="TemplateDetail.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    </head>
    <body class="theme-light dark-mode"> 
        <div class="container">
            <aside class="sidebar">
                <%@include file="../Sidebar.jsp"%>
                <%@include file="../Help.jsp" %>
            </aside>

            <main class="main-content">
                <%@include file="/HeaderContent.jsp" %>

                <!-- Template Header -->
                <div class="template-header">
                    <div class="header-content">
                        <div class="template-info">
                            <div class="template-title-section">
                                <h2 class="template-title"><%= template.getName() %></h2>
                            </div>
                        </div>

                        <div class="header-actions">
                            <!-- Use Template Button -->
                            <a href="<%= request.getContextPath() %>/Login.jsp" class="use-template-btn">
                                <span>Use Template</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Template Dashboard -->
                <div class="template-dashboard">
                    <!-- Stats Overview -->
                    <div class="stats-section">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-tasks"></i>
                            </div>
                            <div class="stat-content">
                                <h3 class="stat-number" id="totalTasks">0</h3>
                                <p class="stat-label">Total Tasks</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-columns"></i>
                            </div>
                            <div class="stat-content">
                                <h3 class="stat-number"><%= boards.size() %></h3>
                                <p class="stat-label">Boards</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-content">
                                <h3 class="stat-number" id="pendingTasks">0</h3>
                                <p class="stat-label">Pending</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-content">
                                <h3 class="stat-number">0</h3>
                                <p class="stat-label">Completed</p>
                            </div>
                        </div>
                    </div>

                    <!-- Boards Section -->
                    <div class="boards-section">
                        <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <div class="left-section">
                                <h2><%= boards.size() %> Boards</h2>
                            </div>
                            <div class="right-section">
                                <button class="add-board-btn">
                                    <i class="fas fa-plus"></i> Add Board
                                </button>
                            </div>
                        </div>


                        <div class="boards-container">
                            <% for (TemplateBoard board : boards) {
                                List<TemplateTask> tasks = tasksMap.get(board.getTemplateBoardId());
                            %>
                            <div class="board-card" data-board-id="<%= board.getTemplateBoardId() %>">
                                <div class="board-header">
                                    <h3 class="board-title"><%= board.getName() %></h3>
                                    <span class="task-count"><%= tasks != null ? tasks.size() : 0 %></span>
                                </div>

                                <div class="board-tasks">
                                    <% if (tasks != null) {
                                    for (TemplateTask task : tasks) { %>
                                    <div class="task-card" data-task-id="<%= task.getTemplateTaskId() %>">
                                        <div class="task-header">
                                            <div class="task-priority medium"></div>
                                        </div>

                                        <div class="task-content">
                                            <h4 class="task-title"><%= task.getTitle() %></h4>
                                            <p class="task-description"><%= task.getDescription() %></p>
                                        </div>

                                        <div class="task-footer">
                                            <span class="task-date">
                                                <i class="fas fa-calendar-alt"></i>
                                                <%= task.getDueDate() %>
                                            </span>
                                            <div class="task-assignee">
                                                <div class="avatar">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <% } } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Task Overview -->
                    <div class="overview-section">
                        <div class="section-header">
                            <h2>Task Overview</h2>
                            <div class="view-filters">
                                <button class="filter-btn active" data-filter="all">All</button>
                                <button class="filter-btn" data-filter="todo">To Do</button>
                                <button class="filter-btn" data-filter="progress">In Progress</button>
                                <button class="filter-btn" data-filter="done">Done</button>
                            </div>
                        </div>

                        <div class="overview-table">
                            <div class="table-header">
                                <div class="col-header">Task</div>
                                <div class="col-header">Board</div>
                                <div class="col-header">Due Date</div>
                                <div class="col-header">Priority</div>
                                <div class="col-header">Status</div>
                            </div>

                            <div class="table-body">
                                <% for (TemplateBoard board : boards) {
                                    List<TemplateTask> tasks = tasksMap.get(board.getTemplateBoardId());
                                    if (tasks != null) {
                                        for (TemplateTask task : tasks) { %>
                                <div class="table-row" data-status="todo">
                                    <div class="task-info">
                                        <div class="task-indicator"></div>
                                        <div class="task-details">
                                            <h4><%= task.getTitle() %></h4>
                                            <p><%= task.getDescription() %></p>
                                        </div>
                                    </div>
                                    <div class="board-info">
                                        <span class="board-name"><%= board.getName() %></span>
                                    </div>
                                    <div class="date-info">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span><%= task.getDueDate() %></span>
                                    </div>
                                    <div class="priority-info">
                                        <span class="priority-badge medium">
                                            <i class="fas fa-flag"></i>
                                            Medium
                                        </span>
                                    </div>
                                    <div class="status-info">
                                        <span class="status-badge todo">
                                            <i class="fas fa-circle"></i>
                                            To Do
                                        </span>
                                    </div>
                                </div>
                                <% } } } %>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script src="${pageContext.request.contextPath}/TemplateDetail.js"></script>
    </body>
</html>

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
    <title>BeeTask - Tasks</title>
    <link rel="stylesheet" href="TemplateDetail.css">
</head>

<body class="dark-mode">
    <div class="container">
        <aside class="sidebar">
            <%@include file="../Sidebar.jsp"%>
            <%@include file="../Help.jsp" %>
        </aside>

        <main class="main-content">
            <%@include file="/HeaderContent.jsp" %>

            <div class="project-header-bar">
                <div class="project-header-name"><%= template.getName() %></div>
                <div class="project-header-actions">
                    <div class="project-user-avatar"></div>
                    <button class="project-action-btn project-filter-btn"><i class="fas fa-filter"></i></button>
                    <button class="project-action-btn project-pin-btn"><i class="fas fa-thumbtack"></i></button>
                    <button class="project-action-btn project-visibility-btn">Change visibility</button>
                    <button class="project-action-btn project-share-btn">Share</button>
                    <button class="project-action-btn project-more-btn"><i class="fas fa-ellipsis-v"></i></button>
                </div>
            </div>

            <div class="template-action-bar">
                <button class="use-template-btn">Use Template</button>
            </div>

            <div class="project-dashboard">
                <div class="task-status-container">
                    <% for (TemplateBoard board : boards) {
                        List<TemplateTask> tasks = tasksMap.get(board.getTemplateBoardId());
                    %>
                    <div class="task-column">
                        <h3>
                            <div class="board-detail">
                                <span class="board-title" contenteditable="false"><%= board.getName() %></span>
                                <span class="task-count">(<%= tasks != null ? tasks.size() : 0 %>)</span>
                            </div>
                            <span>
                                <button class="collapse-btn"><i class="fas fa-chevron-up"></i></button>
                                <button class="menu-btn"><i class="fas fa-ellipsis-v"></i></button>
                            </span>
                        </h3>

                        <% if (tasks != null) {
                            for (TemplateTask task : tasks) { %>
                        <div class="task-card"
                             data-description="<%= task.getDescription() %>"
                             data-priority="Low"
                             data-deadline="<%= task.getDueDate() %>"
                             data-assignee="Unassigned"
                             data-labels="#1E90FF">
                            <p class="task-title" contenteditable="false"><%= task.getTitle() %></p>
                            <p class="task-date" contenteditable="false"><%= task.getDueDate() %></p>
                        </div>
                        <% } } %>
                    </div>
                    <% } %>
                </div>

                <!-- Nút Add Board -->
                <button id="addBoardBtn" class="add-board-btn">Add Board</button>

                <!-- Các popup vẫn giữ nguyên -->
                <div class="popup" id="taskPopup">...</div>
                <div class="add-task-popup" id="addTaskPopup">...</div>
                <div class="task-detail-popup" id="taskDetailPopup">...</div>

                <div class="tasks-overview">
                    <h3>Tasks</h3>
                    <div class="task-list">
                        <div class="task-row" style="font-weight: bold; background-color: #1E2333; color: white;">
                            <div class="task-cell">Tasks</div>
                            <div class="task-cell">Deadline</div>
                            <div class="task-cell">Priority</div>
                            <div class="task-cell">Suggested Time</div>
                        </div>
                        <% for (TemplateBoard board : boards) {
                            List<TemplateTask> tasks = tasksMap.get(board.getTemplateBoardId());
                            if (tasks != null) {
                                for (TemplateTask task : tasks) { %>
                        <div class="task-row">
                            <div class="task-cell"><%= task.getTitle() %></div>
                            <div class="task-cell"><%= task.getDueDate() %></div>
                            <div class="task-cell">
                                <div class="priority-container">
                                    <div class="task-cell priority low">Low</div>
                                </div>
                            </div>
                            <div class="task-cell">Thu 8:00 - 10PM</div>
                        </div>
                        <% } } } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/TemplateDetail.js"></script>
</body>
</html>

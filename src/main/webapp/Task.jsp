<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Project, model.Board, model.Task" %>
<%@ page import="dao.ProjectDAO" %>
<%@ page import="java.util.*" %>

<%
    String rawId = request.getParameter("projectId");
    int projectId = -1;
    
    if (rawId == null || rawId.trim().isEmpty()) {
        out.println("<h2>Error: Project ID is missing.</h2>");
        return;
    }
    ProjectDAO dao = new ProjectDAO();
    Project project = null;
    List<Board> boards = new ArrayList<>();
    Map<Integer, List<Task>> tasksMap = new HashMap<>();

    try {
        projectId = Integer.parseInt(rawId);
        project = dao.getProjectById(projectId);
        if (project != null) {
            boards = dao.getBoardsByProjectId(projectId);
            tasksMap = dao.getTasksByProjectId(projectId);
        } else {
            out.println("<h2>Project not found</h2>");
            return;
        }
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>BeeTask - <%= project.getName() %></title>
    <link rel="stylesheet" href="TemplateDetail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="theme-light dark-mode">
<div class="container">
    <aside class="sidebar">
        <%@include file="../Sidebar.jsp"%>
        <%@include file="../Help.jsp" %>
    </aside>

    <main class="main-content">
        <%@include file="/Header.jsp" %>

        <!-- Project Header -->
        <div class="template-header">
            <div class="header-content">
                <h2 class="template-title"><%= project.getName() %></h2>
            </div>
        </div>

        <!-- Add Board -->
        <div class="boards-section">
            <form action="board" method="post" class="add-board-form">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                <input type="hidden" name="position" value="<%= boards.size() %>">
                <input type="text" name="name" placeholder="New Board Name" required>
                <button type="submit">Add Board</button>
            </form>

            <div class="boards-container" id="boardsContainer">
                <% for (Board board : boards) {
                    List<Task> tasks = tasksMap.get(board.getBoardId()); %>
                    <div class="board-card" data-board-id="<%= board.getBoardId() %>">
                        <div class="board-header">
                            <h3><%= board.getName() %> (<%= tasks != null ? tasks.size() : 0 %>)</h3>
                            <div class="dropdown">
                                <form action="board" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="listId" value="<%= board.getBoardId() %>">
                                    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                    <input type="text" name="name" value="<%= board.getName() %>" required>
                                    <button>Edit</button>
                                </form>
                                <form action="board" method="post" onsubmit="return confirm('Delete this board?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="listId" value="<%= board.getBoardId() %>">
                                    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                    <button>Delete</button>
                                </form>
                            </div>
                        </div>

                        <!-- Task List -->
                        <div class="board-tasks" data-board-id="<%= board.getBoardId() %>">
                            <% if (tasks != null) {
                                for (Task task : tasks) { %>
                                <div class="task-card" data-task-id="<%= task.getTaskId() %>">
                                    <div class="task-priority <%= task.getPriority().toLowerCase() %>"></div>
                                    <h4><%= task.getTitle() %></h4>
                                    <p><%= task.getDescription() %></p>
                                    <small>Status: <%= task.getStatus() %></small><br>
                                    <small>Due: <%= task.getDueDate() %></small>
                                </div>
                            <% } } %>

                            <!-- Create Task Form -->
                            <form action="task" method="post" class="create-task-form">
                                <input type="hidden" name="action" value="create">
                                <input type="hidden" name="boardId" value="<%= board.getBoardId() %>">
                                <input type="text" name="title" placeholder="Task title" required>
                                <input type="text" name="description" placeholder="Description">
                                <select name="status">
                                    <option value="To Do">To Do</option>
                                    <option value="In Progress">In Progress</option>
                                    <option value="Done">Done</option>
                                </select>
                                <select name="priority">
                                    <option value="High">High</option>
                                    <option value="Medium">Medium</option>
                                    <option value="Low">Low</option>
                                </select>
                                <button>Add Task</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Task Overview Table -->
        <div class="overview-section">
            <h3>Task Overview</h3>
            <div class="overview-table">
                <div class="table-header">
                    <div>Task</div>
                    <div>Board</div>
                    <div>Due</div>
                    <div>Priority</div>
                    <div>Status</div>
                </div>
                <div class="table-body">
                    <% for (Board board : boards) {
                        List<Task> tasks = tasksMap.get(board.getBoardId());
                        if (tasks != null) {
                            for (Task task : tasks) { %>
                        <div class="table-row" data-status="<%= task.getStatus().toLowerCase() %>">
                            <div><%= task.getTitle() %></div>
                            <div><%= board.getName() %></div>
                            <div><%= task.getDueDate() %></div>
                            <div><%= task.getPriority() %></div>
                            <div><%= task.getStatus() %></div>
                        </div>
                    <% } } } %>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Script for Drag & Drop -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Drag task
    document.querySelectorAll('.board-tasks').forEach(container => {
        Sortable.create(container, {
            group: 'tasks',
            animation: 150,
            onEnd: evt => {
                const taskId = evt.item.dataset.taskId;
                const newBoardId = evt.to.closest('.board-card').dataset.boardId;
                const newIndex = evt.newIndex;

                fetch('task?action=move', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `taskId=${taskId}&newBoardId=${newBoardId}&newIndex=${newIndex}`
                });
            }
        });
    });

    // Drag boards
    Sortable.create(document.getElementById('boardsContainer'), {
        animation: 200,
        onEnd: function (evt) {
            const boardCards = document.querySelectorAll('.board-card');
            const updates = [];

            boardCards.forEach((card, index) => {
                updates.push(`boardIds[]=${card.dataset.boardId}&positions[]=${index}`);
            });

            fetch('board?action=moveBoardPosition', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: updates.join('&')
            });
        }
    });
</script>
</body>
</html>
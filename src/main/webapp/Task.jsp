<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Project, model.Board, model.Task" %>
<%@ page import="dao.ProjectDAO" %>
<%@ page import="java.util.*" %>
<%
    int projectId = Integer.parseInt(request.getParameter("projectId"));
    ProjectDAO projectDAO = new ProjectDAO();
    Project project = projectDAO.getProjectById(projectId);
    Map<Board, List<Task>> boardTaskMap = projectDAO.getBoardsWithTasks(projectId);
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= project.getName() %> - Task Board</title>
    <link rel="stylesheet" href="css/Task.css">
    <script src="https://kit.fontawesome.com/yourkit.js" crossorigin="anonymous"></script>
</head>
<body class="theme-light">
    <div class="project-dashboard">
        <h2><%= project.getName() %></h2>
        <div class="task-status-container" id="boardContainer">
            <% for (Map.Entry<Board, List<Task>> entry : boardTaskMap.entrySet()) {
                Board board = entry.getKey();
                List<Task> tasks = entry.getValue(); %>
                <div class="task-column" data-board-id="<%= board.getBoardId() %>">
                    <div class="board-detail">
                        <h3 class="title-menu-wrapper">
                            <span class="board-title" contenteditable="true"><%= board.getName() %></span>
                            <button class="menu-btn"><i class="fas fa-ellipsis-v"></i></button>
                        </h3>
                    </div>
                    <% for (Task task : tasks) { %>
                        <div class="task-card" draggable="true" data-task-id="<%= task.getTaskId() %>">
                            <div class="title-menu-wrapper">
                                <p class="task-title"><%= task.getTitle() %></p>
                                <button class="menu-dot"><i class="fas fa-ellipsis-v"></i></button>
                            </div>
                            <span class="task-date"><%= task.getDueDate() %></span>
                        </div>
                    <% } %>
                    <button class="add-board-btn" onclick="openAddTaskPopup(<%= board.getBoardId() %>)">+ Add Task</button>
                </div>
            <% } %>
        </div>
        <button class="add-board-btn" onclick="openCreateBoardPopup(<%= projectId %>)">+ Add Board</button>
    </div>

    <!-- Add Task Popup -->
    <div class="add-task-popup" id="addTaskPopup">
        <div class="add-task-header">
            <span>Add Task</span>
            <span class="popup-close" onclick="closeAddTaskPopup()">&times;</span>
        </div>
        <form id="addTaskForm" method="post" action="task">
            <div class="add-task-content">
                <input type="hidden" name="boardId" id="taskBoardId">
                <label>Title</label>
                <input type="text" name="title" required>
                <label>Description</label>
                <textarea name="description"></textarea>
                <label>Priority</label>
                <select name="priority">
                    <option value="low">Low</option>
                    <option value="medium">Medium</option>
                    <option value="high">High</option>
                </select>
                <label>Due Date</label>
                <input type="date" name="dueDate">
            </div>
            <div class="add-task-actions">
                <button type="button" class="cancel-btn" onclick="closeAddTaskPopup()">Cancel</button>
                <button type="submit" class="add-btn">Add</button>
            </div>
        </form>
    </div>

    <!-- Task Detail Popup -->
    <div class="task-detail-popup" id="taskDetailPopup">
        <div class="task-detail-header">
            <span>Task Detail</span>
            <span class="popup-close" onclick="closeTaskDetailPopup()">&times;</span>
        </div>
        <div class="task-detail-content">
            <input type="hidden" id="detailTaskId">
            <div class="task-detail-fields">
                <label>Title</label>
                <input type="text" class="task-title-input" id="detailTitle">
                <label>Description</label>
                <textarea class="task-description-input" id="detailDescription"></textarea>
            </div>
            <div class="task-detail-actions">
                <button class="action-btn" onclick="saveTaskDetails()">Save</button>
                <button class="action-btn delete-option" onclick="deleteTask()">Delete</button>
            </div>
        </div>
    </div>

    <script src="js/TaskScript.js"></script>
</body>
</html>

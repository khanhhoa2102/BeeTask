<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Project, model.Board, model.Task, model.User" %>
<%@ page import="dao.ProjectDAO, dao.BoardDAO, dao.TaskDAO, dao.TaskStatusDAO" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    String rawId = request.getParameter("projectId");
    int projectId = -1;
    // Debug information
    System.out.println("=== TASK.JSP DEBUG ===");
    System.out.println("User: " + (user != null ? user.getUsername() : "null"));
    System.out.println("Raw Project ID: " + rawId);
    if (user == null) {
        System.out.println("User not logged in, redirecting to login");
        response.sendRedirect("/BeeTask/Authentication/Login.jsp");
        return;
    }
    if (rawId == null || rawId.trim().isEmpty()) {
        System.out.println("Missing project ID, redirecting to error page");
        response.sendRedirect("/BeeTask/ErrorPage.jsp?msg=Missing Project ID");
        return;
    }
    ProjectDAO projectDAO = new ProjectDAO();
    BoardDAO boardDAO = new BoardDAO();
    TaskDAO taskDAO = new TaskDAO();
    TaskStatusDAO statusDAO = new TaskStatusDAO();
    Project project = null;
    List<Board> boards = new ArrayList<>();
    Map<Integer, List<Task>> tasksMap = new HashMap<>();
    Map<Integer, String> statusMap = new HashMap<>();
    try {
        projectId = Integer.parseInt(rawId);
        System.out.println("Parsed Project ID: " + projectId);

        // Load status map first
        statusMap = statusDAO.getAllStatuses();
        System.out.println("Status map loaded: " + statusMap.size() + " statuses");

        // Load project
        project = projectDAO.getProjectById(projectId);
        System.out.println("Project loaded: " + (project != null ? project.getName() : "null"));
        if (project != null) {
            // Load boards
            boards = boardDAO.getBoardsByProjectId(projectId);
            System.out.println("Boards loaded: " + boards.size());

            // Load tasks
            tasksMap = taskDAO.getTasksByProjectIdGrouped(projectId);
            System.out.println("Tasks map size: " + tasksMap.size());

            // Debug each board's tasks
            for (Board board : boards) {
                List<Task> boardTasks = tasksMap.get(board.getBoardId());
                System.out.println("Board '" + board.getName() + "' (ID: " + board.getBoardId() + ") has " +
                     (boardTasks != null ? boardTasks.size() : 0) + " tasks");
                if (boardTasks != null) {
                    for (Task task : boardTasks) {
                        String statusName = statusMap.get(task.getStatusId());
                        System.out.println("  - Task: " + task.getTitle() + " (Status: " + statusName + ")");
                    }
                }
            }
        } else {
            System.out.println("Project not found, redirecting to error page");
            response.sendRedirect("/BeeTask/ErrorPage.jsp?msg=Project Not Found");
            return;
        }
    } catch (NumberFormatException e) {
        System.out.println("Invalid project ID format: " + rawId);
        response.sendRedirect("/BeeTask/ErrorPage.jsp?msg=Invalid Project ID");
        return;
    } catch (Exception e) {
        System.out.println("Error loading project data: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("/BeeTask/ErrorPage.jsp?msg=" + e.getMessage());
        return;
    }

    System.out.println("=== END DEBUG ===");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/Header.jsp"%>
    <title>BeeTask - <%= project.getName() %></title>
    <link rel="stylesheet" href="Task.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="theme-light dark-mode">
     <div class="container">
        <%@ include file="../Sidebar.jsp" %>

        <main class="main-content">
            <div class="template-header">
                <div class="header-content">
                    <div class="header-info">
                        <h2 class="project-title">
                            <i class="fas fa-project-diagram"></i>
                            <%= project.getName() %>
                        </h2>
                        <p class="project-subtitle">Task Management Dashboard</p>
                    </div>
                    <div class="header-actions">
                        <button onclick="openProjectMembersModal()" class="btn btn-secondary">
                            <i class="fas fa-users"></i>
                            Project Members
                        </button>
                        <button onclick="openAddBoardModal()" class="btn btn-primary">
                            <i class="fas fa-plus"></i>
                            Add Board
                        </button>
                        <button class="btn btn-secondary" onclick="toggleViewMode()">
                            <i class="fas fa-th-large" id="viewModeIcon"></i>
                            <span id="viewModeText">Grid View</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Boards Section -->
            <div class="boards-section">
                <div class="boards-header">
                    <div class="boards-info">
                        <h3>Project Boards</h3>
                        <span class="boards-count"><%= boards.size() %> boards</span>
                    </div>
                    <div class="boards-controls">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search boards..." id="boardSearch">
                        </div>
                        <div class="view-toggle">
                            <button class="view-btn active" data-view="grid" title="Grid View">
                                <i class="fas fa-th-large"></i>
                            </button>
                            <button class="view-btn" data-view="list" title="List View">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="boards-container grid-view" id="boardsContainer">
                    <% for (Board board : boards) {
                        List<Task> tasks = tasksMap.get(board.getBoardId());
                        int taskCount = (tasks != null) ? tasks.size() : 0;
                        int completedTasks = 0;
                        if (tasks != null) {
                            for (Task task : tasks) {
                                 String statusName = statusMap.get(task.getStatusId());
                                if (statusName == null) statusName = "Unknown";
                                if ("Done".equals(statusName)) {
                                    completedTasks++;
                                }
                            }
                        }
                    %>
                    <div class="board-card" data-board-id="<%= board.getBoardId() %>">
                        <div class="board-header">
                            <div class="board-title-section">
                                <h3 class="board-title"><%= board.getName() %></h3>
                                <div class="board-stats">
                                    <span class="task-count"><%= taskCount %></span>
                                    <div class="progress-indicator">
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: <%= taskCount > 0 ? (completedTasks * 100 / taskCount) : 0 %>%"></div>
                                        </div>
                                        <span class="progress-text"><%= completedTasks %>/<%= taskCount %></span>
                                    </div>
                                </div>
                            </div>
                            <div class="board-actions">
                                <button onclick="openAddTaskModal(<%= board.getBoardId() %>)" class="action-btn add-task-btn" title="Add Task">
                                    <i class="fas fa-plus"></i>
                                </button>
                                <div class="board-menu">
                                    <button class="action-btn menu-btn" onclick="toggleBoardMenu(this)" title="More Options">
                                        <i class="fas fa-ellipsis-v"></i>
                                    </button>
                                    <div class="board-dropdown">
                                        <button onclick="editBoard(<%= board.getBoardId() %>, '<%= board.getName() %>')">
                                            <i class="fas fa-edit"></i> Edit Board
                                        </button>
                                        <button onclick="duplicateBoard(<%= board.getBoardId() %>)">
                                            <i class="fas fa-copy"></i> Duplicate Board
                                        </button>
                                        <hr>
                                        <button onclick="sortBoardTasks(<%= board.getBoardId() %>, 'dueDate')">
                                            <i class="fas fa-calendar-alt"></i> Sort by Due Date
                                        </button>
                                        <button onclick="sortBoardTasks(<%= board.getBoardId() %>, 'priority')">
                                            <i class="fas fa-flag"></i> Sort by Priority
                                        </button>
                                        <hr>
                                        <button class="delete-btn" onclick="taskManager.deleteBoard(<%= board.getBoardId() %>)">
                                            <i class="fas fa-trash"></i> Delete Board
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="board-content">
                            <div class="board-tasks" data-board-id="<%= board.getBoardId() %>">
                                <% if (tasks != null && !tasks.isEmpty()) {
                                    for (Task task : tasks) {
                                         String statusName = statusMap.get(task.getStatusId());
                                        if (statusName == null) statusName = "Unknown";
                                %>
                                <div class="task-card priority-<%= task.getPriority().toLowerCase() %>"
                                      data-task-id="<%= task.getTaskId() %>"
                                      data-task-title="<%= task.getTitle().replace("'", "\\'") %>"
                                      data-task-description="<%= task.getDescription().replace("'", "\\'") %>"
                                      data-task-duedate="<%= task.getDueDate() != null ? task.getDueDate() : "" %>"
                                      data-task-priority="<%= task.getPriority() %>"
                                      data-task-status="<%= statusName %>"
                                      onclick="openTaskDetailPopup('<%= task.getTaskId() %>', '<%= task.getTitle().replace("'", "\\'") %>', '<%= task.getDescription().replace("'", "\\'") %>', '<%= task.getDueDate() %>', '<%= task.getPriority() %>', '<%= statusName %>')">
                                    <div class="task-priority-indicator"></div>
                                    <div class="task-content">
                                        <h4 class="task-title"><%= task.getTitle() %></h4>
                                        <p class="task-description"><%= task.getDescription() %></p>
                                    </div>
                                    <div class="task-footer">
                                        <div class="task-meta">
                                            <span class="task-date">
                                                <i class="fas fa-calendar-alt"></i>
                                                <%= task.getDueDate() != null ? task.getDueDate() : "No due date" %>
                                            </span>
                                        </div>
                                        <div class="task-badges">
                                            <span class="priority-badge <%= task.getPriority().toLowerCase() %>">
                                                <i class="fas fa-flag"></i>
                                                <%= task.getPriority() %>
                                            </span>
                                            <span class="status-badge <%= statusName.toLowerCase().replace(" ", "") %>">
                                                <%= statusName %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <% }
                                 } else { %>
                                <div class="empty-board">
                                    <i class="fas fa-tasks"></i>
                                    <p>No tasks yet</p>
                                    <button onclick="openAddTaskModal(<%= board.getBoardId() %>)" class="btn btn-ghost">
                                        <i class="fas fa-plus"></i> Add first task
                                    </button>
                                </div>
                                <% } %>
                            </div>

                            <button onclick="openAddTaskModal(<%= board.getBoardId() %>)" class="add-task-button">
                                <i class="fas fa-plus"></i>
                                <span>Add a task</span>
                            </button>
                        </div>
                    </div>
                    <% } %>
                    <!-- Add Board Card -->
                    <div class="board-card add-board-card" onclick="openAddBoardModal()">
                        <div class="add-board-content">
                            <i class="fas fa-plus"></i>
                            <h3>Add New Board</h3>
                            <p>Create a new board to organize your tasks</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Task Overview Section -->
            <div class="overview-section">
                <div class="section-header">
                    <h2>Task Overview</h2>
                    <div class="view-filters">
                        <button class="filter-btn active" data-filter="all">All</button>
                        <button class="filter-btn" data-filter="todo">To Do</button>
                        <button class="filter-btn" data-filter="inprogress">In Progress</button>
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
                        <div class="col-header">AI Suggestion</div>
                    </div>
                    <div class="table-body">
                        <% for (Board board : boards) {
                            List<Task> tasks = tasksMap.get(board.getBoardId());
                            if (tasks != null) {
                                for (Task task : tasks) {
                                     String statusName = statusMap.get(task.getStatusId());
                                    if (statusName == null) statusName = "Unknown";
                        %>
                        <div class="table-row" data-status="<%= statusName.toLowerCase().replace(" ", "") %>"
                             data-task-id="<%= task.getTaskId() %>"
                             data-task-title="<%= task.getTitle().replace("'", "\\'") %>"
                             data-task-description="<%= task.getDescription().replace("'", "\\'") %>"
                             data-task-duedate="<%= task.getDueDate() != null ? task.getDueDate() : "" %>"
                             data-task-priority="<%= task.getPriority() %>"
                             data-task-status="<%= statusName %>">
                            <div class="task-info"
                                 onclick="openTaskDetailPopup('<%= task.getTaskId() %>', '<%= task.getTitle().replace("'", "\\'") %>', '<%= task.getDescription().replace("'", "\\'") %>', '<%= task.getDueDate() %>', '<%= task.getPriority() %>', '<%= statusName %>')">
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
                                <span><%= task.getDueDate() != null ? task.getDueDate() : "No due date" %></span>
                            </div>
                            <div class="priority-info">
                                <span class="priority-badge <%= task.getPriority().toLowerCase() %>">
                                    <i class="fas fa-flag"></i>
                                    <%= task.getPriority() %>
                                </span>
                            </div>
                            <div class="status-info">
                                <span class="status-badge <%= statusName.toLowerCase().replace(" ", "") %>">
                                    <i class="fas fa-circle"></i>
                                    <%= statusName %>
                                </span>
                            </div>
                            <div class="ai-suggestion-col">
                                <% if ("To Do".equals(statusName)) { %>
                                <button class="btn btn-primary btn-sm ai-suggest-btn"
                                        data-task-id="<%= task.getTaskId() %>"
                                        data-task-title="<%= task.getTitle().replace("'", "\\'") %>"
                                        data-task-desc="<%= task.getDescription().replace("'", "\\'") %>"
                                        data-task-due="<%= task.getDueDate() != null ? task.getDueDate() : "" %>"
                                        data-task-priority="<%= task.getPriority() %>">
                                    <i class="fas fa-lightbulb"></i> AI Suggest
                                </button>
                                <% } else { %>
                                    <span class="ai-no-suggestion">N/A</span>
                                <% } %>
                            </div>
                        </div>
                        <% } } } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modals -->
    <div id="addBoardModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-plus"></i> Add New Board</h3>
                <span class="close" onclick="closeAddBoardModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form action="board" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                    <input type="hidden" name="position" value="<%= boards.size() %>">
                    <div class="form-group">
                        <label><i class="fas fa-tag"></i> Board Name:</label>
                        <input type="text" name="name" placeholder="Enter board name..." required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeAddBoardModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Board</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="addTaskModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-plus"></i> Add New Task</h3>
                <span class="close" onclick="closeAddTaskModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="addTaskForm" >
                    <input type="hidden" name="boardId" id="taskBoardId">
                    <div class="form-group">
                        <label><i class="fas fa-heading"></i> Title:</label>
                        <input type="text" name="title" placeholder="Enter task title..." required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-align-left"></i> Description:</label>
                        <textarea name="description" placeholder="Enter task description..."></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-calendar"></i> Due Date:</label>
                            <input type="date" name="dueDate">
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-flag"></i> Priority:</label>
                            <select name="priority">
                                <option value="High">High</option>
                                <option value="Medium" selected>Medium</option>
                                <option value="Low">Low</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-tasks"></i> Status:</label>
                        <select name="status">
                            <option value="To Do" selected>To Do</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Done">Done</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeAddTaskModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Task</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Task Modal -->
    <div id="editTaskModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Edit Task</h3>
                <span class="close" onclick="closeEditTaskModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="editTaskForm">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="taskId" id="editTaskId">
                    <div class="form-group">
                        <label><i class="fas fa-heading"></i> Title:</label>
                        <input type="text" name="title" id="editTaskTitle" placeholder="Enter task title..." required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-align-left"></i> Description:</label>
                        <textarea name="description" id="editTaskDescription" placeholder="Enter task description..."></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-calendar"></i> Due Date:</label>
                            <input type="date" name="dueDate" id="editTaskDueDate">
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-flag"></i> Priority:</label>
                            <select name="priority" id="editTaskPriority">
                                <option value="High">High</option>
                                <option value="Medium">Medium</option>
                                <option value="Low">Low</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-tasks"></i> Status:</label>
                        <select name="status" id="editTaskStatus">
                            <option value="To Do">To Do</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Done">Done</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeEditTaskModal()">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="taskManager.handleEditTask()">Update Task</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="taskDetailModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="taskDetailTitle">Task Details</h3>
                <span class="close" onclick="closeTaskDetailModal()">&times;</span>
            </div>
            <div class="modal-body">
                <input type="hidden" id="taskDetailId" />
                <div class="task-detail-content">
                    <p id="taskDetailDescription"></p>
                    <div class="task-detail-meta">
                        <div class="meta-item">
                            <strong><i class="fas fa-calendar"></i> Due Date:</strong>
                            <span id="taskDetailDueDate"></span>
                        </div>
                        <div class="meta-item">
                            <strong><i class="fas fa-flag"></i> Priority:</strong>
                            <span id="taskDetailPriority"></span>
                        </div>
                        <div class="meta-item">
                            <strong><i class="fas fa-tasks"></i> Status:</strong>
                            <span id="taskDetailStatus"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeTaskDetailModal()">Close</button>
                    <button type="button" class="btn btn-warning" onclick="editTaskFromDetail()">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="btn btn-danger" onclick="taskManager.deleteTask(document.getElementById('taskDetailId').value)">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- AI Suggestion Modal -->
    <div id="aiSuggestionModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-robot"></i> AI Suggestion for Task</h3>
                <span class="close" onclick="closeAISuggestionModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="ai-suggestion-task-info">
                    <h4>Current Task: <span id="aiCurrentTaskTitle"></span></h4>
                    <p><span id="aiCurrentTaskDescription"></span></p>
                    <div class="task-detail-meta">
                        <div class="meta-item">
                            <strong><i class="fas fa-calendar"></i> Due Date:</strong>
                            <span id="aiCurrentTaskDueDate"></span>
                        </div>
                        <div class="meta-item">
                            <strong><i class="fas fa-flag"></i> Priority:</strong>
                            <span id="aiCurrentTaskPriority"></span>
                        </div>
                    </div>
                </div>
                <div class="ai-suggestions-list">
                    <h4>Suggested Details:</h4>
                    <div class="ai-suggestion-item">
                        <p><strong>Suggested Start Time:</strong> <span id="aiSuggestedStart"></span></p>
                        <p><strong>Suggested End Time:</strong> <span id="aiSuggestedEnd"></span></p>
                        <p><strong>Difficulty:</strong> <span id="aiSuggestedDifficulty"></span></p>
                        <p><strong>Priority:</strong> <span id="aiSuggestedPriority"></span></p>
                        <p><strong>Confidence:</strong> <span id="aiSuggestedConfidence"></span></p>
                        <p><strong>Short Description:</strong> <span id="aiSuggestedShortDesc"></span></p>
                        <button class="btn btn-primary btn-sm mt-3" id="applyAISuggestionBtn">
                            <i class="fas fa-check"></i> Apply Suggestion
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Project Members Modal -->
    <div id="projectMembersModal" class="modal project-members-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-users"></i> Project Members</h3>
                <span class="close" onclick="closeProjectMembersModal()">&times;</span>
            </div>
            <div class="modal-body">
                <h4>Current Members:</h4>
                <div class="member-list" id="projectMemberList">
                    <!-- Members will be populated by JS -->
                </div>

                <div class="invite-section">
                    <h4><i class="fas fa-user-plus"></i> Invite New Member:</h4>
                    <div class="invite-form">
                        <input type="email" id="inviteEmail" placeholder="Enter member email..." required>
                        <button class="btn btn-primary" onclick="sendInvitation()">
                            <i class="fas fa-paper-plane"></i> Send Invite
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        window.contextPath = "<%= request.getContextPath() %>";
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
    <script src="<%= request.getContextPath() %>/TaskScript.js"></script>
    <script>
        function openAddBoardModal() {
            document.getElementById('addBoardModal').style.display = 'block';
        }
        function closeAddBoardModal() {
            document.getElementById('addBoardModal').style.display = 'none';
        }
        function openAddTaskModal(boardId) {
            document.getElementById('addTaskModal').style.display = 'block';
            document.getElementById('taskBoardId').value = boardId;
        }
        function closeAddTaskModal() {
            document.getElementById('addTaskModal').style.display = 'none';
        }

        // Edit Task Functions
        function openEditTaskModal(taskId) {
            fetch('task?action=getTask&taskId=' + taskId)
              .then(response => response.json())
              .then(data => {
                document.getElementById('editTaskId').value = data.taskId;
                document.getElementById('editTaskTitle').value = data.title;
                document.getElementById('editTaskDescription').value = data.description;
                document.getElementById('editTaskDueDate').value = data.dueDate;
                document.getElementById('editTaskPriority').value = data.priority;
                const statusMap = {1: 'To Do', 2: 'In Progress', 3: 'Done'};
                const statusSelect = document.getElementById('editTaskStatus');
                statusSelect.value = statusMap[data.statusId] || 'To Do';
                document.getElementById('editTaskModal').style.display = 'block';
              })
              .catch(error => {
                console.error('Error loading task:', error);
                alert('Failed to load task for editing.');
              });
          }

        function closeEditTaskModal() {
            document.getElementById('editTaskModal').style.display = 'none';
        }

        function editTaskFromDetail() {
            const taskId = document.getElementById('taskDetailId').value;
            closeTaskDetailModal();
            openEditTaskModal(taskId);
        }

        function openTaskDetailPopup(taskId, title, description, dueDate, priority, status) {
            document.getElementById('taskDetailId').value = taskId;
            document.getElementById('taskDetailTitle').innerText = title;
            document.getElementById('taskDetailDescription').innerText = description;
            document.getElementById('taskDetailDueDate').innerText = dueDate;
            document.getElementById('taskDetailPriority').innerText = priority;
            document.getElementById('taskDetailStatus').innerText = status;
            document.getElementById('taskDetailModal').style.display = 'block';
        }
        function closeTaskDetailModal() {
            document.getElementById('taskDetailModal').style.display = 'none';
        }

        // AI Suggestion Modal Functions
        function closeAISuggestionModal() {
            document.getElementById('aiSuggestionModal').style.display = 'none';
        }

        // Project Members Modal Functions
        function openProjectMembersModal() {
            window.taskManager.displayProjectMembers(); // Call the TaskManager method
            document.getElementById('projectMembersModal').style.display = 'block';
        }

        function closeProjectMembersModal() {
            document.getElementById('projectMembersModal').style.display = 'none';
        }

        function sendInvitation() {
            window.taskManager.sendInvitation();
        }

        // Global functions for board menu sorting
        function sortBoardTasks(boardId, sortBy) {
            window.taskManager.sortBoardTasks(boardId, sortBy);
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                closeAddBoardModal();
                closeAddTaskModal();
                closeEditTaskModal();
                closeTaskDetailModal();
                closeAISuggestionModal();
                closeProjectMembersModal();
            }
        }
    </script>
</body>
</html>

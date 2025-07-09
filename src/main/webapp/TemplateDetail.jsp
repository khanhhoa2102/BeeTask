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
        <aside class="sidebar">
            <% if (user != null) { %>
            <div class="user-profile">
                <div class="avatar">
                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar">
                    <% } else { %>
                        <div class="avatar-placeholder">
                            <i class="fas fa-user"></i>
                        </div>
                    <% } %>
                </div>
                <div class="info">
                    <span class="username"><%= user.getUsername() %></span>
                    <span class="email"><%= user.getEmail() %></span>
                </div>
            </div>
            <% } %>
            <%@include file="../Sidebar.jsp"%>
            <%@include file="../Help.jsp" %>
        </aside>
        
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

            <!-- Debug Info Section -->
            <div style="background: #e3f2fd; padding: 15px; margin: 20px; border-radius: 8px; border-left: 4px solid #2196f3;">
                <h4 style="color: #1976d2; margin-bottom: 10px;">🔍 Debug Information</h4>
                <p><strong>Project:</strong> <%= project.getName() %> (ID: <%= projectId %>)</p>
                <p><strong>Boards:</strong> <%= boards.size() %> | <strong>Status Map:</strong> <%= statusMap.size() %> statuses</p>
                <p><strong>Tasks by Board:</strong> 
                <% 
                    int totalTasks = 0;
                    for (Board board : boards) {
                        List<Task> boardTasks = tasksMap.get(board.getBoardId());
                        int count = (boardTasks != null) ? boardTasks.size() : 0;
                        totalTasks += count;
                        out.print(board.getName() + "(" + count + ") ");
                    }
                %>
                | <strong>Total:</strong> <%= totalTasks %></p>
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
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button onclick="duplicateBoard(<%= board.getBoardId() %>)">
                                            <i class="fas fa-copy"></i> Duplicate
                                        </button>
                                        <hr>
                                        <form action="board" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="listId" value="<%= board.getBoardId() %>">
                                            <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                            <button type="submit" class="delete-btn" onclick="return confirm('Delete this board and all its tasks?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
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
                    </div>
                    <div class="table-body">
                        <% for (Board board : boards) {
                            List<Task> tasks = tasksMap.get(board.getBoardId());
                            if (tasks != null) {
                                for (Task task : tasks) { 
                                    String statusName = statusMap.get(task.getStatusId());
                                    if (statusName == null) statusName = "Unknown";
                        %>
                        <div class="table-row" data-status="<%= statusName.toLowerCase().replace(" ", "") %>">
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
                <form id="addTaskForm" action="task" method="post">
                    <input type="hidden" name="action" value="create">
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
                <form id="editTaskForm" action="task" method="post">
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
                        <button type="submit" class="btn btn-primary">Update Task</button>
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
                    <form action="task" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this task?')">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="taskId" id="taskDetailId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
    <script src="${pageContext.request.contextPath}/TaskScript.js"></script>
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
            // Fetch task data from server
            fetch('task?action=getTask&taskId=' + taskId)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('editTaskId').value = data.taskId;
                    document.getElementById('editTaskTitle').value = data.title;
                    document.getElementById('editTaskDescription').value = data.description;
                    document.getElementById('editTaskDueDate').value = data.dueDate;
                    document.getElementById('editTaskPriority').value = data.priority;
                    
                    // Set status based on statusId
                    const statusSelect = document.getElementById('editTaskStatus');
                    const statusMap = {1: 'To Do', 2: 'In Progress', 3: 'Done'};
                    statusSelect.value = statusMap[data.statusId] || 'To Do';
                    
                    document.getElementById('editTaskModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error fetching task data:', error);
                    alert('Error loading task data');
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
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                closeAddBoardModal();
                closeAddTaskModal();
                closeEditTaskModal();
                closeTaskDetailModal();
            }
        }
    </script>
</body>
</html>

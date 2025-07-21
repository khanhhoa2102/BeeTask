<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Template, model.TemplateBoard, model.TemplateTask, model.Label, model.User" %>

<%@ page import="dao.admin.TemplateDAO" %>
<%@ page import="java.util.*" %>

<%
    User user = (User) session.getAttribute("user");
    int templateId = Integer.parseInt(request.getParameter("templateId"));
    TemplateDAO dao = new TemplateDAO();
    Template template = dao.getTemplateById(templateId);
    List<TemplateBoard> boards = dao.getTemplateBoards(templateId);
    Map<Integer, List<TemplateTask>> tasksMap = dao.getTemplateTasksByTemplateId(templateId);
    List<Label> allLabels = dao.getAllLabels();

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="HeaderAdmin.jsp"%>
        <title>BeeTask - <%= template.getName() %></title>
        <link rel="stylesheet" href="TemplateDetail.css">
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
                <%@include file="SidebarAdmin.jsp"%>
                <%@include file="../Help.jsp" %>
            </aside>

            <main class="main-content">
                <!-- Template Header -->
                <div class="template-header">
                    <div class="header-content">
                        <div class="template-info">
                            <div class="template-title-section">
                                <h2 class="template-title"><%= template.getName() %></h2>
                            </div>
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

                            <div class="right-section">
                                <button type="button" class="add-board-btn" onclick="document.getElementById('addBoardModal').style.display = 'flex';">
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
                                    <div class="title-row">
                                        <h3 class="board-title"><%= board.getName() %></h3>
                                        <p class="board-description"><%= board.getDescription() %></p>

                                    </div>
                                    <span class="task-count"><%= tasks != null ? tasks.size() : 0 %></span>
                                </div>







                                <button onclick="deleteBoard(<%= board.getTemplateBoardId() %>)" class="delete-board-btn">🗑 Delete Board</button>



                                <!-- Edit Board Button và Form -->
                                <button onclick="showEditBoardForm(<%= board.getTemplateBoardId() %>, '<%= board.getName().replace("'", "\\'") %>', '<%= board.getDescription() != null ? board.getDescription().replace("'", "\\'") : "" %>')"
                                        class="edit-board-btn">
                                    ✏ Edit Board
                                </button>
                                <div id="editBoardForm-<%= board.getTemplateBoardId() %>" class="edit-form" style="display:none;">
                                    <!-- Thêm data attribute để debug -->
                                    <div data-debug="true" data-board-id="<%= board.getTemplateBoardId() %>">
                                        <div class="form-group">
                                            <label>Board Name</label>
                                            <input type="text" 
                                                   id="editBoardName-<%= board.getTemplateBoardId() %>" 
                                                   class="debug-input"
                                                   value="<%= board.getName() %>" />
                                        </div>
                                        <div class="form-group">
                                            <label>Description</label>
                                            <textarea id="editBoardDesc-<%= board.getTemplateBoardId() %>" class="debug-input"><%= board.getDescription() != null ? board.getDescription() : "" %></textarea>

                                        </div>
                                    </div>
                                    <button onclick="console.log('Click save', <%= board.getTemplateBoardId() %>); return submitEditBoard(<%= board.getTemplateBoardId() %>)">
                                        Save
                                    </button>
                                    <button onclick="return hideEditBoardForm(<%= board.getTemplateBoardId() %>)">
                                        Cancel
                                    </button>
                                </div>




                                <div class="board-tasks">
                                    <% if (tasks != null) {
                                        for (TemplateTask task : tasks) { %>
                                    <div class="task-card" data-task-id="<%= task.getTemplateTaskId() %>">

                                        <div class="task-content">
                                            <h4 class="task-title">Title: <%= task.getTitle() %></h4>

                                            <p class="task-description"><strong>Description:</strong> <%= task.getDescription() %></p>

                                            <p class="task-description"><strong>Status:</strong> <%= task.getStatus() %></p>

                                            <!-- Hiển thị labels đơn giản -->
                                            <p class="task-labels">
                                                <strong>Labels:</strong>
                                                <% if (task.getLabels() != null && !task.getLabels().isEmpty()) { %>
                                                <% for (Label label : task.getLabels()) { %>
                                                <%= label.getName() %> 
                                                <% } %>
                                                <% } else { %>
                                                None
                                                <% } %>
                                            </p>
                                        </div>

                                        <div class="task-footer">
                                            <span class="task-date">
                                                <i class="fas fa-calendar-alt"></i>
                                                <strong>Due Date:</strong> <%= task.getDueDate() %>
                                            </span>



                                            <div class="task-assignee">
                                                <div class="avatar">
                                                   
                                                    <strong>🐝</strong> <!-- Nếu có thông tin người được giao có thể hiển thị tại đây -->
                                                </div>
                                            </div>
                                        </div>














                                        <button onclick="deleteTask(<%= task.getTemplateTaskId() %>)" class="delete-task-btn">🗑 Delete Task</button>


                                        <!-- Edit Task Button và Form -->
                                        <button onclick="showEditTaskForm(<%= task.getTemplateTaskId() %>, '<%= task.getTitle().replace("'", "\\'") %>', '<%= task.getDescription() != null ? task.getDescription().replace("'", "\\'") : "" %>', '<%= task.getStatus() %>', '<%= task.getDueDate() != null ? task.getDueDate().toString() : "" %>')"
                                                class="edit-task-btn">
                                            ✏ Edit Task
                                        </button>

                                        <div id="editTaskForm-<%= task.getTemplateTaskId() %>" class="edit-form" style="display:none;">
                                            <div class="form-group">
                                                <label>Task Title</label>
                                                <input type="text" class="task-title-input" />
                                            </div>
                                            <div class="form-group">
                                                <label>Description</label>
                                                <textarea class="task-desc-input"></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label>Status</label>
                                                <select class="task-status-input">
                                                    <option value="To Do">To Do</option>
                                                    <option value="In Progress">In Progress</option>
                                                    <option value="Done">Done</option>
                                                </select>
                                            </div>


                                            <div class="form-group">
                                                <label>Labels</label>
                                                <select class="task-labels-input" multiple size="4">
                                                    <% for (Label label : allLabels) { %>
                                                    <option value="<%= label.getLabelId() %>"><%= label.getName() %></option>
                                                    <% } %>
                                                </select>
                                            </div>


                                            <div class="form-group">
                                                <label>Due Date</label>
                                                <input type="date" class="task-duedate-input" />
                                            </div>
                                            <div class="form-actions">
                                                <button class="btn btn-primary" onclick="submitEditTask(<%= task.getTemplateTaskId() %>)">Save</button>
                                                <button class="btn btn-secondary" onclick="hideEditTaskForm(<%= task.getTemplateTaskId() %>)">Cancel</button>
                                            </div>
                                        </div>

                                    </div>
                                    <% } } %>
                                </div>




                                <button onclick="showAddTaskForm(<%= board.getTemplateBoardId() %>)" class="add-task-btn">
                                    ➕ Add Task
                                </button>

                                <div id="addTaskForm-<%= board.getTemplateBoardId() %>" class="task-form" style="display: none;">
                                    <label for="taskTitle-<%= board.getTemplateBoardId() %>">Task Title:</label><br>
                                    <input type="text" id="taskTitle-<%= board.getTemplateBoardId() %>" placeholder="Task title" class="task-input" /><br>

                                    <label for="taskDescription-<%= board.getTemplateBoardId() %>">Description:</label><br>
                                    <input type="text" id="taskDescription-<%= board.getTemplateBoardId() %>" placeholder="Description" class="task-input" /><br>

                                    <label for="taskDueDate-<%= board.getTemplateBoardId() %>">Due Date:</label><br>
                                    <input type="date" id="taskDueDate-<%= board.getTemplateBoardId() %>" class="task-input" /><br>

                                    <label for="taskStatus-<%= board.getTemplateBoardId() %>">Status:</label><br>
                                    <select id="taskStatus-<%= board.getTemplateBoardId() %>" class="task-input">
                                        <option value="To Do">To Do</option>
                                        <option value="In Progress">In Progress</option>
                                        <option value="Done">Done</option>
                                    </select><br>

                                    <label for="taskLabels-<%= board.getTemplateBoardId() %>">Labels:</label><br>
                                    <select id="taskLabels-<%= board.getTemplateBoardId() %>" multiple size="4" class="task-input">
                                        <% for (Label label : allLabels) { %>
                                        <option value="<%= label.getLabelId() %>"><%= label.getName() %></option>
                                        <% } %>
                                    </select><br>

                                    <button onclick="addTask(<%= board.getTemplateBoardId() %>)" class="task-submit-btn">Add</button>
                                    <button onclick="cancelAddTask(<%= board.getTemplateBoardId() %>)" class="task-cancel-btn" style="margin-left: 10px;">Cancel</button>
                                </div>



                            </div>
                            <% } %>
                        </div>
                    </div>








                    <form method="post" action="${pageContext.request.contextPath}/admin/templatedetailservlet">
                        <input type="hidden" name="action" value="addBoard">
                        <input type="hidden" name="templateId" value="<%= templateId %>">

                        <div class="modal" id="addBoardModal" style="display:none;">
                            <div class="modal-content">
                                <h3>Add Board</h3>

                                <label>Name:</label>
                                <input type="text" name="name" required>

                                <label>Description:</label>
                                <textarea name="description"></textarea>

                                <div class="modal-actions">
                                    <button type="submit">Add</button>
                                    <button type="button" onclick="document.getElementById('addBoardModal').style.display = 'none';">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </form>









                    <!--
                                         Task Overview 
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
        </div>-->








                </div>
            </main>
        </div>









        <style>
            .modal {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background-color: rgba(0, 0, 0, 0.4);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }

            .modal-content {
                background: #fff;
                padding: 25px 30px;
                border-radius: 12px;
                width: 400px;
                max-width: 90%;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            }

            .modal-content h3 {
                text-align: center;
                margin-bottom: 20px;
            }

            .modal-content label {
                display: block;
                margin-top: 10px;
                font-weight: bold;
            }

            .modal-content input[type="text"],
            .modal-content textarea {
                width: 100%;
                padding: 8px 10px;
                margin-top: 5px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
            }

            .modal-actions {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
            }

            .modal-actions button {
                padding: 8px 16px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
            }

            .modal-actions button[type="submit"] {
                background-color: #007bff;
                color: white;
            }

            .modal-actions button[type="button"] {
                background-color: #ccc;
                color: black;



            }













            .edit-form {
                background: #fff;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin: 10px 0;
                border: 1px solid #ddd;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
            }

            .form-group input[type="text"],
            .form-group textarea,
            .form-group select,
            .form-group input[type="date"] {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }

            .btn {
                padding: 8px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
            }

            .btn-primary {
                background-color: #4CAF50;
                color: white;
            }

            .btn-secondary {
                background-color: #f0f0f0;
                color: #333;
            }














            .task-form {
                display: flex;
                flex-direction: column;
                gap: 12px;
                background-color: #f9fafb;
                padding: 16px;
                margin-top: 10px;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
            }

            .task-input {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
                width: 100%;
            }

            .task-input:focus {
                border-color: #3b82f6;
                outline: none;
                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
            }

            .task-submit-btn {
                padding: 10px 16px;
                background-color: #3b82f6;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.2s ease;
            }

            .task-submit-btn:hover {
                background-color: #2563eb;
            }

            .add-task-btn {
                background-color: #10b981;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 8px;
                font-size: 14px;
                cursor: pointer;
                margin-top: 10px;
            }

            .add-task-btn:hover {
                background-color: #059669;
            }





            .task-cancel-btn {
                background-color: #e5e7eb;
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                color: #111827;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .task-cancel-btn:hover {
                background-color: #d1d5db;
            }








            .task-labels-input {
                height: 120px;
                width: 100%;
                overflow-y: auto;
            }



        </style>               











        <script>
            function showEditTaskForm(taskId, title, description, status, dueDateStr, selectedLabelIds = []) {
                const form = document.getElementById("editTaskForm-" + taskId);
                form.style.display = "block";

                form.querySelector(".task-title-input").value = title;
                form.querySelector(".task-desc-input").value = description;
                form.querySelector(".task-status-input").value = status;

                if (dueDateStr && dueDateStr !== "null") {
                    form.querySelector(".task-duedate-input").value = dueDateStr.substring(0, 10); // yyyy-mm-dd
                }

                // Set selected labels
                const labelSelect = form.querySelector(".task-labels-input");
                const selectedIds = selectedLabelIds.map(String); // đảm bảo dạng chuỗi
                Array.from(labelSelect.options).forEach(opt => {
                    opt.selected = selectedIds.includes(opt.value);
                });
            }

            function hideEditTaskForm(taskId) {
                const form = document.getElementById("editTaskForm-" + taskId);
                form.style.display = "none";
            }


            function submitEditTask(taskId) {
                const form = document.getElementById("editTaskForm-" + taskId);
                const title = form.querySelector(".task-title-input").value.trim();
                const description = form.querySelector(".task-desc-input").value.trim();
                const status = form.querySelector(".task-status-input").value;
                const dueDate = form.querySelector(".task-duedate-input").value;

                const labelSelect = form.querySelector(".task-labels-input");
                const labelIds = Array.from(labelSelect.selectedOptions).map(opt => opt.value);

                if (!title) {
                    alert("Task title is required.");
                    return;
                }

                const formData = new URLSearchParams();
                formData.append("action", "editTask");
                formData.append("taskId", taskId);
                formData.append("title", title);
                formData.append("description", description);
                formData.append("status", status);
                formData.append("dueDate", dueDate);
                formData.append("labelIds", labelIds.join(","));

                fetch('${pageContext.request.contextPath}/admin/templatedetailservlet', {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: formData.toString()
                }).then(() => {
                    location.reload();
                });
            }






            function showAddTaskForm(boardId) {
                document.getElementById('addTaskForm-' + boardId).style.display = 'block';
            }



            function cancelAddTask(boardId) {
                const form = document.getElementById('addTaskForm-' + boardId);
                form.style.display = 'none';

                // ✅ Xoá dữ liệu người dùng đã nhập (nếu muốn reset form)
                form.querySelector('#taskTitle-' + boardId).value = '';
                form.querySelector('#taskDescription-' + boardId).value = '';
                form.querySelector('#taskDueDate-' + boardId).value = '';
                form.querySelector('#taskStatus-' + boardId).selectedIndex = 0;
                form.querySelector('#taskLabels-' + boardId).selectedIndex = -1;
            }




            function addTask(boardId) {
                const title = document.getElementById('taskTitle-' + boardId).value.trim();
                const description = document.getElementById('taskDescription-' + boardId).value.trim();
                const dueDate = document.getElementById('taskDueDate-' + boardId).value;
                const status = document.getElementById('taskStatus-' + boardId).value;






// Validate rỗng
                if (!title || !description || !dueDate || !status) {
                    alert("❗ Vui lòng điền đầy đủ tất cả các trường bắt buộc.");
                    return;
                }


                // Validate ngày hạn không được trong quá khứ
                const today = new Date();
                today.setHours(0, 0, 0, 0); // Đặt về đầu ngày

                const dueDateObj = new Date(dueDate);
                dueDateObj.setHours(0, 0, 0, 0); // CŨNG đặt về đầu ngày

                if (dueDateObj < today) {
                    alert("⚠️ Ngày hạn không được là ngày trong quá khứ.");
                    return;
                }






                // Sửa phần này: lấy label từ select multiple



                const labelSelect = document.getElementById("taskLabels-" + boardId);
                const labelIds = Array.from(labelSelect.selectedOptions).map(option => option.value);

                if (!title) {
                    alert("Task title is required.");
                    return;
                }

                const formData = new URLSearchParams();
                formData.append("action", "addTask");
                formData.append("boardId", boardId);
                formData.append("title", title);
                formData.append("description", description);
                formData.append("dueDate", dueDate);
                formData.append("status", status);
                formData.append("labelIds", labelIds.join(",")); // ✅ Ví dụ: labelIds=1,2,3

                fetch('${pageContext.request.contextPath}/admin/templatedetailservlet', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: formData.toString()
                }).then(res => {
                    window.location.href = window.location.pathname + "?templateId=" + <%= templateId %>;
                });
            }







//
//
//            function addTask(boardId) {
//                const title = document.getElementById('taskTitle-' + boardId).value.trim();
//                const description = document.getElementById('taskDescription-' + boardId).value.trim();
//                const dueDate = document.getElementById('taskDueDate-' + boardId).value;
//                const status = document.getElementById('taskStatus-' + boardId).value;
//
//                const labelElements = document.querySelectorAll(`#addTaskForm-${boardId} input[name="label"]:checked`);
//                const labelIds = Array.from(labelElements).map(el => el.value);
//
//                if (!title) {
//                    alert("Task title is required.");
//                    return;
//                }
//
//                // Dùng đối tượng FormData để thêm từng labelIds
//                const formData = new URLSearchParams();
//                formData.append("action", "addTask");
//                formData.append("boardId", boardId);
//                formData.append("title", title);
//                formData.append("description", description);
//                formData.append("dueDate", dueDate);
//                formData.append("status", status);
//
//                formData.append("labelIds", labelIds.join(",")); // ✅ labelIds=1,2,3
//
//
//                fetch('${pageContext.request.contextPath}/admin/templatedetailservlet', {
//                    method: 'POST',
//                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//                    body: formData.toString()
//                }).then(res => {
//                    window.location.href = window.location.pathname + "?templateId=" + <%= templateId %>;
//                });
//
//            }
//
//







            function showEditBoardForm(boardId, boardName) {
                // 1. Đảm bảo chạy sau khi DOM ready
                document.addEventListener('DOMContentLoaded', function () {
                    executeShowForm();
                });

                // Nếu DOM đã ready thì chạy luôn
                if (document.readyState === 'complete') {
                    executeShowForm();
                }

                function executeShowForm() {
                    try {
                        // 2. Sử dụng cách tìm element CHẮC CHẮN nhất
                        const form = findElementAbsolutely('editBoardForm-', boardId);
                        const input = findElementAbsolutely('editBoardName-', boardId);

                        if (!form || !input) {
                            throw new Error(`Elements not found (editBoardForm-${boardId}, editBoardName-${boardId})`);
                        }

                        // 3. Hiển thị form
                        form.style.display = 'block';
                        input.value = boardName || '';
                        console.log('Form shown SUCCESSFULLY');

                    } catch (error) {
                        console.error('FINAL ERROR:', error);
                        alert('Vui lòng đợi 2 giây rồi thử lại');
                        setTimeout(() => location.reload(), 2000); // Tự động reload
                    }
                }

                // Hàm tìm element bằng mọi cách
                function findElementAbsolutely(prefix, id) {
                    const fullId = `${prefix}${id}`;

                    // Thử 4 cách tìm element
                    return document.getElementById(fullId) ||
                            document.querySelector(`[id="${fullId}"]`) ||
                            document.querySelector(`[id*="${fullId}"]`) ||
                            [...document.querySelectorAll('[id^="editBoardForm-"]')]
                            .find(el => el.id.includes(id));
                }
            }

//
//



            function hideEditBoardForm(boardId) {
                const form = document.getElementById("editBoardForm-" + boardId);
                if (form)
                    form.style.display = 'none';
            }








            function submitEditBoard(boardId) {


                console.log("Gọi submitEditBoard với boardId =", boardId, "typeof =", typeof boardId);

                try {

                    console.log("Gọi submitEditBoard với boardId =", boardId, "typeof =", typeof boardId);


                    const nameInput = document.getElementById("editBoardName-" + boardId);
                    const descInput = document.getElementById("editBoardDesc-" + boardId);




//        const nameInput = document.getElementById(`editBoardName-${boardId}`);
//        const descInput = document.getElementById(`editBoardDesc-${boardId}`);
//        
//        const nameInput = document.getElementById(nameId);
//    const descInput = document.getElementById(descId);





                    console.log("DEBUG - BoardId nhận được:", boardId);
                    console.log("DEBUG - Đang tìm các phần tử với ID:", `editBoardName-${boardId}`, `editBoardDesc-${boardId}`);



                    console.log("DEBUG - Phần tử tìm thấy:", nameInput, descInput);

                    if (!nameInput || !descInput) {
                        throw new Error("Không tìm thấy các trường nhập liệu");
                    }

                    const newTitle = nameInput.value.trim();
                    const newDesc = descInput.value.trim();

                    if (!newTitle) {
                        alert("Tên board không được để trống");
                        return false;
                    }

                    fetch('${pageContext.request.contextPath}/admin/templatedetailservlet', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({
                            action: 'editBoard',
                            boardId: boardId,
                            name: newTitle,
                            description: newDesc
                        })
                    })
                            .then(response => {
                                if (!response.ok)
                                    throw new Error("Lỗi server: " + response.status);
                                window.location.reload();
                            })
                            .catch(error => {
                                console.error("Lỗi:", error);
                                alert("Lỗi khi cập nhật: " + error.message);
                            });

                    return false;
                } catch (error) {
                    console.error("Lỗi hệ thống:", error);
                    alert("Lỗi: " + error.message);
                    return false;
                }
            }
//           function submitEditBoard(boardId) {
//    // Lấy giá trị từ các trường input
//    const newName = document.getElementById(`editBoardName-${boardId}`).value.trim();
//    const newDesc = document.getElementById(`editBoardDesc-${boardId}`)?.value.trim() || ''; // Optional chaining nếu không có description
//
//    // Validate
//    if (!newName) {
//        alert("Board name cannot be empty.");
//        return false; // Ngăn form submit nếu dùng trong onclick
//    }
//
//    // Gửi request
//    fetch('/admin/templatedetailservlet', {
//        method: 'POST',
//        headers: {
//            'Content-Type': 'application/x-www-form-urlencoded'
//        },
//        body: new URLSearchParams({
//            action: 'editBoard',
//            boardId: boardId,
//            name: newName,
//            description: newDesc // Thêm description đã lấy được
//        })
//    })
//    .then(response => {
//        if (!response.ok) {
//            throw new Error('Network response was not ok');
//        }
//        return response.text(); // Hoặc response.json() nếu server trả về JSON
//    })
//    .then(() => {
//        window.location.reload(); // Reload trang sau khi thành công
//    })
//    .catch(error => {
//        console.error('Error:', error);
//        alert('Error saving board. Please try again.');
//    });
//
//    return false; // Ngăn form submit nếu dùng trong onclick
//}






            // Hiện form Add Board
            const addBoardBtn = document.querySelector('.add-board-btn');
            addBoardBtn.addEventListener('click', () => {
                document.getElementById('addBoardModal').style.display = 'block';
            });

            function deleteBoard(boardId) {
                if (confirm('Are you sure to delete this board and all its tasks?')) {
                    fetch('${pageContext.request.contextPath}/admin/templatedetailservlet', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({
                            action: 'deleteBoard',
                            boardId: boardId
                        })
                    }).then(res => location.reload());
                }
            }

            function deleteTask(taskId) {
                if (confirm('Are you sure to delete this task and its labels?')) {
                    fetch('${pageContext.request.contextPath}/admin/templatedetailservlet', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({
                            action: 'deleteTask',
                            taskId: taskId

                        })
                    }).then(res => location.reload());
                }
            }
        </script>






        <script src="${pageContext.request.contextPath}/Admin/TemplateDetail.js"></script>
    </body>
</html>
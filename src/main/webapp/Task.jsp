<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="/Header.jsp"%>
    <title>BeeTask - Tasks</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Task.css">
</head>

<body class="dark-mode">
    <div class="container">
        <aside class="sidebar">
            <div class="user-profile">
                <div class="avatar"></div>
                <div class="info">
                    <span class="username">Nguyễn Hữu Sơn</span>
                    <span class="email">nguyenhuusona6@gmail.com</span>
                </div>
            </div>
            <button class="toggle-btn"><i class="fas fa-bars"></i></button>
            <ul class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/DashboardProject.jsp">
                        <i class="fas fa-tachometer-alt"></i><span>Dash Board</span>
                    </a>
                </li>
                <li class="active">
                    <a href="${pageContext.request.contextPath}/Task.jsp">
                        <i class="fas fa-tasks"></i><span>Task</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/CalendarProject.jsp">
                        <i class="fas fa-calendar-alt"></i><span>Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Table.jsp">
                        <i class="fas fa-table"></i><span>Table</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Table.jsp">
                        <i class="fas fa-table"></i><span>Statitics</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Setting.jsp">
                        <i class="fas fa-cog"></i><span>Setting</span>
                    </a>
                </li>
            </ul>
            <ul class="menu help-menu">
                <li class="help-item"><i class="fas fa-question-circle"></i> <span>Help</span></li>
            </ul>
            <div class="drag-handle"></div>
        </aside>

        <main class="main-content">
            <%@include file="/HeaderContent.jsp" %>

            <div class="project-header-bar">
                <div class="project-header-name">Tên Project</div>
                <div class="project-header-actions">
                    <div class="project-user-avatar"></div>
                    <button class="project-action-btn project-filter-btn"><i class="fas fa-filter"></i></button>
                    <button class="project-action-btn project-pin-btn"><i class="fas fa-thumbtack"></i></button>
                    <button class="project-action-btn project-visibility-btn">Change visibility</button>
                    <button class="project-action-btn project-share-btn">Share</button>
                    <button class="project-action-btn project-more-btn"><i class="fas fa-ellipsis-v"></i></button>
                </div>
            </div>

            <div class="project-dashboard">
                <div class="task-status-container">
                    <div class="task-column">
                        <h3>
                            <div class="board-detail">
                                <span class="board-title" contenteditable="false">To Do</span>
                                <span class="task-count">(2)</span>
                            </div>
                            <span>
                                <button class="collapse-btn"><i class="fas fa-chevron-up"></i></button>
                                <button class="menu-btn"><i class="fas fa-ellipsis-v"></i></button>
                            </span>
                        </h3>
                        <div class="task-card">
                            <img src="${pageContext.request.contextPath}/Asset/image5.png" alt="Logo">
                            <p class="task-title" contenteditable="false">Write a Document</p>
                            <p class="task-date" contenteditable="false">May 16</p>
                        </div>
                        <div class="task-card">
                            <p class="task-title" contenteditable="false">Write a Document</p>
                            <p class="task-date" contenteditable="false">May 17</p>
                        </div>
                    </div>
                    <div class="task-column">
                        <h3>
                            <div class="board-detail">
                                <span class="board-title" contenteditable="false">In Progress</span>
                                <span class="task-count">(2)</span>
                            </div>
                            <span>
                                <button class="collapse-btn"><i class="fas fa-chevron-up"></i></button>
                                <button class="menu-btn"><i class="fas fa-ellipsis-v"></i></button>
                            </span>
                        </h3>
                        <div class="task-card">
                            <p class="task-title" contenteditable="false">Write a Document</p>
                            <p class="task-date" contenteditable="false">May 19</p>
                        </div>
                        <div class="task-card">
                            <p class="task-title" contenteditable="false">Write a Document</p>
                            <p class="task-date" contenteditable="false">May 17</p>
                        </div>
                    </div>
                    <div class="task-column">
                        <h3>
                            <div class="board-detail">
                                <span class="board-title" contenteditable="false">Done</span>
                                <span class="task-count">(2)</span>
                            </div>
                            <span>
                                <button class="collapse-btn"><i class="fas fa-chevron-up"></i></button>
                                <button class="menu-btn"><i class="fas fa-ellipsis-v"></i></button>
                            </span>
                        </h3>
                        <div class="task-card">
                            <p class="task-title" contenteditable="false">Write a Document</p>
                            <p class="task-date" contenteditable="false">May 18</p>
                        </div>
                        <div class="task-card">
                            <img src="${pageContext.request.contextPath}/Asset/image4.png" alt="Logo">
                            <p class="task-title" contenteditable="false">Write a Document</p>
                            <p class="task-date" contenteditable="false">May 17</p>
                        </div>
                    </div>
                </div>
                <!-- Nút Add Board -->
                <button id="addBoardBtn" class="add-board-btn">Add Board</button>

                <!-- Popup List Actions -->
                <div class="popup" id="taskPopup">
                    <div class="popup-content dropdown-menu">
                        <div class="dropdown-header">List actions<span class="popup-close">×</span></div>
                        <button class="dropdown-item" data-action="add-tasks">Add Tasks</button>
                        <button class="dropdown-item">Copy List</button>
                        <button class="dropdown-item">Move all task</button>
                        <button class="dropdown-item">Sort by</button>
                        <button class="dropdown-item delete-option">Delete Board</button>
                    </div>
                </div>

                <!-- Popup Add Task -->
                <div class="add-task-popup" id="addTaskPopup">
                    <div class="add-task-header">Add Task<span class="popup-close">×</span></div>
                    <div class="add-task-content">
                        <label for="task-name">Task Name</label>
                        <input type="text" id="task-name" placeholder="Enter task name">

                        <label for="task-description">Description</label>
                        <textarea id="task-description" placeholder="Enter description"></textarea>

                        <label for="task-priority">Priority</label>
                        <select id="task-priority">
                            <option value="low">Low</option>
                            <option value="medium">Medium</option>
                            <option value="high">High</option>
                        </select>

                        <label for="task-due-date">Due Date</label>
                        <input type="date" id="task-due-date">
                    </div>
                    <div class="add-task-actions">
                        <button class="cancel-btn">Cancel</button>
                        <button class="add-btn">Add Task</button>
                    </div>
                </div>

                <!-- Popup Task Detail (sử dụng chung) -->
                <div class="task-detail-popup" id="taskDetailPopup">
                    <div class="task-detail-header">Task Details<span class="popup-close">×</span></div>
                    <div class="task-detail-content">
                        <div class="task-detail-fields">
                            <label>Task title</label>
                            <input type="text" class="task-title-input" value="Task title" readonly>
                            <label>Description</label>
                            <textarea class="task-description-input"
                                placeholder="Add detailed description ...">Add detailed description ...</textarea>
                        </div>
                        <div class="task-detail-actions">
                            <div class="action-btn-container">
                                <button class="action-btn labels-btn">Labels</button>
                                <div class="labels-dropdown" style="display: none;">
                                    <div class="dropdown-header">Select Labels<span class="dropdown-close">×</span>
                                    </div>
                                    <div class="dropdown-content">
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#FF4500">
                                            <span class="color-box" style="background-color: #FF4500;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#228B22">
                                            <span class="color-box" style="background-color: #228B22;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#6A5ACD">
                                            <span class="color-box" style="background-color: #6A5ACD;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#20B2AA">
                                            <span class="color-box" style="background-color: #20B2AA;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#FFA07A">
                                            <span class="color-box" style="background-color: #FFA07A;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#FF69B4">
                                            <span class="color-box" style="background-color: #FF69B4;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#1E90FF">
                                            <span class="color-box" style="background-color: #1E90FF;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#87CEEB">
                                            <span class="color-box" style="background-color: #87CEEB;"></span>
                                        </label>
                                        <label class="dropdown-item">
                                            <input type="checkbox" class="label-checkbox" data-color="#FFD700">
                                            <span class="color-box" style="background-color: #FFD700;"></span>
                                        </label>
                                        <div class="add-label">
                                            <input type="color" class="add-label-input" value="#FF4500">
                                            <button class="add-label-btn">+</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <button class="action-btn">Deadline</button>
                            <button class="action-btn">Check List</button>
                            <button class="action-btn">Assignee</button>
                            <button class="action-btn">Attachments</button>
                            <button class="action-btn">Priority</button>
                        </div>
                        <div class="task-detail-values">
                            <div class="value-box" data-type="labels">
                                <span class="value"></span>
                            </div>
                            <div class="value-box" data-type="deadline">
                                <span class="value"></span>
                            </div>
                            <div class="value-box" data-type="assignee">
                                <span class="value"></span>
                            </div>
                            <div class="value-box" data-type="priority">
                                <span class="value"></span>
                            </div>
                        </div>
                    </div>
                    <div class="task-detail-actions-bottom">
                        <button class="suggestion-btn">AI Suggestion</button>
                        <button class="save-btn">Save</button>
                    </div>
                </div>


                <div class="tasks-overview">
                    <h3>Tasks</h3>
                    <div class="task-list">
                        <div class="task-row" style="font-weight: bold; background-color: #1E2333; color: white;">
                            <div class="task-cell">Tasks</div>
                            <div class="task-cell">Deadline</div>
                            <div class="task-cell">Priority</div>
                            <div class="task-cell">Suggested Time</div>
                        </div>
                        <div class="task-row">
                            <div class="task-cell">Write a Document</div>
                            <div class="task-cell">May 17</div>
                            <div class="task-cell">
                                <div class="priority-container">
                                    <div class="task-cell priority hight">Hight</div>
                                </div>
                            </div>
                            <div class="task-cell">Thu 8:00 - 10PM</div>
                        </div>
                        <div class="task-row">
                            <div class="task-cell">Write a Document</div>
                            <div class="task-cell">May 17</div>
                            <div class="task-cell">
                                <div class="priority-container">
                                    <div class="task-cell priority medium">Medium</div>
                                </div>
                            </div>
                            <div class="task-cell">Thu 8:00 - 10PM</div>
                        </div>
                        <div class="task-row">
                            <div class="task-cell">Write a Document</div>
                            <div class="task-cell">May 17</div>
                            <div class="task-cell">
                                <div class="priority-container">
                                    <div class="task-cell priority low">Low</div>
                                </div>
                            </div>
                            <div class="task-cell">Thu 8:00 - 10PM</div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/TaskScript.js"></script>
</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Project Calendar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CelendarProject.css">
    <script>
    window.addEventListener('DOMContentLoaded', () => {
        // Áp dụng theme
        const savedTheme = localStorage.getItem('theme') || 'dark-mode';
        if (savedTheme === 'dark-mode') {
            document.body.classList.add('dark-mode');
            const toggle = document.getElementById('darkModeToggle');
            if (toggle) toggle.checked = true;
        } else {
            document.body.classList.remove('dark-mode');
            const toggle = document.getElementById('darkModeToggle');
            if (toggle) toggle.checked = false;
        }

        // Áp dụng trạng thái sidebar
        const savedSidebarState = localStorage.getItem('sidebarState') || 'expanded';
        const sidebar = document.querySelector('.sidebar');
        if (sidebar) {
            if (savedSidebarState === 'collapsed') {
                sidebar.classList.add('collapsed');
            } else {
                sidebar.classList.remove('collapsed');
            }
        }

        // Xử lý sự kiện thay đổi theme
        const darkModeToggle = document.getElementById('darkModeToggle');
        if (darkModeToggle) {
            darkModeToggle.addEventListener('change', () => {
                const isDarkMode = darkModeToggle.checked;
                document.body.classList.toggle('dark-mode', isDarkMode);
                localStorage.setItem('theme', isDarkMode ? 'dark-mode' : 'light-mode');
                console.log('Dark Mode:', isDarkMode);
            });
        } else {
            console.warn('Phần tử #darkModeToggle không tồn tại.');
        }
    });
</script>
</head>
<body>
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
                    <a href="${pageContext.request.contextPath}/Task.jsp">
                        <i class="fas fa-tasks"></i><span>Task</span>
                    </a>
                </li>
                <li class="active">
                    <a href="${pageContext.request.contextPath}/CalendarProjectIndividual.jsp">
                        <i class="fas fa-calendar-alt"></i><span>Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Table.jsp">
                        <i class="fas fa-table"></i><span>Table</span>
                    </a>
                </li>
            </ul>
            <ul class="help-menu">
                <li class="help-item"><i class="fas fa-question-circle"></i><span>Help</span></li>
            </ul>
        </aside>
        <main class="main-content">
            <header class="header">
                <div class="header-content-wrapper">
                    <div class="header-left">
                        <button class="icon-btn"><img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="Logo"></button>
                    </div>
                    <div class="header-center">
                        <input type="text" class="search-box" placeholder="Search...">
                        <button class="create-btn">Create Task</button>
                    </div>
                    <div class="header-right">
                        <label class="switch">
                            <input type="checkbox" id="darkModeToggle">
                            <span class="slider"></span>
                        </label>
                        <span class="dark-label">Dark Mode</span>
                    </div>
                </div>
            </header>
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
            <div class="calendar-box">
                <div class="calendar-header">
                    <select id="month-year"></select>
                    <button id="prev-month"><</button>
                    <span id="current-week">This day</span>
                    <button id="next-month">></button>
                    <div class="view-mode">
                        <select id="view-mode-select">
                            <option value="month">Month</option>
                            <option value="week">Week</option>
                            <option value="day">Day</option>
                        </select>
                    </div>
                </div>
                <div class="calendar-content">
                    <div class="sidebar-calendar">
                        <div class="calendar-header">
                            <button id="prev-month-sidebar"><</button>
                            <span id="sidebar-month-year">May, 2025</span>
                            <button id="next-month-sidebar">></button>
                        </div>
                        <table class="sidebar-calendar-table">
                            <thead>
                                <tr>
                                    <th>Sun</th>
                                    <th>Mon</th>
                                    <th>Tue</th>
                                    <th>Wed</th>
                                    <th>Thu</th>
                                    <th>Fri</th>
                                    <th>Sat</th>
                                </tr>
                            </thead>
                            <tbody id="sidebar-calendar-body"></tbody>
                        </table>
                    </div>
                    <div class="calendar-wrapper">
                        <table class="calendar">
                            <thead>
                                <tr>
                                    <th>Sunday</th>
                                    <th>Monday</th>
                                    <th>Tuesday</th>
                                    <th>Wednesday</th>
                                    <th>Thursday</th>
                                    <th>Friday</th>
                                    <th>Saturday</th>
                                </tr>
                            </thead>
                            <tbody id="calendar-body"></tbody>
                        </table>
                    </div>
                </div>
                <button id="add-event-btn" class="add-btn">Add</button>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/CelendarProjectScript.js"></script>
</body>
</html>
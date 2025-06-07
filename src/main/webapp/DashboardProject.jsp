<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Project Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/DashboardProject.css">
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
                <li class="active">
                    <a href="${pageContext.request.contextPath}/DashboardProject.jsp">
                        <i class="fas fa-tachometer-alt"></i><span>Dash Board</span>
                    </a>
                </li>
                <li>
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
            <div class="header">
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
            </div>

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

            <div class="dashboard-container">
                <h2 class="dashboard-title">DashBoard</h2>
                <div class="charts">
                    <div class="chart-card">
                        <h4>User participation</h4>
                        <canvas id="userChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <h4>Time Dynamics</h4>
                        <canvas id="timeChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <h4>Tasks Numbers</h4>
                        <canvas id="taskChart"></canvas>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/DashboardProjectScript.js"></script>
</body>

</html>
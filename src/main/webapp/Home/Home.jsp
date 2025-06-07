<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BeeTask Home</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Home.css">
    <script>
        // Áp dụng theme và trạng thái sidebar từ localStorage khi tải trang
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
        });
    </script>
</head>

<<<<<<< HEAD:src/main/webapp/Home/Home.jsp
<body>
=======
<body class="dark-mode">
>>>>>>> fcad0d7a9b382bb21abfd02abe9ff8c731147cd6:Home.html
    <div class="container">
        <!-- Sidebar -->
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
                    <a href="${pageContext.request.contextPath}/Home/Home.jsp">
                        <i class="fas fa-home"></i><span>Home</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Home/TemplateHome.jsp">
                        <i class="fas fa-copy"></i><span>Templates</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Home/CalendarHome.jsp">
                        <i class="fas fa-calendar-day"></i><span>Today</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Home/Table.jsp">
                        <i class="fas fa-calendar-alt"></i><span>Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/Home/Setting.jsp">
                        <i class="fas fa-cog"></i><span>Setting</span>
                    </a>
                </li>
            </ul>

            <div class="my-project">
                <h4>My project</h4>
                <ul class="project-list">
                    <li>Dự án con bò</li>
                    <li>Dự án con Tem</li>
                    <li>Dự án Vua Game</li>
                </ul>
            </div>

            <ul class="menu help-menu">
                <li class="help-item"><i class="fas fa-question-circle"></i> <span>Help</span></li>
            </ul>
            <div class="drag-handle"></div>
        </aside>

        <!-- Main Header -->
        <main class="main-content">
            <div class="header">
                <div class="header-content-wrapper">
                    <div class="header-left">
                        <button class="icon-btn"><img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="Logo"></button>
                    </div>
                    <div class="header-center">
                        <input type="text" class="search-box" placeholder="Search" />
                        <button class="create-btn">Create Project</button>
                    </div>
                    <div class="header-right">
                        <label class="switch">
                            <input type="checkbox" id="darkModeToggle" />
                            <span class="slider"></span>
                        </label>
                        <span class="dark-label">Dark Mode</span>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Nội dung chính -->
    <div class="content-wrapper">
        <div class="dashboard">
            <!-- Cột trái -->
            <div class="column">
                <h3>Recently viewed</h3>

                <div class="recent-item">
                    <img src="${pageContext.request.contextPath}/Asset/image1.png" alt="Project Thumbnail">
                    <div>
                        <p class="project-title">Dự án con bò</p>
                        <p class="start-date">Start: 10/4/2025</p>
                    </div>
                </div>

                <div class="recent-item">
                    <img src="${pageContext.request.contextPath}/Asset/image2.png" alt="Project Thumbnail">
                    <div>
                        <p class="project-title">Dự án con Tem</p>
                        <p class="start-date">Start: 5/4/2025</p>
                    </div>
                </div>

                <div class="recent-item">
<<<<<<< HEAD:src/main/webapp/Home/Home.jsp
                    <img src="${pageContext.request.contextPath}/Asset/image3.png" alt="Project Thumbnail">
=======
                    <img src="image_ (48).png" alt="Project Thumbnail" />
>>>>>>> fcad0d7a9b382bb21abfd02abe9ff8c731147cd6:Home.html
                    <div>
                        <p class="project-title">Dự án Vua Game</p>
                        <p class="start-date">Start: 1/1/2025</p>
                    </div>
                </div>

                <h3>Up Next</h3>
                <div class="task-card">
<<<<<<< HEAD:src/main/webapp/Home/Home.jsp
                    <div class="task-banner" style="background-image: url('${pageContext.request.contextPath}/Asset/image3.png');">
=======
                    <div class="task-banner" style="background-image: url('./image_\ \(28\).png');">
>>>>>>> fcad0d7a9b382bb21abfd02abe9ff8c731147cd6:Home.html
                        <div class="task-content">
                            <p class="label">Design UI/UX</p>
                            <span class="priority high">High</span>
                        </div>
                    </div>

                    <div class="title-menu-wrapper">
                        <p class="task-title">Dự án con bò</p>
                        <button class="menu-dot"><i class="fas fa-ellipsis-h"></i></button>
                    </div>
                    <p class="deadline">Deadline: May 16, 2025, 8:30PM</p>
                    <div class="task-buttons">
                        <button class="move-btn"><i class="fas fa-share"></i> Move to...</button>
                        <button class="dismiss-btn"><i class="fas fa-times"></i> Dismiss</button>
                    </div>
                </div>
            </div>

            <!-- Cột phải -->
            <div class="column">
                <h3>Pin project</h3>
                <div class="pin-project">
                    <img src="${pageContext.request.contextPath}/Asset/image4.png" alt="Project Thumbnail">
                    <div>
                        <p class="project-title">Dự án con bò</p>
                        <p class="start-date">Start: 10/4/2025</p>
                    </div>
                    <i class="fas fa-star"></i>
                </div>

                <h3>Assignee to me</h3>
                <p>Bạn có một assignee mới từ NguyễnHUUsơn</p>
                <div class="assignee-card">
<<<<<<< HEAD:src/main/webapp/Home/Home.jsp
                    <div class="task-banner" style="background-image: url('${pageContext.request.contextPath}/Asset/image4.png');">
                        <div class="task-content">
                            <p class="label">Design UI/UX</p>
                            <span class="priority high">High</span>
                        </div>
                    </div>
=======
                    <div class="task-banner" style="background-image: url('image_ (48).png');"></div>
>>>>>>> fcad0d7a9b382bb21abfd02abe9ff8c731147cd6:Home.html
                    <div class="title-menu-wrapper">
                        <p class="task-title">Dự án con bò</p>
                        <button class="menu-dot"><i class="fas fa-ellipsis-h"></i></button>
                    </div>
                    <p class="deadline">Deadline: May 16, 2025, 8:30PM</p>
                    <div class="task-buttons">
                        <button class="go-btn">Go to project</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Script -->
<<<<<<< HEAD:src/main/webapp/Home/Home.jsp
    <script src="${pageContext.request.contextPath}/HomeScript.js"></script>
=======
    <script src="homeScript.js"></script>
>>>>>>> fcad0d7a9b382bb21abfd02abe9ff8c731147cd6:Home.html
</body>

</html>
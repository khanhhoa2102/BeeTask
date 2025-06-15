<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@ include file="../Header.jsp"%>
    <title>BeeTask Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Home.css">
</head>

<body class="dark-mode">
    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="user-profile">
                    <div class="avatar">
                        <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                        <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #ccc;"></div>
                        <% } %>
                    </div>
                <div class="info">
                        <span class="username"><%= user.getFullName() %></span>
                        <span class="email"><%= user.getEmail() %></span>
                </div>
            </div>
            
            <%@include file="../Sidebar.jsp" %>

            <div class="my-project">
                <h4>My project</h4>
                <ul class="project-list">
                    <li>Dự án con bò</li>
                    <li>Dự án con Tem</li>
                    <li>Dự án Vua Game</li>
                </ul>
            </div>
            
            <%@include file="../Help.jsp" %>
        </aside>

        <!-- Main Header -->
        <main class="main-content">
            <%@include file="../HeaderContent.jsp" %>
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
                    <img src="${pageContext.request.contextPath}/Asset/image3.png" alt="Project Thumbnail">
                    <div>
                        <p class="project-title">Dự án Vua Game</p>
                        <p class="start-date">Start: 1/1/2025</p>
                    </div>
                </div>

                <h3>Up Next</h3>
                <div class="task-card">
                    <div class="task-banner" style="background-image: url('${pageContext.request.contextPath}/Asset/image3.png');">
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
                <div class="task-card">
                    <div class="task-banner" style="background-image: url('${pageContext.request.contextPath}/Asset/image4.png');">
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
                        <button class="go-btn">Go to project</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Script -->
    <script src="${pageContext.request.contextPath}/Home/HomeScript.js"></script>
</body>

</html>
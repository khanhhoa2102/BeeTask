<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    model.User user = (model.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="../Header.jsp"%>
        <title>BeeTask Home</title>
        <link rel="stylesheet" href="Home.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>

    <body class="dashboard-body">
        <div class="dashboard-container">
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
                        <span class="username"><%= user.getUsername() %></span>
                        <span class="email"><%= user.getEmail() %></span>
                    </div>
                </div>

                <%@include file="../Sidebar.jsp"%>
                <%@include file="../Help.jsp" %>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <%@include file="../HeaderContent.jsp" %>
                
                <!-- Dashboard Content -->
                <div class="dashboard-content">
                    <!-- Stats Cards Row -->
                    <div class="stats-row">
                        <div class="stat-card completed">
                            <div class="stat-icon">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="stat-info">
                                <h3>18</h3>
                                <p>Completed</p>
                            </div>
                        </div>

                        <div class="stat-card in-progress">
                            <div class="stat-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-info">
                                <h3>13</h3>
                                <p>In Progress</p>
                            </div>
                        </div>

                        <div class="team-members-card">
                            <div class="team-header">
                                <h4>Team Members</h4>
                                <span class="member-count">+31</span>
                            </div>
                            <div class="team-avatars">
                                <div class="team-avatar">
                                    <img src="${pageContext.request.contextPath}/Asset/avatar1.png" alt="Member" onerror="this.style.display='none'">
                                </div>
                                <div class="team-avatar">
                                    <img src="${pageContext.request.contextPath}/Asset/avatar2.png" alt="Member" onerror="this.style.display='none'">
                                </div>
                                <div class="team-avatar">
                                    <img src="${pageContext.request.contextPath}/Asset/avatar3.png" alt="Member" onerror="this.style.display='none'">
                                </div>
                                <div class="team-avatar">
                                    <img src="${pageContext.request.contextPath}/Asset/avatar4.png" alt="Member" onerror="this.style.display='none'">
                                </div>
                            </div>
                            <div class="working-hours">
                                <h3>124</h3>
                                <p>Working Hours</p>
                            </div>
                        </div>

                        <div class="timer-card">
                            <div class="timer-header">
                                <h4>Timer</h4>
                                <div class="timer-controls">
                                    <button class="timer-btn pause">
                                        <i class="fas fa-pause"></i>
                                    </button>
                                    <button class="timer-btn play">
                                        <i class="fas fa-play"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="timer-display">
                                <span class="time">02:36:19</span>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content Grid -->
                    <div class="content-grid">
                        <!-- Recent Tasks -->
                        <div class="content-section recent-tasks">
                            <div class="section-header">
                                <h3>Recent Tasks</h3>
                                <button class="view-all-btn">View all</button>
                            </div>

                            <div class="task-grid">
                                <div class="task-card task-list">
                                    <div class="task-header">
                                        <span class="task-label">Task List</span>
                                        <button class="task-menu-btn">
                                            <i class="fas fa-ellipsis-h"></i>
                                        </button>
                                    </div>
                                    <h4 class="task-title">Task Manager Dashboard</h4>
                                    <p class="task-description">Lorem ipsum is simply dummy text of the printing and typesetting industry.</p>
                                    <div class="task-footer">
                                        <span class="task-date">10 Sep 2023</span>
                                        <div class="task-progress">
                                            <div class="progress-bar">
                                                <div class="progress-fill" style="width: 40%;"></div>
                                            </div>
                                            <span class="progress-text">40%</span>
                                        </div>
                                    </div>
                                    <div class="task-avatars">
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar1.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar2.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                    </div>
                                </div>

                                <div class="task-card completed-task">
                                    <div class="task-header">
                                        <span class="task-label completed">Completed</span>
                                        <button class="task-menu-btn">
                                            <i class="fas fa-ellipsis-h"></i>
                                        </button>
                                    </div>
                                    <h4 class="task-title">Music Dashboard Website Template</h4>
                                    <p class="task-description">Lorem ipsum is simply dummy text of the printing and typesetting industry.</p>
                                    <div class="task-footer">
                                        <span class="task-date">12 Sep 2023</span>
                                        <div class="task-progress completed">
                                            <div class="progress-bar">
                                                <div class="progress-fill" style="width: 100%;"></div>
                                            </div>
                                            <span class="progress-text">100%</span>
                                        </div>
                                    </div>
                                    <div class="task-avatars">
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar3.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                    </div>
                                </div>

                                <div class="task-card design-task">
                                    <div class="task-header">
                                        <span class="task-label design">Design</span>
                                        <button class="task-menu-btn">
                                            <i class="fas fa-ellipsis-h"></i>
                                        </button>
                                    </div>
                                    <h4 class="task-title">Banking App Design</h4>
                                    <p class="task-description">Lorem ipsum is simply dummy text of the printing and typesetting industry.</p>
                                    <div class="task-footer">
                                        <span class="task-date">15 Sep 2023</span>
                                        <div class="task-progress">
                                            <div class="progress-bar">
                                                <div class="progress-fill" style="width: 75%;"></div>
                                            </div>
                                            <span class="progress-text">75%</span>
                                        </div>
                                    </div>
                                    <div class="task-avatars">
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar4.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar1.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                    </div>
                                </div>

                                <div class="task-card done-task">
                                    <div class="task-header">
                                        <span class="task-label done">Done</span>
                                        <button class="task-menu-btn">
                                            <i class="fas fa-ellipsis-h"></i>
                                        </button>
                                    </div>
                                    <h4 class="task-title">Mobile App Development</h4>
                                    <p class="task-description">Lorem ipsum is simply dummy text of the printing and typesetting industry.</p>
                                    <div class="task-footer">
                                        <span class="task-date">07 Sep 2023</span>
                                        <div class="task-progress completed">
                                            <div class="progress-bar">
                                                <div class="progress-fill" style="width: 100%;"></div>
                                            </div>
                                            <span class="progress-text">Done</span>
                                        </div>
                                    </div>
                                    <div class="task-avatars">
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar2.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                        <div class="task-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar3.png" alt="Assignee" onerror="this.style.display='none'">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Sidebar -->
                        <div class="right-sidebar">
                            <!-- Calendar -->
                            <div class="calendar-widget">
                                <div class="calendar-header">
                                    <button class="calendar-nav prev">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <h4>Sep 2023</h4>
                                    <button class="calendar-nav next">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                                <div class="calendar-grid">
                                    <div class="calendar-days">
                                        <span>Sun</span>
                                        <span>Mon</span>
                                        <span>Tue</span>
                                        <span>Wed</span>
                                        <span>Thu</span>
                                        <span>Fri</span>
                                        <span>Sat</span>
                                    </div>
                                    <div class="calendar-dates">
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span>1</span>
                                        <span>2</span>
                                        <span>3</span>
                                        <span>4</span>
                                        <span>5</span>
                                        <span>6</span>
                                        <span>7</span>
                                        <span>8</span>
                                        <span>9</span>
                                        <span>10</span>
                                        <span>11</span>
                                        <span>12</span>
                                        <span>13</span>
                                        <span>14</span>
                                        <span class="today">15</span>
                                        <span>16</span>
                                        <span>17</span>
                                        <span>18</span>
                                        <span>19</span>
                                        <span>20</span>
                                        <span>21</span>
                                        <span>22</span>
                                        <span>23</span>
                                        <span>24</span>
                                        <span>25</span>
                                        <span>26</span>
                                        <span>27</span>
                                        <span>28</span>
                                        <span>29</span>
                                        <span>30</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Messages -->
                            <div class="messages-widget">
                                <div class="messages-header">
                                    <h4>Messages</h4>
                                    <button class="view-all-btn">View all</button>
                                </div>
                                <div class="messages-list">
                                    <div class="message-item">
                                        <div class="message-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar1.png" alt="Ann Johnson" onerror="this.style.display='none'">
                                        </div>
                                        <div class="message-content">
                                            <div class="message-header">
                                                <span class="sender-name">Ann Johnson</span>
                                                <span class="message-time">12:18</span>
                                            </div>
                                            <p class="message-text">Lorem ipsum is simply dummy text of the...</p>
                                        </div>
                                    </div>

                                    <div class="message-item">
                                        <div class="message-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar2.png" alt="Ann Johnson" onerror="this.style.display='none'">
                                        </div>
                                        <div class="message-content">
                                            <div class="message-header">
                                                <span class="sender-name">Ann Johnson</span>
                                                <span class="message-time">14:15</span>
                                            </div>
                                            <p class="message-text">Lorem ipsum is simply dummy text of the...</p>
                                        </div>
                                    </div>

                                    <div class="message-item">
                                        <div class="message-avatar">
                                            <img src="${pageContext.request.contextPath}/Asset/avatar3.png" alt="Ann Johnson" onerror="this.style.display='none'">
                                        </div>
                                        <div class="message-content">
                                            <div class="message-header">
                                                <span class="sender-name">Ann Johnson</span>
                                                <span class="message-time">17:30</span>
                                            </div>
                                            <p class="message-text">Lorem ipsum is simply...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script src="HomeScript.js"></script>
    </body>
</html>

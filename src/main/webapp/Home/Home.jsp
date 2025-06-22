<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
                <!-- Minimalist Dashboard Content -->
                <div class="dashboard-content">
                    <!-- Main Welcome Section -->
                    <div class="main-section">
                        <div class="welcome-card">
                            <div class="welcome-illustration">
                                <div class="illustration-container">
                                    <div class="floating-shapes">
                                        <div class="shape shape-1"></div>
                                        <div class="shape shape-2"></div>
                                        <div class="shape shape-3"></div>
                                        <div class="shape shape-4"></div>
                                        <div class="shape shape-5"></div>
                                    </div>
                                    <div class="central-icon">
                                        <i class="fas fa-tasks"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="welcome-content">
                                <h2>Welcome to BeeTask</h2>
                                <p>Manage your work efficiently, track project progress, and collaborate with your team seamlessly. Start by creating your first workspace and organizing your tasks.</p>
                                <div class="welcome-actions">
                                    <button class="primary-btn">
                                        <i class="fas fa-plus"></i>
                                        Create New Project
                                    </button>
                                    <button class="secondary-btn">
                                        <i class="fas fa-play"></i>
                                        View Tutorial
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Sidebar -->
                    <div class="right-sidebar">
                        <!-- Compact Clock Widget -->
                        <div class="clock-widget">
                            <div class="widget-header">
                                <h4><i class="fas fa-clock"></i> Current Time</h4>
                            </div>
                            <div class="clock-display">
                                <div class="mini-analog-clock">
                                    <div class="mini-clock-face">
                                        <div class="mini-hour-hand" id="miniHourHand"></div>
                                        <div class="mini-minute-hand" id="miniMinuteHand"></div>
                                        <div class="mini-second-hand" id="miniSecondHand"></div>
                                        <div class="mini-center-dot"></div>
                                    </div>
                                </div>
                                <div class="time-info">
                                    <div class="current-time" id="currentTime">00:00:00</div>
                                    <div class="current-date" id="currentDate">Monday, January 1, 2024</div>
                                </div>
                            </div>
                        </div>

                        <!-- Compact Calendar Widget -->
                        <div class="calendar-widget">
                            <div class="widget-header">
                                <h4><i class="fas fa-calendar"></i> Calendar</h4>
                                <div class="calendar-nav">
                                    <button class="nav-btn prev" id="prevMonth">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <span class="month-year" id="monthYear">December, 2024</span>
                                    <button class="nav-btn next" id="nextMonth">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="mini-calendar">
                                <div class="calendar-days">
                                    <span>Sun</span>
                                    <span>Mon</span>
                                    <span>Tue</span>
                                    <span>Wed</span>
                                    <span>Thu</span>
                                    <span>Fri</span>
                                    <span>Sat</span>
                                </div>
                                <div class="calendar-dates" id="calendarDates">
                                    <!-- Calendar dates will be generated by JavaScript -->
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activity Widget -->
                        <div class="activity-widget">
                            <div class="widget-header">
                                <h4><i class="fas fa-history"></i> Recent Activity</h4>
                            </div>
                            <div class="activity-list">
                                <div class="activity-item">
                                    <div class="activity-icon completed">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="activity-content">
                                        <span class="activity-text">Completed task "UI Design"</span>
                                        <span class="activity-time">2 hours ago</span>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon new">
                                        <i class="fas fa-plus"></i>
                                    </div>
                                    <div class="activity-content">
                                        <span class="activity-text">Created new project "Website"</span>
                                        <span class="activity-time">5 hours ago</span>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon comment">
                                        <i class="fas fa-comment"></i>
                                    </div>
                                    <div class="activity-content">
                                        <span class="activity-text">Commented on "Code Review" task</span>
                                        <span class="activity-time">1 day ago</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script src="Home.js"></script>
    </body>
</html>
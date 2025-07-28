<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User headerUser = (User) session.getAttribute("user");
    Boolean skipUserIdSet = (Boolean) request.getAttribute("skipUserIdSet");

    if (headerUser != null && (skipUserIdSet == null || !skipUserIdSet)) {
        session.setAttribute("userId", headerUser.getUserId());
    }
%>

<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/Header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Notification.css">

<div class="header">
    <div class="header-content-wrapper">
        <div class="header-left">
            <button class="icon-btn">
                <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="Logo">
            </button>
        </div>

        <div class="header-center">
            <input type="text" class="search-box" placeholder="Search...">
            <button class="create-btn">Create</button>
        </div>

        <div class="header-right">
            <!-- Dark Mode Toggle -->
            <div class="dark-mode-section">
                <span class="dark-label">Dark</span>
                <label class="switch">
                    <input type="checkbox" id="darkModeToggle">
                    <span class="slider"></span>
                </label>
            </div>

            <!-- Header Icons -->
            <div class="header-icons">
                <button class="header-icon-btn" id="bookmarkBtn" title="Bookmarks">
                    <i class="far fa-bookmark"></i>
                </button>
                <button class="header-icon-btn" id="notificationBtn" title="Notifications" onclick="toggleDropdown()">
                    <i class="far fa-bell"></i>
                </button>
                <div class="notification-dropdown" id="notificationDropdown">
                    <div class="notification-scrollable">
                        <div class="notification-section">
                            <button class="section-toggle" onclick="toggleSection('systemSection')">
                                ▶ System
                            </button>
                            <ul id="systemSection" class="notification-section-content">
                                <!-- JS will populate system notifications here -->
                            </ul>
                        </div>
                        <div id="notificationList">
                            <!-- JS will populate project notifications here -->
                        </div>
                    </div>
                    <div class="notification-actions">
                        <button onclick="markAllRead()">Mark all read</button>
                        <button onclick="markAllUnread()">Mark all unread</button>
                        <button onclick="window.location.href='${pageContext.request.contextPath}/ManageNotification.jsp'">Manage</button>
                    </div>
                </div>
                <button class="header-icon-btn" id="helpBtn" title="Help">
                    <i class="far fa-question-circle"></i>
                </button>

                <% if (headerUser != null) { %>
                <!-- User Avatar & Dropdown -->
                <div class="user-avatar-container" style="position: relative;">
                    <button class="user-avatar-btn" id="userAvatarBtn" title="Account menu">
                        <%= headerUser.getUsername().substring(0, 2).toUpperCase() %>
                    </button>

                    <div class="user-dropdown" id="userDropdown">
                        <!-- Header Info -->
                        <div class="dropdown-header">
                            <div class="dropdown-section-title">ACCOUNT</div>
                            <div class="dropdown-user-info">
                                <div class="dropdown-avatar">
                                    <%= headerUser.getUsername().substring(0, 2).toUpperCase() %>
                                </div>
                                <div class="dropdown-user-details">
                                    <h6><%= headerUser.getUsername() %></h6>
                                    <p><%= headerUser.getEmail() %></p>
                                </div>
                            </div>
                        </div>

                        <!-- Account Section -->
                        <div class="dropdown-section">
                            <a href="${pageContext.request.contextPath}/Authentication/SwitchAccount.jsp" class="dropdown-item">
                                <span>Switch Account</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/account/settings" class="dropdown-item has-arrow">
                                <span>Account Settings</span>
                            </a>
                            <% if(headerUser.getRole().equalsIgnoreCase("User")) {%>
                            <a href="${pageContext.request.contextPath}/VIP.jsp" class="dropdown-item">
                                <span>Get Premium</span>
                            </a>
                            <%}%>
                        </div>

                        <!-- Workspace -->
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item workspace-item">
                                <i class="fas fa-users"></i>
                                <span>Create Workspace</span>
                            </a>
                        </div>

                        <!-- Help & Logout -->
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item">
                                <span>Help</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/Header.js"></script>

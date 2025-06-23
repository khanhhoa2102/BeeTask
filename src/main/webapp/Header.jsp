<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="session-check.jspf" %>
<% session.setAttribute("userId", (Integer)user.getUserId());%>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Notification.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Header.css">

<div class="header">
    <div class="header-content-wrapper">
        <div class="header-left">
            <button class="icon-btn">
                <img src="../Asset/Longlogo.png" alt="Logo">
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
                    <ul id="notificationList">
                        <!-- JS will populate list here -->
                    </ul>
                    <div class="notification-actions">
                        <button onclick="markAllRead(event)">Mark all read</button>
                        <button onclick="markAllUnread(event)">Mark all unread</button>
                        <button onclick="window.location.href='${pageContext.request.contextPath}/ManageNotification.jsp'">Manage</button>
                    </div>
                </div>
                <button class="header-icon-btn" id="helpBtn" title="Help">
                    <i class="far fa-question-circle"></i>
                </button>

                <!-- User Avatar & Dropdown -->
                <div class="user-avatar-container" style="position: relative;">
                    <button class="user-avatar-btn" id="userAvatarBtn" title="Account menu">
                        <%= user.getUsername().substring(0, 2).toUpperCase() %>
                    </button>

                    <div class="user-dropdown" id="userDropdown">
                        <!-- Header Info -->
                        <div class="dropdown-header">
                            <div class="dropdown-section-title">ACCOUNT</div>
                            <div class="dropdown-user-info">
                                <div class="dropdown-avatar">
                                    <%= user.getUsername().substring(0, 2).toUpperCase() %>
                                </div>
                                <div class="dropdown-user-details">
                                    <h4><%= user.getUsername() %></h4>
                                    <p><%= user.getEmail() %></p>
                                </div>
                            </div>
                        </div>

                        <!-- Account Section -->
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item">
                                <span>Switch Account</span>
                            </a>
                            <a href="#" class="dropdown-item has-arrow">
                                <span>Account Settings</span>
                            </a>
                        </div>

                        <!-- Trello Section -->
                        <div class="dropdown-section">
                            <div class="dropdown-section-title">TRELLO</div>
                            <a href="#" class="dropdown-item">
                                <span>Profile & Display</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Activity</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Cards</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Settings</span>
                            </a>
                            <a href="#" class="dropdown-item has-arrow">
                                <span>Theme</span>
                            </a>
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
                            <a href="#" class="dropdown-item">
                                <span>Keyboard Shortcuts</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    window.addEventListener('DOMContentLoaded', () => {
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

        const darkModeToggle = document.getElementById('darkModeToggle');
        if (darkModeToggle) {
            darkModeToggle.addEventListener('change', () => {
                const isDarkMode = darkModeToggle.checked;
                document.body.classList.toggle('dark-mode', isDarkMode);
                localStorage.setItem('theme', isDarkMode ? 'dark-mode' : 'light-mode');
                console.log('Dark Mode:', isDarkMode);
            });
        } else {
            console.warn('#darkModeToggle element not found.');
        }
    });

    function toggleDropdown() {
        const dropdown = document.getElementById("notificationDropdown");
        dropdown.classList.toggle("show");
        if (dropdown.classList.contains("show")) {
            loadNotifications();
        }
    }

    function loadNotifications() {
        fetch('${pageContext.request.contextPath}/notifications?action=view')
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById("notificationList");
                const countEl = document.getElementById("notificationCount");
                list.innerHTML = "";

                let unreadCount = 0;
                data.forEach(notification => {
                    const li = document.createElement("li");
                    li.textContent = notification.message;
                    if (!notification.isRead) {
                        li.classList.add("unread");
                        unreadCount++;
                    } else li.classList.add("read");
                    list.appendChild(li);
                });

                if (unreadCount > 0) {
                    countEl.style.display = "inline-block";
                    countEl.textContent = unreadCount;
                } else {
                    countEl.style.display = "none";
                }
            });
    }

    function markAllRead(event) {
        event.stopPropagation();
        fetch('${pageContext.request.contextPath}/notifications?action=markAllRead')
            .then(() => loadNotifications());
    }

    function markAllUnread(event) {
        event.stopPropagation();
        fetch('${pageContext.request.contextPath}/notifications?action=markAllUnread')
            .then(() => loadNotifications());
    }
</script>

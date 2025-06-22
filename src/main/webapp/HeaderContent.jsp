<header class="header">
    <div class="header-content-wrapper">
        <div class="header-left">
            <button class="icon-btn">
                <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="Logo">
            </button>
        </div>
        <div class="header-center">
            <input type="text" class="search-box" placeholder="Search...">
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/ManageNotification.jsp">
                <i class="fas fa-pen"></i><span>Manage Notifications</span>
            </a>
        </div>
        <div class="notification-container">
            <i class="fas fa-bell notification-bell" onclick="toggleDropdown()"></i>
            <div class="notification-dropdown" id="notificationDropdown">
                <ul id="notificationList">
                    <!-- JS will populate list here -->
                </ul>
                <div class="notification-actions">
                    <button onclick="markAllRead(event)">Mark all read</button>
                    <button onclick="markAllUnread(event)">Mark all unread</button>
                </div>
            </div>
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
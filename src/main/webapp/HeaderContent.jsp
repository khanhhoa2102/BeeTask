<!--<div class="header">
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
        <div>
            <a href="${pageContext.request.contextPath}/Ma  nageNotification.jsp">
                <i class="fas fa-pen"></i><span>Manage Notifications</span>
            </a>
        </div>
        <div class="notification-container">
            <i class="fas fa-bell notification-bell" onclick="toggleDropdown()"></i>
            <div class="notification-dropdown" id="notificationDropdown">
                <ul id="notificationList">
                     JS will populate list here 
                </ul>
                <div class="notification-actions">
                    <button onclick="markAllRead(event)">Mark all read</button>
                    <button onclick="markAllUnread(event)">Mark all unread</button>
                </div>
            </div>
        </div>
        <div class="header-right">
             Dark Mode Toggle 
            <div class="dark-mode-section">
                <span class="dark-label">Dark</span>
                <label class="switch">
                    <input type="checkbox" id="darkModeToggle">
                    <span class="slider"></span>
                </label>
            </div>

             Header Icons 
            <div class="header-icons">
                <button class="header-icon-btn" id="bookmarkBtn" title="Bookmarks">
                    <i class="far fa-bookmark"></i>
                </button>
                <button class="header-icon-btn" id="notificationBtn" title="Notifications">
                    <i class="far fa-bell"></i>
                </button>
                <button class="header-icon-btn" id="helpBtn" title="Help">
                    <i class="far fa-question-circle"></i>
                </button>

                 User Avatar & Dropdown 
                <div style="position: relative;">
                    <button class="user-avatar-btn" id="userAvatarBtn" title="Account menu">
                        <%= user.getUsername().substring(0, 2).toUpperCase() %>
                    </button>

                    <div class="user-dropdown" id="userDropdown">
                         Header Info 
                        <div class="dropdown-header">
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

                         Account Section 
                        <div class="dropdown-section">
                            <div class="dropdown-section-title">ACCOUNT</div>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-exchange-alt"></i>
                                <span>Switch Account</span>
                            </a>
                            <a href="#" class="dropdown-item has-arrow">
                                <i class="fas fa-user-cog"></i>
                                <span>Manage Account</span>
                            </a>
                        </div>

                         Trello Section 
                        <div class="dropdown-section">
                            <div class="dropdown-section-title">TRELLO</div>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-user"></i>
                                <span>Profile and Visibility</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-chart-line"></i>
                                <span>Activity</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-credit-card"></i>
                                <span>Cards</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-cog"></i>
                                <span>Settings</span>
                            </a>
                            <a href="#" class="dropdown-item has-arrow">
                                <i class="fas fa-palette"></i>
                                <span>Themes</span>
                            </a>
                        </div>

                         Workspace 
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item workspace-item">
                                <i class="fas fa-users"></i>
                                <span>Create Workspace</span>
                            </a>
                        </div>

                         Help & Logout 
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-question-circle"></i>
                                <span>Help</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-keyboard"></i>
                                <span>Keyboard Shortcuts</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                <i class="fas fa-sign-out-alt"></i>
                                <span>Log Out</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>-->

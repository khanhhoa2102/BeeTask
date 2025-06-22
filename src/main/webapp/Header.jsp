<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="session-check.jspf" %>

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
                <button class="header-icon-btn" id="notificationBtn" title="Notifications">
                    <i class="far fa-bell"></i>
                </button>
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
                            <div class="dropdown-section-title">TÀI KHOẢN</div>
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
                                <span>Chuyển đổi Tài khoản</span>
                            </a>
                            <a href="#" class="dropdown-item has-arrow">
                                <span>Quản lý tài khoản</span>
                            </a>
                        </div>

                        <!-- Trello Section -->
                        <div class="dropdown-section">
                            <div class="dropdown-section-title">TRELLO</div>
                            <a href="#" class="dropdown-item">
                                <span>Hồ sơ và Hiển thị</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Hoạt động</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Thẻ</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Cài đặt</span>
                            </a>
                            <a href="#" class="dropdown-item has-arrow">
                                <span>Chủ đề</span>
                            </a>
                        </div>

                        <!-- Workspace -->
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item workspace-item">
                                <i class="fas fa-users"></i>
                                <span>Tạo Không gian làm việc</span>
                            </a>
                        </div>

                        <!-- Help & Logout -->
                        <div class="dropdown-section">
                            <a href="#" class="dropdown-item">
                                <span>Trợ giúp</span>
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>Phím tắt</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                <span>Đăng xuất</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/Header.js"></script>
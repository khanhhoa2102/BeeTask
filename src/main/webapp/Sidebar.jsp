<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();
    String uri = request.getRequestURI();
%>


<!-- Isolated Sidebar Styles with Dark Mode Support -->
<style>
    /* ISOLATED SIDEBAR WITH DARK MODE SUPPORT */
    .beetask-sidebar-container {
        position: fixed;
        top: 0;
        left: 0;
        z-index: 9999;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    /* LIGHT MODE (Default) */
    .beetask-sidebar {
        width: 220px;
        height: 100vh;
        background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        border-right: 1px solid #e2e8f0;
        display: flex;
        flex-direction: column;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        backdrop-filter: blur(20px);
        overflow: hidden;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
    }

    /* DARK MODE */
    body.dark-mode .beetask-sidebar {
        background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
        border-right: 1px solid rgba(255, 255, 255, 0.1);
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
    }

    .beetask-sidebar.beetask-collapsed {
        width: 70px;
    }

    /* User Section */
    .beetask-user-section {
        padding: 12px 16px;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        align-items: center;
        gap: 10px;
        background: rgba(0, 0, 0, 0.02);
        transition: all 0.3s ease;
    }

    body.dark-mode .beetask-user-section {
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(255, 255, 255, 0.02);
    }

    .beetask-user-profile {
        display: flex;
        align-items: center;
        gap: 10px;
        flex: 1;
        min-width: 0;
        transition: all 0.3s ease;
    }

    .beetask-sidebar.beetask-collapsed .beetask-user-section {
        justify-content: center;
    }

    .beetask-sidebar.beetask-collapsed .beetask-user-profile {
        justify-content: center;
    }

    .beetask-user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 8px;
        overflow: hidden;
        flex-shrink: 0;
        position: relative;
    }

    .beetask-user-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .beetask-avatar-placeholder {
        width: 100%;
        height: 100%;
        background: linear-gradient(135deg, #667eea, #764ba2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 12px;
    }

    .beetask-user-info {
        flex: 1;
        min-width: 0;
        transition: all 0.3s ease;
    }

    .beetask-sidebar.beetask-collapsed .beetask-user-info {
        opacity: 0;
        transform: translateX(-10px);
        width: 0;
        overflow: hidden;
    }

    .beetask-username {
        display: block;
        color: #1f2937;
        font-weight: 600;
        font-size: 13px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-bottom: 1px;
        transition: color 0.3s ease;
    }

    body.dark-mode .beetask-username {
        color: #f8fafc;
    }

    .beetask-user-role {
        display: block;
        color: #6b7280;
        font-size: 11px;
        text-transform: capitalize;
        transition: color 0.3s ease;
    }

    body.dark-mode .beetask-user-role {
        color: #94a3b8;
    }

    /* Toggle Button */
    .beetask-toggle {
        width: 32px;
        height: 32px;
        border: none;
        background: rgba(0, 0, 0, 0.05);
        border-radius: 6px;
        color: #6b7280;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
        margin: 8px 16px;
        flex-shrink: 0;
    }

    body.dark-mode .beetask-toggle {
        background: rgba(255, 255, 255, 0.1);
        color: #94a3b8;
    }

    .beetask-toggle:hover {
        background: rgba(0, 0, 0, 0.1);
        color: #374151;
        transform: scale(1.05);
    }

    body.dark-mode .beetask-toggle:hover {
        background: rgba(255, 255, 255, 0.2);
        color: #e2e8f0;
    }

    .beetask-toggle i {
        font-size: 14px;
        transition: transform 0.3s ease;
    }

    .beetask-sidebar.beetask-collapsed .beetask-toggle {
        margin: 8px auto;
    }

    .beetask-sidebar.beetask-collapsed .beetask-toggle i {
        transform: rotate(180deg);
    }

    /* Navigation */
    .beetask-nav {
        flex: 1;
        padding: 8px 0;
        overflow-y: auto;
        overflow-x: hidden;
    }

    .beetask-nav::-webkit-scrollbar {
        width: 3px;
    }

    .beetask-nav::-webkit-scrollbar-track {
        background: transparent;
    }

    .beetask-nav::-webkit-scrollbar-thumb {
        background: rgba(0, 0, 0, 0.2);
        border-radius: 2px;
    }

    body.dark-mode .beetask-nav::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.2);
    }

    .beetask-nav-menu {
        list-style: none;
        margin: 0;
        padding: 0 12px;
    }

    .beetask-nav-item {
        margin-bottom: 2px;
    }

    .beetask-nav-link {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px;
        border-radius: 8px;
        color: #6b7280;
        text-decoration: none;
        transition: all 0.2s ease;
        position: relative;
        overflow: hidden;
    }

    body.dark-mode .beetask-nav-link {
        color: #94a3b8;
    }

    .beetask-nav-link:hover {
        background: rgba(0, 0, 0, 0.05);
        color: #374151;
        transform: translateX(2px);
    }

    body.dark-mode .beetask-nav-link:hover {
        background: rgba(255, 255, 255, 0.05);
        color: #e2e8f0;
    }

    .beetask-nav-link i {
        font-size: 18px;
        width: 20px;
        text-align: center;
        flex-shrink: 0;
        transition: all 0.2s ease;
        font-weight: 900;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }

    .beetask-nav-text {
        font-weight: 500;
        font-size: 14px;
        flex: 1;
        transition: all 0.3s ease;
        white-space: nowrap;
    }

    .beetask-sidebar.beetask-collapsed .beetask-nav-link {
        justify-content: center;
        padding: 14px 12px;
    }

    .beetask-sidebar.beetask-collapsed .beetask-nav-text {
        opacity: 0;
        transform: translateX(-10px);
        width: 0;
        overflow: hidden;
    }

    /* Enhanced Active State */
    .beetask-nav-item.beetask-active .beetask-nav-link {
        background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(251, 146, 60, 0.1));
        color: #ea580c;
        border: 1px solid rgba(249, 115, 22, 0.3);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.15);
    }

    body.dark-mode .beetask-nav-item.beetask-active .beetask-nav-link {
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.25), rgba(118, 75, 162, 0.15));
        color: #f8fafc;
        border: 1px solid rgba(102, 126, 234, 0.4);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }

    .beetask-nav-item.beetask-active .beetask-nav-link::before {
        content: "";
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background: linear-gradient(180deg, #f97316, #fb923c);
        border-radius: 0 2px 2px 0;
    }

    body.dark-mode .beetask-nav-item.beetask-active .beetask-nav-link::before {
        background: linear-gradient(180deg, #667eea, #764ba2);
    }

    .beetask-nav-item.beetask-active .beetask-nav-link i {
        color: #f97316;
        transform: scale(1.1);
        text-shadow: 0 0 8px rgba(249, 115, 22, 0.3);
    }

    body.dark-mode .beetask-nav-item.beetask-active .beetask-nav-link i {
        color: #667eea;
        text-shadow: 0 0 8px rgba(102, 126, 234, 0.3);
    }

    /* Section Dividers */
    .beetask-divider {
        height: 1px;
        background: #e2e8f0;
        margin: 12px 16px;
        transition: background-color 0.3s ease;
    }

    body.dark-mode .beetask-divider {
        background: rgba(255, 255, 255, 0.1);
    }

    /* Footer */
    .beetask-footer {
        padding: 12px;
        border-top: 1px solid #e2e8f0;
        background: rgba(0, 0, 0, 0.02);
        transition: all 0.3s ease;
    }

    body.dark-mode .beetask-footer {
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(0, 0, 0, 0.2);
    }

    /* Enhanced Tooltips for Collapsed State */
    .beetask-sidebar.beetask-collapsed .beetask-nav-link {
        position: relative;
    }

    .beetask-sidebar.beetask-collapsed .beetask-nav-link:hover::after {
        content: attr(data-tooltip);
        position: absolute;
        left: calc(100% + 15px);
        top: 50%;
        transform: translateY(-50%);
        background: rgba(0, 0, 0, 0.9);
        color: white;
        padding: 8px 12px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        white-space: nowrap;
        z-index: 10001;
        opacity: 0;
        animation: beetask-tooltip-show 0.2s ease forwards;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    body.dark-mode .beetask-sidebar.beetask-collapsed .beetask-nav-link:hover::after {
        background: rgba(0, 0, 0, 0.95);
    }

    .beetask-sidebar.beetask-collapsed .beetask-nav-link:hover::before {
        content: "";
        position: absolute;
        left: calc(100% + 10px);
        top: 50%;
        transform: translateY(-50%);
        border: 5px solid transparent;
        border-right-color: rgba(0, 0, 0, 0.9);
        z-index: 10001;
    }

    body.dark-mode .beetask-sidebar.beetask-collapsed .beetask-nav-link:hover::before {
        border-right-color: rgba(0, 0, 0, 0.95);
    }

    @keyframes beetask-tooltip-show {
        from {
            opacity: 0;
            transform: translateY(-50%) translateX(-5px);
        }
        to {
            opacity: 1;
            transform: translateY(-50%) translateX(0);
        }
    }

    /* Mobile Overlay */
    .beetask-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9998;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        backdrop-filter: blur(2px);
    }

    .beetask-overlay.beetask-active {
        opacity: 1;
        visibility: visible;
    }

    /* Main Content Adjustment */
    .beetask-main-content {
        margin-left: 220px;
        transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .beetask-sidebar.beetask-collapsed ~ .beetask-main-content,
    .beetask-sidebar.beetask-collapsed + * .beetask-main-content {
        margin-left: 70px;
    }

    /* Global body adjustment when sidebar is present */
    body.beetask-sidebar-active {
        margin-left: 220px;
        transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    body.beetask-sidebar-active.beetask-sidebar-collapsed {
        margin-left: 70px;
    }

    /* Responsive Design */
    @media (max-width: 1024px) {
        .beetask-sidebar {
            transform: translateX(-100%);
        }

        .beetask-sidebar.beetask-mobile-open {
            transform: translateX(0);
        }

        body.beetask-sidebar-active {
            margin-left: 0;
        }

        body.beetask-sidebar-active.beetask-sidebar-collapsed {
            margin-left: 0;
        }
    }

    @media (max-width: 768px) {
        .beetask-sidebar {
            width: 100%;
            max-width: 280px;
        }
    }

    /* Focus States */
    .beetask-nav-link:focus,
    .beetask-toggle:focus {
        outline: 2px solid #f97316;
        outline-offset: 2px;
    }

    body.dark-mode .beetask-nav-link:focus,
    body.dark-mode .beetask-toggle:focus {
        outline: 2px solid #667eea;
    }

    /* Smooth Animations */
    .beetask-nav-item {
        animation: beetask-slide-in 0.3s ease;
    }

    .beetask-nav-item:nth-child(1) {
        animation-delay: 0.05s;
    }
    .beetask-nav-item:nth-child(2) {
        animation-delay: 0.1s;
    }
    .beetask-nav-item:nth-child(3) {
        animation-delay: 0.15s;
    }
    .beetask-nav-item:nth-child(4) {
        animation-delay: 0.2s;
    }
    .beetask-nav-item:nth-child(5) {
        animation-delay: 0.25s;
    }
    .beetask-nav-item:nth-child(6) {
        animation-delay: 0.3s;
    }

    @keyframes beetask-slide-in {
        from {
            opacity: 0;
            transform: translateX(-10px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    /* Dark Mode Transition Effects */
    .beetask-sidebar,
    .beetask-user-section,
    .beetask-toggle,
    .beetask-nav-link,
    .beetask-username,
    .beetask-user-role,
    .beetask-divider,
    .beetask-footer {
        transition: all 0.3s ease;
    }
</style>

<div class="beetask-sidebar-container">
    <aside class="beetask-sidebar" id="beetaskSidebar">
        <!-- User Profile Section -->
        <div class="beetask-user-section">
            <div class="beetask-user-profile">
                <div class="beetask-user-avatar">
                    <c:choose>
                        <c:when test="${not empty user and not empty user.avatarUrl}">
                            <img src="${user.avatarUrl}" alt="Avatar">

                        </c:when>
                        <c:otherwise>
                            <div class="beetask-avatar-placeholder">
                                ${not empty user ? fn:substring(user.username, 0, 2).toUpperCase() : 'U'}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="beetask-user-info">
                    <span class="beetask-username">${not empty user ? user.username : 'Guest'}</span>
                    <span class="beetask-user-role">${not empty user ? user.role : 'User'}</span>
                </div>
            </div>
        </div>

        <!-- Toggle Button -->
        <button class="beetask-toggle" id="beetaskToggle" title="Toggle Sidebar">
            <i class="fas fa-angle-double-left"></i>
        </button>

        <!-- Navigation Menu -->
        <nav class="beetask-nav">
            <ul class="beetask-nav-menu">
                <li class="beetask-nav-item <%= uri.endsWith("/Home.jsp") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/Home/Home.jsp" %>" class="beetask-nav-link" data-tooltip="Home">
                        <i class="fas fa-home"></i>
                        <span class="beetask-nav-text">Home</span>
                    </a>
                </li>
                <li class="beetask-nav-item <%= uri.endsWith("/projects.jsp") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/Projects.jsp" %>" class="beetask-nav-link" data-tooltip="Projects">
                        <i class="fas fa-folder-open"></i>
                        <span class="beetask-nav-text">Projects</span>
                    </a>
                </li>
                <li class="beetask-nav-item <%= uri.endsWith("/Templates.jsp") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/Home/Templates.jsp" %>" class="beetask-nav-link" data-tooltip="Templates">
                        <i class="fas fa-clone"></i>
                        <span class="beetask-nav-text">Templates</span>
                    </a>
                </li>
            </ul>

            <div class="beetask-divider"></div>

            <ul class="beetask-nav-menu">
                <li class="beetask-nav-item <%= uri.endsWith("/CalendarHome.jsp") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/Home/CalendarHome.jsp" %>" class="beetask-nav-link" data-tooltip="Today">
                        <i class="fas fa-calendar-day"></i>
                        <span class="beetask-nav-text">Today</span>
                    </a>
                </li>
                <li class="beetask-nav-item <%= uri.endsWith("/Table.jsp") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/Home/Table.jsp" %>" class="beetask-nav-link" data-tooltip="Calendar">
                        <i class="fas fa-calendar-alt"></i>
                        <span class="beetask-nav-text">Calendar</span>
                    </a>
                </li>
                <li class="beetask-nav-item <%= uri.endsWith("/Note.jsp") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/notes" %>" class="beetask-nav-link" data-tooltip="Notes">
                        <i class="fas fa-sticky-note"></i>
                        <span class="beetask-nav-text">Notes</span>
                    </a>
                </li>
            </ul>

            <div class="beetask-divider"></div>

            <ul class="beetask-nav-menu">
                <li class="beetask-nav-item <%= uri.endsWith("/leaderstaticservlet") ? "beetask-active" : "" %>">
                    <a href="<%= session.getAttribute("user") == null ? contextPath + "/Authentication/Login.jsp" : contextPath + "/leaderstaticservlet" %>" class="beetask-nav-link" data-tooltip="Statistics">
                        <i class="fas fa-chart-bar"></i>
                        <span class="beetask-nav-text">Statistics</span>
                    </a>
                </li>
            </ul>

        </nav>

        <!-- Footer -->
        <div class="beetask-footer">
            <ul class="beetask-nav-menu">
                <li class="beetask-nav-item <%= uri.endsWith("/Setting.jsp") ? "beetask-active" : "" %>">
                    <a href="${pageContext.request.contextPath}/Home/Setting.jsp" class="beetask-nav-link" data-tooltip="Settings">
                        <i class="fas fa-cog"></i>
                        <span class="beetask-nav-text">Settings</span>
                    </a>
                </li>
                <li class="beetask-nav-item">
                    <a href="#" class="beetask-nav-link" onclick="showHelpModal()" data-tooltip="Help & Support">
                        <i class="fas fa-question-circle"></i>
                        <span class="beetask-nav-text">Help & Support</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- Mobile Overlay -->
    <div class="beetask-overlay" id="beetaskOverlay"></div>
</div>

<!-- Enhanced JavaScript with Dark Mode Sync -->
<script>
    (function () {
        'use strict';

        class BeeTaskSidebar {
            constructor() {
                this.sidebar = document.getElementById("beetaskSidebar");
                this.toggle = document.getElementById("beetaskToggle");
                this.overlay = document.getElementById("beetaskOverlay");
                this.isCollapsed = localStorage.getItem("beetaskSidebarCollapsed") === "true";
                this.isMobile = window.innerWidth <= 1024;

                this.init();
            }

            init() {
                this.setupEventListeners();
                this.handleResize();
                this.restoreState();
                this.setupKeyboardNavigation();
                this.updateToggleIcon();
                this.updateBodyClass();
                this.syncWithHeaderDarkMode();
            }

            setupEventListeners() {
                this.toggle?.addEventListener("click", () => {
                    if (this.isMobile) {
                        this.toggleMobile();
                    } else {
                        this.toggleCollapse();
                    }
                });

                this.overlay?.addEventListener("click", () => this.closeMobile());

                window.addEventListener("resize", () => this.handleResize());

                document.addEventListener("keydown", (e) => {
                    if (e.key === "Escape" && this.isMobile) {
                        this.closeMobile();
                    }
                });

                const navLinks = document.querySelectorAll(".beetask-nav-link");
                navLinks.forEach((link) => {
                    link.addEventListener("click", () => {
                        if (this.isMobile) {
                            setTimeout(() => this.closeMobile(), 150);
                        }
                    });
                });
            }

            syncWithHeaderDarkMode() {
                // Listen for dark mode changes from header
                const darkModeToggle = document.getElementById('darkModeToggle');
                if (darkModeToggle) {
                    darkModeToggle.addEventListener('change', () => {
                        // Sidebar will automatically respond to body.dark-mode class changes
                        this.handleDarkModeChange();
                    });
                }

                // Listen for storage changes (if dark mode is changed in another tab)
                window.addEventListener('storage', (e) => {
                    if (e.key === 'theme') {
                        this.handleDarkModeChange();
                    }
                });

                // Initial sync
                this.handleDarkModeChange();
            }

            handleDarkModeChange() {
                // Add any specific sidebar dark mode handling here if needed
                // The CSS will automatically handle the visual changes

                // Optional: Dispatch custom event for other components
                window.dispatchEvent(new CustomEvent("beetaskSidebarDarkModeChange", {
                    detail: {
                        isDarkMode: document.body.classList.contains('dark-mode'),
                        sidebar: this.sidebar
                    }
                }));
            }

            toggleCollapse() {
                this.isCollapsed = !this.isCollapsed;
                this.sidebar.classList.toggle("beetask-collapsed", this.isCollapsed);
                this.updateToggleIcon();
                this.updateBodyClass();
                localStorage.setItem("beetaskSidebarCollapsed", this.isCollapsed);

                window.dispatchEvent(new CustomEvent("beetaskSidebarToggle", {
                    detail: {collapsed: this.isCollapsed}
                }));
            }

            updateToggleIcon() {
                const icon = this.toggle.querySelector("i");
                if (icon) {
                    if (this.isCollapsed) {
                        icon.className = "fas fa-angle-double-right";
                        this.toggle.title = "Expand Sidebar";
                    } else {
                        icon.className = "fas fa-angle-double-left";
                        this.toggle.title = "Collapse Sidebar";
                    }
                }
            }

            updateBodyClass() {
                if (!this.isMobile) {
                    document.body.classList.add("beetask-sidebar-active");
                    document.body.classList.toggle("beetask-sidebar-collapsed", this.isCollapsed);
                } else {
                    document.body.classList.remove("beetask-sidebar-active", "beetask-sidebar-collapsed");
                }
            }

            toggleMobile() {
                this.sidebar.classList.toggle("beetask-mobile-open");
                this.overlay.classList.toggle("beetask-active");
                document.body.style.overflow = this.sidebar.classList.contains("beetask-mobile-open") ? "hidden" : "";
            }

            closeMobile() {
                this.sidebar.classList.remove("beetask-mobile-open");
                this.overlay.classList.remove("beetask-active");
                document.body.style.overflow = "";
            }

            handleResize() {
                const wasMobile = this.isMobile;
                this.isMobile = window.innerWidth <= 1024;

                if (wasMobile !== this.isMobile) {
                    if (!this.isMobile) {
                        this.sidebar.classList.remove("beetask-mobile-open");
                        this.overlay.classList.remove("beetask-active");
                        document.body.style.overflow = "";
                    } else {
                        this.sidebar.classList.remove("beetask-collapsed");
                    }
                    this.updateBodyClass();
                }
            }

            restoreState() {
                if (!this.isMobile && this.isCollapsed) {
                    this.sidebar.classList.add("beetask-collapsed");
                }
            }

            setupKeyboardNavigation() {
                const navLinks = document.querySelectorAll(".beetask-nav-link");

                navLinks.forEach((link, index) => {
                    link.addEventListener("keydown", (e) => {
                        switch (e.key) {
                            case "ArrowDown":
                                e.preventDefault();
                                const nextLink = navLinks[index + 1];
                                if (nextLink)
                                    nextLink.focus();
                                break;
                            case "ArrowUp":
                                e.preventDefault();
                                const prevLink = navLinks[index - 1];
                                if (prevLink)
                                    prevLink.focus();
                                break;
                            case "Home":
                                e.preventDefault();
                                navLinks[0].focus();
                                break;
                            case "End":
                                e.preventDefault();
                                navLinks[navLinks.length - 1].focus();
                                break;
                        }
                    });
                });
            }

            // Public methods
            getDarkModeState() {
                return document.body.classList.contains('dark-mode');
            }

            getCollapsedState() {
                return this.isCollapsed;
            }
        }

        // Initialize when DOM is ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                window.beetaskSidebar = new BeeTaskSidebar();
            });
        } else {
            window.beetaskSidebar = new BeeTaskSidebar();
        }
    })();
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview, model.User" %>
<%@ include file="../session-check.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="HeaderAdmin.jsp" %>
    <title>User Management - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/UserManagement.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
            <%@ include file="SidebarAdmin.jsp" %>
            <%@ include file="../Help.jsp" %>
        </aside>

        <main class="main-content">
            <div class="page-header">
                <h1><i class="fas fa-users-cog"></i> User Management Dashboard</h1>
                <p class="page-description">Manage user accounts, permissions, and access controls</p>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <div class="search-box">
                    <form action="UserManagementServlet" method="get">
                        <%
                            String keyword = (String) request.getAttribute("keyword");
                            if (keyword == null) keyword = "";
                        %>
                        <div class="search-input-group">
                            <i class="fas fa-search"></i>
                            <input type="text" name="keyword" placeholder="Search by ID, name, email..." value="<%= keyword %>">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i>
                                Search
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Quick Actions Section -->
            <section class="quick-actions-section">
                <div class="section-header">
                    <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
                </div>
                <div class="quick-actions-card">
                    <form action="UserManagementServlet" method="post" class="quick-action-form">
                        <div class="form-group">
                            <label for="userId"><i class="fas fa-user"></i> User ID</label>
                            <input type="text" id="userId" name="userId" placeholder="Enter User ID" required>
                        </div>
                        <div class="form-group">
                            <label for="action"><i class="fas fa-cog"></i> Action</label>
                            <select id="action" name="action" required>
                                <option value="">Select Action</option>
                                <option value="lock"><i class="fas fa-lock"></i> Lock Account</option>
                                <option value="unlock"><i class="fas fa-unlock"></i> Unlock Account</option>
                            </select>
                        </div>
                        <button type="submit" class="execute-btn">
                            <i class="fas fa-play"></i>
                            Execute Action
                        </button>
                    </form>
                </div>
            </section>

            <!-- Locked Users Section -->
            <section class="users-section">
                <div class="section-header">
                    <h2><i class="fas fa-user-lock"></i> Locked Users</h2>
                    <div class="section-badge locked-badge">
                        <%
                            List<User> lockedUsers = (List<User>) request.getAttribute("lockedUsers");
                            int lockedCount = lockedUsers != null ? lockedUsers.size() : 0;
                        %>
                        <%= lockedCount %> Users
                    </div>
                </div>
                <div class="table-container">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID</th>
                                <th><i class="fas fa-user"></i> Full Name</th>
                                <th><i class="fas fa-envelope"></i> Email</th>
                                <th><i class="fas fa-calendar"></i> Created Date</th>
                                <th><i class="fas fa-shield-alt"></i> Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (lockedUsers != null) {
                                    for (User lockedUser : lockedUsers) {
                            %>
                            <tr class="user-row clickable-row" data-user-id="<%= lockedUser.getUserId() %>" data-user-name="<%= lockedUser.getUsername() %>" data-user-status="locked">
                                <td class="user-id"><%= lockedUser.getUserId() %></td>
                                <td class="user-name">
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            <i class="fas fa-user-circle"></i>
                                        </div>
                                        <span><%= lockedUser.getUsername() %></span>
                                    </div>
                                </td>
                                <td class="user-email"><%= lockedUser.getEmail() %></td>
                                <td class="user-date"><%= lockedUser.getCreatedAt() %></td>
                                <td class="user-status">
                                    <span class="status-badge locked">
                                        <i class="fas fa-lock"></i> Locked
                                    </span>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- All Users Section -->
            <section class="users-section">
                <div class="section-header">
                    <h2><i class="fas fa-users"></i> All Users</h2>
                    <div class="section-badge total-badge">
                        <%
                            List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                            int totalCount = allUsers != null ? allUsers.size() : 0;
                        %>
                        <%= totalCount %> Users
                    </div>
                </div>
                <div class="table-container">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID</th>
                                <th><i class="fas fa-user"></i> Full Name</th>
                                <th><i class="fas fa-envelope"></i> Email</th>
                                <th><i class="fas fa-calendar"></i> Created Date</th>
                                <th><i class="fas fa-shield-alt"></i> Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (allUsers != null) {
                                    for (User listedUser : allUsers) {
                                        String statusClass = listedUser.isActive() ? "active" : "locked";
                                        String statusText = listedUser.isActive() ? "Active" : "Locked";
                                        String statusIcon = listedUser.isActive() ? "fa-check-circle" : "fa-lock";
                            %>
                            <tr class="user-row clickable-row" data-user-id="<%= listedUser.getUserId() %>" data-user-name="<%= listedUser.getUsername() %>" data-user-status="<%= statusClass %>">
                                <td class="user-id"><%= listedUser.getUserId() %></td>
                                <td class="user-name">
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            <i class="fas fa-user-circle"></i>
                                        </div>
                                        <span><%= listedUser.getUsername() %></span>
                                    </div>
                                </td>
                                <td class="user-email"><%= listedUser.getEmail() %></td>
                                <td class="user-date"><%= listedUser.getCreatedAt() %></td>
                                <td class="user-status">
                                    <span class="status-badge <%= statusClass %>">
                                        <i class="fas <%= statusIcon %>"></i> <%= statusText %>
                                    </span>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- Modal for User Action Confirmation -->
    <div id="userActionModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle"><i class="fas fa-user-cog"></i> User Action</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="user-action-info">
                    <div class="user-avatar-large">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="user-details">
                        <h4 id="modalUserName">User Name</h4>
                        <p id="modalUserId">User ID: #123</p>
                        <p id="modalCurrentStatus">Current Status: Active</p>
                    </div>
                </div>
                <div class="action-confirmation">
                    <p id="confirmationMessage">Are you sure you want to perform this action?</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal()">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <form id="modalActionForm" action="UserManagementServlet" method="post" style="display: inline;">
                    <input type="hidden" id="modalActionUserId" name="userId">
                    <input type="hidden" id="modalActionType" name="action">
                    <button type="submit" id="confirmActionBtn" class="btn-confirm">
                        <i class="fas fa-check"></i> Confirm
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Modal functionality
    const modal = document.getElementById('userActionModal');
    const closeBtn = document.querySelector('.close');

    // Check if modal exists
    if (!modal) {
        console.error('Modal not found');
        return;
    }

    // Close modal when clicking X
    if (closeBtn) {
        closeBtn.onclick = function() {
            closeModal();
        }
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target == modal) {
            closeModal();
        }
    }

    function closeModal() {
        modal.style.display = 'none';
    }

    // Add click event to all user rows
    const clickableRows = document.querySelectorAll('.clickable-row');
    
    clickableRows.forEach(row => {
        row.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            const userName = this.getAttribute('data-user-name');
            const userStatus = this.getAttribute('data-user-status');
            
            // Check if required elements exist
            const modalUserName = document.getElementById('modalUserName');
            const modalUserId = document.getElementById('modalUserId');
            const modalCurrentStatus = document.getElementById('modalCurrentStatus');
            const confirmationMessage = document.getElementById('confirmationMessage');
            const modalActionUserId = document.getElementById('modalActionUserId');
            const modalActionType = document.getElementById('modalActionType');
            const confirmBtn = document.getElementById('confirmActionBtn');
            
            if (!modalUserName || !modalUserId || !modalCurrentStatus || !confirmationMessage || 
                !modalActionUserId || !modalActionType || !confirmBtn) {
                console.error('Required modal elements not found');
                return;
            }
            
            // Determine action based on current status
            const isLocked = userStatus === 'locked';
            const action = isLocked ? 'unlock' : 'lock';
            const actionText = isLocked ? 'Unlock' : 'Lock';
            const actionIcon = isLocked ? 'fa-unlock' : 'fa-lock';
            const actionColor = isLocked ? 'success' : 'danger';
            
            // Update modal content safely
            modalUserName.textContent = userName || 'Unknown User';
            modalUserId.textContent = 'User ID: #' + (userId || 'N/A');
            modalCurrentStatus.textContent = 'Current Status: ' + (userStatus === 'locked' ? 'Locked' : 'Active');
            confirmationMessage.textContent = 'Are you sure you want to ' + actionText.toLowerCase() + ' this user account?';
            
            // Update form
            modalActionUserId.value = userId || '';
            modalActionType.value = action;
            
            // Update confirm button
            confirmBtn.innerHTML = '<i class="fas ' + actionIcon + '"></i> ' + actionText + ' User';
            confirmBtn.className = 'btn-confirm ' + actionColor;
            
            // Show modal
            modal.style.display = 'block';
        });
    });

    // Add hover effect to clickable rows
    clickableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
            this.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.15)';
            this.style.transition = 'all 0.3s ease';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = 'none';
        });
    });

    // Make closeModal function global so it can be called from onclick
    window.closeModal = closeModal;
});
</script>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/session-check.jspf" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Switch Account - BeeTask</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/SwitchAccount.css">
    </head>
    <body data-context-path="${pageContext.request.contextPath}">
        <!-- Background -->
        <div class="background-gradient"></div>

        <div class="switch-container">
            <!-- Header -->
            <div class="switch-header">
                <button class="nav-btn" onclick="history.back()">
                    <i class="fas fa-arrow-left"></i>
                </button>
                <div class="logo-section">
                    <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask" class="logo">
                </div>
                <button class="nav-btn" onclick="window.close()">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="content-header">
                    <h1>Switch Account</h1>
                    <p>Choose an account to continue</p>
                </div>

                <!-- Current Account -->
                <div class="section">
                    <div class="section-title">
                        <i class="fas fa-user-circle"></i>
                        <span>Current Account</span>
                    </div>
                    <div class="account-item current-account">
                        <div class="account-avatar current">
                            <%= user.getUsername().substring(0, 2).toUpperCase() %>
                        </div>
                        <div class="account-details">
                            <h3><%= user.getUsername()  %></h3>
                            <p><%= user.getEmail() %></p>
                            <span class="status-badge">Active</span>
                        </div>
                        <div class="account-menu">
                            <button class="menu-btn" title="Settings">
                                <i class="fas fa-cog"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Other Accounts -->
                <div class="section">
                    <div class="section-title">
                        <i class="fas fa-users"></i>
                        <span>Other Accounts</span>
                    </div>
                    <div class="accounts-list" id="accountsList">
                        <!-- Accounts will be loaded here -->
                    </div>
                    <div class="empty-message" id="emptyMessage" style="display: none;">
                        <i class="fas fa-user-plus"></i>
                        <p>No other accounts found</p>
                    </div>
                </div>

                <!-- Add Account -->
                <div class="section">
                    <button class="add-account-btn" onclick="showAddModal()">
                        <i class="fas fa-plus"></i>
                        <span>Add Account</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Add Account Modal -->
        <div class="modal-backdrop" id="addModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Add Account</h3>
                    <button class="close-btn" onclick="hideAddModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="addAccountForm">
                        <div class="input-group">
                            <label>Email</label>
                            <input type="email" id="email" name="email" required placeholder="Enter email address">
                        </div>
                        <div class="input-group">
                            <label>Password</label>
                            <input type="password" id="password" name="password" required placeholder="Enter password">
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-cancel" onclick="hideAddModal()">Cancel</button>
                            <button type="submit" class="btn-primary">Add Account</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Confirm Delete Modal -->
        <div class="modal-backdrop" id="confirmModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Confirm Delete</h3>
                    <button class="close-btn" onclick="hideConfirmModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="confirm-content">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p id="confirmMessage">Are you sure you want to remove this account?</p>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-cancel" onclick="hideConfirmModal()">Cancel</button>
                        <button type="button" class="btn-danger" id="confirmDelete">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loading -->
        <div class="loading-overlay" id="loadingOverlay">
            <div class="loading-content">
                <div class="spinner"></div>
                <p>Processing...</p>
            </div>
        </div>

        <!-- Toast Notifications -->
        <div class="toast-container" id="toastContainer"></div>

        <script>
            const currentEmail = "<%= user != null ? user.getEmail() : "" %>";
        </script>
        <script src="${pageContext.request.contextPath}/Authentication/SwitchAccount.js"></script>
    </body>
</html>
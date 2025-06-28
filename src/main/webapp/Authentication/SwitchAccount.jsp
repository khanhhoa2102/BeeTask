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
        <!-- Background circles -->
        <div class="background-circles">
            <div class="circle circle-1"></div>
            <div class="circle circle-2"></div>
            <div class="circle circle-3"></div>
            <div class="circle circle-4"></div>
            <div class="circle circle-5"></div>
        </div>

        <div class="switch-account-container">
            <!-- Header with Logo -->
            <div class="switch-header">
                <button class="back-btn" onclick="history.back()">
                    <i class="fas fa-arrow-left"></i>
                </button>
                <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <button class="close-btn" onclick="window.close()">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Main Card -->
            <div class="main-card">
                <div class="card-header">
                    <h1>Switch Account</h1>
                    <p>Choose an account to continue with BeeTask</p>
                </div>

                <!-- Current Account Section -->
                <div class="current-account-section">
                    <h2>Current Account</h2>
                    <div class="account-card current">
                        <div class="account-avatar">
                            <%= user.getUsername().substring(0, 2).toUpperCase() %>
                        </div>
                        <div class="account-info">
                            <h3><%= user.getUsername() %></h3>
                            <p><%= user.getEmail() %></p>
                            <span class="current-badge">Current</span>
                        </div>
                        <div class="account-actions">
                            <button class="action-btn settings-btn" title="Account Settings">
                                <i class="fas fa-cog"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Other Accounts Section -->
                <div class="other-accounts-section">
                    <h2>Other Accounts</h2>
                    <div class="account-list" id="accountList"></div>
                    <!-- Empty State -->
                    <div class="empty-state" id="emptyState" style="display: none;">
                        <i class="fas fa-users"></i>
                        <h3>No other accounts</h3>
                        <p>You don't have any other accounts linked to this device.</p>
                    </div>
                </div>

                <!-- Add Account Section -->
                <div class="add-account-section">
                    <button class="add-account-btn" onclick="showAddAccountModal()">
                        <i class="fas fa-plus"></i>
                        <span>Add Another Account</span>
                    </button>
                </div>

                <!-- Footer -->
                <div class="switch-footer">
                    <p>Manage your accounts securely. <a href="#" onclick="showPrivacyInfo()">Privacy Policy</a></p>
                </div>
            </div>
        </div>

        <!-- Add Account Modal -->
        <div class="modal-overlay" id="addAccountModal">
            <div class="modal">
                <div class="modal-header">
                    <h3>Add Account</h3>
                    <button class="modal-close" onclick="hideAddAccountModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="addAccountForm">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" required placeholder="Enter your Email">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required placeholder="Enter your Password">
                        </div>
                        <div class="form-actions">
                            <button type="button" class="btn-secondary" onclick="hideAddAccountModal()">Cancel</button>
                            <button type="submit" class="btn-primary">Add Account</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal">
                <div class="modal-header">
                    <h3>Confirm Action</h3>
                    <button class="modal-close" onclick="hideConfirmModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="confirmMessage"></p>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="hideConfirmModal()">Cancel</button>
                        <button type="button" class="btn-danger" id="confirmAction">Confirm</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loading Overlay -->
        <div class="loading-overlay" id="loadingOverlay">
            <div class="loading-spinner">
                <i class="fas fa-spinner fa-spin"></i>
                <p>Switching account...</p>
            </div>
        </div>

        <script>
            const currentEmail = "<%= user != null ? user.getEmail() : "" %>";
            console.log("✅ Current email:", currentEmail);
        </script>
        <script src="${pageContext.request.contextPath}/Authentication/SwitchAccount.js"></script>


    </body>
</html>

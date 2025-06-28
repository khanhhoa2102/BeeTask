<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BeeTask - Change Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/ResetPassword.css">
</head>
<body>
    <div class="decorative-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <div class="container">
        <div class="change-card">
            <!-- Logo Section -->
            <div class="logo-section">
                <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <h2 class="change-title">Change Password</h2>
            </div>

            <!-- Change Password Form -->
            <form class="change-form" id="changeForm"
                  action="${pageContext.request.contextPath}/reset-password"
                  method="post">

                <!-- Hidden Token Field -->
                <input type="hidden" name="token" value="${token}" />

                <!-- New Password -->
                <div class="form-group">
                    <label for="newPassword" class="form-label">New Password</label>
                    <div class="password-container">
                        <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="Enter new Password" required>
                        <button type="button" class="toggle-password" id="toggleNew">
                            <svg class="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <span class="error-message" id="newPasswordError"></span>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <div class="password-container">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Enter Confirm Password" required>
                        <button type="button" class="toggle-password" id="toggleConfirm">
                            <svg class="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <span class="error-message" id="confirmPasswordError"></span>
                </div>

                <!-- Submit -->
                <button type="submit" class="change-btn" id="changeBtn">
                    <span class="btn-text">Change Password</span>
                    <span class="loading-spinner" id="loadingSpinner" style="display: none;">
                        <div class="spinner"></div>
                    </span>
                </button>

                <!-- Success Message -->
                <div class="success-message" id="successMessage" style="display: none;">
                    <div class="success-icon">✓</div>
                    <p>Password changed successfully!</p>
                    <small>You will be redirected to login page</small>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Authentication/ResetPassword.js"></script>
</body>
</html>

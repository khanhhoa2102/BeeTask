<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BeeTask - Forgot Password</title>
    <link rel="stylesheet" href="ForgotPassword.css">
</head>
<body>
    <div class="decorative-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>
    
    <div class="container">
        <div class="forgot-card">
            <!-- Logo Section -->
            <div class="logo-section">
                <div class="logo-container">
                    <img src="Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <h2 class="forgot-title">Forgot Password</h2>
                <p class="forgot-subtitle">Enter your email to receive a reset link</p>
            </div>

            <!-- Hiển thị thông báo từ servlet (KHÔNG dùng JSTL) -->
            <%
                Object msgObj = request.getAttribute("message");
                if (msgObj != null) {
            %>
                <div style="margin: 10px 0; color: red; font-weight: bold; text-align: center;">
                    <%= msgObj.toString() %>
                </div>
            <%
                }
            %>

            <!-- Forgot Password Form -->
            <form class="forgot-form" id="forgotForm" action="forgot-password" method="post">
                <!-- Email Field -->
                <div class="form-group">
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-input" 
                        placeholder="Enter your Email"
                        required
                    >
                    <span class="error-message" id="emailError"></span>
                </div>

                <!-- Send Button -->
                <button type="submit" class="send-btn" id="sendBtn">
                    <span class="btn-text">Send</span>
                    <span class="loading-spinner" id="loadingSpinner" style="display: none;">
                        <div class="spinner"></div>
                    </span>
                </button>

                <!-- Back to Login -->
                <div class="back-link">
                    <a href="Login.jsp" class="login-link">← Back to Login</a>
                </div>
            </form>
        </div>
    </div>

    <script src="ForgotPassword.js"></script>
</body>
</html>

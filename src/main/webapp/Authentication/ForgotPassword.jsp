<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BeeTask - Reset Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/ForgotPassword.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <!-- Animated Background -->
    <div class="background-container">
        <div class="background-overlay"></div>
        <div class="floating-elements">
            <div class="floating-card security-card">
                <div class="card-header">Security Check</div>
                <div class="security-items">
                    <div class="security-item">🔐 Account Protected</div>
                    <div class="security-item">📧 Email Verification</div>
                    <div class="security-item">🔄 Password Reset</div>
                </div>
            </div>
            <div class="floating-card help-card">
                <div class="help-header">Need Help?</div>
                <div class="help-steps">
                    <div class="help-step">1. Enter your email</div>
                    <div class="help-step">2. Check your inbox</div>
                    <div class="help-step">3. Follow the link</div>
                </div>
            </div>
            <div class="floating-card time-card">
                <div class="time-header">Quick Recovery</div>
                <div class="time-info">
                    <div class="time-stat">
                        <div class="time-number">2</div>
                        <div class="time-label">Minutes</div>
                    </div>
                    <div class="time-desc">Average reset time</div>
                </div>
            </div>
        </div>
        <div class="geometric-shapes">
            <div class="shape hexagon"></div>
            <div class="shape circle"></div>
            <div class="shape triangle"></div>
            <div class="shape square"></div>
        </div>
    </div>

    <div class="main-container">
        <div class="auth-card">
            <!-- Logo Section -->
            <div class="logo-section">
                <div class="logo-container">
                    <div class="logo-backdrop"></div>
                    <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <h1 class="auth-title">Reset Your Password</h1>
                <p class="auth-subtitle">Enter your email address and we'll send you a link to reset your password</p>
            </div>

            <!-- Messages -->
            <%
                Object msgObj = request.getAttribute("message");
                if (msgObj != null) {
            %>
                <div class="message error-message">
                    <div class="message-icon">⚠️</div>
                    <span><%= msgObj.toString() %></span>
                </div>
            <%
                }
            %>

            <!-- Forgot Password Form -->
            <form class="auth-form" id="forgotForm" action="${pageContext.request.contextPath}/forgot-password" method="post">
                <div class="form-group">
                    <label for="email" class="form-label">Email Address</label>
                    <div class="input-container">
                        <div class="input-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                <polyline points="22,6 12,13 2,6"/>
                            </svg>
                        </div>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-input"
                            placeholder="Enter your email address"
                            required
                        >
                    </div>
                    <span class="error-text" id="emailError"></span>
                </div>

                <button type="submit" class="primary-btn" id="sendBtn">
                    <span class="btn-content">
                        <span class="btn-text">Send Reset Link</span>
                        <div class="btn-loader" id="loadingSpinner">
                            <div class="loader-spinner"></div>
                        </div>
                    </span>
                </button>

                <div class="help-section">
                    <div class="help-info">
                        <div class="help-icon">💡</div>
                        <div class="help-text">
                            <p><strong>What happens next?</strong></p>
                            <p>We'll send a secure link to your email. Click it to create a new password for your BeeTask account.</p>
                        </div>
                    </div>
                </div>

                <div class="auth-footer">
                    <p>Remember your password? <a href="${pageContext.request.contextPath}/login" class="login-link">Back to Sign In</a></p>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Authentication/ForgotPassword.js"></script>
</body>
</html>

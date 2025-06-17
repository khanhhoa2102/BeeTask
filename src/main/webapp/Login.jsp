<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String googleClientId = System.getenv("GOOGLE_CLIENT_ID");
%>

<% 
    String msg = request.getParameter("msg");
    if ("reset_success".equals(msg)) {
%>
    <div class="success-message">✅ Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập.</div>
<% 
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BeeTask - Login</title>
        <link rel="stylesheet" href="Login.css">
    </head>
    <body>
        <div class="container">
            <div class="login-card">
                <!-- Logo Section -->
                <div class="logo-section">
                    <div class="logo-container">
                        <img src="Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                    </div>
                    <h2 class="login-title">Login to continue</h2>
                </div>

                <!-- Login Form -->
                <form class="login-form" id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                    <!-- Email Field -->
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
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

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            class="form-input" 
                            placeholder="Enter your Password"
                            required
                            >
                        <span class="error-message" id="passwordError"></span>
                    </div>

                    <!-- Remember Me -->
                    <div class="checkbox-group">
                        <input type="checkbox" id="remember" name="remember" class="checkbox" checked>
                        <label for="remember" class="checkbox-label">Remember me</label>
                    </div>

                    <!-- Login Button -->
                    <button type="submit" class="login-btn" id="loginBtn">
                        <span class="btn-text">Login</span>
                        <span class="loading-spinner" id="loadingSpinner" style="display: none;">
                            <div class="spinner"></div>
                        </span>
                    </button>

                    <!-- Divider -->
                    <div class="divider">Or Continue With:</div>

                    <!-- Google Sign In -->
                    <!-- Google Sign In -->
                    <button type="button" class="google-btn" id="googleBtn"
                            onclick="window.location.href = 'https://accounts.google.com/o/oauth2/auth?scope=openid%20email%20profile&redirect_uri=http://localhost:8080/BeeTask/LoginGoogleServlet&response_type=code&client_id=<%= googleClientId %>&approval_prompt=force'">
                        <svg class="google-icon" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="..."/>
                        <path fill="#34A853" d="..."/>
                        <path fill="#FBBC05" d="..."/>
                        <path fill="#EA4335" d="..."/>
                        </svg>
                        <span>Google</span>
                    </button>
                    <!-- Footer Links -->
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/ForgotPassword.jsp" class="forgot-link">Forgot Password</a>
                        <a href="Register.jsp" class="register-link">Create new Account</a>
                    </div>
                </form>
            </div>
        </div>
        <script>
            var errorMessage = "<%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>";
        </script>
        <script src="Login.js"></script>
    </body>
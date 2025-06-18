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

    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
%>
    <div class="success-message">✅ <%= successMessage %></div>
<%
        session.removeAttribute("successMessage");
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
            <div class="logo-section">
                <div class="logo-container">
                    <img src="Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <h2 class="login-title">Login to continue</h2>
            </div>

            <form class="login-form" id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-input" 
                        placeholder="Enter your Email"
                        required>
                    <span class="error-message" id="emailError"></span>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-input" 
                        placeholder="Enter your Password"
                        required>
                    <span class="error-message" id="passwordError"></span>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="remember" name="remember" class="checkbox" checked>
                    <label for="remember" class="checkbox-label">Remember me</label>
                </div>

                <button type="submit" class="login-btn" id="loginBtn">
                    <span class="btn-text">Login</span>
                    <span class="loading-spinner" id="loadingSpinner" style="display: none;">
                        <div class="spinner"></div>
                    </span>
                </button>

                <div class="divider">Or Continue With:</div>

                <button type="button" class="google-btn" id="googleBtn"
                        onclick="window.location.href = 'https://accounts.google.com/o/oauth2/auth?scope=openid%20email%20profile&redirect_uri=http://localhost:8080/BeeTask/LoginGoogleServlet&response_type=code&client_id=<%= googleClientId %>&approval_prompt=force'">
                    <svg class="google-icon" viewBox="0 0 24 24">
                        <svg class="google-icon" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                        </svg>
                    </svg>
                    <span>Google</span>
                </button>

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
</html>

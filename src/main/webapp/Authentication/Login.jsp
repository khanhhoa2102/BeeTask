<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%    
    String googleClientId = System.getenv("GOOGLE_CLIENT_ID");    
    String msg = request.getParameter("msg");    
    String successMessage = (String) session.getAttribute("successMessage");    
    String errorMessage = (String) request.getAttribute("errorMessage");
    
%>
<!DOCTYPE html>
<html lang="en">
    <head>        
        <meta charset="UTF-8">        
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <title>BeeTask - Login</title>        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/Login.css">    
    </head>    
    <body>        
        <!-- Background decorations -->        
        <div class="decorative-shapes">            
            <div class="shape"></div>            
            <div class="shape"></div>            
            <div class="shape"></div>            
            <div class="shape"></div>        
        </div>        
        
<body data-context-path="${pageContext.request.contextPath}">
        <div class="container">            
            <div class="login-card">                       
                <div class="logo-section">                    
                    <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <h2 class="login-title">Login to continue</h2>
            </div>           
                
                <% if ("reset_success".equals(msg)) { %>                
                <div class="success-message show">✅ Reset password successfully!</div>                
                <% } %>                
                <% if (successMessage != null) { %>                
                <div class="success-message show">✅ <%= successMessage %></div>                
                <%                    
                    session.removeAttribute("successMessage");                
                %>                
                <% } %>                
                <% if (errorMessage != null) { %>                
                <div class="server-message error"><%= errorMessage %></div>                
                <% } %>                
                
                <!-- Login Form -->                
                <form class="login-form" id="loginForm" action="${pageContext.request.contextPath}/login" method="post">                    
                    <!-- Email -->                    
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
                    
                    <!-- Password -->                    
                    <div class="form-group" style="position: relative;">                        
                        <input                             
                            type="password"                             
                            id="password"                             
                            name="password"                             
                            class="form-input"                             
                            placeholder="Enter your Password"                            
                            required                            
                        >                        
                        <!-- Show/Hide password -->                        
                        <button type="button" class="toggle-password" id="togglePassword">                            
                            <svg class="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">                            
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>                            
                                <circle cx="12" cy="12" r="3"/>                            
                            </svg>                        
                        </button>                        
                        <span class="error-message" id="passwordError"></span>                    
                    </div>                    
                    
                    <!-- Remember me -->                    
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
                    
                    <!-- Google -->                    
                    <button type="button" class="google-btn" id="googleBtn"
                        onclick="window.location.href = 'https://accounts.google.com/o/oauth2/auth?scope=openid%20email%20profile&access_type=offline&prompt=consent&redirect_uri=http://localhost:8080/BeeTask/LoginGoogleServlet&response_type=code&client_id=<%= googleClientId %>'">
                    <svg class="google-icon" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                    </svg>
                    <span>Google</span>
                </button>                 
                    
                    <!-- Footer links -->                    
                    <div class="footer-links">                        
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Forgot password?</a>                        
                        <span style="margin: 0 8px; color: #ccc;">|</span>                        
                        <a href="${pageContext.request.contextPath}/register" class="register-link">Create account</a>                    
                    </div>                
                </form>            
            </div>        
        </div>                                    
        
        <script src="${pageContext.request.contextPath}/Authentication/Login.js"></script>    
    </body>
</html>

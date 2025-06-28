<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BeeTask - Sign Up</title>
        <link rel="stylesheet" href="Register.css">
    </head>
    <body>
        <div class="decorative-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>

        <div class="container">
            <div class="register-card">
                <div class="logo-section">
                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                    </div>
                    <h2 class="register-title">Sign up</h2>
                    <% if (request.getAttribute("emailError") != null) { %>
                    <div id="topErrorMessage" class="top-error-message">
                        <%= request.getAttribute("emailError") %>
                    </div>
                    <% } %>

                </div>

                <form class="register-form" id="registerForm" action="${pageContext.request.contextPath}/register" method="post">

                    <!-- Name -->
                    <div class="form-group">
                        <label for="name" class="form-label">Name</label>
                        <input 
                            type="text" 
                            id="name" 
                            name="name" 
                            class="form-input" 
                            placeholder="Enter Username"
                            value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>"
                            required>
                     <span class="error-message" id="nameError"></span>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            class="form-input <%= request.getAttribute("emailError") != null ? "input-error" : "" %>" 
                            placeholder="Enter your Email"
                            value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                            required>
                        <span class="error-message" id="emailError"></span>

                    </div>

                    <!-- Password -->
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
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-bar">
                                <div class="strength-fill" id="strengthFill"></div>
                            </div>
                            <span class="strength-text" id="strengthText"></span>
                        </div>
                    </div>

                    <!-- Submit -->
                    <button type="submit" class="register-btn" id="registerBtn">
                        <span class="btn-text">Sign up</span>
                        <span class="loading-spinner" id="loadingSpinner" style="display: none;">
                            <div class="spinner"></div>
                        </span>
                    </button>

                    <!-- Divider -->
                    <div class="divider">Or Continue With:</div>

                    <!-- Google -->
                    <button type="button" class="google-btn" id="googleBtn">
                        <svg class="google-icon" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                        </svg>
                        <span>Google</span>
                    </button>

                    <!-- Footer -->
                    <div class="footer-link">
                        <a href="Login.jsp" class="login-link">Already have an account? Log in</a>
                    </div>
                </form>
            </div>
        </div>

        <script src="Register.js"></script>
    </body>
</html>

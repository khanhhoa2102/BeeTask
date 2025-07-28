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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Additional scroll styles */
        .auth-card {
            max-height: 90vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .auth-card-container {
            display: flex;
            width: 100%;
            height: 100%;
        }
        .auth-form-wrapper {
            flex: 1;
            padding: 2rem;
            overflow-y: auto;
            scroll-behavior: smooth;
            -webkit-overflow-scrolling: touch;
        }
        @media (max-width: 768px) {
            .auth-card {
                max-height: 95vh;
            }
            .auth-form-wrapper {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <!-- Animated Background -->
    <div class="background-container">
        <div class="background-overlay"></div>
        <div class="floating-elements">
            <div class="floating-card kanban-card">
                <div class="card-header">Sprint Planning</div>
                <div class="card-items">
                    <div class="card-item">✓ Design Review</div>
                    <div class="card-item">⏳ Development</div>
                    <div class="card-item">📋 Testing</div>
                </div>
            </div>
            <div class="floating-card calendar-card">
                <div class="calendar-header">December 2024</div>
                <div class="calendar-grid">
                    <div class="calendar-day active">15</div>
                    <div class="calendar-day">16</div>
                    <div class="calendar-day">17</div>
                    <div class="calendar-day">18</div>
                </div>
            </div>
            <div class="floating-card team-card">
                <div class="team-header">Team Collaboration</div>
                <div class="team-avatars">
                    <div class="avatar">👨‍💻</div>
                    <div class="avatar">👩‍💼</div>
                    <div class="avatar">👨‍🎨</div>
                    <div class="avatar">+3</div>
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
            <div class="auth-card-container">
                <!-- Info Panel -->
                <div class="auth-info-panel">
                    <h2>Welcome to BeeTask</h2>
                    <p>Sign in to manage your tasks and collaborate with your team</p>
                    
                    <div class="feature-item">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        <span>Intuitive task management</span>
                    </div>
                    <div class="feature-item">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <span>Real-time collaboration</span>
                    </div>
                    <div class="feature-item">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        <span>Secure cloud storage</span>
                    </div>
                </div>

                <!-- Form Wrapper with Scroll -->
                <div class="auth-form-wrapper">
                    <!-- Logo Section -->
                    <div class="logo-section">
                        <div class="logo-container">
                            <div class="logo-backdrop"></div>
                            <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                        </div>
                        <h1 class="auth-title">Welcome back to BeeTask</h1>
                        <p class="auth-subtitle">Sign in to manage your tasks</p>
                    </div>

                    <!-- Messages -->
                    <% if ("reset_success".equals(msg)) { %>
                        <div class="message success-message">
                            <div class="message-icon">✅</div>
                            <span>Password reset successfully!</span>
                        </div>
                    <% } %>
                    <% if (successMessage != null) { %>
                        <div class="message success-message">
                            <div class="message-icon">✅</div>
                            <span><%= successMessage %></span>
                        </div>
                        <% session.removeAttribute("successMessage"); %>
                    <% } %>
                    <% if (errorMessage != null) { %>
                        <div class="message error-message">
                            <div class="message-icon">⚠️</div>
                            <span><%= errorMessage %></span>
                        </div>
                    <% } %>

                    <!-- Login Form -->
                    <form class="auth-form" id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
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
                                    placeholder="Enter your work email"
                                    required
                                >
                            </div>
                            <span class="error-text" id="emailError"></span>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-container">
                                <div class="input-icon">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                        <circle cx="12" cy="16" r="1"/>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                    </svg>
                                </div>
                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    class="form-input"
                                    placeholder="Enter your password"
                                    required
                                >
                                <button type="button" class="toggle-password" id="togglePassword">
                                    <svg class="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                        <circle cx="12" cy="12" r="3"/>
                                    </svg>
                                </button>
                            </div>
                            <span class="error-text" id="passwordError"></span>
                        </div>

                        <div class="form-options">
                            <label class="checkbox-container">
                                <input type="checkbox" id="remember" name="remember" checked>
                                <span class="checkmark"></span>
                                <span class="checkbox-text">Remember me</span>
                            </label>
                            <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Forgot password?</a>
                        </div>

                        <button type="submit" class="primary-btn" id="loginBtn">
                            <span class="btn-content">
                                <span class="btn-text">Sign In</span>
                                <div class="btn-loader" id="loadingSpinner">
                                    <div class="loader-spinner"></div>
                                </div>
                            </span>
                        </button>

                        <div class="divider">
                            <span class="divider-text">Or continue with</span>
                        </div>

                        <button type="button" class="google-btn" id="googleBtn"
                            onclick="window.location.href = 'https://accounts.google.com/o/oauth2/auth?scope=openid%20email%20profile&access_type=offline&prompt=consent&redirect_uri=http://localhost:8080/BeeTask/LoginGoogleServlet&response_type=code&client_id=<%= googleClientId %>'">
                            <svg class="google-icon" viewBox="0 0 24 24">
                                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                            </svg>
                            <span>Continue with Google</span>
                        </button>

                        <div class="auth-footer">
                            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register" class="register-link">Create account</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Authentication/Login.js"></script>
</body>
</html>
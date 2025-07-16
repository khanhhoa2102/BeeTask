<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BeeTask - Create Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/Register.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <!-- Animated Background -->
    <div class="background-container">
        <div class="background-overlay"></div>
        <div class="floating-elements">
            <div class="floating-card project-card">
                <div class="card-header">New Project</div>
                <div class="project-progress">
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: 75%"></div>
                    </div>
                    <span class="progress-text">75% Complete</span>
                </div>
            </div>
            <div class="floating-card task-card">
                <div class="task-header">Today's Tasks</div>
                <div class="task-list">
                    <div class="task-item completed">✓ Design mockups</div>
                    <div class="task-item">📝 Write documentation</div>
                    <div class="task-item">🔍 Code review</div>
                </div>
            </div>
            <div class="floating-card stats-card">
                <div class="stats-header">Team Stats</div>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">24</div>
                        <div class="stat-label">Tasks</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">8</div>
                        <div class="stat-label">Members</div>
                    </div>
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
                <h1 class="auth-title">Join BeeTask Today</h1>
                <p class="auth-subtitle">Create your account and start collaborating with your team</p>
            </div>

            <!-- Error Messages -->
            <% if (request.getAttribute("emailError") != null) { %>
                <div class="message error-message">
                    <div class="message-icon">⚠️</div>
                    <span><%= request.getAttribute("emailError") %></span>
                </div>
            <% } %>

            <!-- Register Form -->
            <form class="auth-form" id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="name" class="form-label">Full Name</label>
                    <div class="input-container">
                        <div class="input-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <input
                            type="text"
                            id="name"
                            name="name"
                            class="form-input"
                            placeholder="Enter your full name"
                            value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>"
                            required
                        >
                    </div>
                    <span class="error-text" id="nameError"></span>
                </div>

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
                            class="form-input <%= request.getAttribute("emailError") != null ? "input-error" : "" %>"
                            placeholder="Enter your work email"
                            value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
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
                            placeholder="Create a strong password"
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
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthFill"></div>
                        </div>
                        <div class="strength-indicators">
                            <span class="strength-text" id="strengthText">Password strength</span>
                            <div class="strength-requirements" id="strengthRequirements">
                                <div class="requirement" id="lengthReq">
                                    <span class="req-icon">○</span>
                                    <span class="req-text">At least 8 characters</span>
                                </div>
                                <div class="requirement" id="upperReq">
                                    <span class="req-icon">○</span>
                                    <span class="req-text">One uppercase letter</span>
                                </div>
                                <div class="requirement" id="numberReq">
                                    <span class="req-icon">○</span>
                                    <span class="req-text">One number</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <div class="input-container">
                        <div class="input-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                <path d="M9 16l2 2 4-4"/>
                            </svg>
                        </div>
                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            class="form-input"
                            placeholder="Confirm your password"
                            required
                        >
                        <button type="button" class="toggle-password" id="toggleConfirmPassword">
                            <svg class="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <span class="error-text" id="confirmPasswordError"></span>
                    <div class="password-match" id="passwordMatch">
                        <div class="match-indicator" id="matchIndicator">
                            <span class="match-icon">○</span>
                            <span class="match-text">Passwords match</span>
                        </div>
                    </div>
                </div>

                <div class="terms-section">
                    <label class="checkbox-container">
                        <input type="checkbox" id="terms" name="terms" required>
                        <span class="checkmark"></span>
                        <span class="checkbox-text">
                            I agree to the <a href="#" class="terms-link">Terms of Service</a> and 
                            <a href="#" class="terms-link">Privacy Policy</a>
                        </span>
                    </label>
                </div>

                <button type="submit" class="primary-btn" id="registerBtn">
                    <span class="btn-content">
                        <span class="btn-text">Create Account</span>
                        <div class="btn-loader" id="loadingSpinner">
                            <div class="loader-spinner"></div>
                        </div>
                    </span>
                </button>

                <div class="divider">
                    <span class="divider-text">Or continue with</span>
                </div>

                <button type="button" class="google-btn" id="googleBtn">
                    <svg class="google-icon" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                    </svg>
                    <span>Continue with Google</span>
                </button>

                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login" class="login-link">Sign in</a></p>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Authentication/Register.js"></script>
</body>
</html>

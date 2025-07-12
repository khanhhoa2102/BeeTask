<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) request.getAttribute("user");
    User sessionUser = (User) session.getAttribute("user");
    boolean isGoogle = user != null && "google".equalsIgnoreCase(user.getLoginProvider());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Settings</title>
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/AccountSettings.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body data-context-path="${pageContext.request.contextPath}">
<div class="page-container">
    <% if (user == null) { %>
        <div class="login-prompt">
            <div class="login-card">
                <div class="login-icon">🔒</div>
                <h2>Not Logged In</h2>
                <p>Please log in to access your account settings.</p>
            </div>
        </div>
    <% } else { %>
    <div class="container">
        <div class="page-header">
            <h1>Account Settings</h1>
            <p>Edit your personal information below</p>
        </div>
        <div class="content-grid">
            <!-- Profile card -->
            <div class="profile-card">
                <div class="profile-header">
                    <div class="avatar-container">
                        <img id="avatarPreview" class="avatar"
                             src="<%= user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty() ? user.getAvatarUrl() : "https://via.placeholder.com/100" %>"
                             alt="Avatar" />
                        <div class="avatar-fallback"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
                    </div>
                    <h3><%= user.getUsername() %></h3>
                    <div class="email"><%= user.getEmail() %></div>
                </div>
                <div class="profile-info">
                    <div class="info-item"><i class="fas fa-phone"></i>
                        <span id="phoneDisplay"><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %></span>
                    </div>
                    <div class="info-item"><i class="fas fa-map-marker-alt"></i>
                        <span id="addressDisplay"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></span>
                    </div>
                    <div class="info-item"><i class="fas fa-calendar-alt"></i>
                        <span><%= user.getCreatedAt() != null ? user.getCreatedAt().toLocalDateTime().toLocalDate().toString() : "Unknown" %></span>
                    </div>
                </div>
            </div>

            <!-- Settings form -->
            <div class="settings-card">
                <form id="settingsForm" method="post" action="${pageContext.request.contextPath}/account/settings">
                    <div class="card-header">
                        <h2><i class="fas fa-user-cog"></i> Account Information</h2>
                        <p>Please make sure all information is correct.</p>
                    </div>
                    <div class="form-section">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" id="username" name="username" value="<%= user.getUsername() %>" required />
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber">Phone Number</label>
                                <input type="text" id="phoneNumber" name="phoneNumber"
                                       value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" />
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="avatarUrl">Avatar (URL)</label>
                                <input type="text" id="avatarUrl" name="avatarUrl"
                                       value="<%= user.getAvatarUrl() != null ? user.getAvatarUrl() : "" %>"
                                       <%= isGoogle ? "readonly" : "" %> />
                                <% if (isGoogle) { %>
                                    <small style="color: gray;">Avatar is from Google account and cannot be changed here.</small>
                                <% } %>
                            </div>
                            <div class="form-group">
                                <label for="dob">Date of Birth</label>
                                <input type="date" id="dob" name="dob"
                                       value="<%= user.getDateOfBirth() != null ? user.getDateOfBirth().toString() : "" %>" />
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="gender">Gender</label>
                                <select id="gender" name="gender">
                                    <option value="">-- Select Gender --</option>
                                    <option value="Nam" <%= "Nam".equals(user.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="Nữ" <%= "Nữ".equals(user.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="Khác" <%= "Khác".equals(user.getGender()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="address">Address</label>
                                <input type="text" id="address" name="address"
                                       value="<%= user.getAddress() != null ? user.getAddress() : "" %>" />
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="submitBtn"><span>Save Changes</span></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <% } %>
</div>

<!-- Toast Notification -->
<div id="toast" class="toast">
    <div class="toast-content">
        <i class="toast-icon"></i>
        <span class="toast-message"></span>
    </div>
</div>

<!-- JS -->
<script src="${pageContext.request.contextPath}/AccountSettings.js"></script>
</body>
</html>

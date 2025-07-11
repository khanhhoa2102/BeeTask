<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview, model.User" %>
<%@ include file="../session-check.jspf" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="HeaderAdmin.jsp" %>
    <title>All Projects - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Statistic.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="dashboard-body">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="user-profile">
                <div class="avatar">
                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                    <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #ccc;"></div>
                    <% } %>
                </div>
                <div class="info">
                    <span class="username"><%= user.getUsername() %></span>
                    <span class="email"><%= user.getEmail() %></span>
                </div>
            </div>

            <%@ include file="SidebarAdmin.jsp" %>
            <%@ include file="../Help.jsp" %>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="calendar-box">
                <h2>All Projects in System</h2>

                <%
                    List<ProjectOverview> allProjects = (List<ProjectOverview>) request.getAttribute("projects");

                    int lockedCount = 0;
                    Map<Integer, List<ProjectOverview>> projectMap = new LinkedHashMap<>();

                    for (ProjectOverview po : allProjects) {
                        projectMap.computeIfAbsent(po.getProjectId(), k -> new ArrayList<>()).add(po);
                    }

                    // Đếm số lượng dự án bị khóa
                    Set<Integer> lockedProjects = new HashSet<>();
                    for (List<ProjectOverview> group : projectMap.values()) {
                        if (group.get(0).isLocked()) {
                            lockedProjects.add(group.get(0).getProjectId());
                        }
                    }
                    lockedCount = lockedProjects.size();
                %>

                <p style="color: red; margin-bottom: 15px;">Locked Projects: <strong><%= lockedCount %></strong></p>

                <%
                    if (allProjects != null && !allProjects.isEmpty()) {
                        for (Map.Entry<Integer, List<ProjectOverview>> entry : projectMap.entrySet()) {
                            ProjectOverview project = entry.getValue().get(0);
                            Set<String> memberNames = new LinkedHashSet<>();
                            String leader = "";

                            for (ProjectOverview po : entry.getValue()) {
                                memberNames.add(po.getUsername());
                                if ("Leader".equalsIgnoreCase(po.getRole())) {
                                    leader = po.getUsername();
                                }
                            }
                %>
                <div class="project-block">
                    <div class="project-header-card">
                        <div class="project-icon"><i class="fas fa-project-diagram"></i></div>
                        <div class="project-info">
                            <h1 class="project-title">
                                <span class="project-id">#<%= project.getProjectId() %></span>
                                <%= project.getProjectName() %>
                                <% if (project.isLocked()) { %>
                                    <span style="color: red;">(Locked)</span>
                                <% } %>
                            </h1>
                            <p class="project-description">
                                <i class="fas fa-info-circle"></i>
                                <%= project.getProjectDescription() %>
                            </p>
                            <div class="project-meta">
                                <div class="meta-item">
                                    <i class="fas fa-user-plus"></i>
                                    Created By: <strong><%= project.getProjectCreatedBy() %></strong>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-crown"></i>
                                    Leader: <strong><%= leader != null && !leader.isEmpty() ? leader : "N/A" %></strong>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    Created At: <strong><%= project.getProjectCreatedAt() %></strong>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-users"></i>
                                    Members (<%= memberNames.size() %>): 
                                    <strong><%= String.join(", ", memberNames) %></strong>
                                </div>
                                <div class="meta-item">
                                   <form method="post" action="allprojects">
    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
    <input type="hidden" name="isLocked" value="<%= project.isLocked() ? "false" : "true" %>">
    <button type="submit" class="btn <%= project.isLocked() ? "btn-unlock" : "btn-lock" %>">
        <i class="fas <%= project.isLocked() ? "fa-lock-open" : "fa-lock" %>"></i>
        <%= project.isLocked() ? "Unlock" : "Lock" %>
    </button>
</form>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        } // end for
                    } else {
                %>
                <p>There is no project in the system.</p>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>

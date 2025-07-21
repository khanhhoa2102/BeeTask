<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview, model.User" %>
<%@ include file="../session-check.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="HeaderAdmin.jsp" %>
    <title>Project Management Dashboard - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/Statistic.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
                <h2><i class="fas fa-tasks"></i> Project Management Dashboard</h2>
                
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

                <div class="status-badge locked">
                    <i class="fas fa-shield-alt"></i>
                    <strong><%= lockedCount %></strong> Locked Projects
                </div>

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
                        <div class="project-icon">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div class="project-info">
                            <h1 class="project-title">
                                <span class="project-id">#<%= project.getProjectId() %></span>
                                <%= project.getProjectName() %>
                                <% if (project.isLocked()) { %>
                                    <span class="locked-indicator">
                                        <i class="fas fa-lock"></i> LOCKED
                                    </span>
                                <% } %>
                            </h1>
                            <p class="project-description">
                                <i class="fas fa-info-circle"></i>
                                <%= project.getProjectDescription() %>
                            </p>
                            <div class="project-meta">
                                <div class="meta-item">
                                    <i class="fas fa-user-plus"></i>
                                    <span>Created By: <strong><%= project.getProjectCreatedBy() %></strong></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-crown"></i>
                                    <span>Project Leader: <strong><%= leader != null && !leader.isEmpty() ? leader : "Not Assigned" %></strong></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-calendar-plus"></i>
                                    <span>Created: <strong><%= project.getProjectCreatedAt() %></strong></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-users"></i>
                                    <span>Team Members (<%= memberNames.size() %>): <strong><%= String.join(", ", memberNames) %></strong></span>
                                </div>
                                <div class="meta-item">
                                    <form method="post" action="allprojects" style="margin: 0;">
                                        <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                        <input type="hidden" name="isLocked" value="<%= project.isLocked() ? "false" : "true" %>">
                                        <button type="submit" class="btn <%= project.isLocked() ? "btn-unlock" : "btn-lock" %>">
                                            <i class="fas <%= project.isLocked() ? "fa-unlock" : "fa-lock" %>"></i>
                                            <%= project.isLocked() ? "Unlock Project" : "Lock Project" %>
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
                <div style="text-align: center; padding: 3rem; color: #64748b;">
                    <i class="fas fa-folder-open" style="font-size: 4rem; margin-bottom: 1rem; color: #cbd5e1;"></i>
                    <h3>No Projects Found</h3>
                    <p>There are currently no projects in the system.</p>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>

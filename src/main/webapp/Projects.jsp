<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Project, model.User, dao.ProjectDAO" %>
<%@ include file="session-check.jspf" %>
<%
    ProjectDAO projectDAO = new ProjectDAO();
    List<Project> projects = projectDAO.getProjectsByUserId(user.getUserId());
    String editIdStr = request.getParameter("editId");
    Integer editId = (editIdStr != null) ? Integer.parseInt(editIdStr) : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="Header.jsp" %>
    <title>BeeTask - Project Management</title>
    <link rel="stylesheet" href="Projects.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container">
        <%@include file="./Sidebar.jsp"%>

    <div class="main-content">
        <div class="page-header">
            <div class="header-container">
                <h1 class="page-title">
                    <i class="fas fa-project-diagram"></i>
                    Project Management
                </h1>
                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="projectSearch" class="search-input" placeholder="Search projects...">
                    </div>
                    <button class="btn primary create-btn" onclick="openCreateModal()">
                        <i class="fas fa-plus"></i>
                        Create New Project
                    </button>
                </div>
            </div>
        </div>

        <div class="content">
            <div class="projects-section">
                <div class="section-header">
                    <div class="section-info">
                        <h2 class="section-title">Your Projects</h2>
                        <span class="project-count"><%= projects.size() %> projects</span>
                    </div>
                    <div class="view-options">
                        <button class="view-btn active" data-view="grid" title="Grid view">
                            <i class="fas fa-th-large"></i>
                        </button>
                        <button class="view-btn" data-view="list" title="List view">
                            <i class="fas fa-list"></i>
                        </button>
                    </div>
                </div>

                <div class="projects-grid" id="projectsContainer">
                    <% if (projects.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-folder-open"></i>
                            </div>
                            <h3>No projects yet</h3>
                            <p>Create your first project to start managing your work</p>
                            <button class="btn primary" onclick="openCreateModal()">
                                <i class="fas fa-plus"></i>
                                Create your first project
                            </button>
                        </div>
                    <% } else { %>
                        <% for (Project p : projects) { %>
                            <div class="project-card" data-project-id="<%= p.getProjectId() %>" data-project-name="<%= p.getName().toLowerCase() %>">
                                <div class="card-header">
                                    <div class="project-icon">
                                        <i class="fas fa-folder"></i>
                                    </div>
                                    <div class="card-actions">
                                        <button class="action-btn" onclick="editProject(<%= p.getProjectId() %>)" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="action-btn delete-btn" onclick="confirmDelete(<%= p.getProjectId() %>, '<%= p.getName() %>')" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="card-content">
                                    <h3 class="project-title"><%= p.getName() %></h3>
                                    <p class="project-description">
                                        <%= p.getDescription() != null && !p.getDescription().isEmpty() ? p.getDescription() : "No description provided" %>
                                    </p>
                                    <div class="click-hint">
                                        <i class="fas fa-mouse-pointer"></i>
                                        <span>Click to view tasks</span>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="project-meta">
                                        <span class="meta-item">
                                            <i class="fas fa-calendar-alt"></i>
                                            <%= p.getCreatedAt() %>
                                        </span>
                                    </div>
                                    <div class="project-status">
                                        <span class="status-badge active">Active</span>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Create/Edit Project Modal -->
<div class="modal" id="projectModal">
    <div class="modal-backdrop"></div>
    <div class="modal-container">
        <div class="modal-header">
            <h3 id="modalTitle">
                <i class="fas fa-plus-circle"></i>
                Create New Project
            </h3>
            <button class="modal-close" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form id="projectForm" action="project" method="post">
            <div class="modal-body">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="projectId" id="projectId">
                
                <div class="form-group">
                    <label for="projectName">Project Name *</label>
                    <input type="text" id="projectName" name="name" class="form-input" placeholder="Enter project name..." required>
                </div>
                
                <div class="form-group">
                    <label for="projectDescription">Project Description</label>
                    <textarea id="projectDescription" name="description" class="form-textarea" placeholder="Enter project description..." rows="4"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn secondary" onclick="closeModal()">
                    <i class="fas fa-times"></i>
                    Cancel
                </button>
                <button type="submit" class="btn primary" id="submitBtn">
                    <i class="fas fa-save"></i>
                    Save Project
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal" id="deleteModal">
    <div class="modal-backdrop"></div>
    <div class="modal-container small">
        <div class="modal-header danger">
            <h3>
                <i class="fas fa-exclamation-triangle"></i>
                Confirm Deletion
            </h3>
            <button class="modal-close" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to delete the project <strong id="deleteProjectName"></strong>?</p>
            <p class="warning-text">This action cannot be undone!</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn secondary" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i>
                Cancel
            </button>
            <form id="deleteForm" action="project" method="post" style="display: inline;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="projectId" id="deleteProjectId">
                <button type="submit" class="btn danger">
                    <i class="fas fa-trash"></i>
                    Delete Project
                </button>
            </form>
        </div>
    </div>
</div>

<script src="Projects.js"></script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.TemplateDAO" %>
<%@ page import="model.Template" %>
<%@ page import="java.util.*" %>
<%@ include file="../session-check.jspf" %>
<%
    TemplateDAO templateDAO = new TemplateDAO();
    List<Template> templates = templateDAO.getAllTemplates();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="../Header.jsp" %>
    <title>BeeTask - Template Library</title>
    <link rel="stylesheet" href="../Templates.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container">
        
    <%@include file="../Sidebar.jsp"%>

    <div class="main-content">
        <div class="page-header">
            <div class="header-container">
                <h1 class="page-title">Featured templates</h1>
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" id="templateSearch" class="search-input" placeholder="Find templates">
                </div>
            </div>
        </div>

        <div class="content">
            <div class="create-board-section">
                <div class="create-board-card" onclick="createNewBoard()">
                    <div class="create-icon">
                        <i class="fas fa-plus"></i>
                    </div>
                    <div class="create-content">
                        <h3>Create a new table</h3>
                        <p>Start from scratch with a blank slate</p>
                    </div>
                </div>
            </div>
            <div class="categories-section">
                <div class="categories-grid">
                    <div class="category-item" data-category="business">
                        <div class="category-icon business-gradient">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <span class="category-name">Business</span>
                    </div>
                    <div class="category-item" data-category="design">
                        <div class="category-icon design-gradient">
                            <i class="fas fa-palette"></i>
                        </div>
                        <span class="category-name">Design</span>
                    </div>
                    <div class="category-item" data-category="education">
                        <div class="category-icon education-gradient">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <span class="category-name">Education</span>
                    </div>
                    <div class="category-item" data-category="development">
                        <div class="category-icon development-gradient">
                            <i class="fas fa-code"></i>
                        </div>
                        <span class="category-name">Technique</span>
                    </div>
                    <div class="category-item" data-category="marketing">
                        <div class="category-icon marketing-gradient">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <span class="category-name">Marketing</span>
                    </div>
                    <div class="category-item" data-category="project">
                        <div class="category-icon project-gradient">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <span class="category-name">Project Management</span>
                    </div>
                    <div class="category-item" data-category="remote">
                        <div class="category-icon remote-gradient">
                            <i class="fas fa-home"></i>
                        </div>
                        <span class="category-name">Working Remotely</span>
                    </div>
                </div>
            </div>

            <div class="featured-grid">
            <% for (Template t : templates) { %>
                <div class="featured-card" data-template-id="<%= t.getTemplateId() %>" data-category="<%= t.getCategory() %>">
                    <div class="card-image">
                        <img src="<%= t.getThumbnailUrl() %>" alt="<%= t.getName() %>" loading="lazy">
                        <div class="card-overlay">
                            <button class="overlay-btn" onclick="previewTemplate(<%= t.getTemplateId() %>)" title="Preview">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="overlay-btn" onclick="useTemplate(<%= t.getTemplateId() %>)" title="Use">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <div class="trello-logo">
                            <span>T</span>
                        </div>
                    </div>
                    <div class="card-content">
                        <h3 class="card-title"><%= t.getName() %></h3>
                        <p class="card-description"><%= t.getDescription() %></p>
                        <div class="card-stats">
                            <span class="stat-item">
                                <i class="fas fa-copy"></i> 0
                            </span>
                            <span class="stat-item">
                                <i class="fas fa-eye"></i> 0
                            </span>
                        </div>
                    </div>
                </div>
            <% } %>
            </div>

            <div class="create-board-section">
                <div class="create-board-card" onclick="createNewBoard()">
                    <div class="create-icon">
                        <i class="fas fa-plus"></i>
                    </div>
                    <div class="create-content">
                        <h3>Create a new table</h3>
                        <p>Start from scratch with a blank slate</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="createBoardModal">
    <div class="modal-backdrop"></div>
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Create a new table</h3>
            <button class="modal-close" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="createBoardForm">
                <div class="form-group">
                    <label for="boardName">Table name</label>
                    <input type="text" id="boardName" name="boardName" class="form-input" placeholder="Nhập tên bảng..." required>
                </div>
                <div class="form-group">
                    <label for="boardDescription">Description (Optional)</label>
                    <textarea id="boardDescription" name="boardDescription" class="form-textarea" placeholder="Mô tả bảng của bạn..." rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="boardCategory">Category</label>
                    <select id="boardCategory" name="boardCategory" class="form-select">
                        <option value="Business">Business</option>
                        <option value="Development">Technique</option>
                        <option value="Design">Design</option>
                        <option value="Marketing">Marketing</option>
                        <option value="Education">Education</option>
                        <option value="Project Management">Project Management</option>
                        <option value="Remote Work">Working Remotely</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn secondary" onclick="closeModal()">
                <i class="fas fa-times"></i>
                Cancel
            </button>
            <button class="btn primary" onclick="submitCreateBoard()">
                <i class="fas fa-plus"></i>
                Create a table
            </button>
        </div>
    </div>
</div>

<script src="../Templates.js"></script>
</body>
</html>

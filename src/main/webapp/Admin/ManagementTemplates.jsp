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
    <%@include file="HeaderAdmin.jsp" %>
    <title>BeeTask </title>
    <link rel="stylesheet" href="ManagementTemplates.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container">
    <aside class="sidebar">
        <div class="user-profile">
            <div class="avatar">
                <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                    <img src="<%= user.getAvatarUrl() %>" alt="Avatar">
                <% } else { %>
                    <div class="avatar-placeholder">
                        <i class="fas fa-user"></i>
                    </div>
                <% } %>
            </div>
            <div class="info">
                <span class="username"><%= user.getUsername() %></span>
                <span class="email"><%= user.getEmail() %></span>
            </div>
        </div>
        <%@include file="SidebarAdmin.jsp"%>
        <%@include file="../Help.jsp" %>
    </aside>

    <div class="main-content">
        <div class="page-header">
            <div class="header-container">
                <h1 class="page-title"> </h1>
                <div class="search-container">

                </div>
            </div>
        </div>


            <div class="featured-grid">
                
                
                
                
        <div class="content">
    <div class="create-board-section">
        <div class="create-board-card" onclick="createNewBoard()">
            <div class="create-icon">
                <i class="fas fa-plus"></i>
            </div>
            <div class="create-content">
                <h3>Create New Template</h3>
               
            </div>
        </div>
    </div>
</div>
                
                
            <% for (Template t : templates) { %>
                <div class="featured-card" data-template-id="<%= t.getTemplateId() %>" data-category="<%= t.getCategory() %>">
                    <div class="card-image">
                        <img src="<%= t.getThumbnailUrl() %>" alt="<%= t.getName() %>" loading="lazy">
                        <div class="card-overlay">
                            <button class="overlay-btn" onclick="previewTemplate(<%= t.getTemplateId() %>)" title="Preview">
                                <i class="fas fa-eye"></i>
                            </button>
                            
                        </div>
                       
                    </div>
                    <div class="card-content">
    <h3 class="card-title" id="title-<%= t.getTemplateId() %>"><%= t.getName() %></h3>
    <p class="card-description" id="desc-<%= t.getTemplateId() %>"><%= t.getDescription() %></p>

   <form method="post" action="<%=request.getContextPath()%>/admin/TemplateActionServlet" class="edit-form" id="form-<%= t.getTemplateId() %>" style="display:none;">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="templateId" value="<%= t.getTemplateId() %>">

    <label for="name-<%= t.getTemplateId() %>">Name:</label><br>
    <input type="text" id="name-<%= t.getTemplateId() %>" name="name" value="<%= t.getName() %>" required><br>

    <label for="description-<%= t.getTemplateId() %>">Description:</label><br>
    <textarea id="description-<%= t.getTemplateId() %>" name="description"><%= t.getDescription() %></textarea><br>

    <label for="category-<%= t.getTemplateId() %>">Category:</label><br>
    <input type="text" id="category-<%= t.getTemplateId() %>" name="category" value="<%= t.getCategory() %>"><br>

    <label for="thumbnailUrl-<%= t.getTemplateId() %>">Thumbnail URL:</label><br>
    <input type="text" id="thumbnailUrl-<%= t.getTemplateId() %>" name="thumbnailUrl" value="<%= t.getThumbnailUrl() %>"><br>

    <button type="submit" class="btn primary"><i class="fas fa-save"></i> Save</button>
    <button type="button" onclick="cancelEdit(<%= t.getTemplateId() %>)" class="btn secondary">Cancel</button>
</form>


    <div class="card-actions">
        <button class="btn small" onclick="showEditForm(<%= t.getTemplateId() %>)"><i class="fas fa-edit"></i>Edit</button>
        <form method="post" action="<%=request.getContextPath()%>/admin/TemplateActionServlet" style="display:inline;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="templateId" value="<%= t.getTemplateId() %>">
            <button type="submit" class="btn small danger" onclick="return confirm('Bạn có chắc muốn xóa mẫu này?')"><i class="fas fa-trash"></i>Delete</button>
        </form>
    </div>
</div>

                </div>
            <% } %>
            </div>

        </div>
    </div>


<div class="modal" id="createBoardModal">
    <div class="modal-backdrop"></div>
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i>Create new template</h3>
            <button class="modal-close" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
           <form id="createBoardForm" method="post" action="<%=request.getContextPath()%>/admin/TemplateActionServlet">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="boardName">Name template</label>
        <input type="text" id="boardName" name="name" class="form-input" placeholder="Enter the template name ..." required>
    </div>
    <div class="form-group">
        <label for="boardDescription">Description (optional)</label>
        <textarea id="boardDescription" name="description" class="form-textarea" placeholder="Describe your template ..." rows="3"></textarea>
    </div>
    
  
    
    
<div class="form-group" id="customCategoryGroup" style="display:none;">
    <label for="customCategory">Enter custom category</label>
    <input type="text" id="customCategory" class="form-input" placeholder="Enter custom category..." />
</div>

<div class="form-group">
    <label for="thumbnailUrl">Thumbnail URL</label>
    <input type="text" id="thumbnailUrl" name="thumbnailUrl" class="form-input" placeholder="Enter image URL...">
</div>

<div class="modal-footer">
    <button class="btn secondary" type="button" onclick="closeModal()">
        <i class="fas fa-times"></i>
        Cancel
    </button>
    <button class="btn primary" type="submit">
        <i class="fas fa-plus"></i>
        Create Board
    </button>
</div>
    
    
</form>

            
            
        </div>
       
    </div>
</div>

            
            
            
            <script>
    function showEditForm(templateId) {
        const form = document.getElementById("form-" + templateId);
        if (form) form.style.display = "block";

        const title = document.getElementById("title-" + templateId);
        const desc = document.getElementById("desc-" + templateId);
        if (title) title.style.display = "none";
        if (desc) desc.style.display = "none";
    }

    function cancelEdit(templateId) {
        const form = document.getElementById("form-" + templateId);
        if (form) form.style.display = "none";

        const title = document.getElementById("title-" + templateId);
        const desc = document.getElementById("desc-" + templateId);
        if (title) title.style.display = "block";
        if (desc) desc.style.display = "block";
    }
</script>

            
            
            
     <script>
    function toggleCustomCategory() {
        const select = document.getElementById("boardCategory");
        const customInputGroup = document.getElementById("customCategoryGroup");

        if (select.value === "Other") {
            customInputGroup.style.display = "block";
        } else {
            customInputGroup.style.display = "none";
        }
    }

    // Khi submit form, nếu chọn "Khác", gán giá trị custom vào input ẩn
    document.getElementById("createBoardForm").addEventListener("submit", function (e) {
        const select = document.getElementById("boardCategory");
        if (select.value === "Other") {
            const customCategory = document.getElementById("customCategory").value.trim();
            if (customCategory !== "") {
                // Gán giá trị customCategory vào một input ẩn tên là "category"
                const hiddenInput = document.createElement("input");
                hiddenInput.type = "hidden";
                hiddenInput.name = "category";
                hiddenInput.value = customCategory;
                this.appendChild(hiddenInput);
            }
        }
    });
</script>
       
            
            
            
<script src="Templates.js"></script>
</body>
</html>

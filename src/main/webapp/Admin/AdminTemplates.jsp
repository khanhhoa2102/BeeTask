<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.admin.TemplateDAO, model.Template, java.util.*" %>
<%@ include file="../session-check.jspf" %>
<%
    TemplateDAO templateDAO = new TemplateDAO();
    List<Template> templates = templateDAO.getAllTemplates();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Templates</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            padding: 30px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .add-form {
            background: #fff;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        .add-form input, .add-form button {
            margin: 8px 10px 8px 0;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .add-form button {
            background: #2e89ff;
            color: white;
            border: none;
            cursor: pointer;
        }

        .template-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            margin: 15px auto;
            max-width: 900px;
            overflow: hidden;
        }

        .template-card img {
            width: 150px;
            height: 100px;
            object-fit: cover;
        }

        .template-info {
            flex: 1;
            padding: 20px;
        }

        .template-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            padding: 20px;
        }

        .template-actions form {
            display: inline;
        }

        .template-actions button {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-edit {
            background: #ffc107;
            color: black;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .edit-form {
            display: none;
            margin-top: 10px;
        }

        .edit-form input {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<h1>Quản lý Thư viện Mẫu</h1>

<!-- Form thêm mới -->
<div class="add-form">
    <form action="${pageContext.request.contextPath}/admin/TemplateActionServlet" method="post">
        <input type="hidden" name="action" value="add">
        <input type="text" name="name" placeholder="Tên" required>
        <input type="text" name="description" placeholder="Mô tả">
        <input type="text" name="category" placeholder="Danh mục">
        <input type="text" name="thumbnailUrl" placeholder="URL ảnh đại diện">
        <button type="submit">Thêm</button>
    </form>
</div>

<!-- Danh sách template -->
<% for (Template t : templates) { %>
    <div class="template-card">
        <img src="<%= t.getThumbnailUrl() %>" alt="Thumbnail">
        <div class="template-info">
            <h3><%= t.getName() %></h3>
            <p><strong>Mô tả:</strong> <%= t.getDescription() %></p>
            <p><strong>Danh mục:</strong> <%= t.getCategory() %></p>

            <!-- Form sửa (ẩn/hiện) -->
            <form class="edit-form" action="${pageContext.request.contextPath}/admin/TemplateActionServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="templateId" value="<%= t.getTemplateId() %>">
                <input type="text" name="name" value="<%= t.getName() %>" required><br>
                <input type="text" name="description" value="<%= t.getDescription() %>"><br>
                <input type="text" name="category" value="<%= t.getCategory() %>"><br>
                <input type="text" name="thumbnailUrl" value="<%= t.getThumbnailUrl() %>"><br>
                <button type="submit" class="btn-edit">Lưu</button>
            </form>
        </div>

        <div class="template-actions">
            <!-- Nút hiện form sửa -->
            <button class="btn-edit" onclick="toggleEditForm(this)">Chỉnh sửa</button>

            <!-- Nút xóa -->
            <form action="${pageContext.request.contextPath}/admin/TemplateActionServlet" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa không?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="templateId" value="<%= t.getTemplateId() %>">
                <button type="submit" class="btn-delete">Xóa</button>
            </form>
        </div>
    </div>
<% } %>

<script>
    function toggleEditForm(button) {
        const card = button.closest('.template-card');
        const form = card.querySelector('.edit-form');
        form.style.display = form.style.display === 'block' ? 'none' : 'block';
    }
</script>
</body>
</html>

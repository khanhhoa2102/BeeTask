package controller.admin;

import context.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;
import java.sql.*;

@WebServlet("/admin/TemplateActionServlet")
public class TemplateActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    handleAdd(request, response);
                    break;
                case "edit":
                    handleEdit(request, response);
                    break;
                case "delete":
                    handleDelete(request, response);
                    break;
                default:
                    response.sendRedirect("error.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
    
    
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    // Điều hướng về trang quản lý templates
    response.sendRedirect(request.getContextPath() + "/Admin/AdminTemplates.jsp");
}


    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String thumbnailUrl = request.getParameter("thumbnailUrl");
        int createdBy = ((User) request.getSession().getAttribute("user")).getUserId();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO Templates (Name, Description, Category, ThumbnailUrl, CreatedBy) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, description);
                stmt.setString(3, category);
                stmt.setString(4, thumbnailUrl);
                stmt.setInt(5, createdBy);
                stmt.executeUpdate();
            }
        }

        response.sendRedirect(request.getContextPath() + "/Admin/Templates.jsp");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int templateId = Integer.parseInt(request.getParameter("templateId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String thumbnailUrl = request.getParameter("thumbnailUrl");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Templates SET Name=?, Description=?, Category=?, ThumbnailUrl=? WHERE TemplateId=?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, description);
                stmt.setString(3, category);
                stmt.setString(4, thumbnailUrl);
                stmt.setInt(5, templateId);
                stmt.executeUpdate();
            }
        }

        response.sendRedirect(request.getContextPath() + "/Admin/Templates.jsp");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int templateId = Integer.parseInt(request.getParameter("templateId"));

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement stmt1 = conn.prepareStatement(
                    "DELETE FROM TemplateTasks WHERE TemplateBoardId IN (SELECT TemplateBoardId FROM TemplateBoards WHERE TemplateId = ?)")) {
                stmt1.setInt(1, templateId);
                stmt1.executeUpdate();
            }

            try (PreparedStatement stmt2 = conn.prepareStatement("DELETE FROM TemplateBoards WHERE TemplateId = ?")) {
                stmt2.setInt(1, templateId);
                stmt2.executeUpdate();
            }

            try (PreparedStatement stmt3 = conn.prepareStatement("DELETE FROM Templates WHERE TemplateId = ?")) {
                stmt3.setInt(1, templateId);
                stmt3.executeUpdate();
            }
        }

        response.sendRedirect(request.getContextPath() + "/Admin/Templates.jsp");
    }
}

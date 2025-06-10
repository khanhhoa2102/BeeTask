package dao;

import context.DBConnection;
import model.Template;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TemplateDAO {

    public List<Template> getAllTemplates() {
        List<Template> templates = new ArrayList<>();

        String sql = "SELECT TemplateId, Name, Description, Category, ThumbnailUrl FROM Templates";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Template t = new Template();
                t.setTemplateId(rs.getInt("TemplateId"));
                t.setName(rs.getString("Name"));
                t.setDescription(rs.getString("Description"));
                t.setCategory(rs.getString("Category"));
                t.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                templates.add(t);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn templates: " + e.getMessage());
        }

        return templates;
    }

}

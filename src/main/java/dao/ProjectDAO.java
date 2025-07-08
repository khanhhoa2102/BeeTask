/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Project;

public class ProjectDAO {

    public List<Project> findAll() throws Exception {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM Projects";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Project project = new Project(
                        rs.getInt("ProjectId"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getInt("CreatedBy"),
                        rs.getTimestamp("CreatedAt")
                );
                list.add(project);
            }
        }
        return list;
    }

    public Project findById(int id) throws Exception {
        String sql = "SELECT * FROM Projects WHERE ProjectId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Project(
                            rs.getInt("ProjectId"),
                            rs.getString("Name"),
                            rs.getString("Description"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Project p) throws Exception {
        String sql = "INSERT INTO Projects (Name, Description, CreatedBy) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getName());
            stmt.setString(2, p.getDescription());
            stmt.setInt(3, p.getCreatedBy());
            stmt.executeUpdate();
        }
    }

    public void update(Project p) throws Exception {
        String sql = "UPDATE Projects SET Name=?, Description=?, CreatedBy=? WHERE ProjectId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getName());
            stmt.setString(2, p.getDescription());
            stmt.setInt(3, p.getCreatedBy());
            stmt.setInt(4, p.getProjectId());
            stmt.executeUpdate();
        }
    }

    public void delete(int projectId) throws Exception {
        String sql = "DELETE FROM Projects WHERE ProjectId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            stmt.executeUpdate();
        }
    }

    public List<Project> getTop3ProjectsByUser(int userId) throws SQLException {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT TOP 3 p.ProjectId, p.Name, p.Description, p.CreatedBy, p.CreatedAt "
                + "FROM Projects p "
                + "INNER JOIN ProjectMembers pm ON p.ProjectId = pm.ProjectId "
                + "WHERE pm.UserId = ? "
                + "ORDER BY p.CreatedAt DESC";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("ProjectId");
                    String name = rs.getString("Name");
                    String desc = rs.getString("Description");
                    int createdBy = rs.getInt("CreatedBy");
                    Timestamp createdAt = rs.getTimestamp("CreatedAt");

                    Project p = new Project(id, name, desc, createdBy, createdAt);
                    projects.add(p);

                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return projects;
    }

}

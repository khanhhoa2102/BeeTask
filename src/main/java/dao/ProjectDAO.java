/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Project;

public class ProjectDAO {
    public List<Project> findAll() throws Exception {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM Projects";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
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
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getName());
            stmt.setString(2, p.getDescription());
            stmt.setInt(3, p.getCreatedBy());
            stmt.executeUpdate();
        }
    }

    public void update(Project p) throws Exception {
        String sql = "UPDATE Projects SET Name=?, Description=?, CreatedBy=? WHERE ProjectId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getName());
            stmt.setString(2, p.getDescription());
            stmt.setInt(3, p.getCreatedBy());
            stmt.setInt(4, p.getProjectId());
            stmt.executeUpdate();
        }
    }

    public void delete(int projectId) throws Exception {
        String sql = "DELETE FROM Projects WHERE ProjectId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            stmt.executeUpdate();
        }
    }
}
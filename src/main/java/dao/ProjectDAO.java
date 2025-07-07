package dao;

import context.DBConnection;
import model.Project;
import java.sql.*;

public class ProjectDAO {
    
    // Get project by ID
    public Project getProjectById(int projectId) {
        String sql = "SELECT * FROM Projects WHERE ProjectId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("ProjectId"));
                project.setName(rs.getString("Name"));
                project.setDescription(rs.getString("Description"));
                project.setCreatedBy(rs.getInt("CreatedBy")); // CreatedBy is INT in your database
                project.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                System.out.println("Found project: " + project.getName());
                return project;
            } else {
                System.out.println("No project found with ID: " + projectId);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting project by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Insert new project
    public void insert(Project project) {
        String sql = "INSERT INTO Projects (Name, Description, CreatedBy, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, project.getName());
            stmt.setString(2, project.getDescription());
            stmt.setInt(3, project.getCreatedBy());
            
            int result = stmt.executeUpdate();
            System.out.println("Project inserted successfully. Rows affected: " + result);
            
        } catch (SQLException e) {
            System.err.println("Error inserting project: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Update project
    public void update(Project project) {
        String sql = "UPDATE Projects SET Name = ?, Description = ? WHERE ProjectId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, project.getName());
            stmt.setString(2, project.getDescription());
            stmt.setInt(3, project.getProjectId());
            
            int result = stmt.executeUpdate();
            System.out.println("Project updated successfully. Rows affected: " + result);
            
        } catch (SQLException e) {
            System.err.println("Error updating project: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Delete project
    public void delete(int projectId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Delete tasks first (cascade from boards)
                String deleteTasksSQL = "DELETE FROM Tasks WHERE BoardId IN (SELECT BoardId FROM Boards WHERE ProjectId = ?)";
                try (PreparedStatement stmt1 = conn.prepareStatement(deleteTasksSQL)) {
                    stmt1.setInt(1, projectId);
                    stmt1.executeUpdate();
                }
                
                // Delete boards
                String deleteBoardsSQL = "DELETE FROM Boards WHERE ProjectId = ?";
                try (PreparedStatement stmt2 = conn.prepareStatement(deleteBoardsSQL)) {
                    stmt2.setInt(1, projectId);
                    stmt2.executeUpdate();
                }
                
                // Delete project
                String deleteProjectSQL = "DELETE FROM Projects WHERE ProjectId = ?";
                try (PreparedStatement stmt3 = conn.prepareStatement(deleteProjectSQL)) {
                    stmt3.setInt(1, projectId);
                    stmt3.executeUpdate();
                }
                
                conn.commit();
                System.out.println("Project deleted successfully with ID: " + projectId);
                
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
            
        } catch (SQLException e) {
            System.err.println("Error deleting project: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Get all projects (for listing)
    public java.util.List<Project> getAllProjects() {
        java.util.List<Project> projects = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Projects ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("ProjectId"));
                project.setName(rs.getString("Name"));
                project.setDescription(rs.getString("Description"));
                project.setCreatedBy(rs.getInt("CreatedBy"));
                project.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                projects.add(project);
            }
            
            System.out.println("Found " + projects.size() + " projects");
            
        } catch (SQLException e) {
            System.err.println("Error getting all projects: " + e.getMessage());
            e.printStackTrace();
        }
        
        return projects;
    }
    
    // Get projects by user ID (for user's projects)
    public java.util.List<Project> getProjectsByUserId(int userId) {
        java.util.List<Project> projects = new java.util.ArrayList<>();
        String sql = "SELECT DISTINCT p.* FROM Projects p " +
                     "LEFT JOIN ProjectMembers pm ON p.ProjectId = pm.ProjectId " +
                     "WHERE p.CreatedBy = ? OR pm.UserId = ? " +
                     "ORDER BY p.CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("ProjectId"));
                project.setName(rs.getString("Name"));
                project.setDescription(rs.getString("Description"));
                project.setCreatedBy(rs.getInt("CreatedBy"));
                project.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                projects.add(project);
            }
            
            System.out.println("Found " + projects.size() + " projects for user " + userId);
            
        } catch (SQLException e) {
            System.err.println("Error getting projects by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return projects;
    }
}

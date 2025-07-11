package dao;

import model.ProjectOverview;
import context.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectOverviewDao {
    
    
    
    
    
    
    
    public String getUserRole(int userId) throws SQLException {
    String sql = "SELECT Role FROM Users WHERE UserId = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("Role");
            }
        }
    }
    return null;
}

    
    
    
    
    
    public List<String> getUserRolesInProjects(int userId) throws SQLException {
    List<String> roles = new ArrayList<>();
    String sql = "SELECT Role FROM ProjectMembers WHERE UserId = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(rs.getString("Role"));
            }
        }
    }
    return roles;
}

    
    
    
    public List<ProjectOverview> getProjectsByUserAndRole(int userId, String roleInProject) throws SQLException {
    List<ProjectOverview> list = new ArrayList<>();

   
    String sql =
        "SELECT " +
        "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
        "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
        "pm.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
        "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
        "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
        "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
        "FROM Projects p " +
        "JOIN Users pu ON p.CreatedBy = pu.UserId " +
        "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
        "JOIN Users u ON u.UserId = pm.UserId " +
        "JOIN Boards b ON b.ProjectId = p.ProjectId " +
        "JOIN Tasks t ON t.BoardId = b.BoardId " +
        "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
        "JOIN Users tu ON tu.UserId = t.CreatedBy " +
        "WHERE p.ProjectId IN (SELECT ProjectId FROM ProjectMembers WHERE UserId = ? AND Role = ?) " +
        "ORDER BY p.ProjectId, u.Username, t.TaskId";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userId);
        ps.setString(2, roleInProject); // "Leader" hoặc "Member"

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
    }

    return list;
}

    
    
    
    
    public List<ProjectOverview> getAllProjectsByUser(int userId) throws SQLException {
    List<ProjectOverview> list = new ArrayList<>();
String sql =
    "SELECT " +
    "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
    "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
    "pm.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
    "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
    "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
    "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus, " +
    "p.IsLocked " +  
    "FROM Projects p " +
    "JOIN Users pu ON p.CreatedBy = pu.UserId " +
    "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
    "JOIN Users u ON u.UserId = pm.UserId " +
    "JOIN Boards b ON b.ProjectId = p.ProjectId " +
    "JOIN Tasks t ON t.BoardId = b.BoardId " +
    "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
    "JOIN Users tu ON tu.UserId = t.CreatedBy " +
    "WHERE p.ProjectId IN (SELECT ProjectId FROM ProjectMembers WHERE UserId = ?) " +
    "ORDER BY p.ProjectId, u.Username, t.TaskId";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
    }

    return list;
}

    
    
    
    
    
    public List<ProjectOverview> getProjectDetailsByUser(int userId, int projectId) throws SQLException {
    List<ProjectOverview> list = new ArrayList<>();
String sql =
    "SELECT " +
    "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
    "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
    "pm.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
    "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
    "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
    "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus, " +
    "p.IsLocked " +  
    "FROM Projects p " +
    "JOIN Users pu ON p.CreatedBy = pu.UserId " +
    "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
    "JOIN Users u ON u.UserId = pm.UserId " +
    "JOIN Boards b ON b.ProjectId = p.ProjectId " +
    "JOIN Tasks t ON t.BoardId = b.BoardId " +
    "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
    "JOIN Users tu ON tu.UserId = t.CreatedBy " +
    "WHERE p.ProjectId = ? AND p.ProjectId IN (SELECT ProjectId FROM ProjectMembers WHERE UserId = ?) " +
    "ORDER BY p.ProjectId, u.Username, t.TaskId";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, projectId);
        ps.setInt(2, userId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
    }

    return list;
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public List<ProjectOverview> getAllProjectsBasicForAdmin() throws SQLException {
    List<ProjectOverview> list = new ArrayList<>();

String sql =
    "SELECT " +
    "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
    "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
    "p.IsLocked, " + // ✅ Thêm dòng này
    "pm.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
    "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
    "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
    "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
    "FROM Projects p " +
    "JOIN Users pu ON p.CreatedBy = pu.UserId " +
    "LEFT JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
    "LEFT JOIN Users u ON u.UserId = pm.UserId " +
    "LEFT JOIN Boards b ON b.ProjectId = p.ProjectId " +
    "LEFT JOIN Tasks t ON t.BoardId = b.BoardId " +
    "LEFT JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
    "LEFT JOIN Users tu ON tu.UserId = t.CreatedBy " +
    "ORDER BY p.ProjectId, u.Username, t.TaskId";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            list.add(mapRow(rs));
        }
    }

    return list;
}

    
    // Khóa hoặc mở khóa một dự án
public void setProjectLockStatus(int projectId, boolean isLocked) {
    String sql = "UPDATE Projects SET IsLocked = ? WHERE ProjectId = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setBoolean(1, isLocked);
        stmt.setInt(2, projectId);

        int result = stmt.executeUpdate();
        System.out.println((isLocked ? "Locked" : "Unlocked") + " project with ID: " + projectId + ". Rows affected: " + result);

    } catch (SQLException e) {
        System.err.println("Error updating lock status for project: " + e.getMessage());
        e.printStackTrace();
    }
}

    
    
    
     private ProjectOverview mapRow(ResultSet rs) throws SQLException {
        return new ProjectOverview(
            rs.getInt("ProjectId"),
            rs.getString("ProjectName"),
            rs.getString("ProjectDescription"),
            rs.getString("ProjectCreatedBy"),
            rs.getString("ProjectCreatedAt"),
            rs.getInt("UserId"),
            rs.getString("UserName"),
            rs.getString("UserRole"),
            rs.getInt("TaskId"),
            rs.getString("TaskTitle"),
            rs.getString("TaskDescription"),
            rs.getString("DueDate"),
            rs.getString("TaskCreatedAt"),
            rs.getString("TaskCreatedBy"),
            rs.getString("TaskStatus"),
                rs.getBoolean("IsLocked")

                
        );
    }
     
     
     
     
    
    }
  
    

   
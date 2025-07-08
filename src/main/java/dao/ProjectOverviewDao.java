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
        "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
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
        "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
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
            rs.getString("TaskStatus")
        );
    }
    
    
    
    
    

//    public List<ProjectOverview> getProjectsByLeaderId(int userId) throws SQLException {
//        List<ProjectOverview> list = new ArrayList<>();
//
//        String sql =
//            "SELECT " +
//            "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
//            "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
//            "u.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
//            "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
//            "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
//            "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
//            "FROM Projects p " +
//            "JOIN Users pu ON p.CreatedBy = pu.UserId " +
//            "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
//            "JOIN Users u ON u.UserId = pm.UserId " +
//            "JOIN Boards b ON b.ProjectId = p.ProjectId " +
//            "JOIN Tasks t ON t.BoardId = b.BoardId " +
//            "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
//            "JOIN TaskAssignees ta ON ta.TaskId = t.TaskId AND ta.UserId = pm.UserId " +
//            "JOIN Users tu ON tu.UserId = t.CreatedBy " +
//            "WHERE p.ProjectId IN ( " +
//            "    SELECT ProjectId FROM ProjectMembers WHERE UserId = ? " +
//            ") AND ( " +
//            "    EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Leader') " +
//            " OR EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Premium') " +
//            ") " +
//            "ORDER BY p.ProjectId, u.Username, t.TaskId";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userId); // ProjectMembers
//            ps.setInt(2, userId); // Check Leader
//            ps.setInt(3, userId); // Check Premium
//
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    ProjectOverview po = mapRow(rs);
//                    list.add(po);
//                }
//            }
//        }
//
//        return list;
//    }
//
//    public List<ProjectOverview> getProjectByIdAndLeader(int projectId, int userId) throws SQLException {
//        List<ProjectOverview> result = new ArrayList<>();
//
//        String sql =
//            "SELECT " +
//            "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
//            "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
//            "u.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
//            "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
//            "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
//            "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
//            "FROM Projects p " +
//            "JOIN Users pu ON p.CreatedBy = pu.UserId " +
//            "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
//            "JOIN Users u ON u.UserId = pm.UserId " +
//            "JOIN Boards b ON b.ProjectId = p.ProjectId " +
//            "JOIN Tasks t ON t.BoardId = b.BoardId " +
//            "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
//            "JOIN TaskAssignees ta ON ta.TaskId = t.TaskId AND ta.UserId = pm.UserId " +
//            "JOIN Users tu ON tu.UserId = t.CreatedBy " +
//            "WHERE p.ProjectId = ? " +
//            "AND p.ProjectId IN ( " +
//            "    SELECT ProjectId FROM ProjectMembers WHERE UserId = ? " +
//            ") AND ( " +
//            "    EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Leader') " +
//            " OR EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Premium') " +
//            ") " +
//            "ORDER BY u.Username, t.TaskId";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, projectId); // Where p.ProjectId = ?
//            stmt.setInt(2, userId);    // ProjectMembers
//            stmt.setInt(3, userId);    // Check Leader
//            stmt.setInt(4, userId);    // Check Premium
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    ProjectOverview po = mapRow(rs);
//                    result.add(po);
//                }
//            }
//        }
//
//        return result;
//    }

   
}







































//package dao;
//
//import model.ProjectOverview;
//import context.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class ProjectOverviewDao {
//
//    public List<ProjectOverview> getProjectsByLeaderId(int leaderUserId) throws SQLException {
//        List<ProjectOverview> list = new ArrayList<>();
//
//        String sql =
//    "SELECT " +
//    "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
//    "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
//    "u.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
//    "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
//    "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
//    "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
//    "FROM Projects p " +
//    "JOIN Users pu ON p.CreatedBy = pu.UserId " +
//    "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
//    "JOIN Users u ON u.UserId = pm.UserId " +
//    "JOIN Boards b ON b.ProjectId = p.ProjectId " +
//    "JOIN Tasks t ON t.BoardId = b.BoardId " +
//    "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
//    "JOIN TaskAssignees ta ON ta.TaskId = t.TaskId AND ta.UserId = pm.UserId " +
//    "JOIN Users tu ON tu.UserId = t.CreatedBy " +
//    // CHỈ LẤY PROJECT MÀ USER LÀ LEADER
//    "WHERE p.ProjectId IN ( " +
//        "    SELECT ProjectId FROM ProjectMembers WHERE UserId = ? " +
//        ") AND ( " +
//        "    EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Leader') " +
//        " OR EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Premium') " +
//        ") " +
//    "ORDER BY p.ProjectId, u.Username, t.TaskId";
//
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, leaderUserId);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    ProjectOverview po = new ProjectOverview(
//                        rs.getInt("ProjectId"),
//                        rs.getString("ProjectName"),
//                        rs.getString("ProjectDescription"),
//                        rs.getString("ProjectCreatedBy"),
//                        rs.getString("ProjectCreatedAt"),
//                        rs.getInt("UserId"),
//                        rs.getString("UserName"),
//                        rs.getString("UserRole"),
//                        rs.getInt("TaskId"),
//                        rs.getString("TaskTitle"),
//                        rs.getString("TaskDescription"),
//                        rs.getString("DueDate"),
//                        rs.getString("TaskCreatedAt"),
//                        rs.getString("TaskCreatedBy"),
//                        rs.getString("TaskStatus")
//                    );
//                    list.add(po);
//                }
//            }
//        }
//
//        return list;
//    }
//    
//    
//    
//    
//    
//    
//   public List<ProjectOverview> getProjectByIdAndLeader(int projectId, int leaderId) throws SQLException {
//    List<ProjectOverview> result = new ArrayList<>();
//    String sql =
//        "SELECT " +
//        "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
//        "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
//        "u.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
//        "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
//        "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
//        "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
//        "FROM Projects p " +
//        "JOIN Users pu ON p.CreatedBy = pu.UserId " +
//        "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
//        "JOIN Users u ON u.UserId = pm.UserId " +
//        "JOIN Boards b ON b.ProjectId = p.ProjectId " +
//        "JOIN Tasks t ON t.BoardId = b.BoardId " +
//        "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
//        "JOIN TaskAssignees ta ON ta.TaskId = t.TaskId AND ta.UserId = pm.UserId " +
//        "JOIN Users tu ON tu.UserId = t.CreatedBy " +
//        "WHERE p.ProjectId IN ( " +
//        "    SELECT ProjectId FROM ProjectMembers WHERE UserId = ? " +
//        ") AND ( " +
//        "    EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Leader') " +
//        " OR EXISTS (SELECT 1 FROM Users WHERE UserId = ? AND Role = 'Premium') " +
//        ") " +
//        "ORDER BY u.Username, t.TaskId";
//
//    try (Connection conn = DBConnection.getConnection();
//         PreparedStatement stmt = conn.prepareStatement(sql)) {
//        stmt.setInt(1, projectId);
//        stmt.setInt(2, leaderId);
//        try (ResultSet rs = stmt.executeQuery()) {
//            while (rs.next()) {
//                ProjectOverview po = mapRow(rs);
//                result.add(po);
//            }
//        }
//    }
//    return result;
//}
//
//private ProjectOverview mapRow(ResultSet rs) throws SQLException {
//    return new ProjectOverview(
//        rs.getInt("ProjectId"),
//        rs.getString("ProjectName"),
//        rs.getString("ProjectDescription"),
//        rs.getString("ProjectCreatedBy"),
//        rs.getString("ProjectCreatedAt"),
//        rs.getInt("UserId"),
//        rs.getString("UserName"),
//        rs.getString("UserRole"),
//        rs.getInt("TaskId"),
//        rs.getString("TaskTitle"),
//        rs.getString("TaskDescription"),
//        rs.getString("DueDate"),
//        rs.getString("TaskCreatedAt"),
//        rs.getString("TaskCreatedBy"),
//        rs.getString("TaskStatus")
//    );
//}
//
//
//    
//    
//    
//    
//    
//    
//    
//}

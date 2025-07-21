package dao.admin;

import context.DBConnection;
import java.sql.*;
import java.util.*;

public class UserStatsDAO {

    public UserStatsDAO() {
    }

    public List<Map<String, Object>> getWeeklyUserRegistrations(int numberOfWeeks) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();

        String sql =
            "SELECT " +
            "    FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, CreatedAt) + 1, CreatedAt), 'yyyy-MM-dd') AS WeekStart, " +
            "    Role, " +
            "    COUNT(*) AS Count " +
            "FROM Users " +
            "WHERE CreatedAt >= DATEADD(WEEK, -?, GETDATE()) " +
            "  AND Role IN ('User', 'Premium') " +
            "GROUP BY " +
            "    FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, CreatedAt) + 1, CreatedAt), 'yyyy-MM-dd'), " +
            "    Role " +
            "ORDER BY WeekStart DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, numberOfWeeks);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("week", rs.getString("WeekStart"));
                row.put("role", rs.getString("Role"));
                row.put("count", rs.getInt("Count"));
                result.add(row);
            }
        }

        return result;
    }
    
    
    
    
    
    
    
   public List<Map<String, Object>> getWeeklyProjectsCreated(int numberOfWeeks) throws SQLException {
    List<Map<String, Object>> result = new ArrayList<>();

    String sql =
        "SELECT " +
        "  DATEADD(DAY, -DATEPART(WEEKDAY, CreatedAt) + 1, CAST(CreatedAt AS DATE)) AS WeekStart, " +
        "  COUNT(*) AS ProjectCount " +
        "FROM Projects " +
        "WHERE CreatedAt >= DATEADD(WEEK, -?, GETDATE()) " +
        "GROUP BY DATEADD(DAY, -DATEPART(WEEKDAY, CreatedAt) + 1, CAST(CreatedAt AS DATE)) " +
        "ORDER BY WeekStart ASC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, numberOfWeeks);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("week", rs.getDate("WeekStart"));
            row.put("count", rs.getInt("ProjectCount"));
            result.add(row);
        }
    }

    return result;
}
 
    
    
    public Map<String, Integer> getUserStatusDistribution() throws SQLException {
    Map<String, Integer> result = new HashMap<>();
String sql =
    "SELECT " +
    "    Role, IsActive, COUNT(*) AS Count " +
    "FROM Users " +
    "WHERE Role IN ('User', 'Premium') " +
    "GROUP BY Role, IsActive";


    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            String role = rs.getString("Role");
            boolean isActive = rs.getBoolean("IsActive");
            String key = role + (isActive ? "_Active" : "_Blocked");
            result.put(key, rs.getInt("Count"));
        }
    }

    return result;
}

    
    
    
    
    // Trong lớp ProjectStatsDAO hoặc DAO bạn đang dùng
public Map<String, Integer> getProjectLockStatusDistribution() throws SQLException {
    Map<String, Integer> result = new HashMap<>();
    String sql = "SELECT IsLocked, COUNT(*) AS Total FROM Projects GROUP BY IsLocked";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            boolean isLocked = rs.getBoolean("IsLocked");
            int total = rs.getInt("Total");
            result.put(isLocked ? "Locked" : "Unlocked", total);
        }
    }

    return result;
}










//lấy thông tin user
public Map<String, Integer> getUserSummaryStats() throws SQLException {
    Map<String, Integer> result = new HashMap<>();

    String sql = "SELECT " +
                 "COUNT(*) AS TotalUsers, " +
                 "SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END) AS BlockedUsers, " +
                 "SUM(CASE WHEN Role = 'Premium' THEN 1 ELSE 0 END) AS PremiumUsers " +
                 "FROM Users";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        if (rs.next()) {
            result.put("TotalUsers", rs.getInt("TotalUsers"));
            result.put("BlockedUsers", rs.getInt("BlockedUsers"));
            result.put("PremiumUsers", rs.getInt("PremiumUsers"));
        }
    }

    return result;
}






public Map<String, Integer> getProjectSummaryStats() throws SQLException {
    Map<String, Integer> result = new HashMap<>();

    String sql = "SELECT " +
                 "COUNT(*) AS TotalProjects, " +
                 "SUM(CASE WHEN IsLocked = 1 THEN 1 ELSE 0 END) AS LockedProjects " +
                 "FROM Projects";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        if (rs.next()) {
            result.put("TotalProjects", rs.getInt("TotalProjects"));
            result.put("LockedProjects", rs.getInt("LockedProjects"));
        }
    }

    return result;
}

    
    
    
    
}

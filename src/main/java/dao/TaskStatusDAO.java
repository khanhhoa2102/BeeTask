package dao;

import context.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class TaskStatusDAO {
    
    // Get all statuses as a map (StatusId -> StatusName)
    public Map<Integer, String> getAllStatuses() {
        Map<Integer, String> statusMap = new HashMap<>();
        String sql = "SELECT StatusId, Name FROM TaskStatuses";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                statusMap.put(rs.getInt("StatusId"), rs.getString("Name"));
            }
            
            System.out.println("Loaded " + statusMap.size() + " task statuses");
            
        } catch (SQLException e) {
            System.err.println("Error loading task statuses: " + e.getMessage());
            e.printStackTrace();
        }
        
        return statusMap;
    }
    
    // Get status name by ID
    public String getStatusName(int statusId) {
        String sql = "SELECT Name FROM TaskStatuses WHERE StatusId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, statusId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("Name");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting status name: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "Unknown";
    }
    
    // Get status ID by name
    public int getStatusId(String statusName) {
        String sql = "SELECT StatusId FROM TaskStatuses WHERE Name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, statusName);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("StatusId");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting status ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 1; // Default to "To Do" status
    }
}

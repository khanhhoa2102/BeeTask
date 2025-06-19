package dao;

import model.User;
import java.sql.*;
import java.util.*;
import context.DBConnection;


public class UserManagementDao {

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<User> getLockedUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE IsActive = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE Users SET IsActive = ? WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("UserId"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("PasswordHash"),
                rs.getString("AvatarUrl"),
                rs.getBoolean("IsActive"),
                rs.getTimestamp("CreatedAt")
        );
    }
    
    
    
    public List<User> searchUsers(String keyword) {
    List<User> list = new ArrayList<>();
    String sql = "SELECT * FROM Users WHERE UserId LIKE ? OR FullName LIKE ? OR Email LIKE ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        String searchPattern = "%" + keyword + "%";
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        ps.setString(3, searchPattern);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    
    
    
    public int countAllUsers() {
    int count = 0;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM Users")) {
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return count;
}

public int countLockedUsers() {
    int count = 0;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE status = 0")) {
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return count;
}


    
}

package dao;

import context.DBConnection;
import java.sql.*;
import java.util.*;
import model.User;

public class TaskAssigneeDAO {

    public List<Integer> findUserIdsByTask(int taskId) {
        List<Integer> userIds = new ArrayList<>();
        String sql = "SELECT UserId FROM TaskAssignees WHERE TaskId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                userIds.add(rs.getInt("UserId"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userIds;
    }

    public void insert(int taskId, int userId) throws Exception {
        String sql = "INSERT INTO TaskAssignees (TaskId, UserId) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public void delete(int taskId, int userId) {
        String sql = "DELETE FROM TaskAssignees WHERE taskId = ? AND userId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<User> findUsersByTask(int taskId) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* FROM TaskAssignees ta JOIN Users u ON ta.userId = u.userId WHERE ta.taskId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("userId"));
                    user.setUsername(rs.getString("username"));
                    // add any other fields if needed
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // ✅ Đổi tên hàm này để đúng với chỗ gọi từ TaskController
    public void deleteAssigneesByTaskId(int taskId) throws Exception {
        String sql = "DELETE FROM TaskAssignees WHERE TaskId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
        }
    }
    public void updateTaskAssignees(int taskId, List<Integer> userIds) {
        String deleteSQL = "DELETE FROM TaskAssignees WHERE TaskId = ?";
        String insertSQL = "INSERT INTO TaskAssignees (TaskId, UserId) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement delStmt = conn.prepareStatement(deleteSQL)) {
                delStmt.setInt(1, taskId);
                delStmt.executeUpdate();
            }

            try (PreparedStatement insStmt = conn.prepareStatement(insertSQL)) {
                for (Integer userId : userIds) {
                    insStmt.setInt(1, taskId);
                    insStmt.setInt(2, userId);
                    insStmt.addBatch();
                }
                insStmt.executeBatch();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
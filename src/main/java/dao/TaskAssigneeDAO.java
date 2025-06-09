package dao;

import context.DBConnection;
import java.sql.*;
import java.util.*;

public class TaskAssigneeDAO {
    public List<Integer> findUserIdsByTask(int taskId) throws Exception {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT UserId FROM TaskAssignees WHERE TaskId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("UserId"));
                }
            }
        }
        return list;
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

    public void delete(int taskId, int userId) throws Exception {
        String sql = "DELETE FROM TaskAssignees WHERE TaskId=? AND UserId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }
}
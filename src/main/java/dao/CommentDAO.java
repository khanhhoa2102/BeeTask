package dao;

import context.DBConnection;
import model.TaskComment;
import java.sql.*;
import java.util.*;

public class CommentDAO {
    public List<TaskComment> findByTaskId(int taskId) throws Exception {
        List<TaskComment> list = new ArrayList<>();
        String sql = "SELECT * FROM TaskComments WHERE TaskId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    TaskComment c = new TaskComment(
                        rs.getInt("CommentId"),
                        rs.getInt("TaskId"),
                        rs.getInt("UserId"),
                        rs.getString("Content"),
                        rs.getTimestamp("CreatedAt")
                    );
                    list.add(c);
                }
            }
        }
        return list;
    }

    public void insert(TaskComment c) throws Exception {
        String sql = "INSERT INTO TaskComments (TaskId, UserId, Content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, c.getTaskId());
            stmt.setInt(2, c.getUserId());
            stmt.setString(3, c.getContent());
            stmt.executeUpdate();
        }
    }
}
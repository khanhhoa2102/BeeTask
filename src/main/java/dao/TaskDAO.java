package dao;

import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Task;

public class TaskDAO {

    public List<Task> findAll() throws Exception {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Tasks";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Task task = new Task(
                        rs.getInt("TaskId"),
                        rs.getInt("BoardId"),
                        rs.getInt("ListId"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getInt("StatusId"),
                        toUtilDate(rs.getTimestamp("DueDate")),
                        toUtilDate(rs.getTimestamp("CreatedAt")),
                        rs.getInt("CreatedBy")
                );
                list.add(task);
            }
        }
        return list;
    }

    public Task findById(int id) throws Exception {
        String sql = "SELECT * FROM Tasks WHERE TaskId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Task(
                            rs.getInt("TaskId"),
                            rs.getInt("BoardId"),
                            rs.getInt("ListId"),
                            rs.getString("Title"),
                            rs.getString("Description"),
                            rs.getInt("StatusId"),
                            toUtilDate(rs.getTimestamp("DueDate")),
                            toUtilDate(rs.getTimestamp("CreatedAt")),
                            rs.getInt("CreatedBy")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Task t) throws Exception {
        String sql = "INSERT INTO Tasks (BoardId, ListId, Title, Description, StatusId, DueDate, CreatedBy) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, t.getBoardId());
            stmt.setInt(2, t.getListId());
            stmt.setString(3, t.getTitle());
            stmt.setString(4, t.getDescription());
            stmt.setInt(5, t.getStatusId());
            stmt.setTimestamp(6, toSqlTimestamp(t.getDueDate()));
            stmt.setInt(7, t.getCreatedBy());
            stmt.executeUpdate();
        }
    }

    public void update(Task t) throws Exception {
        String sql = "UPDATE Tasks SET Title=?, Description=?, StatusId=?, DueDate=? WHERE TaskId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, t.getTitle());
            stmt.setString(2, t.getDescription());
            stmt.setInt(3, t.getStatusId());
            stmt.setTimestamp(4, toSqlTimestamp(t.getDueDate()));
            stmt.setInt(5, t.getTaskId());
            stmt.executeUpdate();
        }
    }

    public void delete(int taskId) throws Exception {
        String sql = "DELETE FROM Tasks WHERE TaskId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
        }
    }

    public List<Task> getTasksByUserId(int userId) throws Exception {
        List<Task> list = new ArrayList<>();
        String sql
                = "SELECT t.* "
                + "FROM Tasks t "
                + "INNER JOIN TaskAssignees ta ON t.TaskId = ta.TaskId "
                + "WHERE ta.UserId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task(
                            rs.getInt("TaskId"),
                            rs.getInt("BoardId"),
                            rs.getInt("ListId"),
                            rs.getString("Title"),
                            rs.getString("Description"),
                            rs.getInt("StatusId"),
                            toUtilDate(rs.getTimestamp("DueDate")),
                            toUtilDate(rs.getTimestamp("CreatedAt")),
                            rs.getInt("CreatedBy")
                    );
                    list.add(task);
                }
            }
        }
        return list;
    }

    private java.util.Date toUtilDate(Timestamp timestamp) {
        return timestamp != null ? new java.util.Date(timestamp.getTime()) : null;
    }

    private Timestamp toSqlTimestamp(java.util.Date date) {
        return date != null ? new Timestamp(date.getTime()) : null;
    }
}

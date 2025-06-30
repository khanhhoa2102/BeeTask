package dao;

import context.DBConnection;
import model.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TaskDAO {
    private Connection connection;

    public TaskDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Insert new task
    public void insert(Task task) {
        String sql = "INSERT INTO Tasks (BoardId, Title, Description, StatusId, DueDate, CreatedAt, Position, Priority) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE(), ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, task.getBoardId());
            stmt.setString(2, task.getTitle());
            stmt.setString(3, task.getDescription());
            stmt.setString(4, task.getStatus());
            stmt.setDate(5, task.getDueDate());
            stmt.setInt(6, task.getPosition());
            stmt.setString(7, task.getPriority());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete task
    public void delete(int taskId) {
        String sql = "DELETE FROM Tasks WHERE TaskId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Move task to another board and reorder
    public void moveTaskToBoard(int taskId, int newBoardId, int newIndex) {
        String updateSql = "UPDATE Tasks SET BoardId = ?, Position = ? WHERE TaskId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(updateSql)) {
            stmt.setInt(1, newBoardId);
            stmt.setInt(2, newIndex);
            stmt.setInt(3, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get tasks grouped by BoardId
    public Map<Integer, List<Task>> getTasksByProjectIdGrouped(int projectId) {
        Map<Integer, List<Task>> tasksMap = new HashMap<>();
        String sql = "SELECT T.* FROM Tasks T JOIN Boards B ON T.BoardId = B.BoardId WHERE B.ProjectId = ? ORDER BY B.Position, T.Position";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Task task = mapResultSetToTask(rs);
                int boardId = task.getBoardId();
                tasksMap.computeIfAbsent(boardId, k -> new ArrayList<>()).add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasksMap;
    }

    // Helper
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("TaskId"));
        task.setBoardId(rs.getInt("BoardId"));
        task.setTitle(rs.getString("Title"));
        task.setDescription(rs.getString("Description"));
        task.setStatus(rs.getString("StatusId"));
        task.setDueDate(rs.getDate("DueDate"));
        task.setCreatedAt(rs.getTimestamp("CreatedAt"));
        task.setPosition(rs.getInt("Position"));
        task.setPriority(rs.getString("Priority"));
        return task;
    }
}
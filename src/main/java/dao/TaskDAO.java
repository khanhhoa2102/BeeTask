package dao;

import context.DBConnection;
import model.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
        String sql = "INSERT INTO Tasks (BoardId, ListId, Title, Description, StatusId, DueDate, CreatedAt, CreatedBy, Position, Priority) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, task.getBoardId());
            stmt.setInt(2, task.getListId());
            stmt.setString(3, task.getTitle());
            stmt.setString(4, task.getDescription());
            stmt.setString(5, task.getStatus()); // statusId is now a String status
            stmt.setDate(6, task.getDueDate());
            stmt.setString(7, task.getCreatedBy());
            stmt.setInt(8, task.getPosition());
            stmt.setString(9, task.getPriority());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update task
    public void update(Task task) {
        String sql = "UPDATE Tasks SET Title = ?, Description = ?, StatusId = ?, DueDate = ?, Priority = ? WHERE TaskId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getStatus());
            stmt.setDate(4, task.getDueDate());
            stmt.setString(5, task.getPriority());
            stmt.setInt(6, task.getTaskId());
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

    // Move task to another board and update position
    public void moveTask(int taskId, int newBoardId, int newPosition) {
        String sql = "UPDATE Tasks SET BoardId = ?, Position = ? WHERE TaskId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, newBoardId);
            stmt.setInt(2, newPosition);
            stmt.setInt(3, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update task position (within same board)
    public void updateTaskPosition(int taskId, int position) {
        String sql = "UPDATE Tasks SET Position = ? WHERE TaskId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, position);
            stmt.setInt(2, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get tasks by board ID
    public List<Task> getTasksByBoardId(int boardId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Tasks WHERE BoardId = ? ORDER BY Position ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, boardId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get tasks by project ID (used for overview)
    public List<Task> getTasksByProjectId(int projectId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT T.* FROM Tasks T JOIN Boards B ON T.BoardId = B.BoardId WHERE B.ProjectId = ? ORDER BY B.Position, T.Position";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Helper to map ResultSet to Task
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("TaskId"));
        task.setBoardId(rs.getInt("BoardId"));
        task.setListId(rs.getInt("ListId"));
        task.setTitle(rs.getString("Title"));
        task.setDescription(rs.getString("Description"));
        task.setStatus(rs.getString("StatusId"));
        task.setDueDate(rs.getDate("DueDate"));
        task.setCreatedAt(rs.getTimestamp("CreatedAt"));
        task.setCreatedBy(rs.getString("CreatedBy"));
        task.setPosition(rs.getInt("Position"));
        task.setPriority(rs.getString("Priority"));
        return task;
    }

    // Move task to new board + position (for drag & drop)
    public void moveTaskToBoard(int taskId, int newBoardId, int newIndex) throws SQLException {
        String updateBoardSQL = "UPDATE Tasks SET BoardId = ?, Position = 9999 WHERE TaskId = ?";
        String shiftTasksSQL = "UPDATE Tasks SET Position = Position + 1 WHERE BoardId = ? AND Position >= ?";
        String updatePositionSQL = "UPDATE Tasks SET Position = ? WHERE TaskId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(updateBoardSQL);
                 PreparedStatement ps2 = conn.prepareStatement(shiftTasksSQL);
                 PreparedStatement ps3 = conn.prepareStatement(updatePositionSQL)) {

                ps1.setInt(1, newBoardId);
                ps1.setInt(2, taskId);
                ps1.executeUpdate();

                ps2.setInt(1, newBoardId);
                ps2.setInt(2, newIndex);
                ps2.executeUpdate();

                ps3.setInt(1, newIndex);
                ps3.setInt(2, taskId);
                ps3.executeUpdate();

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        }
    }
}
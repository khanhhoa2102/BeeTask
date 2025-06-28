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
        String sql = "INSERT INTO Tasks (boardId, listId, title, description, statusId, dueDate, createdAt, createdBy, position, priority) " +
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
        String sql = "UPDATE Tasks SET title = ?, description = ?, statusId = ?, dueDate = ?, priority = ? WHERE taskId = ?";
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
        String sql = "DELETE FROM Tasks WHERE taskId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Move task to another board and update position
    public void moveTask(int taskId, int newBoardId, int newPosition) {
        String sql = "UPDATE Tasks SET boardId = ?, position = ? WHERE taskId = ?";
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
        String sql = "UPDATE Tasks SET position = ? WHERE taskId = ?";
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
        String sql = "SELECT * FROM Tasks WHERE boardId = ? ORDER BY position ASC";
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
        String sql = "SELECT t.* FROM Tasks t JOIN Boards b ON t.boardId = b.boardId WHERE b.projectId = ? ORDER BY b.position, t.position";
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
        task.setTaskId(rs.getInt("taskId"));
        task.setBoardId(rs.getInt("boardId"));
        task.setListId(rs.getInt("listId"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setStatus(rs.getString("statusId"));
        task.setDueDate(rs.getDate("dueDate"));
        task.setCreatedAt(rs.getTimestamp("createdAt"));
        task.setCreatedBy(rs.getString("createdBy"));
        task.setPosition(rs.getInt("position"));
        task.setPriority(rs.getString("priority"));
        return task;
    }
    // ✅ Move task to new board + position (for drag & drop)
    public void moveTaskToBoard(int taskId, int newBoardId, int newIndex) throws SQLException {
        String updateBoardSQL = "UPDATE Tasks SET BoardId = ?, Position = 9999 WHERE TaskId = ?";
        String shiftTasksSQL = "UPDATE Tasks SET Position = Position + 1 WHERE BoardId = ? AND Position >= ?";
        String updatePositionSQL = "UPDATE Tasks SET Position = ? WHERE TaskId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(updateBoardSQL);
                 PreparedStatement ps2 = conn.prepareStatement(shiftTasksSQL);
                 PreparedStatement ps3 = conn.prepareStatement(updatePositionSQL)) {

                // Step 1: Move task to new board with temporary position
                ps1.setInt(1, newBoardId);
                ps1.setInt(2, taskId);
                ps1.executeUpdate();

                // Step 2: Shift other tasks down to make space
                ps2.setInt(1, newBoardId);
                ps2.setInt(2, newIndex);
                ps2.executeUpdate();

                // Step 3: Set correct final position
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

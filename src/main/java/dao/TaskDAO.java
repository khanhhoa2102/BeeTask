package dao;

import context.DBConnection;
import model.Task;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TaskDAO {
    private TaskStatusDAO statusDAO = new TaskStatusDAO();
    
    // Insert new task
    public void insert(Task task) {
        String sql = "INSERT INTO Tasks (BoardId, ListId, Title, Description, StatusId, Priority, DueDate, Position, CreatedBy, CreatedAt) " +
                     "VALUES (?, 1, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, task.getBoardId());
            // ListId = 1 (default, we ignore this)
            stmt.setString(2, task.getTitle());
            stmt.setString(3, task.getDescription() != null ? task.getDescription() : "");
            stmt.setInt(4, task.getStatusId());
            stmt.setString(5, task.getPriority() != null ? task.getPriority() : "Medium");
            stmt.setDate(6, task.getDueDate());
            stmt.setInt(7, getNextPositionForBoard(task.getBoardId()));
            stmt.setInt(8, task.getCreatedBy());
            
            int result = stmt.executeUpdate();
            System.out.println("✅ Task inserted successfully. Rows affected: " + result);
            
        } catch (SQLException e) {
            System.err.println("❌ Error inserting task: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Update task
    public void update(Task task) {
        String sql = "UPDATE Tasks SET Title = ?, Description = ?, StatusId = ?, Priority = ?, DueDate = ? WHERE TaskId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setInt(3, task.getStatusId());
            stmt.setString(4, task.getPriority());
            stmt.setDate(5, task.getDueDate());
            stmt.setInt(6, task.getTaskId());
            
            int result = stmt.executeUpdate();
            System.out.println("✅ Task updated successfully. Rows affected: " + result);
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating task: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Get task by ID for editing
    public Task getTaskById(int taskId) {
        String sql = "SELECT t.*, ts.Name as StatusName FROM Tasks t " +
                     "INNER JOIN TaskStatuses ts ON t.StatusId = ts.StatusId " +
                     "WHERE t.TaskId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, taskId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Task task = mapResultSetToTask(rs);
                task.setStatusName(rs.getString("StatusName"));
                System.out.println("✅ Found task: " + task.getTitle());
                return task;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting task by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }


    // Delete task
    public void delete(int taskId) {
        String sql = "DELETE FROM Tasks WHERE TaskId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, taskId);
            int result = stmt.executeUpdate();
            System.out.println("✅ Task deleted successfully. Rows affected: " + result);
            
        } catch (SQLException e) {
            System.err.println("❌ Error deleting task: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Get next position for a board
    public int getNextPositionForBoard(int boardId) {
        String sql = "SELECT COALESCE(MAX(Position), -1) + 1 FROM Tasks WHERE BoardId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, boardId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting next position: " + e.getMessage());
        }
        return 0;
    }

    // Get tasks by board ID
    public List<Task> getTasksByBoardId(int boardId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM Tasks WHERE BoardId = ? ORDER BY Position ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, boardId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tasks.add(mapResultSetToTask(rs));
            }
            
            System.out.println("Found " + tasks.size() + " tasks for board " + boardId);
            
        } catch (SQLException e) {
            System.err.println("Error getting tasks by board ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tasks;
    }

    // Get tasks grouped by project ID - MAIN METHOD FOR JSP
    public Map<Integer, List<Task>> getTasksByProjectIdGrouped(int projectId) {
        System.out.println("🔍 Loading tasks for project: " + projectId);
        
        Map<Integer, List<Task>> taskMap = new HashMap<>();
        String sql = "SELECT t.*, b.Name as BoardName, ts.Name as StatusName FROM Tasks t " +
                     "INNER JOIN Boards b ON t.BoardId = b.BoardId " +
                     "INNER JOIN TaskStatuses ts ON t.StatusId = ts.StatusId " +
                     "WHERE b.ProjectId = ? " +
                     "ORDER BY b.Position ASC, t.Position ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Task task = mapResultSetToTask(rs);
                // Set the status name from the join
                task.setStatusName(rs.getString("StatusName"));
                int boardId = task.getBoardId();
                
                // Initialize list if not exists
                if (!taskMap.containsKey(boardId)) {
                    taskMap.put(boardId, new ArrayList<>());
                }
                
                taskMap.get(boardId).add(task);
                System.out.println("📝 Found task: " + task.getTitle() + " in board " + boardId + " with status: " + task.getStatusName());
            }
            
            System.out.println("✅ Found tasks for " + taskMap.size() + " boards in project " + projectId);
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting tasks by project ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return taskMap;

    }

    // Helper method to map ResultSet to Task object
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        
        task.setTaskId(rs.getInt("TaskId"));
        task.setBoardId(rs.getInt("BoardId"));
        // We ignore ListId completely
        task.setTitle(rs.getString("Title") != null ? rs.getString("Title") : "");
        task.setDescription(rs.getString("Description") != null ? rs.getString("Description") : "");
        task.setStatusId(rs.getInt("StatusId"));
        task.setDueDate(rs.getDate("DueDate"));
        task.setCreatedAt(rs.getTimestamp("CreatedAt"));
        task.setPosition(rs.getInt("Position"));
        task.setPriority(rs.getString("Priority") != null ? rs.getString("Priority") : "Medium");
        
        // Handle CreatedBy safely
        int createdBy = rs.getInt("CreatedBy");
        if (!rs.wasNull()) {
            task.setCreatedBy(createdBy);
        } else {
            task.setCreatedBy(1); // Default user ID
        }
        
        return task;
    }

    // Move task to new board + position (for drag & drop)
    public void moveTaskToBoard(int taskId, int newBoardId, int newIndex) throws SQLException {
        String sql = "UPDATE Tasks SET BoardId = ?, Position = ? WHERE TaskId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newBoardId);
            stmt.setInt(2, newIndex);
            stmt.setInt(3, taskId);
            
            int result = stmt.executeUpdate();
            System.out.println("✅ Task " + taskId + " moved to board " + newBoardId + " at position " + newIndex);
            
        } catch (SQLException e) {
            System.err.println("❌ Error moving task: " + e.getMessage());
            throw e;
        }
    }

    // Get all tasks (for debugging)
    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM Tasks ORDER BY BoardId, Position";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tasks.add(mapResultSetToTask(rs));
            }
            
            System.out.println("📊 Total tasks in database: " + tasks.size());
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting all tasks: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tasks;
    }

    // Debug method
    public void debugTasksForProject(int projectId) {
        System.out.println("=== DEBUG TASKS FOR PROJECT " + projectId + " ===");
        
        // Check if project exists
        String projectSQL = "SELECT COUNT(*) FROM Projects WHERE ProjectId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(projectSQL)) {
            
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("Project exists: " + (rs.getInt(1) > 0));
            }
        } catch (SQLException e) {
            System.err.println("Error checking project: " + e.getMessage());
        }
        
        // Check boards for project
        String boardSQL = "SELECT BoardId, Name FROM Boards WHERE ProjectId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(boardSQL)) {
            
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            System.out.println("Boards for project " + projectId + ":");
            while (rs.next()) {
                System.out.println("  - Board " + rs.getInt("BoardId") + ": " + rs.getString("Name"));
            }
        } catch (SQLException e) {
            System.err.println("Error checking boards: " + e.getMessage());
        }
        
        // Check tasks
        String taskSQL = "SELECT t.TaskId, t.Title, t.BoardId, b.Name as BoardName, ts.Name as StatusName " +
                         "FROM Tasks t " +
                         "INNER JOIN Boards b ON t.BoardId = b.BoardId " +
                         "INNER JOIN TaskStatuses ts ON t.StatusId = ts.StatusId " +
                         "WHERE b.ProjectId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(taskSQL)) {
            
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            System.out.println("Tasks for project " + projectId + ":");
            while (rs.next()) {
                System.out.println("  - Task " + rs.getInt("TaskId") + ": " + rs.getString("Title") + 
                                 " (Board: " + rs.getString("BoardName") + ", Status: " + rs.getString("StatusName") + ")");
            }
        } catch (SQLException e) {
            System.err.println("Error checking tasks: " + e.getMessage());
        }
        
        System.out.println("=== END DEBUG ===");
    }
}

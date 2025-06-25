package dao;

import context.DBConnection;
import model.Project;
import model.Board;
import model.Task;

import java.sql.*;
import java.util.*;

public class ProjectDAO {
    private Connection connection;

    public ProjectDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy thông tin một project theo ID
    public Project getProjectById(int projectId) throws SQLException {
        String sql = "SELECT * FROM Project WHERE projectId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Project(
                    rs.getInt("projectId"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("createdBy"),
                    rs.getTimestamp("createdAt")
                );
            }
        }
        return null;
    }

    // Lấy danh sách Board theo projectId
    public List<Board> getBoardsByProjectId(int projectId) throws SQLException {
        List<Board> boards = new ArrayList<>();
        String sql = "SELECT * FROM Board WHERE projectId = ? ORDER BY position ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Board board = new Board(
                    rs.getInt("boardId"),
                    rs.getInt("projectId"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getTimestamp("createdAt")
                );
                board.setPosition(rs.getInt("position"));
                boards.add(board);
            }
        }
        return boards;
    }

    // Lấy danh sách Task theo projectId (dạng Map<boardId, List<Task>>)
    public Map<Integer, List<Task>> getTasksByProjectId(int projectId) throws SQLException {
        Map<Integer, List<Task>> taskMap = new HashMap<>();
        String sql = "SELECT t.* FROM Task t JOIN Board b ON t.boardId = b.boardId WHERE b.projectId = ? ORDER BY t.position ASC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("taskId"));
                task.setBoardId(rs.getInt("boardId"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setStatus(rs.getString("status"));
                task.setPriority(rs.getString("priority"));
                task.setDueDate(rs.getDate("dueDate"));
                task.setCreatedAt(rs.getTimestamp("createdAt"));
                task.setCreatedBy(rs.getString("createdBy"));
                task.setPosition(rs.getInt("position"));

                int boardId = task.getBoardId();
                if (!taskMap.containsKey(boardId)) {
                    taskMap.put(boardId, new ArrayList<>());
                }
                taskMap.get(boardId).add(task);
            }
        }

        return taskMap;
    }
}

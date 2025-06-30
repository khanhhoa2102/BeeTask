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
        String sql = "SELECT * FROM Projects WHERE ProjectId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Project(
                    rs.getInt("ProjectId"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getString("CreatedBy"),
                    rs.getTimestamp("CreatedAt")
                );
            }
        }
        return null;
    }

    // Lấy danh sách Board theo projectId
    public List<Board> getBoardsByProjectId(int projectId) throws SQLException {
        List<Board> boards = new ArrayList<>();
        String sql = "SELECT * FROM Boards WHERE ProjectId = ? ORDER BY Position ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Board board = new Board(
                    rs.getInt("BoardId"),
                    rs.getInt("ProjectId"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getTimestamp("CreatedAt")
                );
                board.setPosition(rs.getInt("Position"));
                boards.add(board);
            }
        }
        return boards;
    }

    // Lấy danh sách Task theo projectId (dạng Map<boardId, List<Task>>)
    public Map<Integer, List<Task>> getTasksByProjectId(int projectId) throws SQLException {
        Map<Integer, List<Task>> taskMap = new HashMap<>();
        String sql = "SELECT t.* FROM Tasks t JOIN Boards b ON t.BoardId = b.BoardId WHERE b.ProjectId = ? ORDER BY t.Position ASC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("TaskId"));
                task.setBoardId(rs.getInt("BoardId"));
                task.setTitle(rs.getString("Title"));
                task.setDescription(rs.getString("Description"));
                task.setStatus(rs.getString("Status"));
                task.setPriority(rs.getString("Priority"));
                task.setDueDate(rs.getDate("DueDate"));
                task.setCreatedAt(rs.getTimestamp("CreatedAt"));
                task.setCreatedBy(rs.getString("CreatedBy"));
                task.setPosition(rs.getInt("Position"));

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
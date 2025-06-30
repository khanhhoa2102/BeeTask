package dao;

import context.DBConnection;
import model.Board;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {
    private Connection connection;

    public BoardDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Insert Board
    public void insert(Board board) {
        String sql = "INSERT INTO Boards (ProjectId, Name, CreatedAt, Position) VALUES (?, ?, GETDATE(), ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, board.getProjectId());
            stmt.setString(2, board.getName());
            stmt.setInt(3, board.getPosition());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update board name
    public void update(Board board) {
        String sql = "UPDATE Boards SET Name = ? WHERE BoardId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, board.getName());
            stmt.setInt(2, board.getBoardId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete board
    public void delete(int boardId) {
        String sql = "DELETE FROM Boards WHERE BoardId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, boardId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Duplicate board (with tasks)
    public void duplicate(int boardId) {
        try {
            connection.setAutoCommit(false);

            // Duplicate Board
            String duplicateBoardSQL = "INSERT INTO Boards (ProjectId, Name, CreatedAt, Position) " +
                                       "SELECT ProjectId, CONCAT(Name, ' (Copy)'), GETDATE(), Position + 1 FROM Boards WHERE BoardId = ?";
            try (PreparedStatement boardStmt = connection.prepareStatement(duplicateBoardSQL, Statement.RETURN_GENERATED_KEYS)) {
                boardStmt.setInt(1, boardId);
                boardStmt.executeUpdate();

                ResultSet rs = boardStmt.getGeneratedKeys();
                if (rs.next()) {
                    int newBoardId = rs.getInt(1);

                    // Duplicate tasks
                    String duplicateTasksSQL = "INSERT INTO Tasks (BoardId, Title, Description, StatusId, DueDate, CreatedAt, Position, Priority) " +
                            "SELECT ?, Title, Description, StatusId, DueDate, GETDATE(), Position, Priority FROM Tasks WHERE BoardId = ?";
                    try (PreparedStatement taskStmt = connection.prepareStatement(duplicateTasksSQL)) {
                        taskStmt.setInt(1, newBoardId);
                        taskStmt.setInt(2, boardId);
                        taskStmt.executeUpdate();
                    }
                }
            }

            connection.commit();
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // Update board position
    public void updateBoardPosition(int boardId, int position) {
        String sql = "UPDATE Boards SET Position = ? WHERE BoardId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, position);
            stmt.setInt(2, boardId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Find Board by ID
    public Board findById(int boardId) {
        String sql = "SELECT * FROM Boards WHERE BoardId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, boardId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBoard(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all boards for project
    public List<Board> getBoardsByProjectId(int projectId) {
        List<Board> boards = new ArrayList<>();
        String sql = "SELECT * FROM Boards WHERE ProjectId = ? ORDER BY Position ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                boards.add(mapResultSetToBoard(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return boards;
    }

    private Board mapResultSetToBoard(ResultSet rs) throws SQLException {
        Board board = new Board();
        board.setBoardId(rs.getInt("BoardId"));
        board.setProjectId(rs.getInt("ProjectId"));
        board.setName(rs.getString("Name"));
        board.setCreatedAt(rs.getTimestamp("CreatedAt"));
        board.setPosition(rs.getInt("Position"));
        return board;
    }
}
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

    // Insert new board
    public void insert(Board board) {
        String sql = "INSERT INTO Boards (ProjectId, Name, Description, CreatedAt, Position) VALUES (?, ?, ?, GETDATE(), ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, board.getProjectId());
            stmt.setString(2, board.getName());
            stmt.setString(3, board.getDescription() != null ? board.getDescription() : "");
            stmt.setInt(4, board.getPosition());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get board by ID
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

    // Update board name & description
    public void update(Board board) {
        String sql = "UPDATE Boards SET Name = ?, Description = ? WHERE BoardId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, board.getName());
            stmt.setString(2, board.getDescription());
            stmt.setInt(3, board.getBoardId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete board by ID
    public void delete(int boardId) {
        try {
            connection.setAutoCommit(false);

            // First delete all tasks in this board
            String deleteTasksSQL = "DELETE FROM Tasks WHERE BoardId = ?";
            try (PreparedStatement stmt1 = connection.prepareStatement(deleteTasksSQL)) {
                stmt1.setInt(1, boardId);
                stmt1.executeUpdate();
            }

            // Then delete the board
            String deleteBoardSQL = "DELETE FROM Boards WHERE BoardId = ?";
            try (PreparedStatement stmt2 = connection.prepareStatement(deleteBoardSQL)) {
                stmt2.setInt(1, boardId);
                stmt2.executeUpdate();
            }

            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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

    // Get all boards by project ID, ordered by position
    public List<Board> getBoardsByProjectId(int projectId) {
        List<Board> list = new ArrayList<>();
        String sql = "SELECT * FROM Boards WHERE ProjectId = ? ORDER BY Position ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBoard(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Helper to map ResultSet to Board object
    private Board mapResultSetToBoard(ResultSet rs) throws SQLException {
        Board board = new Board();
        board.setBoardId(rs.getInt("BoardId"));
        board.setProjectId(rs.getInt("ProjectId"));
        board.setName(rs.getString("Name"));
        board.setDescription(rs.getString("Description"));
        board.setCreatedAt(rs.getTimestamp("CreatedAt"));
        board.setPosition(rs.getInt("Position"));
        return board;
    }

    // Duplicate board (with tasks)
    public void duplicate(int boardId) {
        try {
            connection.setAutoCommit(false);

            // Get original board info
            Board originalBoard = findById(boardId);
            if (originalBoard == null) {
                return;
            }

            // Duplicate Board
            String duplicateBoardSQL = "INSERT INTO Boards (ProjectId, Name, Description, CreatedAt, Position) "
                    + "VALUES (?, ?, GETDATE(), ?)";
            int newBoardId = -1;

            try (PreparedStatement boardStmt = connection.prepareStatement(duplicateBoardSQL, Statement.RETURN_GENERATED_KEYS)) {
                boardStmt.setInt(1, originalBoard.getProjectId());
                boardStmt.setString(2, originalBoard.getName() + " (Copy)");
                boardStmt.setInt(3, originalBoard.getPosition() + 1);
                boardStmt.executeUpdate();

                ResultSet rs = boardStmt.getGeneratedKeys();
                if (rs.next()) {
                    newBoardId = rs.getInt(1);

                    // Duplicate tasks
                    String duplicateTasksSQL = "INSERT INTO Tasks (BoardId, Title, Description, Status, DueDate, CreatedAt, Position, Priority) "
                            + "SELECT ?, Title, Description, Status, DueDate, GETDATE(), Position, Priority FROM Tasks WHERE BoardId = ?";
                    try (PreparedStatement taskStmt = connection.prepareStatement(duplicateTasksSQL)) {
                        taskStmt.setInt(1, newBoardId);
                        taskStmt.setInt(2, boardId);
                        taskStmt.executeUpdate();
                    }
                }
            }

            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public int insertAndReturnId(Board board) {
        String sql = "INSERT INTO Boards (ProjectId, Name, Description, CreatedAt, Position) VALUES (?, ?, ?, GETDATE(), ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, board.getProjectId());
            stmt.setString(2, board.getName());
            stmt.setString(3, board.getDescription() != null ? board.getDescription() : "");
            stmt.setInt(4, board.getPosition());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // ✅ Trả về ID vừa insert
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // ❌ Trường hợp lỗi
    }

}

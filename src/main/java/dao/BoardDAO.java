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

            // FIX: Nếu description null thì gán chuỗi rỗng
            String desc = board.getDescription() != null ? board.getDescription() : "";
            stmt.setString(3, desc);

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
        String sql = "DELETE FROM Boards WHERE BoardId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, boardId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
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
}
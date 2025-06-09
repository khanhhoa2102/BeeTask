package dao;

import context.DBConnection;
import model.Board;
import java.sql.*;
import java.util.*;

public class BoardDAO {
    public List<Board> findAll() throws Exception {
        List<Board> list = new ArrayList<>();
        String sql = "SELECT * FROM Boards";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Board b = new Board(
                    rs.getInt("BoardId"),
                    rs.getInt("ProjectId"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getTimestamp("CreatedAt")
                );
                list.add(b);
            }
        }
        return list;
    }

    public Board findById(int id) throws Exception {
        String sql = "SELECT * FROM Boards WHERE BoardId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Board(
                        rs.getInt("BoardId"),
                        rs.getInt("ProjectId"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getTimestamp("CreatedAt")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Board b) throws Exception {
        String sql = "INSERT INTO Boards (ProjectId, Name, Description) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, b.getProjectId());
            stmt.setString(2, b.getName());
            stmt.setString(3, b.getDescription());
            stmt.executeUpdate();
        }
    }

    public void update(Board b) throws Exception {
        String sql = "UPDATE Boards SET Name=?, Description=? WHERE BoardId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, b.getName());
            stmt.setString(2, b.getDescription());
            stmt.setInt(3, b.getBoardId());
            stmt.executeUpdate();
        }
    }

    public void delete(int boardId) throws Exception {
        String sql = "DELETE FROM Boards WHERE BoardId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, boardId);
            stmt.executeUpdate();
        }
    }
}
package dao;

import context.DBConnection;
import model.Note;
import java.sql.*;
import java.util.*;

public class NoteDAO {
    public List<Note> findAllByUserId(int userId) throws Exception {
        List<Note> list = new ArrayList<>();
        String sql = "SELECT * FROM Notes WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Note n = new Note(
                        rs.getInt("NoteId"),
                        rs.getInt("UserId"),
                        rs.getString("Title"),
                        rs.getString("Content"),
                        rs.getString("Tag"),
                        rs.getTimestamp("CreatedAt")
                    );
                    list.add(n);
                }
            }
        }
        return list;
    }

    public Note findById(int noteId) throws Exception {
        String sql = "SELECT * FROM Notes WHERE NoteId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, noteId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Note(
                        rs.getInt("NoteId"),
                        rs.getInt("UserId"),
                        rs.getString("Title"),
                        rs.getString("Content"),
                        rs.getString("Tag"),
                        rs.getTimestamp("CreatedAt")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Note n) throws Exception {
        String sql = "INSERT INTO Notes (UserId, Title, Content, Tag) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, n.getUserId());
            stmt.setString(2, n.getTitle());
            stmt.setString(3, n.getContent());
            stmt.setString(4, n.getTag());
            stmt.executeUpdate();
        }
    }

    public void update(Note n) throws Exception {
        String sql = "UPDATE Notes SET Title=?, Content=?, Tag=? WHERE NoteId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, n.getTitle());
            stmt.setString(2, n.getContent());
            stmt.setString(3, n.getTag());
            stmt.setInt(4, n.getNoteId());
            stmt.executeUpdate();
        }
    }

    public void delete(int noteId) throws Exception {
        String sql = "DELETE FROM Notes WHERE NoteId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, noteId);
            stmt.executeUpdate();
        }
    }
}
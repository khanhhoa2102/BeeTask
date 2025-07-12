package dao;

import context.DBConnection;
import model.Note;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoteDAO {

    public static List<Note> findAllByUserId(int userId) {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT n.NoteId, n.UserId, n.Title, n.Content, n.CreatedAt, n.Deadline, "
                + "n.LabelId, l.Name, l.Color "
                + "FROM Notes n LEFT JOIN Labels l ON n.LabelId = l.LabelId "
                + "WHERE n.UserId = ? "
                + "ORDER BY n.CreatedAt DESC";  // ✅ Thêm dòng này

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Note note = new Note();
                note.setNoteId(rs.getInt("NoteId"));
                note.setUserId(rs.getInt("UserId"));
                note.setTitle(rs.getString("Title"));
                note.setContent(rs.getString("Content"));
                note.setCreatedAt(rs.getTimestamp("CreatedAt"));
                note.setDeadline(rs.getTimestamp("Deadline"));
                note.setLabelId(rs.getInt("LabelId"));
                note.setLabelName(rs.getString("Name"));
                note.setLabelColor(rs.getString("Color"));
                notes.add(note);
            }

            rs.close();
            return notes;

        } catch (SQLException e) {
            System.err.println("[ERROR] findAllByUserId: Lỗi khi truy vấn UserId = " + userId);
            e.printStackTrace();
            return null;
        }
    }

    public boolean createNote(Note note) {
        String sql = "INSERT INTO Notes (UserId, Title, Content, LabelId, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, note.getUserId());
            stmt.setString(2, note.getTitle());
            stmt.setString(3, note.getContent());

            // ✅ Nếu LabelId = 0 hoặc nhỏ hơn 1 thì gán NULL
            if (note.getLabelId() <= 0) {
                stmt.setNull(4, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(4, note.getLabelId());
            }

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[ERROR] createNote: Lỗi SQL khi tạo ghi chú");
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateNote(int noteId, String title, String content, String deadline) {
        String sql;
        boolean hasDeadline = deadline != null && !deadline.isEmpty();

        if (hasDeadline) {
            sql = "UPDATE Notes SET Title = ?, Content = ?, Deadline = ? WHERE NoteId = ?";
        } else {
            sql = "UPDATE Notes SET Title = ?, Content = ?, Deadline = NULL WHERE NoteId = ?";
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.setString(2, content);
            if (hasDeadline) {
                stmt.setTimestamp(3, Timestamp.valueOf(deadline));
                stmt.setInt(4, noteId);
            } else {
                stmt.setInt(3, noteId);
            }

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[ERROR] updateNote: Lỗi SQL khi cập nhật ghi chú ID = " + noteId);
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("[ERROR] updateNote: Lỗi không xác định");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNote(int noteId) {
        String sql = "DELETE FROM Notes WHERE NoteId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, noteId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[ERROR] deleteNote: Lỗi SQL khi xóa ghi chú ID = " + noteId);
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("[ERROR] deleteNote: Lỗi không xác định");
            e.printStackTrace();
            return false;
        }
    }
}

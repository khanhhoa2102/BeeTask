package dao;

import context.DBConnection;
import model.ai.ScheduledTaskSuggestion;

import java.sql.*;
import java.util.List;

public class AIScheduleDAO {

    // ✅ 1. Insert suggestion if not already 'Pending' for this task
    public void insertIfNotExists(ScheduledTaskSuggestion suggestion) throws Exception {
        String checkSql = "SELECT COUNT(*) FROM AISchedules WHERE TaskId = ? AND Status = 'Pending'";
        String insertSql = "INSERT INTO AISchedules (TaskId, SuggestedStartTime, SuggestedEndTime, ConfidenceScore, Status, Difficulty, Priority, ShortDescription) "
                + "VALUES (?, ?, ?, ?, 'Pending', ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql); PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {

            checkStmt.setInt(1, suggestion.getTaskId());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                insertStmt.setInt(1, suggestion.getTaskId());
                insertStmt.setTimestamp(2, Timestamp.valueOf(suggestion.getStart()));
                insertStmt.setTimestamp(3, Timestamp.valueOf(suggestion.getEnd()));
                insertStmt.setDouble(4, suggestion.getConfidence());
                insertStmt.setInt(5, suggestion.getDifficulty());
                insertStmt.setString(6, suggestion.getPriority());
                insertStmt.setString(7, suggestion.getShortDescription());

                insertStmt.executeUpdate();
                System.out.println("✅ Inserted new Pending suggestion for TaskId: " + suggestion.getTaskId());
            } else {
                System.out.println("ℹ️ Suggestion already exists for TaskId: " + suggestion.getTaskId());
            }
        }
    }

    // ✅ 2. Update status to Accepted / Rejected
    public void updateStatus(int taskId, String status) throws Exception {
        String sql = "UPDATE AISchedules SET Status = ? WHERE TaskId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, taskId);
            stmt.executeUpdate();
            System.out.println("✅ Status updated for taskId " + taskId + " → " + status);
        }
    }

    // ✅ 3. Get suggestion with 'Accepted' status
    public ScheduledTaskSuggestion getSuggestionByTaskId(int taskId) throws Exception {
        String sql = "SELECT t.Title, s.SuggestedStartTime, s.SuggestedEndTime, s.ConfidenceScore, s.Difficulty, s.Priority, s.ShortDescription "
                + "FROM AISchedules s "
                + "JOIN Tasks t ON s.TaskId = t.TaskId "
                + "WHERE s.TaskId = ? AND s.Status = 'Accepted'";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                ScheduledTaskSuggestion suggestion = new ScheduledTaskSuggestion();
                suggestion.setTitle(rs.getString("Title"));
                suggestion.setStart(rs.getTimestamp("SuggestedStartTime").toLocalDateTime());
                suggestion.setEnd(rs.getTimestamp("SuggestedEndTime").toLocalDateTime());
                suggestion.setConfidence(rs.getDouble("ConfidenceScore"));
                suggestion.setDifficulty(rs.getInt("Difficulty"));
                suggestion.setPriority(rs.getString("Priority"));
                suggestion.setShortDescription(rs.getString("ShortDescription"));
                suggestion.setTaskId(taskId);
                return suggestion;
            }
            return null;
        }
    }

    public void insertAISchedules(int userId, List<ScheduledTaskSuggestion> suggestions, String status) throws Exception {
        String sql = "INSERT INTO AISchedules (TaskId, SuggestedStartTime, SuggestedEndTime, ConfidenceScore, Status, Difficulty, Priority, ShortDescription) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (ScheduledTaskSuggestion s : suggestions) {
                stmt.setInt(1, s.getTaskId());
                stmt.setTimestamp(2, Timestamp.valueOf(s.getStart()));
                stmt.setTimestamp(3, Timestamp.valueOf(s.getEnd()));
                stmt.setDouble(4, s.getConfidence());
                stmt.setString(5, status); // <-- dùng tham số status
                stmt.setInt(6, s.getDifficulty());
                stmt.setString(7, s.getPriority());
                stmt.setString(8, s.getShortDescription());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

}

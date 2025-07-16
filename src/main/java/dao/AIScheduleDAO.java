package dao;

import context.DBConnection;
import model.ai.ScheduledTaskSuggestion;

import java.sql.*;
import java.util.List;

public class AIScheduleDAO {

    public void insertSchedules(int userId, List<ScheduledTaskSuggestion> suggestions) throws Exception {
        String sql = "INSERT INTO AISchedules (TaskId, SuggestedStartTime, SuggestedEndTime, ConfidenceScore, Status, Difficulty, Priority, ShortDescription) " +
                     "SELECT t.TaskId, ?, ?, ?, 'Accepted', ?, ?, ? FROM Tasks t " +
                     "JOIN TaskAssignees a ON t.TaskId = a.TaskId WHERE a.UserId = ? AND t.Title = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (ScheduledTaskSuggestion s : suggestions) {
                stmt.setTimestamp(1, Timestamp.valueOf(s.getStart()));
                stmt.setTimestamp(2, Timestamp.valueOf(s.getEnd()));
                stmt.setDouble(3, s.getConfidence());
                stmt.setInt(4, s.getDifficulty());
                stmt.setString(5, s.getPriority());
                stmt.setString(6, s.getShortDescription());
                stmt.setInt(7, userId);
                stmt.setString(8, s.getTitle());
                stmt.addBatch();
            }

            stmt.executeBatch();
        }
    }

    public ScheduledTaskSuggestion getSuggestionByTaskId(int taskId) throws Exception {
        String sql = "SELECT t.Title, s.SuggestedStartTime, s.SuggestedEndTime, s.ConfidenceScore, s.Difficulty, s.Priority, s.ShortDescription " +
                     "FROM AISchedules s " +
                     "JOIN Tasks t ON s.TaskId = t.TaskId " +
                     "WHERE s.TaskId = ? AND s.Status = 'Accepted'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
                return suggestion;
            }
            return null;
        }
    }
}

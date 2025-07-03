
package dao;

import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.List;
import model.ai.ScheduledTaskSuggestion;

public class AIScheduleDAO {

    public void insertSchedules(int userId, List<ScheduledTaskSuggestion> suggestions) throws Exception {
        String sql = "INSERT INTO AISchedules (TaskId, SuggestedStartTime, SuggestedEndTime, ConfidenceScore, Status) " +
                     "SELECT t.TaskId, ?, ?, ?, 'Accepted' FROM Tasks t " +
                     "JOIN TaskAssignees a ON t.TaskId = a.TaskId WHERE a.UserId = ? AND t.Title = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (ScheduledTaskSuggestion s : suggestions) {
                stmt.setTimestamp(1, Timestamp.valueOf(s.getStart()));
                stmt.setTimestamp(2, Timestamp.valueOf(s.getEnd()));
                stmt.setDouble(3, s.getConfidence());
                stmt.setInt(4, userId);
                stmt.setString(5, s.getTitle());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
}

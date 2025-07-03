package dao;

import context.DBConnection;
import model.CalendarEvent;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CalendarEventDAO {

    public List<CalendarEvent> getEventsByUserId(int userId) throws Exception {
        List<CalendarEvent> list = new ArrayList<>();
        String sql =
            "SELECT * FROM CalendarEvents WHERE UserId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CalendarEvent event = new CalendarEvent(
                        rs.getInt("EventId"),
                        rs.getInt("UserId"),
                        rs.getObject("TaskId") != null ? rs.getInt("TaskId") : null,
                        rs.getString("Title"),
                        rs.getString("Description"),
                        toUtilDate(rs.getTimestamp("StartTime")),
                        toUtilDate(rs.getTimestamp("EndTime")),
                        toUtilDate(rs.getTimestamp("ReminderTime"))
                    );
                    list.add(event);
                }
            }
        }
        return list;
    }

    public void insert(CalendarEvent event) throws Exception {
        String sql = "INSERT INTO CalendarEvents (UserId, TaskId, Title, Description, StartTime, EndTime, ReminderTime) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, event.getUserId());
            if (event.getTaskId() != null) {
                stmt.setInt(2, event.getTaskId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, event.getTitle());
            stmt.setString(4, event.getDescription());
            stmt.setTimestamp(5, toSqlTimestamp(event.getStartTime()));
            stmt.setTimestamp(6, toSqlTimestamp(event.getEndTime()));
            stmt.setTimestamp(7, toSqlTimestamp(event.getReminderTime()));

            stmt.executeUpdate();
        }
    }

    public void update(CalendarEvent event) throws Exception {
        String sql = "UPDATE CalendarEvents SET TaskId=?, Title=?, Description=?, StartTime=?, EndTime=?, ReminderTime=? " +
                     "WHERE EventId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (event.getTaskId() != null) {
                stmt.setInt(1, event.getTaskId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setString(2, event.getTitle());
            stmt.setString(3, event.getDescription());
            stmt.setTimestamp(4, toSqlTimestamp(event.getStartTime()));
            stmt.setTimestamp(5, toSqlTimestamp(event.getEndTime()));
            stmt.setTimestamp(6, toSqlTimestamp(event.getReminderTime()));
            stmt.setInt(7, event.getEventId());

            stmt.executeUpdate();
        }
    }

    public void delete(int eventId) throws Exception {
        String sql = "DELETE FROM CalendarEvents WHERE EventId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.executeUpdate();
        }
    }

    // Helpers
    private java.util.Date toUtilDate(Timestamp timestamp) {
        return timestamp != null ? new java.util.Date(timestamp.getTime()) : null;
    }

    private Timestamp toSqlTimestamp(java.util.Date date) {
        return date != null ? new Timestamp(date.getTime()) : null;
    }
}

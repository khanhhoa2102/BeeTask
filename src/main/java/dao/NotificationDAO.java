package dao;

import model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBConnection;

public class NotificationDAO {

    // CREATE
    public void addNotification(Notification notification) {
        String sql = "INSERT INTO Notifications (UserId, Message, IsRead, CreatedAt) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getMessage());
            stmt.setBoolean(3, notification.isRead());
            stmt.setTimestamp(4, notification.getCreatedAt());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void updateNotification(Notification notification) {
        String sql = "UPDATE Notifications SET Message = ? WHERE NotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, notification.getMessage());
            stmt.setInt(2, notification.getNotificationId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Notification> getAllNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("NotificationId"));
                n.setUserId(rs.getInt("UserId"));
                n.setMessage(rs.getString("Message"));
                n.setIsRead(rs.getBoolean("IsRead"));
                n.setCreatedAt(rs.getTimestamp("CreatedAt"));
                notifications.add(n);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }



    // READ (by user)
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserId = ? ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("NotificationId"));
                n.setUserId(rs.getInt("UserId"));
                n.setMessage(rs.getString("Message"));
                n.setIsRead(rs.getBoolean("IsRead"));
                n.setCreatedAt(rs.getTimestamp("CreatedAt"));
                notifications.add(n);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
    
    public Notification getNotificationById(int id) {
        String sql = "SELECT * FROM Notifications WHERE NotificationId = ?";
        Notification notification = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                notification = new Notification();
                notification.setNotificationId(rs.getInt("NotificationId"));
                notification.setUserId(rs.getInt("UserId"));
                notification.setMessage(rs.getString("Message"));
                notification.setIsRead(rs.getBoolean("IsRead"));
                notification.setCreatedAt(rs.getTimestamp("CreatedAt"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notification;
    }


    // UPDATE (mark as read)
    public void markAsRead(int notificationId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notificationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void markAsUnread(int notificationId) {
        String sql = "UPDATE Notifications SET IsRead = 0 WHERE NotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notificationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Mark all notifications as read for a user
    public void markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Mark all notifications as unread
    public void markAllAsUnread(int userId) {
        String sql = "UPDATE Notifications SET IsRead = 0 WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // DELETE (by ID)
    public void deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notifications WHERE NotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notificationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // DELETE (all for a user)
    public void deleteAllNotificationsByUser(int userId) {
        String sql = "DELETE FROM Notifications WHERE UserId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


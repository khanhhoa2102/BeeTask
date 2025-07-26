package dao;

import java.util.List;
import model.ProjectNotification;
import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ProjectNotificationDAO {
    public void addProjectNotification(ProjectNotification notification) {
        String sql = "INSERT INTO ProjectNotifications (ProjectId, Message, CreatedAt) " +
                    "OUTPUT INSERTED.ProjectNotificationId, INSERTED.Message, INSERTED.CreatedAt " +
                    "VALUES (?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, notification.getProjectId());
            stmt.setString(2, notification.getMessage());
            stmt.setTimestamp(3, notification.getCreatedAt());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int newId = rs.getInt("ProjectNotificationId");
                addNotificationStatus(notification.getProjectId(), newId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void addNotificationStatus(int projectId, int projectNotificationId) {
        String getMembersSql = "SELECT UserId FROM ProjectMembers WHERE ProjectId = ? AND Role <> 'Leader'";
        String insertStatusSql = "INSERT INTO ProjectNotificationStatus (UserId, ProjectNotificationId, IsRead) VALUES (?, ?, 0)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement getMembersStmt = conn.prepareStatement(getMembersSql);
            PreparedStatement insertStmt = conn.prepareStatement(insertStatusSql)
        ) {
            // Step 1: Get all member IDs
            getMembersStmt.setInt(1, projectId);
            ResultSet rs = getMembersStmt.executeQuery();

            List<Integer> userIds = new ArrayList<>();
            while (rs.next()) {
                userIds.add(rs.getInt("UserId"));
            }

            // Step 2: Insert notification status for each user
            for (int userId : userIds) {
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, projectNotificationId);
                insertStmt.addBatch();
            }

            // Execute batch insert
            insertStmt.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<ProjectNotification> getNotificationsByProjectId(int projectId) {
        List<ProjectNotification> notifications = new ArrayList<>();

        String sql = "SELECT ProjectNotificationId, ProjectId, Message, CreatedAt " +
                     "FROM ProjectNotifications " +
                     "WHERE ProjectId = ? " +
                     "ORDER BY CreatedAt DESC";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ProjectNotification notification = new ProjectNotification();
                notification.setProjectNotificationId(rs.getInt("ProjectNotificationId"));
                notification.setProjectId(rs.getInt("ProjectId"));
                notification.setMessage(rs.getString("Message"));
                notification.setCreatedAt(rs.getTimestamp("CreatedAt"));

                notifications.add(notification);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return notifications;
    }
    
    public ProjectNotification getNotificationById(int projectNotificationId) {
        String sql = "SELECT ProjectNotificationId, ProjectId, Message, CreatedAt " +
                     "FROM ProjectNotifications " +
                     "WHERE ProjectNotificationId = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, projectNotificationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                ProjectNotification notification = new ProjectNotification();
                notification.setProjectNotificationId(rs.getInt("ProjectNotificationId"));
                notification.setProjectId(rs.getInt("ProjectId"));
                notification.setMessage(rs.getString("Message"));
                notification.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return notification;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null; // Not found or error
    }
    
    public List<ProjectNotification> getNotificationsByUserId(int userId) {
        List<ProjectNotification> list = new ArrayList<>();

        String sql = "SELECT ProjectNotificationId, IsRead " +
                     "FROM ProjectNotificationStatus " +
                     "WHERE UserId = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int notificationId = rs.getInt("ProjectNotificationId");
                boolean isRead = rs.getBoolean("IsRead");

                // Reuse existing DAO method
                ProjectNotification full = getNotificationById(notificationId);
                if (full != null) {
                    ProjectNotification upn = new ProjectNotification(
                        full.getProjectNotificationId(),
                        full.getProjectId(),
                        full.getMessage(),
                        full.getCreatedAt(),
                        userId,
                        isRead
                    );
                    list.add(upn);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public void markAsRead(int userId, int notificationId) {
        String sql = "UPDATE ProjectNotificationStatus SET IsRead = 1 WHERE UserId = ? AND ProjectNotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, notificationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
    public void markAsUnread(int userId, int notificationId) {
        String sql = "UPDATE ProjectNotificationStatus SET IsRead = 0 WHERE UserId = ? AND ProjectNotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, notificationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
    public void markAllAsRead(int userId) {
        String sql = "UPDATE ProjectNotificationStatus SET IsRead = 1 WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void markAllAsUnread(int userId) {
        String sql = "UPDATE ProjectNotificationStatus SET IsRead = 0 WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void markAllAsUnreadById(int notificationId) {
        String sql = "UPDATE ProjectNotificationStatus SET IsRead = 0 WHERE NotificationId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void editNotification(ProjectNotification notification) {
        String sql = "UPDATE ProjectNotifications SET Message = ? WHERE NotificationId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, notification.getMessage());
            stmt.setInt(2, notification.getProjectNotificationId());

            stmt.executeUpdate();
            
            markAllAsUnreadById(notification.getProjectNotificationId());

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void deleteNotificationById(int notificationId) {
    String deleteStatusSql = "DELETE FROM ProjectNotificationStatus WHERE ProjectNotificationId = ?";
    String deleteNotificationSql = "DELETE FROM ProjectNotifications WHERE ProjectNotificationId = ?";

    try (
        Connection conn = DBConnection.getConnection();
        PreparedStatement statusStmt = conn.prepareStatement(deleteStatusSql);
        PreparedStatement notificationStmt = conn.prepareStatement(deleteNotificationSql)
    ) {
        // Start transaction
        conn.setAutoCommit(false);

        // Delete from status table first
        statusStmt.setInt(1, notificationId);
        statusStmt.executeUpdate();

        // Delete from notifications table
        notificationStmt.setInt(1, notificationId);
        notificationStmt.executeUpdate();

        // Commit transaction
        conn.commit();

    } catch (Exception e) {
        e.printStackTrace();
    }
}

    
    public void deleteNotificationByUser(int userId, int projectNotificationId) {
        String sql = "DELETE FROM ProjectNotificationStatus WHERE UserId = ? AND ProjectNotificationId = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, userId);
            stmt.setInt(2, projectNotificationId);

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

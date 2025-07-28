package model;

import java.sql.Timestamp;

public class ProjectNotification {
    private int projectNotificationId;
    private int projectId;
    private String message;
    private Timestamp createdAt;
    private int userId;
    private boolean isRead;

    public ProjectNotification() {}

    public ProjectNotification(int projectNotificationId, int projectId, String message,
                                   Timestamp createdAt, int userId, boolean isRead) {
        this.projectNotificationId = projectNotificationId;
        this.projectId = projectId;
        this.message = message;
        this.createdAt = createdAt;
        this.userId = userId;
        this.isRead = isRead;
    }

    public int getProjectNotificationId() {
        return projectNotificationId;
    }

    public void setProjectNotificationId(int projectNotificationId) {
        this.projectNotificationId = projectNotificationId;
    }

    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    @Override
    public String toString() {
        return "UserProjectNotification{" +
                "projectNotificationId=" + projectNotificationId +
                ", projectId=" + projectId +
                ", message='" + message + '\'' +
                ", createdAt=" + createdAt +
                ", userId=" + userId +
                ", isRead=" + isRead +
                '}';
    }
}

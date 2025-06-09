
package model;

import java.sql.Timestamp;

public class TaskComment {
    private int commentId;
    private int taskId;
    private int userId;
    private String content;
    private Timestamp createdAt;

    public TaskComment(int commentId, int taskId, int userId, String content, Timestamp createdAt) {
        this.commentId = commentId;
        this.taskId = taskId;
        this.userId = userId;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "TaskComment{" + "commentId=" + commentId + ", taskId=" + taskId + ", userId=" + userId + ", content=" + content + ", createdAt=" + createdAt + '}';
    }

    
}


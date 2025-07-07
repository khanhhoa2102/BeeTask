package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private int boardId;
    private String title;
    private String description;
    private int statusId;
    private Date dueDate;
    private Timestamp createdAt;
    private int createdBy;
    private int position;
    private String priority;

    // Default constructor
    public Task() {}

    // Full constructor (đã bỏ listId)
    public Task(int taskId, int boardId, String title, String description,
                int statusId, Date dueDate, Timestamp createdAt, int createdBy,
                int position, String priority) {
        this.taskId = taskId;
        this.boardId = boardId;
        this.title = title;
        this.description = description;
        this.statusId = statusId;
        this.dueDate = dueDate;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.position = position;
        this.priority = priority;
    }

    // Getters & Setters
    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getTitle() {
        return title != null ? title : "";
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description != null ? description : "";
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getPriority() {
        return priority != null ? priority : "Medium";
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", boardId=" + boardId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", statusId=" + statusId +
                ", dueDate=" + dueDate +
                ", createdAt=" + createdAt +
                ", createdBy=" + createdBy +
                ", position=" + position +
                ", priority='" + priority + '\'' +
                '}';
    }
}

package model;

import java.util.Date;

public class Task {
    private int taskId;
    private int boardId;
    private int listId;
    private String title;
    private String description;
    private int statusId;
    private Date dueDate;
    private Date createdAt;
    private int createdBy;

    public Task() {
    }

    public Task(int taskId, int boardId, int listId, String title, String description,
                int statusId, Date dueDate, Date createdAt, int createdBy) {
        this.taskId = taskId;
        this.boardId = boardId;
        this.listId = listId;
        this.title = title;
        this.description = description;
        this.statusId = statusId;
        this.dueDate = dueDate;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
    }

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

    public int getListId() {
        return listId;
    }

    public void setListId(int listId) {
        this.listId = listId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
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

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", boardId=" + boardId +
                ", listId=" + listId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", statusId=" + statusId +
                ", dueDate=" + dueDate +
                ", createdAt=" + createdAt +
                ", createdBy=" + createdBy +
                '}';
    }
}

package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private int boardId;
    private int listId;
    private String title;
    private String description;
    private String status;      // e.g., "To Do", "In Progress", "Done"
    private Date dueDate;
    private Timestamp createdAt;
    private String createdBy;
    private int position;
    private String priority;    // e.g., "High", "Medium", "Low"

    public Task() {}

    public Task(int taskId, int boardId, int listId, String title, String description,
                String status, Date dueDate, Timestamp createdAt, String createdBy,
                int position, String priority) {
        this.taskId = taskId;
        this.boardId = boardId;
        this.listId = listId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.dueDate = dueDate;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.position = position;
        this.priority = priority;
    }

    // Getters and Setters
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public int getListId() { return listId; }
    public void setListId(int listId) { this.listId = listId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public int getPosition() { return position; }
    public void setPosition(int position) { this.position = position; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
}

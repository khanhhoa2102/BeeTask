package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private int boardId;
    private int listId; // Keep this field for database compatibility
    private String title;
    private String description;
    private int statusId;
    private String statusName; // Add this field to store status name
    private Date dueDate;
    private Timestamp createdAt;
    private int createdBy;
    private int position;
    private String priority;

    // Default constructor
    public Task() {}

    // Getters and Setters
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

    public String getStatusName() {
        return statusName;
    }
    
    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    // Add this method for JSP compatibility
    public String getStatus() {
        return statusName != null ? statusName : "Unknown";
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
        return priority; 
    }
    
    public void setPriority(String priority) { 
        this.priority = priority; 
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
                ", statusName='" + statusName + '\'' +
                ", dueDate=" + dueDate +
                ", createdAt=" + createdAt +
                ", createdBy=" + createdBy +
                ", position=" + position +
                ", priority='" + priority + '\'' +
                '}';
    }
}
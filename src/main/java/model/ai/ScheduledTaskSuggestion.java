package model.ai;

import java.time.LocalDateTime;

public class ScheduledTaskSuggestion {
    private int taskId;
    private String title;
    private int difficulty;
    private LocalDateTime dueDate;
    private LocalDateTime start;
    private LocalDateTime end;
    private String priority; // "Low", "Medium", "High"
    private double confidence;
    private String shortDescription;
    private Boolean event;


    public ScheduledTaskSuggestion() {
    }

    public ScheduledTaskSuggestion(String title, int difficulty, LocalDateTime dueDate,
            LocalDateTime start, LocalDateTime end,
            String priority, double confidence, String shortDescription) {
        this.title = title;
        this.difficulty = difficulty;
        this.dueDate = dueDate;
        this.start = start;
        this.end = end;
        this.priority = priority;
        this.confidence = confidence;
        this.shortDescription = shortDescription;
    }

    public ScheduledTaskSuggestion(int taskId, String title, int difficulty, LocalDateTime dueDate, LocalDateTime start, LocalDateTime end, String priority, double confidence, String shortDescription, Boolean event) {
        this.taskId = taskId;
        this.title = title;
        this.difficulty = difficulty;
        this.dueDate = dueDate;
        this.start = start;
        this.end = end;
        this.priority = priority;
        this.confidence = confidence;
        this.shortDescription = shortDescription;
        this.event = event;
    }
    
    

    // Getters
    public String getTitle() {
        return title;
    }

    public int getDifficulty() {
        return difficulty;
    }

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public LocalDateTime getStart() {
        return start;
    }

    public LocalDateTime getEnd() {
        return end;
    }

    public String getPriority() {
        return priority;
    }

    public double getConfidence() {
        return confidence;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    // Setters
    public void setTitle(String title) {
        this.title = title;
    }

    public void setDifficulty(int difficulty) {
        this.difficulty = difficulty;
    }

    public void setDueDate(LocalDateTime dueDate) {
        this.dueDate = dueDate;
    }

    public void setStart(LocalDateTime start) {
        this.start = start;
    }

    public void setEnd(LocalDateTime end) {
        this.end = end;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public void setConfidence(double confidence) {
        this.confidence = confidence;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public Boolean getEvent() {
        return event;
    }

    public void setEvent(Boolean event) {
        this.event = event;
    }

    public Boolean isEvent() {
        return event != null && event;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }
    
    
}

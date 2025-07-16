package model.ai;

import java.util.List;

import java.time.LocalDateTime;

public class SimpleTask {

    private String title;
    private String description;
    private LocalDateTime dueDate;
    private List<String> labels;
    private String status;
    private int difficulty;
    private String priority;

    public SimpleTask(String title, String description, LocalDateTime dueDate, List<String> labels, String status, int difficulty, String priority) {
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.labels = labels;
        this.status = status;
        this.difficulty = difficulty;
        this.priority = priority;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setDueDate(LocalDateTime dueDate) {
        this.dueDate = dueDate;
    }

    public void setLabels(List<String> labels) {
        this.labels = labels;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setDifficulty(int difficulty) {
        this.difficulty = difficulty;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public List<String> getLabels() {
        return labels;
    }

    public String getStatus() {
        return status;
    }

    public int getDifficulty() {
        return difficulty;
    }

    public String getPriority() {
        return priority;
    }
}

package model;

import java.util.Date;
import java.util.List;


public class TemplateTask {
    private int templateTaskId;
    private int templateBoardId;
    private String title;
    private String description;
    private String status;
    private Date dueDate; 
    private List<Label> labels; 
    private List<User> assignees; 

    public TemplateTask() {
    }

    public TemplateTask(int templateTaskId, int templateBoardId, String title, String description, String status, Date dueDate, List<Label> labels, List<User> assignees) {
        this.templateTaskId = templateTaskId;
        this.templateBoardId = templateBoardId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.dueDate = dueDate;
        this.labels = labels;
        this.assignees = assignees;
    }

   

    public int getTemplateTaskId() {
        return templateTaskId;
    }

    public void setTemplateTaskId(int templateTaskId) {
        this.templateTaskId = templateTaskId;
    }

    public int getTemplateBoardId() {
        return templateBoardId;
    }

    public void setTemplateBoardId(int templateBoardId) {
        this.templateBoardId = templateBoardId;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public List<Label> getLabels() {
        return labels;
    }

    public void setLabels(List<Label> labels) {
        this.labels = labels;
    }

    public List<User> getAssignees() {
        return assignees;
    }

    public void setAssignees(List<User> assignees) {
        this.assignees = assignees;
    }
}

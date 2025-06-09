/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ASUS
 */
public class TemplateTask {
    private int templateTaskId;
    private int templateBoardId;
    private String title;
    private String description;
    private String status;

    public TemplateTask(int templateTaskId, int templateBoardId, String title, String description, String status) {
        this.templateTaskId = templateTaskId;
        this.templateBoardId = templateBoardId;
        this.title = title;
        this.description = description;
        this.status = status;
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
    
}

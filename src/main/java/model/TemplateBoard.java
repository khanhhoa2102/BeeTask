
package model;

public class TemplateBoard {
    private int templateBoardId;
    private int templateId;
    private String name;
    private String description;

    
    public TemplateBoard() {
    }

    public TemplateBoard(int templateBoardId, int templateId, String name, String description) {
        this.templateBoardId = templateBoardId;
        this.templateId = templateId;
        this.name = name;
        this.description = description;
    }

    public int getTemplateBoardId() {
        return templateBoardId;
    }

    public void setTemplateBoardId(int templateBoardId) {
        this.templateBoardId = templateBoardId;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
}

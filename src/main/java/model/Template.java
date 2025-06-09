
package model;


public class Template {
    private int templateId;
    private String name;
    private String description;
    private String sampleData;
    private int createdBy;

    public Template(int templateId, String name, String description, String sampleData, int createdBy) {
        this.templateId = templateId;
        this.name = name;
        this.description = description;
        this.sampleData = sampleData;
        this.createdBy = createdBy;
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

    public String getSampleData() {
        return sampleData;
    }

    public void setSampleData(String sampleData) {
        this.sampleData = sampleData;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "Template{" + "templateId=" + templateId + ", name=" + name + ", description=" + description + ", sampleData=" + sampleData + ", createdBy=" + createdBy + '}';
    }
    
}

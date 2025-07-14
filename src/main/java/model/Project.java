//package model;
//
//import java.sql.Timestamp;
//
//public class Project {
//    private int projectId;
//    private String name;
//    private String description;
//    private int createdBy;  // Changed from String to int to match database
//    private Timestamp createdAt;
//
//    // Default constructor
//    public Project() {}
//
//    // Full constructor
//    public Project(int projectId, String name, String description, int createdBy, Timestamp createdAt) {
//        this.projectId = projectId;
//        this.name = name;
//        this.description = description;
//        this.createdBy = createdBy;
//        this.createdAt = createdAt;
//    }
//
//    // Getters and Setters
//    public int getProjectId() {
//        return projectId;
//    }
//
//    public void setProjectId(int projectId) {
//        this.projectId = projectId;
//    }
//
//    public String getName() {
//        return name;
//    }
//
//    public void setName(String name) {
//        this.name = name;
//    }
//
//    public String getDescription() {
//        return description;
//    }
//
//    public void setDescription(String description) {
//        this.description = description;
//    }
//
//    public int getCreatedBy() {
//        return createdBy;
//    }
//
//    public void setCreatedBy(int createdBy) {
//        this.createdBy = createdBy;
//    }
//
//    public Timestamp getCreatedAt() {
//        return createdAt;
//    }
//
//    public void setCreatedAt(Timestamp createdAt) {
//        this.createdAt = createdAt;
//    }
//
//    @Override
//    public String toString() {
//        return "Project{" +
//                "projectId=" + projectId +
//                ", name='" + name + '\'' +
//                ", description='" + description + '\'' +
//                ", createdBy=" + createdBy +
//                ", createdAt=" + createdAt +
//                '}';
//    }
//}



package model;

import java.sql.Timestamp;

public class Project {
    private int projectId;
    private String name;
    private String description;
    private int createdBy;
    private Timestamp createdAt;
    private boolean isLocked; // ✅ Thêm thuộc tính mới

    // Default constructor
    public Project() {}

    
    // ✅ Constructor không có isLocked (giữ tương thích cũ)
    public Project(int projectId, String name, String description, int createdBy, Timestamp createdAt) {
        this.projectId = projectId;
        this.name = name;
        this.description = description;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.isLocked = false; // mặc định là không khóa
    }
    
    
    
    // Full constructor
    public Project(int projectId, String name, String description, int createdBy, Timestamp createdAt, boolean isLocked) {
        this.projectId = projectId;
        this.name = name;
        this.description = description;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.isLocked = isLocked;
    }

    // Getters and Setters
    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
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

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isLocked() {
        return isLocked;
    }

    public void setLocked(boolean isLocked) {
        this.isLocked = isLocked;
    }

    @Override
    public String toString() {
        return "Project{" +
                "projectId=" + projectId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", isLocked=" + isLocked +
                '}';
    }
}

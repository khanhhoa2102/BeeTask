package model;

public class ProjectOverview {
    private int projectId;
    private String projectName;
    private String projectDescription;
    private String projectCreatedBy;
    private String projectCreatedAt;

    private int userId;
    private String username;
    private String role;

    private int taskId;
    private String taskTitle;
    private String taskDescription;
    private String dueDate;
    private String taskCreatedAt;
    private String taskCreatedBy;
    private String taskStatus;

    public ProjectOverview(int projectId, String projectName, String projectDescription, String projectCreatedBy, String projectCreatedAt,
                           int userId, String username, String role,
                           int taskId, String taskTitle, String taskDescription, String dueDate, String taskCreatedAt, String taskCreatedBy, String taskStatus) {
        this.projectId = projectId;
        this.projectName = projectName;
        this.projectDescription = projectDescription;
        this.projectCreatedBy = projectCreatedBy;
        this.projectCreatedAt = projectCreatedAt;

        this.userId = userId;
        this.username = username;
        this.role = role;

        this.taskId = taskId;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;
        this.dueDate = dueDate;
        this.taskCreatedAt = taskCreatedAt;
        this.taskCreatedBy = taskCreatedBy;
        this.taskStatus = taskStatus;
    }

    public int getProjectId() {
        return projectId;
    }

    public String getProjectName() {
        return projectName;
    }

    public String getProjectDescription() {
        return projectDescription;
    }

    public String getProjectCreatedBy() {
        return projectCreatedBy;
    }

    public String getProjectCreatedAt() {
        return projectCreatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public int getTaskId() {
        return taskId;
    }

    public String getTaskTitle() {
        return taskTitle;
    }

    public String getTaskDescription() {
        return taskDescription;
    }

    public String getDueDate() {
        return dueDate;
    }

    public String getTaskCreatedAt() {
        return taskCreatedAt;
    }

    public String getTaskCreatedBy() {
        return taskCreatedBy;
    }

    public String getTaskStatus() {
        return taskStatus;
    }

    @Override
    public String toString() {
        return "ProjectOverview{" +
                "projectId=" + projectId +
                ", projectName='" + projectName + '\'' +
                ", projectDescription='" + projectDescription + '\'' +
                ", projectCreatedBy='" + projectCreatedBy + '\'' +
                ", projectCreatedAt='" + projectCreatedAt + '\'' +
                ", userId=" + userId +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                ", taskId=" + taskId +
                ", taskTitle='" + taskTitle + '\'' +
                ", taskDescription='" + taskDescription + '\'' +
                ", dueDate='" + dueDate + '\'' +
                ", taskCreatedAt='" + taskCreatedAt + '\'' +
                ", taskCreatedBy='" + taskCreatedBy + '\'' +
                ", taskStatus='" + taskStatus + '\'' +
                '}';
    }
}

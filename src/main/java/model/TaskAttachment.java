package model;

import java.sql.Timestamp;

public class TaskAttachment {
    private int attachmentId;
    private int taskId;
    private String fileUrl;
    private String fileName;
    private String fileType;
    private int fileSize;
    private Timestamp uploadedAt;

    public TaskAttachment() {
    }

    public TaskAttachment(int attachmentId, String fileUrl, String fileName, String fileType, int taskId) {
        this.attachmentId = attachmentId;
        this.taskId = taskId;
        this.fileUrl = fileUrl;
        this.fileName = fileName;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.uploadedAt = uploadedAt;
    }

    // Getters and setters

    public int getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(int attachmentId) {
        this.attachmentId = attachmentId;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public int getFileSize() {
        return fileSize;
    }

    public void setFileSize(int fileSize) {
        this.fileSize = fileSize;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
    
    public String getFilePath() {
            return taskId + "/" + fileName;
        }
}

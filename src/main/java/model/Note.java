package model;

import java.sql.Timestamp;

public class Note {
    private int noteId;
    private int userId;
    private String title;
    private String content;
    private Timestamp createdAt;
    private Timestamp deadline;
    private int labelId;
    private String labelName;   // Tên nhãn (từ Labels.Name)
    private String labelColor;  // Màu nhãn (từ Labels.Color)

    // ✅ Constructor mặc định
    public Note() {}

    // ✅ Constructor tiện dụng khi tạo mới ghi chú
    public Note(String title, String content, int userId, int labelId) {
        this.title = title;
        this.content = content;
        this.userId = userId;
        this.labelId = labelId;
    }
    

    // Getters & Setters
    public int getNoteId() {
        return noteId;
    }

    public void setNoteId(int noteId) {
        this.noteId = noteId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getDeadline() {
        return deadline;
    }

    public void setDeadline(Timestamp deadline) {
        this.deadline = deadline;
    }

    public int getLabelId() {
        return labelId;
    }

    public void setLabelId(int labelId) {
        this.labelId = labelId;
    }

    public String getLabelName() {
        return labelName;
    }

    public void setLabelName(String labelName) {
        this.labelName = labelName;
    }

    public String getLabelColor() {
        return labelColor;
    }

    public void setLabelColor(String labelColor) {
        this.labelColor = labelColor;
    }
}

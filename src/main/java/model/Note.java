
package model;

import java.sql.Timestamp;

public class Note {
    private int noteId;
    private int userId;
    private String title;
    private String content;
    private String tag;
    private Timestamp createdAt;

    public Note(int noteId, int userId, String title, String content, String tag, Timestamp createdAt) {
        this.noteId = noteId;
        this.userId = userId;
        this.title = title;
        this.content = content;
        this.tag = tag;
        this.createdAt = createdAt;
    }

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

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Note{" + "noteId=" + noteId + ", userId=" + userId + ", title=" + title + ", content=" + content + ", tag=" + tag + ", createdAt=" + createdAt + '}';
    }

    
}

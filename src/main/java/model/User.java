package model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String avatarUrl;
    private boolean isActive;
    private Timestamp createdAt;

    public User(int userId, String fullName, String email, String passwordHash, String avatarUrl, boolean isActive, Timestamp createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.avatarUrl = avatarUrl;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

     public boolean isActive() {
        return isActive;
    }
     
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", fullName=" + fullName + ", email=" + email + ", passwordHash=" + passwordHash + ", avatarUrl=" + avatarUrl + ", isActive=" + isActive + ", createdAt=" + createdAt + '}';
    }

   

    
}

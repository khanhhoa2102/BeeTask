package model;

import java.util.Date;

public class TokenForgetPassword {
    private int id;
    private String token;
    private Date expiryTime;
    private boolean isUsed;
    private int userId;
    private Date createdAt;

    // Constructors
    public TokenForgetPassword() {}

    public TokenForgetPassword(int id, String token, Date expiryTime, boolean isUsed, int userId, Date createdAt) {
        this.id = id;
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    public TokenForgetPassword(String token, Date expiryTime, boolean isUsed, int userId) {
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.userId = userId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Date expiryTime) {
        this.expiryTime = expiryTime;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean used) {
        isUsed = used;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}

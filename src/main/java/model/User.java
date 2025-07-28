package model;

import java.sql.Date;
import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String avatarUrl;
    private String phoneNumber;
    private Date dateOfBirth;
    private String gender;
    private String address;
    private String loginProvider;
    private String googleId;
    private boolean isEmailVerified;
    private boolean isActive;
    private Timestamp createdAt;
    private String role; // ✅ Thêm role
    private int assignedTo; // new

    public User() {}
    
    public int getAssignedTo() {
        return assignedTo;
    }

    public User(int userId, String username, String email, String passwordHash, String avatarUrl,
                String phoneNumber, Date dateOfBirth, String gender, String address,
                String loginProvider, String googleId, boolean isEmailVerified, boolean isActive,
                Timestamp createdAt, String role) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.avatarUrl = avatarUrl;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
        this.loginProvider = loginProvider;
        this.googleId = googleId;
        this.isEmailVerified = isEmailVerified;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.role = role; // ✅ Gán role
    }

    // Getters & Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getLoginProvider() {
        return loginProvider;
    }

    public void setLoginProvider(String loginProvider) {
        this.loginProvider = loginProvider;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public boolean isEmailVerified() {
        return isEmailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        isEmailVerified = emailVerified;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getRole() { 
        return role;
    }

    public void setRole(String role) { 
        this.role = role;
    }

    
    
    
   
    
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", avatarUrl='" + avatarUrl + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", dateOfBirth=" + dateOfBirth +
                ", gender='" + gender + '\'' +
                ", address='" + address + '\'' +
                ", loginProvider='" + loginProvider + '\'' +
                ", googleId='" + googleId + '\'' +
                ", isEmailVerified=" + isEmailVerified +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                ", role='" + role + '\'' + // ✅ In role ra toString
                '}';
    }
}










































































//package model;
//
//import java.sql.Date;
//import java.sql.Timestamp;
//
//public class User {
//    private int userId;
//    private String username;
//    private String email;
//    private String passwordHash;
//    private String avatarUrl;
//    private String phoneNumber;
//    private Date dateOfBirth;
//    private String gender;
//    private String address;
//    private String loginProvider;
//    private String googleId;
//    private boolean isEmailVerified;
//    private boolean isActive;
//    private Timestamp createdAt;
//
//    public User() {}
//
//    public User(int userId, String username, String email, String passwordHash, String avatarUrl,
//                String phoneNumber, Date dateOfBirth, String gender, String address,
//                String loginProvider, String googleId, boolean isEmailVerified, boolean isActive, Timestamp createdAt) {
//        this.userId = userId;
//        this.username = username;
//        this.email = email;
//        this.passwordHash = passwordHash;
//        this.avatarUrl = avatarUrl;
//        this.phoneNumber = phoneNumber;
//        this.dateOfBirth = dateOfBirth;
//        this.gender = gender;
//        this.address = address;
//        this.loginProvider = loginProvider;
//        this.googleId = googleId;
//        this.isEmailVerified = isEmailVerified;
//        this.isActive = isActive;
//        this.createdAt = createdAt;
//    }
//
//    // Getters & Setters
//
//    public int getUserId() {
//        return userId;
//    }
//
//    public void setUserId(int userId) {
//        this.userId = userId;
//    }
//
//    public String getUsername() {
//        return username;
//    }
//
//    public void setUsername(String username) {
//        this.username = username;
//    }
//
//    public String getEmail() {
//        return email;
//    }
//
//    public void setEmail(String email) {
//        this.email = email;
//    }
//
//    public String getPasswordHash() {
//        return passwordHash;
//    }
//
//    public void setPasswordHash(String passwordHash) {
//        this.passwordHash = passwordHash;
//    }
//
//    public String getAvatarUrl() {
//        return avatarUrl;
//    }
//
//    public void setAvatarUrl(String avatarUrl) {
//        this.avatarUrl = avatarUrl;
//    }
//
//    public String getPhoneNumber() {
//        return phoneNumber;
//    }
//
//    public void setPhoneNumber(String phoneNumber) {
//        this.phoneNumber = phoneNumber;
//    }
//
//    public Date getDateOfBirth() {
//        return dateOfBirth;
//    }
//
//    public void setDateOfBirth(Date dateOfBirth) {
//        this.dateOfBirth = dateOfBirth;
//    }
//
//    public String getGender() {
//        return gender;
//    }
//
//    public void setGender(String gender) {
//        this.gender = gender;
//    }
//
//    public String getAddress() {
//        return address;
//    }
//
//    public void setAddress(String address) {
//        this.address = address;
//    }
//
//    public String getLoginProvider() {
//        return loginProvider;
//    }
//
//    public void setLoginProvider(String loginProvider) {
//        this.loginProvider = loginProvider;
//    }
//
//    public String getGoogleId() {
//        return googleId;
//    }
//
//    public void setGoogleId(String googleId) {
//        this.googleId = googleId;
//    }
//
//    public boolean isEmailVerified() {
//        return isEmailVerified;
//    }
//
//    public void setEmailVerified(boolean emailVerified) {
//        isEmailVerified = emailVerified;
//    }
//
//    public boolean isActive() {
//        return isActive;
//    }
//
//    public void setActive(boolean active) {
//        isActive = active;
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
//        return "User{" +
//                "userId=" + userId +
//                ", username='" + username + '\'' +
//                ", email='" + email + '\'' +
//                ", avatarUrl='" + avatarUrl + '\'' +
//                ", phoneNumber='" + phoneNumber + '\'' +
//                ", dateOfBirth=" + dateOfBirth +
//                ", gender='" + gender + '\'' +
//                ", address='" + address + '\'' +
//                ", loginProvider='" + loginProvider + '\'' +
//                ", googleId='" + googleId + '\'' +
//                ", isEmailVerified=" + isEmailVerified +
//                ", isActive=" + isActive +
//                ", createdAt=" + createdAt +
//                '}';
//    }
//}

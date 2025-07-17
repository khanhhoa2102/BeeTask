package model;

import java.sql.Timestamp;

public class Invitation {
    private int invitationId;
    private Integer userId;          // Dùng Integer để có thể null
    private String email;            // Thêm để lưu email người được mời
    private int projectId;
    private String status;           // Pending, Accepted, Declined
    private Timestamp sentAt;
    private Timestamp respondedAt;

    public Invitation() {}

    public Invitation(int invitationId, Integer userId, String email, int projectId, String status, Timestamp sentAt, Timestamp respondedAt) {
        this.invitationId = invitationId;
        this.userId = userId;
        this.email = email;
        this.projectId = projectId;
        this.status = status;
        this.sentAt = sentAt;
        this.respondedAt = respondedAt;
    }

    // Getters and Setters
    public int getInvitationId() {
        return invitationId;
    }

    public void setInvitationId(int invitationId) {
        this.invitationId = invitationId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    public Timestamp getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Timestamp respondedAt) {
        this.respondedAt = respondedAt;
    }

    @Override
    public String toString() {
        return "Invitation{" +
                "invitationId=" + invitationId +
                ", userId=" + userId +
                ", email='" + email + '\'' +
                ", projectId=" + projectId +
                ", status='" + status + '\'' +
                ", sentAt=" + sentAt +
                ", respondedAt=" + respondedAt +
                '}';
    }
}

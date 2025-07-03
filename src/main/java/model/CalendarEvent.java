
package model;

import java.util.Date;

public class CalendarEvent {
    private int eventId;
    private int userId;
    private Integer taskId; // NULL được hỗ trợ bằng wrapper
    private String title;
    private String description;
    private Date startTime;
    private Date endTime;
    private Date reminderTime;

    public CalendarEvent() {}

    public CalendarEvent(int eventId, int userId, Integer taskId, String title, String description,
                         Date startTime, Date endTime, Date reminderTime) {
        this.eventId = eventId;
        this.userId = userId;
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.startTime = startTime;
        this.endTime = endTime;
        this.reminderTime = reminderTime;
    }

    // Getters & Setters

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Date getReminderTime() {
        return reminderTime;
    }

    public void setReminderTime(Date reminderTime) {
        this.reminderTime = reminderTime;
    }
}

package model.ai;

import java.util.Date;

public class SimpleCalendarEvent {
    private String title;
    private Date startTime;
    private Date endTime;

    public SimpleCalendarEvent(String title, Date startTime, Date endTime) {
        this.title = title;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public String getTitle() { return title; }
    public Date getStartTime() { return startTime; }
    public Date getEndTime() { return endTime; }
}

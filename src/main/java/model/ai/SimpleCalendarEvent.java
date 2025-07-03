package model.ai;

import java.util.Date;

public class SimpleCalendarEvent {
    private String title;
    private Date start;
    private Date end;

    public SimpleCalendarEvent() {}

    public SimpleCalendarEvent(String title, Date start, Date end) {
        this.title = title;
        this.start = start;
        this.end = end;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }
}

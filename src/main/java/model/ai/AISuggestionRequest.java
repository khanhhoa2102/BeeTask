package model.ai;

import java.util.List;

public class AISuggestionRequest {
    private List<SimpleTask> tasks;
    private List<SimpleCalendarEvent> calendar;

    public AISuggestionRequest(List<SimpleTask> tasks, List<SimpleCalendarEvent> calendar) {
        this.tasks = tasks;
        this.calendar = calendar;
    }

    public List<SimpleTask> getTasks() { return tasks; }
    public List<SimpleCalendarEvent> getCalendar() { return calendar; }
}

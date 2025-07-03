package model.ai;

import java.util.List;

public class AISuggestionRequest {
    private List<SimpleTask> tasks;
    private List<SimpleCalendarEvent> calendar;

    public AISuggestionRequest() {}

    public AISuggestionRequest(List<SimpleTask> tasks, List<SimpleCalendarEvent> calendar) {
        this.tasks = tasks;
        this.calendar = calendar;
    }

    public List<SimpleTask> getTasks() {
        return tasks;
    }

    public void setTasks(List<SimpleTask> tasks) {
        this.tasks = tasks;
    }

    public List<SimpleCalendarEvent> getCalendar() {
        return calendar;
    }

    public void setCalendar(List<SimpleCalendarEvent> calendar) {
        this.calendar = calendar;
    }
}

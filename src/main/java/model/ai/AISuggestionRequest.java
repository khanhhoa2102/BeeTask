package model.ai;

import java.util.List;

public class AISuggestionRequest {

    private SimpleTask targetTask;
    private List<SimpleTask> otherTasks;
    private List<SimpleCalendarEvent> calendar;
    private String projectName;

    public AISuggestionRequest(SimpleTask targetTask, List<SimpleTask> otherTasks,
                                List<SimpleCalendarEvent> calendar, String projectName) {
        this.targetTask = targetTask;
        this.otherTasks = otherTasks;
        this.calendar = calendar;
        this.projectName = projectName;
    }

    public SimpleTask getTargetTask() {
        return targetTask;
    }

    public List<SimpleTask> getOtherTasks() {
        return otherTasks;
    }

    public List<SimpleCalendarEvent> getCalendar() {
        return calendar;
    }

    public String getProjectName() {
        return projectName;
    }
}

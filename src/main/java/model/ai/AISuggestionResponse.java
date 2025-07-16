package model.ai;

import java.util.List;

public class AISuggestionResponse {
    private List<ScheduledTaskSuggestion> schedules;

    public AISuggestionResponse() {}

    public AISuggestionResponse(List<ScheduledTaskSuggestion> schedules) {
        this.schedules = schedules;
    }

    public List<ScheduledTaskSuggestion> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<ScheduledTaskSuggestion> schedules) {
        this.schedules = schedules;
    }
}

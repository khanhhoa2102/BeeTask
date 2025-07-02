package model.ai;

import java.util.List;

public class AISuggestionResponse {
    private List<ScheduledTaskSuggestion> schedules;

    public List<ScheduledTaskSuggestion> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<ScheduledTaskSuggestion> schedules) {
        this.schedules = schedules;
    }
}

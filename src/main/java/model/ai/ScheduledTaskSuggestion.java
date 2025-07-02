package model.ai;

public class ScheduledTaskSuggestion {
    private String title; // trùng với key "title"
    private String start; // trùng với key "start"
    private String end;   // trùng với key "end"
    private double confidence; // optional, mặc định là 0 nếu thiếu

    public ScheduledTaskSuggestion() {
    }

    public ScheduledTaskSuggestion(String title, String start, String end, double confidence) {
        this.title = title;
        this.start = start;
        this.end = end;
        this.confidence = confidence;
    }

    // Getters & Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public double getConfidence() {
        return confidence;
    }

    public void setConfidence(double confidence) {
        this.confidence = confidence;
    }
}

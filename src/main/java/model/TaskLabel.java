
package model;

public class TaskLabel {
    private int taskId;
    private int labelId;

    public TaskLabel(int taskId, int labelId) {
        this.taskId = taskId;
        this.labelId = labelId;
    }


    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getLabelId() {
        return labelId;
    }

    public void setLabelId(int labelId) {
        this.labelId = labelId;
    }

    @Override
    public String toString() {
        return "TaskLabel{" + "taskId=" + taskId + ", labelId=" + labelId + '}';
    }
    
}

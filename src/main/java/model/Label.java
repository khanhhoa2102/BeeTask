package model;

public class Label {
    private int labelId;
    private String name;
    private String color;

    public Label() {
    }

    public Label(int labelId, String name, String color) {
        this.labelId = labelId;
        this.name = name;
        this.color = color;
    }

    public int getLabelId() {
        return labelId;
    }

    public void setLabelId(int labelId) {
        this.labelId = labelId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

   
}

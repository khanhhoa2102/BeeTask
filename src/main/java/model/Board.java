package model;

import java.sql.Timestamp;

public class Board {
    private int boardId;
    private int projectId;
    private String name;
    private String description;
    private Timestamp createdAt;
    private int position;

    public Board() {}

    public Board(int boardId, int projectId, String name, String description, Timestamp createdAt) {
        this.boardId = boardId;
        this.projectId = projectId;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getPosition() { return position; }
    public void setPosition(int position) { this.position = position; }
}

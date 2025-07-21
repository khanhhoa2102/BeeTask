package dao.admin;

import context.DBConnection;
import model.Template;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Label;
import model.TemplateBoard;
import model.TemplateTask;
import model.User;

public class TemplateDAO {
    public List<Template> getAllTemplates() {
        List<Template> templates = new ArrayList<>();
        String sql = "SELECT TemplateId, Name, Description, Category, ThumbnailUrl FROM Templates";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Template t = new Template();
                t.setTemplateId(rs.getInt("TemplateId"));
                t.setName(rs.getString("Name"));
                t.setDescription(rs.getString("Description"));
                t.setCategory(rs.getString("Category"));
                t.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                templates.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return templates;
    }
    
    
    
    
    
    
    
    
    
    public Template getTemplateById(int templateId) {
        String sql = "SELECT TemplateId, Name, Description, Category, ThumbnailUrl FROM Templates WHERE TemplateId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, templateId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Template t = new Template();
                t.setTemplateId(rs.getInt("TemplateId"));
                t.setName(rs.getString("Name"));
                t.setDescription(rs.getString("Description"));
                t.setCategory(rs.getString("Category"));
                t.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                return t;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TemplateBoard> getTemplateBoards(int templateId) {
        List<TemplateBoard> boards = new ArrayList<>();
        String sql = "SELECT TemplateBoardId, TemplateId, Name, Description FROM TemplateBoards WHERE TemplateId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, templateId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                TemplateBoard b = new TemplateBoard();
                b.setTemplateBoardId(rs.getInt("TemplateBoardId"));
                b.setTemplateId(rs.getInt("TemplateId"));
                b.setName(rs.getString("Name"));
                b.setDescription(rs.getString("Description"));
                boards.add(b);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return boards;
    }
//
//    public Map<Integer, List<TemplateTask>> getTemplateTasksByTemplateId(int templateId) {
//        Map<Integer, List<TemplateTask>> taskMap = new HashMap<>();
//        String sql = "SELECT t.TemplateTaskId, t.TemplateBoardId, t.Title, t.Description, t.Status, t.DueDate FROM TemplateTasks t INNER JOIN TemplateBoards b ON t.TemplateBoardId = b.TemplateBoardId WHERE b.TemplateId = ?";
//
//        List<TemplateTask> allTasks = new ArrayList<>();
//
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, templateId);
//            ResultSet rs = stmt.executeQuery();
//            while (rs.next()) {
//                TemplateTask task = new TemplateTask();
//                task.setTemplateTaskId(rs.getInt("TemplateTaskId"));
//                task.setTemplateBoardId(rs.getInt("TemplateBoardId"));
//                task.setTitle(rs.getString("Title"));
//                task.setDescription(rs.getString("Description"));
//                task.setStatus(rs.getString("Status"));
//
//                Timestamp dueTimestamp = rs.getTimestamp("DueDate");
//                if (dueTimestamp != null) {
//                    task.setDueDate(new java.util.Date(dueTimestamp.getTime()));
//                }
//
//                allTasks.add(task);
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        for (TemplateTask task : allTasks) {
//            int boardId = task.getTemplateBoardId();
//            taskMap.computeIfAbsent(boardId, k -> new ArrayList<>()).add(task);
//        }
//
//        return taskMap;
//    }

   

    private List<User> getAssigneesForTask(int templateTaskId) {
        List<User> assignees = new ArrayList<>();
        String sql = "SELECT u.UserId, u.Username, u.AvatarUrl FROM TemplateTaskAssignees t JOIN Users u ON t.UserId = u.UserId WHERE t.TemplateTaskId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, templateTaskId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("UserId"));
                user.setUsername(rs.getString("Username"));
                user.setAvatarUrl(rs.getString("AvatarUrl"));
                assignees.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return assignees;
    }
    
    
    
    

public List<Label> getAllLabels() {
    List<Label> labels = new ArrayList<>();
    String sql = "SELECT LabelId, Name, Color FROM Labels";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Label l = new Label();
            l.setLabelId(rs.getInt("LabelId"));
            l.setName(rs.getString("Name"));
            l.setColor(rs.getString("Color"));
            labels.add(l);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return labels;
}

    
    
 private List<model.Label> getLabelsForTask(int templateTaskId) {
        List<model.Label> labels = new ArrayList<>();
        String sql = "SELECT l.LabelId, l.Name, l.Color FROM TemplateTaskLabels t JOIN Labels l ON t.LabelId = l.LabelId WHERE t.TemplateTaskId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, templateTaskId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                model.Label label = new model.Label();
                label.setLabelId(rs.getInt("LabelId"));
                label.setName(rs.getString("Name"));
                label.setColor(rs.getString("Color"));
                labels.add(label);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return labels;
    }


public List<Label> getLabelsByTaskId(int taskId) {
    List<Label> labels = new ArrayList<>();
    String sql = "SELECT l.labelId, l.name FROM Task_Label tl JOIN Label l ON tl.labelId = l.labelId WHERE tl.taskId = ?";
    try (Connection con =DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, taskId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Label label = new Label();
                label.setLabelId(rs.getInt("labelId"));
                label.setName(rs.getString("name"));
                labels.add(label);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return labels;
}






public Map<Integer, List<TemplateTask>> getTemplateTasksByTemplateId(int templateId) {
    Map<Integer, List<TemplateTask>> taskMap = new HashMap<>();
    String sql = "SELECT t.TemplateTaskId, t.TemplateBoardId, t.Title, t.Description, t.Status, t.DueDate " +
                 "FROM TemplateTasks t " +
                 "INNER JOIN TemplateBoards b ON t.TemplateBoardId = b.TemplateBoardId " +
                 "WHERE b.TemplateId = ?";
    
    List<TemplateTask> allTasks = new ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, templateId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            TemplateTask task = new TemplateTask();
            task.setTemplateTaskId(rs.getInt("TemplateTaskId"));
            task.setTemplateBoardId(rs.getInt("TemplateBoardId"));
            task.setTitle(rs.getString("Title"));
            task.setDescription(rs.getString("Description"));
            task.setStatus(rs.getString("Status"));
            
            Timestamp dueTimestamp = rs.getTimestamp("DueDate");
            if (dueTimestamp != null) {
                task.setDueDate(new java.util.Date(dueTimestamp.getTime()));
            }
            
            // Lấy labels cho task này
            task.setLabels(getLabelsForTemplateTask(task.getTemplateTaskId()));
            
            allTasks.add(task);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    // Nhóm tasks theo boardId
    for (TemplateTask task : allTasks) {
        int boardId = task.getTemplateBoardId();
        taskMap.computeIfAbsent(boardId, k -> new ArrayList<>()).add(task);
    }
    
    return taskMap;
}

// Method helper để lấy labels cho một template task
private List<Label> getLabelsForTemplateTask(int templateTaskId) {
    List<Label> labels = new ArrayList<>();
    String sql = "SELECT l.LabelId, l.Name, l.Color " +
                 "FROM Labels l " +
                 "INNER JOIN TemplateTaskLabels ttl ON l.LabelId = ttl.LabelId " +
                 "WHERE ttl.TemplateTaskId = ?";
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, templateTaskId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Label label = new Label();
            label.setLabelId(rs.getInt("LabelId"));
            label.setName(rs.getString("Name"));
            label.setColor(rs.getString("Color"));
            labels.add(label);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return labels;
}
    
    
}

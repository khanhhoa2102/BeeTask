
package dao.admin;

import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Label;
import model.TemplateTask;


public class TemplateDetailDao {
    
    
    
    public void addTemplateBoard(int templateId, String name, String description) {
    String sql = "INSERT INTO TemplateBoards (TemplateId, Name, Description) VALUES (?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, templateId);
        ps.setString(2, name);
        ps.setString(3, description);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

    
    
  
    
    
  public void updateTemplateBoard(int boardId, String name, String description) {
    String sql = "UPDATE TemplateBoards SET Name = ?, Description = ? WHERE TemplateBoardId = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, name);
        ps.setString(2, description);
        ps.setInt(3, boardId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
  
    
    public void deleteTemplateBoard(int boardId) {
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // 1. Lấy danh sách taskId trong board này
        String getTasksSql = "SELECT TemplateTaskId FROM TemplateTasks WHERE TemplateBoardId = ?";
        List<Integer> taskIds = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(getTasksSql)) {
            ps.setInt(1, boardId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                taskIds.add(rs.getInt("TemplateTaskId"));
            }
        }

        // 2. Xóa các task assignees liên quan
        String deleteAssigneesSql = "DELETE FROM TemplateTaskAssignees WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteAssigneesSql)) {
            for (int taskId : taskIds) {
                ps.setInt(1, taskId);
                ps.executeUpdate();
            }
        }

        // 3. Xóa các task label liên quan
        String deleteLabelsSql = "DELETE FROM TemplateTaskLabels WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteLabelsSql)) {
            for (int taskId : taskIds) {
                ps.setInt(1, taskId);
                ps.executeUpdate();
            }
        }

        // 4. Xóa các task
        String deleteTasksSql = "DELETE FROM TemplateTasks WHERE TemplateBoardId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteTasksSql)) {
            ps.setInt(1, boardId);
            ps.executeUpdate();
        }

        // 5. Xóa board
        String deleteBoardSql = "DELETE FROM TemplateBoards WHERE TemplateBoardId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteBoardSql)) {
            ps.setInt(1, boardId);
            ps.executeUpdate();
        }

        conn.commit();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

  
  
 public void addTemplateTask(int boardId, String title, String description, String status, Timestamp dueDate, List<Integer> labelIds) {
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // 1. Thêm task
        String insertTaskSql = "INSERT INTO TemplateTasks (TemplateBoardId, Title, Description, Status, DueDate) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(insertTaskSql, PreparedStatement.RETURN_GENERATED_KEYS);
        ps.setInt(1, boardId);
        ps.setString(2, title);
        ps.setString(3, description);
        ps.setString(4, status);
        ps.setTimestamp(5, dueDate);
        ps.executeUpdate();

        // 2. Lấy taskId vừa tạo
        ResultSet rs = ps.getGeneratedKeys();
        int taskId = 0;
        if (rs.next()) {
            taskId = rs.getInt(1);
        }

        // 3. Thêm các nhãn (label) vào bảng trung gian
        if (labelIds != null) {
            String insertLabelSql = "INSERT INTO TemplateTaskLabels (TemplateTaskId, LabelId) VALUES (?, ?)";
            try (PreparedStatement psLabel = conn.prepareStatement(insertLabelSql)) {
                for (int labelId : labelIds) {
                    psLabel.setInt(1, taskId);
                    psLabel.setInt(2, labelId);
                    psLabel.executeUpdate();
                }
            }
        }

        conn.commit();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

  
  
  
  public void updateTemplateTask(int taskId, String title, String description, String status, Timestamp dueDate, List<Integer> labelIds) {
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // 1. Cập nhật task
        String sql = "UPDATE TemplateTasks SET Title = ?, Description = ?, Status = ?, DueDate = ? WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, status);
            ps.setTimestamp(4, dueDate);
            ps.setInt(5, taskId);
            ps.executeUpdate();
        }

        // 2. Xóa tất cả nhãn cũ
        String deleteLabelSql = "DELETE FROM TemplateTaskLabels WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteLabelSql)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        }

        // 3. Thêm lại nhãn mới
        if (labelIds != null) {
            String insertLabelSql = "INSERT INTO TemplateTaskLabels (TemplateTaskId, LabelId) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertLabelSql)) {
                for (int labelId : labelIds) {
                    ps.setInt(1, taskId);
                    ps.setInt(2, labelId);
                    ps.executeUpdate();
                }
            }
        }

        conn.commit();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

  
  
  
public void deleteTemplateTask(int taskId) {
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // 1. Xóa assignees liên quan
        String deleteAssigneesSql = "DELETE FROM TemplateTaskAssignees WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteAssigneesSql)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        }

        // 2. Xóa labels liên quan
        String deleteLabelsSql = "DELETE FROM TemplateTaskLabels WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteLabelsSql)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        }

        // 3. Xóa task chính
        String deleteTaskSql = "DELETE FROM TemplateTasks WHERE TemplateTaskId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteTaskSql)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        }

        conn.commit();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

  
  


  
// Thêm vào TemplateDetailDao class

// Method để lấy thông tin task theo ID
public TemplateTask getTemplateTaskById(int taskId) {
    String sql = "SELECT t.TemplateTaskId, t.TemplateBoardId, t.Title, t.Description, t.Status, t.DueDate " +
                 "FROM TemplateTasks t WHERE t.TemplateTaskId = ?";
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, taskId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
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
            task.setLabels(getLabelsForTemplateTask(taskId));
            
            return task;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return null;
}

// Method để lấy tất cả labels
public List<Label> getAllLabels() {
    List<Label> labels = new ArrayList<>();
    String sql = "SELECT LabelId, Name, Color FROM Labels ORDER BY Name";
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
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

// Method helper để lấy labels cho một template task (nếu chưa có)
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

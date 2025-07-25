package dao;

import context.DBConnection;
import model.TaskAttachment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskAttachmentDAO {

    public void insertAttachment(TaskAttachment attachment) {
        String sql = "INSERT INTO TaskAttachments (TaskId, FileUrl, FileName, FileType, FileSize) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, attachment.getTaskId());
            ps.setString(2, attachment.getFileUrl());
            ps.setString(3, attachment.getFileName());
            ps.setString(4, attachment.getFileType());
            ps.setInt(5, attachment.getFileSize());
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<TaskAttachment> getAttachmentsByTaskId(int taskId) {
        List<TaskAttachment> attachments = new ArrayList<>();
        String sql = "SELECT * FROM TaskAttachments WHERE TaskId = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TaskAttachment attachment = new TaskAttachment();
                attachment.setAttachmentId(rs.getInt("AttachmentId"));
                attachment.setTaskId(rs.getInt("TaskId"));
                attachment.setFileUrl(rs.getString("FileUrl"));
                attachment.setFileName(rs.getString("FileName"));
                attachment.setFileType(rs.getString("FileType"));
                attachment.setFileSize(rs.getInt("FileSize"));
                attachments.add(attachment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attachments;
    }
        public int insertAttachmentAndReturnId(TaskAttachment attachment) {
        String sql = "INSERT INTO TaskAttachments (TaskId, FileUrl, FileName, FileType, FileSize) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, attachment.getTaskId());
            ps.setString(2, attachment.getFileUrl());
            ps.setString(3, attachment.getFileName());
            ps.setString(4, attachment.getFileType());
            ps.setInt(5, attachment.getFileSize());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // attachmentId
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}
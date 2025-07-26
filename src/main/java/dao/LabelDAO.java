package dao;

import context.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Label;

public class LabelDAO {
    public static List<Label> getAllLabels() throws SQLException {
        List<Label> labels = new ArrayList<>();
        String sql = "SELECT * FROM Labels";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                labels.add(new Label(
                    rs.getInt("LabelId"),
                    rs.getString("Name"),
                    rs.getString("Color")
                ));
            }
        }
        return labels;
    }
    
    public static boolean createLabel(String name, String color) throws SQLException {
        String sql = "INSERT INTO Labels (Name, Color) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, name);
            stmt.setString(2, color);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}

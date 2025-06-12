package dao;

import context.DBConnection;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public List<User> findAll() throws Exception {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User user = new User(
                        rs.getInt("UserId"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("AvatarUrl"),
                        rs.getBoolean("IsActive"),
                        rs.getTimestamp("CreatedAt")
                );
                list.add(user);
            }
        }
        return list;
    }

    public User findById(int id) throws Exception {
        String sql = "SELECT * FROM Users WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("UserId"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("PasswordHash"),
                            rs.getString("AvatarUrl"),
                            rs.getBoolean("IsActive"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        }
        return null;
    }

    public void insert(User user) throws Exception {
        String sql = "INSERT INTO Users (FullName, Email, PasswordHash, AvatarUrl) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getAvatarUrl());
            stmt.executeUpdate();
        }
    }

    public void update(User user) throws Exception {
        String sql = "UPDATE Users SET FullName=?, Email=?, PasswordHash=?, AvatarUrl=?, IsActive=? WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getAvatarUrl());
            stmt.setBoolean(5, user.isActive());
            stmt.setInt(6, user.getUserId());
            stmt.executeUpdate();
        }
    }

    public void delete(int userId) throws Exception {
        String sql = "DELETE FROM Users WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    // ✅ Login kiểm tra trực tiếp email và mật khẩu
    public User checkLogin(String email, String password) throws Exception {
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("UserId"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("AvatarUrl"),
                        rs.getBoolean("IsActive"),
                        rs.getTimestamp("CreatedAt")
                );
            }
        }
        return null;
    }

    public static User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("UserId"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("AvatarUrl"),
                        rs.getBoolean("IsActive"),
                        rs.getTimestamp("CreatedAt")
                );
            }
        }
        return null;
    }

    public static void insertUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (FullName, Email, PasswordHash, AvatarUrl, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getAvatarUrl());
            ps.setBoolean(5, user.isActive());
            ps.setTimestamp(6, user.getCreatedAt());
            ps.executeUpdate();
        }
    }
}

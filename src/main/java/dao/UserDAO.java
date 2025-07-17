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
                list.add(extractUser(rs));
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
                    return extractUser(rs);
                }
            }
        }
        return null;
    }

    public User findByEmail(String email) throws Exception {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }
        }
        return null;
    }

    public void insert(User user) throws Exception {
    String sql = "INSERT INTO Users (Username, Email, PasswordHash, AvatarUrl, PhoneNumber, DateOfBirth, Gender, Address, LoginProvider, GoogleId, IsEmailVerified, IsActive) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        stmt.setString(1, user.getUsername());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPasswordHash());
        stmt.setString(4, user.getAvatarUrl());
        stmt.setString(5, user.getPhoneNumber());
        stmt.setDate(6, user.getDateOfBirth());
        stmt.setString(7, user.getGender());
        stmt.setString(8, user.getAddress());
        stmt.setString(9, user.getLoginProvider());
        stmt.setString(10, user.getGoogleId());
        stmt.setBoolean(11, user.isEmailVerified());
        stmt.setBoolean(12, user.isActive());

        stmt.executeUpdate();

        // ✅ Lấy UserId được sinh ra và gán lại vào đối tượng
        try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                int newUserId = generatedKeys.getInt(1);
                user.setUserId(newUserId);
                System.out.println("✅ Created user with ID: " + newUserId);
            } else {
                throw new Exception("❌ Failed to retrieve generated user ID.");
            }
        }
    }
}


    public void update(User user) throws Exception {
        String sql = "UPDATE Users SET Username=?, Email=?, PasswordHash=?, AvatarUrl=?, PhoneNumber=?, DateOfBirth=?, Gender=?, Address=?, LoginProvider=?, GoogleId=?, IsEmailVerified=?, IsActive=? WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getAvatarUrl());
            stmt.setString(5, user.getPhoneNumber());
            stmt.setDate(6, user.getDateOfBirth());
            stmt.setString(7, user.getGender());
            stmt.setString(8, user.getAddress());
            stmt.setString(9, user.getLoginProvider());
            stmt.setString(10, user.getGoogleId());
            stmt.setBoolean(11, user.isEmailVerified());
            stmt.setBoolean(12, user.isActive());
            stmt.setInt(13, user.getUserId());
            stmt.executeUpdate();
        }
    }

    public void delete(int userId) throws Exception {
        String sql = "DELETE FROM Users WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    // Đăng nhập qua email và password
    public User login(String email, String passwordHash) throws Exception {
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ? AND IsActive = 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, passwordHash);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }
        }
        return null;
    }

    // Đăng nhập bằng GoogleId
    public User findByGoogleId(String googleId) throws Exception {
        String sql = "SELECT * FROM Users WHERE GoogleId = ? AND LoginProvider = 'Google'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, googleId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }
        }
        return null;
    }

    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserId"));
        user.setUsername(rs.getString("Username"));
        user.setEmail(rs.getString("Email"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setAvatarUrl(rs.getString("AvatarUrl"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setDateOfBirth(rs.getDate("DateOfBirth"));
        user.setGender(rs.getString("Gender"));
        user.setAddress(rs.getString("Address"));
        user.setLoginProvider(rs.getString("LoginProvider"));
        user.setGoogleId(rs.getString("GoogleId"));
        user.setEmailVerified(rs.getBoolean("IsEmailVerified"));
        user.setActive(rs.getBoolean("IsActive"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        user.setRole(rs.getString("Role"));
        return user;
    }

    public boolean isEmailExist(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean updateRole(int userId) throws Exception {
        String sql = "UPDATE Users SET Role = 'Premium' WHERE UserId = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND IsActive = 1";

        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("UserId"),
                            rs.getString("Username"),
                            rs.getString("Email"),
                            rs.getString("PasswordHash"),
                            rs.getString("AvatarUrl"),
                            rs.getString("PhoneNumber"),
                            rs.getDate("DateOfBirth"),
                            rs.getString("Gender"),
                            rs.getString("Address"),
                            rs.getString("LoginProvider"),
                            rs.getString("GoogleId"),
                            rs.getBoolean("IsEmailVerified"),
                            rs.getBoolean("IsActive"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getString("Role") // role đã được bạn thêm trong model
                    );
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi truy vấn người dùng theo email: " + e.getMessage());
        }

        return null;
    }
}

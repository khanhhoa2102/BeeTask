package dao;

import context.DBConnection;
import model.User;
import java.sql.*;

public class UserProfileDAO {

    public static User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE userId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setAvatarUrl(rs.getString("avatarUrl"));
                user.setGender(rs.getString("gender"));
                user.setAddress(rs.getString("address"));
                user.setDateOfBirth(rs.getDate("dateOfBirth"));
                // Có thể in debug tại đây nếu cần
                System.out.println("[DEBUG] getUserById: user loaded = " + user);
                return user;
            } else {
                System.err.println("[DEBUG] getUserById: Không tìm thấy user với ID = " + userId);
            }

        } catch (Exception e) {
            System.err.println("[ERROR] getUserById: Lỗi khi truy vấn userId = " + userId);
            e.printStackTrace();
        }
        return null;
    }

    public static boolean updateUserProfile(User user) {
        String sql = "UPDATE Users SET Username = ?, PhoneNumber = ?, AvatarUrl = ?, Gender = ?, DateOfBirth = ?, Address = ? WHERE UserId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Kiểm tra UserId tồn tại
            User existingUser = getUserById(user.getUserId());
            if (existingUser == null) {
                System.err.println("⚠️ [DAO] UserId " + user.getUserId() + " không tồn tại!");
                return false;
            }

            // Kiểm tra Username không rỗng
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                System.err.println("⚠️ [DAO] Username không được để trống!");
                return false;
            }

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getAvatarUrl());
            stmt.setString(4, user.getGender());
            stmt.setDate(5, user.getDateOfBirth());
            stmt.setString(6, user.getAddress());
            stmt.setInt(7, user.getUserId());

            // Log dữ liệu
            System.out.println("\n🔵 [DAO] Đang cập nhật user:");
            System.out.println(" - UserId: " + user.getUserId());
            System.out.println(" - Username: " + user.getUsername());
            System.out.println(" - Phone: " + user.getPhoneNumber());
            System.out.println(" - Avatar: " + user.getAvatarUrl());
            System.out.println(" - Gender: " + user.getGender());
            System.out.println(" - DOB: " + user.getDateOfBirth());
            System.out.println(" - Address: " + user.getAddress());

            int rows = stmt.executeUpdate();
            System.out.println("✅ [DAO] Rows updated: " + rows);

            if (rows == 0) {
                System.err.println("⚠️ [DAO] Không có dòng nào được cập nhật! Kiểm tra UserId hoặc dữ liệu giống hệt.");
            }

            return rows > 0;

        } catch (SQLException e) {
            System.err.println("❌ [DAO] SQLException khi cập nhật hồ sơ:");
            System.err.println(" - SQLState: " + e.getSQLState());
            System.err.println(" - ErrorCode: " + e.getErrorCode());
            System.err.println(" - Message: " + e.getMessage());
            e.printStackTrace();
            return false;

        } catch (Exception ex) {
            System.err.println("❌ [DAO] Lỗi không xác định khi cập nhật hồ sơ:");
            ex.printStackTrace();
            return false;
        }
    }
}

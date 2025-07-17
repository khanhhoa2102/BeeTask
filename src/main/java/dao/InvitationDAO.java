package dao;

import context.DBConnection;
import model.Invitation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvitationDAO {

    // CREATE
    public boolean addInvitation(Invitation invitation) {
        String sql = "INSERT INTO Invitations (UserId, Email, ProjectId, Status, SentAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (invitation.getUserId() != null) {
                stmt.setInt(1, invitation.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setString(2, invitation.getEmail());
            stmt.setInt(3, invitation.getProjectId());
            stmt.setString(4, invitation.getStatus());
            stmt.setTimestamp(5, invitation.getSentAt());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ: Lấy tất cả lời mời của một user
    public List<Invitation> getInvitationsByUserId(int userId) {
        List<Invitation> invitations = new ArrayList<>();
        String sql = "SELECT * FROM Invitations WHERE UserId = ? ORDER BY SentAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Invitation invitation = mapResultSetToInvitation(rs);
                invitations.add(invitation);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invitations;
    }

    // READ: Lấy lời mời theo user + project
    public Invitation getInvitation(int userId, int projectId, String token) {
        String sql = "SELECT * FROM Invitations WHERE UserId = ? AND ProjectId = ? AND Token = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, projectId);
            stmt.setString(3, token);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToInvitation(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE: Accept or Decline
    public boolean updateInvitationStatus(int invitationId, String newStatus) {
        String sql = "UPDATE Invitations SET Status = ?, RespondedAt = ? WHERE InvitationId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(3, invitationId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    public boolean deleteInvitation(int invitationId) {
        String sql = "DELETE FROM Invitations WHERE InvitationId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, invitationId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Gán userId cho invitation sau khi người dùng đăng ký
    public boolean updateUserIdForEmail(String email, int userId) {
        if (email == null) {
            return false;
        }

        String sql = "UPDATE Invitations SET UserId = ? WHERE Email = ? AND UserId IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper: Chuyển từ ResultSet → Invitation
    private Invitation mapResultSetToInvitation(ResultSet rs) throws SQLException {
        Invitation inv = new Invitation();
        int userId = rs.getInt("UserId");
        inv.setUserId(rs.wasNull() ? null : userId);
        inv.setEmail(rs.getString("Email"));
        inv.setInvitationId(rs.getInt("InvitationId"));
        inv.setProjectId(rs.getInt("ProjectId"));
        inv.setStatus(rs.getString("Status"));
        inv.setSentAt(rs.getTimestamp("SentAt"));
        inv.setRespondedAt(rs.getTimestamp("RespondedAt"));
        return inv;
    }

    // Lấy invitation theo ID
    public Invitation getInvitationById(int invitationId) {
        String sql = "SELECT * FROM Invitations WHERE InvitationId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, invitationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToInvitation(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra đã mời email này chưa
    public boolean isAlreadyInvited(String email, int projectId) {
        String sql = "SELECT COUNT(*) FROM Invitations WHERE Email = ? AND ProjectId = ? AND Status = 'Pending'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setInt(2, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int createInvitation(Invitation invitation) {
        String sql = "INSERT INTO Invitations (UserId, Email, ProjectId, Status, SentAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (invitation.getUserId() != null) {
                stmt.setInt(1, invitation.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setString(2, invitation.getEmail());
            stmt.setInt(3, invitation.getProjectId());
            stmt.setString(4, invitation.getStatus());
            stmt.setTimestamp(5, invitation.getSentAt());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Invitation> getPendingInvitationsByEmail(String email) {
        List<Invitation> invitations = new ArrayList<>();
        String sql = "SELECT * FROM Invitations WHERE Email = ? AND Status = 'Pending'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                invitations.add(mapResultSetToInvitation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invitations;
    }

    public List<Invitation> getAcceptedInvitationsWithoutMembership(int userId) {
        List<Invitation> list = new ArrayList<>();
        String sql = "SELECT i.* FROM Invitations i "
                + "WHERE i.UserId = ? AND i.Status = 'Accepted' "
                + "AND NOT EXISTS (SELECT 1 FROM ProjectMembers pm WHERE pm.ProjectId = i.ProjectId AND pm.UserId = ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Invitation inv = new Invitation(
                        rs.getInt("InvitationId"),
                        rs.getInt("UserId"),
                        rs.getString("Email"),
                        rs.getInt("ProjectId"),
                        rs.getString("Status"),
                        rs.getTimestamp("SentAt"),
                        rs.getTimestamp("RespondedAt")
                );
                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

}

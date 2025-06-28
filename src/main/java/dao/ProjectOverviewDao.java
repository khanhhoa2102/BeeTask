package dao;

import model.ProjectOverview;
import context.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectOverviewDao {

    public List<ProjectOverview> getProjectsByLeaderId(int leaderUserId) throws SQLException {
        List<ProjectOverview> list = new ArrayList<>();

        String sql =
    "SELECT " +
    "p.ProjectId, p.Name AS ProjectName, p.Description AS ProjectDescription, " +
    "pu.Username AS ProjectCreatedBy, p.CreatedAt AS ProjectCreatedAt, " +
    "u.UserId, u.Username AS UserName, pm.Role AS UserRole, " +
    "t.TaskId, t.Title AS TaskTitle, t.Description AS TaskDescription, " +
    "t.DueDate, t.CreatedAt AS TaskCreatedAt, " +
    "tu.Username AS TaskCreatedBy, ts.Name AS TaskStatus " +
    "FROM Projects p " +
    "JOIN Users pu ON p.CreatedBy = pu.UserId " +
    "JOIN ProjectMembers pm ON pm.ProjectId = p.ProjectId " +
    "JOIN Users u ON u.UserId = pm.UserId " +
    "JOIN Boards b ON b.ProjectId = p.ProjectId " +
    "JOIN Tasks t ON t.BoardId = b.BoardId " +
    "JOIN TaskStatuses ts ON ts.StatusId = t.StatusId " +
    "JOIN TaskAssignees ta ON ta.TaskId = t.TaskId AND ta.UserId = pm.UserId " +
    "JOIN Users tu ON tu.UserId = t.CreatedBy " +
    // CHỈ LẤY PROJECT MÀ USER LÀ LEADER
    "WHERE p.ProjectId IN ( " +
    "    SELECT ProjectId FROM ProjectMembers WHERE UserId = ? AND Role = 'Leader' " +
    ") " +
    "ORDER BY p.ProjectId, u.Username, t.TaskId";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, leaderUserId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProjectOverview po = new ProjectOverview(
                        rs.getInt("ProjectId"),
                        rs.getString("ProjectName"),
                        rs.getString("ProjectDescription"),
                        rs.getString("ProjectCreatedBy"),
                        rs.getString("ProjectCreatedAt"),
                        rs.getInt("UserId"),
                        rs.getString("UserName"),
                        rs.getString("UserRole"),
                        rs.getInt("TaskId"),
                        rs.getString("TaskTitle"),
                        rs.getString("TaskDescription"),
                        rs.getString("DueDate"),
                        rs.getString("TaskCreatedAt"),
                        rs.getString("TaskCreatedBy"),
                        rs.getString("TaskStatus")
                    );
                    list.add(po);
                }
            }
        }

        return list;
    }
}

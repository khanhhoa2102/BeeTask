package dao;

import context.DBConnection;
import model.Project;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class ProjectDAO {

    // Get project by ID (Task1)
    public Project getProjectById(int projectId) {
        String sql = "SELECT * FROM Projects WHERE ProjectId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("ProjectId"));
                project.setName(rs.getString("Name"));
                project.setDescription(rs.getString("Description"));
                project.setCreatedBy(rs.getInt("CreatedBy"));
                project.setCreatedAt(rs.getTimestamp("CreatedAt"));

                System.out.println("Found project: " + project.getName());
                return project;
            } else {
                System.out.println("No project found with ID: " + projectId);
            }

        } catch (SQLException e) {
            System.err.println("Error getting project by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public int insert(Project project) {
        String sql = "INSERT INTO Projects (Name, Description, CreatedBy, CreatedAt) VALUES (?, ?, ?, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, project.getName());
            stmt.setString(2, project.getDescription());
            stmt.setInt(3, project.getCreatedBy());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Inserting project failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int projectId = generatedKeys.getInt(1);
                    System.out.println("Inserted ProjectId: " + projectId);
                    return projectId;
                } else {
                    throw new SQLException("Inserting project failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error inserting project: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }
    
    public void addProjectMember(int projectId, int userId, String role) {
        String sql = "INSERT INTO ProjectMembers (ProjectId, UserId, Role) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, userId);
            stmt.setString(3, role);

            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error adding project member: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Update project (Task1)
    public void update(Project project) {
        String sql = "UPDATE Projects SET Name = ?, Description = ? WHERE ProjectId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, project.getName());
            stmt.setString(2, project.getDescription());
            stmt.setInt(3, project.getProjectId());

            int result = stmt.executeUpdate();
            System.out.println("Project updated successfully. Rows affected: " + result);

        } catch (SQLException e) {
            System.err.println("Error updating project: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Delete project (Task1 - with cascading)
    public void delete(int projectId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                String deleteTasksSQL = "DELETE FROM Tasks WHERE BoardId IN (SELECT BoardId FROM Boards WHERE ProjectId = ?)";
                try (PreparedStatement stmt1 = conn.prepareStatement(deleteTasksSQL)) {
                    stmt1.setInt(1, projectId);
                    stmt1.executeUpdate();
                }

                String deleteBoardsSQL = "DELETE FROM Boards WHERE ProjectId = ?";
                try (PreparedStatement stmt2 = conn.prepareStatement(deleteBoardsSQL)) {
                    stmt2.setInt(1, projectId);
                    stmt2.executeUpdate();
                }

                String deleteProjectSQL = "DELETE FROM Projects WHERE ProjectId = ?";
                try (PreparedStatement stmt3 = conn.prepareStatement(deleteProjectSQL)) {
                    stmt3.setInt(1, projectId);
                    stmt3.executeUpdate();
                }

                conn.commit();
                System.out.println("Project deleted successfully with ID: " + projectId);

            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            System.err.println("Error deleting project: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Get all projects (Task1)
    public List<Project> getAllProjects() {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT * FROM Projects ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("ProjectId"));
                project.setName(rs.getString("Name"));
                project.setDescription(rs.getString("Description"));
                project.setCreatedBy(rs.getInt("CreatedBy"));
                project.setCreatedAt(rs.getTimestamp("CreatedAt"));

                projects.add(project);
            }

            System.out.println("Found " + projects.size() + " projects");

        } catch (SQLException e) {
            System.err.println("Error getting all projects: " + e.getMessage());
            e.printStackTrace();
        }

        return projects;
    }

    // Get projects by user ID (Task1)
    public List<Project> getProjectsByUserId(int userId) {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT DISTINCT p.* FROM Projects p "
                + "LEFT JOIN ProjectMembers pm ON p.ProjectId = pm.ProjectId "
                + "WHERE p.CreatedBy = ? OR pm.UserId = ? "
                + "ORDER BY p.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("ProjectId"));
                project.setName(rs.getString("Name"));
                project.setDescription(rs.getString("Description"));
                project.setCreatedBy(rs.getInt("CreatedBy"));
                project.setCreatedAt(rs.getTimestamp("CreatedAt"));

                projects.add(project);
            }

            System.out.println("Found " + projects.size() + " projects for user " + userId);

        } catch (SQLException e) {
            System.err.println("Error getting projects by user ID: " + e.getMessage());
            e.printStackTrace();
        }

        return projects;
    }

    // Get top 3 projects by user (main)
    public List<Project> getTop3ProjectsByUser(int userId) throws SQLException {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT TOP 3 p.ProjectId, p.Name, p.Description, p.CreatedBy, p.CreatedAt "
                + "FROM Projects p "
                + "INNER JOIN ProjectMembers pm ON p.ProjectId = pm.ProjectId "
                + "WHERE pm.UserId = ? "
                + "ORDER BY p.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Project p = new Project(
                            rs.getInt("ProjectId"),
                            rs.getString("Name"),
                            rs.getString("Description"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt")
                    );
                    projects.add(p);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return projects;
    }

    // Find all projects (main)
    public List<Project> findAll() throws Exception {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM Projects";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Project project = new Project(
                        rs.getInt("ProjectId"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getInt("CreatedBy"),
                        rs.getTimestamp("CreatedAt")
                );
                list.add(project);
            }
        }

        return list;
    }

    public int insertAndReturnId(Project project) throws SQLException {
        String sql = "INSERT INTO Projects (Name, Description, CreatedBy, CreatedAt) VALUES (?, ?, ?, GETDATE())";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, project.getName());
            stmt.setString(2, project.getDescription());
            stmt.setInt(3, project.getCreatedBy());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        throw new SQLException("Unable to retrieve generated project ID");
    }

    public List<User> getMembersByProjectId(int projectId) {
        List<User> members = new ArrayList<>();

        String sql = "SELECT u.UserId, u.Username, u.Email, pm.Role "
                + "FROM ProjectMembers pm "
                + "JOIN Users u ON pm.UserId = u.UserId "
                + "WHERE pm.ProjectId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("UserId"));
                user.setUsername(rs.getString("Username"));
                user.setEmail(rs.getString("Email"));
                user.setRole(rs.getString("Role"));
                members.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return members;
    }

// Hàm thêm thành viên vào project nếu chưa tồn tại
    public boolean addMemberToProject(int projectId, int userId, String role) {
        String checkSql = "SELECT * FROM ProjectMembers WHERE ProjectId = ? AND UserId = ?";
        String insertSql = "INSERT INTO ProjectMembers (ProjectId, UserId, Role) VALUES (?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection()) {

            // 1. Kiểm tra xem đã là thành viên chưa
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, projectId);
                checkStmt.setInt(2, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        // Đã tồn tại
                        return false;
                    }
                }
            }

            // 2. Nếu chưa thì thêm
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, projectId);
                insertStmt.setInt(2, userId);
                insertStmt.setString(3, role);
                insertStmt.executeUpdate();
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isUserInProject(int projectId, int userId) {
        String sql = "SELECT 1 FROM ProjectMembers WHERE ProjectId = ? AND UserId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Trả về true nếu có bản ghi
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<User> getUsersByProjectId(int projectId) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* FROM Users u JOIN ProjectMembers pm ON u.UserId = pm.UserId WHERE pm.ProjectId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserId"));
                    user.setUsername(rs.getString("Username"));
                    user.setEmail(rs.getString("Email"));
                    // add other fields if needed
                    users.add(user);
                }
            }
        }
        return users;
    }

    public boolean isLeaderOfProject(int userId, int projectId) {
        String sql = "SELECT Role FROM ProjectMembers WHERE ProjectId = ? AND UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("Role");
                return "Leader".equalsIgnoreCase(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Project> getProjectsByLeaderId(int userId) {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT * FROM Projects WHERE CreatedBy = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project(
                        rs.getInt("ProjectId"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getInt("CreatedBy"),
                        rs.getTimestamp("CreatedAt")
                );
                projects.add(project);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return projects;
    }

}
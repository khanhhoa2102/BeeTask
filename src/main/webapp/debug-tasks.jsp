<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.TaskDAO, dao.BoardDAO, dao.ProjectDAO, dao.TaskStatusDAO" %>
<%@ page import="model.Task, model.Board, model.Project" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Debug Tasks</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-section { margin: 20px 0; padding: 15px; border: 1px solid #ccc; }
        .error { color: red; }
        .success { color: green; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>BeeTask Debug Page</h1>
    
    <%
        TaskDAO taskDAO = new TaskDAO();
        BoardDAO boardDAO = new BoardDAO();
        ProjectDAO projectDAO = new ProjectDAO();
        TaskStatusDAO statusDAO = new TaskStatusDAO();
        
        String projectIdParam = request.getParameter("projectId");
        int projectId = 1; // Default project ID
        
        if (projectIdParam != null && !projectIdParam.trim().isEmpty()) {
            try {
                projectId = Integer.parseInt(projectIdParam);
            } catch (NumberFormatException e) {
                out.println("<p class='error'>Invalid project ID: " + projectIdParam + "</p>");
            }
        }
        
        // Load status map
        Map<Integer, String> statusMap = statusDAO.getAllStatuses();
    %>
    
    <div class="debug-section">
        <h2>Project Information</h2>
        <form method="get">
            <label>Project ID: <input type="number" name="projectId" value="<%= projectId %>" /></label>
            <input type="submit" value="Load Project" />
        </form>
        
        <%
            try {
                Project project = projectDAO.getProjectById(projectId);
                if (project != null) {
                    out.println("<p class='success'>Project found: " + project.getName() + "</p>");
                } else {
                    out.println("<p class='error'>Project not found with ID: " + projectId + "</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error loading project: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Task Status Map</h2>
        <%
            if (statusMap.isEmpty()) {
                out.println("<p class='error'>No task statuses found!</p>");
            } else {
                out.println("<p class='success'>Found " + statusMap.size() + " task statuses</p>");
        %>
        <table>
            <tr>
                <th>Status ID</th>
                <th>Status Name</th>
            </tr>
            <%
                for (Map.Entry<Integer, String> entry : statusMap.entrySet()) {
            %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= entry.getValue() %></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>All Tasks in Database</h2>
        <%
            try {
                List<Task> allTasks = taskDAO.getAllTasks();
                if (allTasks.isEmpty()) {
                    out.println("<p class='error'>No tasks found in database!</p>");
                } else {
                    out.println("<p class='success'>Found " + allTasks.size() + " tasks</p>");
        %>
        <table>
            <tr>
                <th>Task ID</th>
                <th>Board ID</th>
                <th>Title</th>
                <th>Description</th>
                <th>Status ID</th>
                <th>Status Name</th>
                <th>Priority</th>
                <th>Due Date</th>
                <th>Position</th>
            </tr>
            <%
                for (Task task : allTasks) {
                    String statusName = statusMap.get(task.getStatusId());
                    if (statusName == null) statusName = "Unknown";
            %>
            <tr>
                <td><%= task.getTaskId() %></td>
                <td><%= task.getBoardId() %></td>
                <td><%= task.getTitle() %></td>
                <td><%= task.getDescription() %></td>
                <td><%= task.getStatusId() %></td>
                <td><%= statusName %></td>
                <td><%= task.getPriority() %></td>
                <td><%= task.getDueDate() %></td>
                <td><%= task.getPosition() %></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error loading tasks: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Boards for Project <%= projectId %></h2>
        <%
            try {
                List<Board> boards = boardDAO.getBoardsByProjectId(projectId);
                if (boards.isEmpty()) {
                    out.println("<p class='error'>No boards found for project " + projectId + "</p>");
                } else {
                    out.println("<p class='success'>Found " + boards.size() + " boards</p>");
        %>
        <table>
            <tr>
                <th>Board ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Position</th>
            </tr>
            <%
                for (Board board : boards) {
            %>
            <tr>
                <td><%= board.getBoardId() %></td>
                <td><%= board.getName() %></td>
                <td><%= board.getDescription() %></td>
                <td><%= board.getPosition() %></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error loading boards: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Tasks Grouped by Board for Project <%= projectId %></h2>
        <%
            try {
                Map<Integer, List<Task>> tasksMap = taskDAO.getTasksByProjectIdGrouped(projectId);
                if (tasksMap.isEmpty()) {
                    out.println("<p class='error'>No tasks found for project " + projectId + "</p>");
                } else {
                    out.println("<p class='success'>Found tasks in " + tasksMap.size() + " boards</p>");
                    
                    for (Map.Entry<Integer, List<Task>> entry : tasksMap.entrySet()) {
                        int boardId = entry.getKey();
                        List<Task> tasks = entry.getValue();
                        
                        out.println("<h3>Board ID: " + boardId + " (" + tasks.size() + " tasks)</h3>");
        %>
        <table>
            <tr>
                <th>Task ID</th>
                <th>Title</th>
                <th>Status ID</th>
                <th>Status Name</th>
                <th>Priority</th>
                <th>Due Date</th>
            </tr>
            <%
                        for (Task task : tasks) {
                            String statusName = statusMap.get(task.getStatusId());
                            if (statusName == null) statusName = "Unknown";
            %>
            <tr>
                <td><%= task.getTaskId() %></td>
                <td><%= task.getTitle() %></td>
                <td><%= task.getStatusId() %></td>
                <td><%= statusName %></td>
                <td><%= task.getPriority() %></td>
                <td><%= task.getDueDate() %></td>
            </tr>
            <%
                        }
            %>
        </table>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error loading grouped tasks: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Database Connection Test</h2>
        <%
            try {
                java.sql.Connection conn = context.DBConnection.getConnection();
                if (conn != null && !conn.isClosed()) {
                    out.println("<p class='success'>Database connection successful!</p>");
                    conn.close();
                } else {
                    out.println("<p class='error'>Database connection failed!</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Database connection error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <p><a href="Task.jsp?projectId=<%= projectId %>">Back to Task Page</a></p>
</body>
</html>
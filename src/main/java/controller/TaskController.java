package controller;

import dao.TaskDAO;
import dao.TaskStatusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Task;
import model.User;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/task")
public class TaskController extends HttpServlet {
    private TaskDAO taskDAO;
    private TaskStatusDAO statusDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
        statusDAO = new TaskStatusDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        System.out.println("🎯 TaskController received action: " + action);
        
        try {
            switch (action) {
                case "move":
                    moveTask(request, response);
                    break;
                case "create":
                    createTask(request, response);
                    break;
                case "delete":
                    deleteTask(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (Exception e) {
            System.err.println("❌ Error in TaskController: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request: " + e.getMessage());
        }
    }

    private void moveTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            int newBoardId = Integer.parseInt(request.getParameter("newBoardId"));
            int newIndex = Integer.parseInt(request.getParameter("newIndex"));

            System.out.println("🔄 Moving task " + taskId + " to board " + newBoardId + " at position " + newIndex);
            
            taskDAO.moveTaskToBoard(taskId, newBoardId, newIndex);
            response.setStatus(HttpServletResponse.SC_OK);
            
        } catch (Exception e) {
            System.err.println("❌ Error moving task: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Get user from session
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                System.out.println("❌ User not logged in");
                response.sendRedirect("/BeeTask/Authentication/Login.jsp");
                return;
            }

            int boardId = Integer.parseInt(request.getParameter("boardId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String statusName = request.getParameter("status");
            String priority = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");
            
            System.out.println("➕ Creating task: " + title + " for board " + boardId);

            // Get status ID from status name
            int statusId = statusDAO.getStatusId(statusName);
            
            Task task = new Task();
            task.setBoardId(boardId);
            task.setTitle(title);
            task.setDescription(description != null ? description : "");
            task.setStatusId(statusId);
            task.setPriority(priority != null ? priority : "Medium");
            task.setCreatedBy(user.getUserId());
            
            // Handle due date
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                task.setDueDate(Date.valueOf(dueDateStr));
            }

            taskDAO.insert(task);
            System.out.println("✅ Task created successfully");
            
            // Redirect back to the task page
            String referer = request.getHeader("Referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect("Task.jsp");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error creating task: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=" + e.getMessage());
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            System.out.println("🗑️ Deleting task: " + taskId);
            
            taskDAO.delete(taskId);
            System.out.println("✅ Task deleted successfully");
            
            String referer = request.getHeader("Referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect("Task.jsp");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error deleting task: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=" + e.getMessage());
        }
    }
}

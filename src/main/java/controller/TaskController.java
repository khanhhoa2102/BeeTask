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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getTask".equals(action)) {
            getTaskForEdit(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid GET action");
        }
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
                case "edit":
                    editTask(request, response);
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

    private void getTaskForEdit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            Task task = taskDAO.getTaskById(taskId);

            if (task != null) {
                // Return task data as JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                String json = String.format(
                        "{\"taskId\":%d,\"title\":\"%s\",\"description\":\"%s\",\"statusId\":%d,\"priority\":\"%s\",\"dueDate\":\"%s\"}",
                        task.getTaskId(),
                        task.getTitle().replace("\"", "\\\""),
                        task.getDescription().replace("\"", "\\\""),
                        task.getStatusId(),
                        task.getPriority(),
                        task.getDueDate() != null ? task.getDueDate().toString() : ""
                );

                response.getWriter().write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            System.err.println("❌ Error getting task for edit: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void editTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String statusName = request.getParameter("status");
            String priority = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");

            int statusId = statusDAO.getStatusId(statusName);

            Task task = new Task();
            task.setTaskId(taskId);
            task.setTitle(title);
            task.setDescription(description != null ? description : "");
            task.setStatusId(statusId);
            task.setPriority(priority != null ? priority : "Medium");

            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                task.setDueDate(Date.valueOf(dueDateStr));
            } else {
                task.setDueDate(null);
            }

            taskDAO.update(task);

            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"message\": \"Task updated successfully\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to update task: " + e.getMessage() + "\"}");
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
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            int boardId = Integer.parseInt(request.getParameter("boardId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String statusName = request.getParameter("status");
            String priority = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");

            int statusId = statusDAO.getStatusId(statusName);

            Task task = new Task();
            task.setBoardId(boardId);
            task.setTitle(title);
            task.setDescription(description != null ? description : "");
            task.setStatusId(statusId);
            task.setPriority(priority != null ? priority : "Medium");
            task.setCreatedBy(user.getUserId());

            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                task.setDueDate(Date.valueOf(dueDateStr));
            }

            taskDAO.insert(task);

            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"message\": \"Task created successfully\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to create task: " + e.getMessage() + "\"}");
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            System.out.println("🗑️ Deleting task: " + taskId);

            taskDAO.delete(taskId);

            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"message\": \"Task deleted successfully\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to delete task: " + e.getMessage() + "\"}");
        }
    }
}

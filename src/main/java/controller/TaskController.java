package controller;

import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Task;

import java.io.IOException;

@WebServlet("/task")
public class TaskController extends HttpServlet {
    private TaskDAO taskDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
            return;
        }

        try {
            switch (action) {
                case "create":
                    createTask(request, response);
                    break;
                case "delete":
                    deleteTask(request, response);
                    break;
                case "move":
                    moveTask(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int boardId = Integer.parseInt(request.getParameter("boardId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String dueDate = request.getParameter("dueDate");

        Task task = new Task();
        task.setBoardId(boardId);
        task.setTitle(title);
        task.setDescription(description);
        task.setStatus(status);
        task.setPriority(priority);
        task.setDueDate(dueDate != null && !dueDate.isEmpty() ? java.sql.Date.valueOf(dueDate) : null);

        taskDAO.insert(task);

        response.sendRedirect(request.getHeader("Referer"));
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        taskDAO.delete(taskId);
        response.sendRedirect(request.getHeader("Referer"));
    }

    private void moveTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        int newBoardId = Integer.parseInt(request.getParameter("newBoardId"));
        int newIndex = Integer.parseInt(request.getParameter("newIndex"));

        taskDAO.moveTaskToBoard(taskId, newBoardId, newIndex);

        response.setStatus(HttpServletResponse.SC_OK);
    }
}

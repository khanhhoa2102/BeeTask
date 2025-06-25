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
        String action = request.getParameter("action");

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
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void moveTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            int newBoardId = Integer.parseInt(request.getParameter("newBoardId"));
            int newIndex = Integer.parseInt(request.getParameter("newIndex"));

            taskDAO.moveTaskToBoard(taskId, newBoardId, newIndex);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String priority = request.getParameter("priority");
            int position = Integer.parseInt(request.getParameter("position")); // ép kiểu

            Task task = new Task();
            task.setBoardId(boardId);
            task.setTitle(title);
            task.setDescription(description);
            task.setStatus(status);     // status là String
            task.setPriority(priority); // priority là String
            task.setPosition(position);

            taskDAO.insert(task);

            response.sendRedirect(request.getHeader("Referer"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            taskDAO.delete(taskId);
            response.sendRedirect(request.getHeader("Referer"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}

package controller;

import com.google.gson.Gson;
import dao.TaskDAO;
import model.Task;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/tasks")
public class TaskController extends HttpServlet {
    private TaskDAO taskDAO = new TaskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            List<Task> tasks = taskDAO.findAllByBoard(boardId);

            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_OK);
            new Gson().toJson(tasks, response.getWriter());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            BufferedReader reader = request.getReader();
            Gson gson = new Gson();
            Task task = gson.fromJson(reader, Task.class);
            taskDAO.insert(task);

            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_CREATED);
            gson.toJson(task, response.getWriter());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    @Override
protected void doPut(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        BufferedReader reader = request.getReader();
        Gson gson = new Gson();
        Task task = gson.fromJson(reader, Task.class);

        taskDAO.update(task);

        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);
        gson.toJson(task, response.getWriter());
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
    }
}

@Override
protected void doDelete(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int taskId = Integer.parseInt(request.getParameter("id"));
        taskDAO.delete(taskId);

        response.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204: Xóa thành công, không cần trả dữ liệu
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
    }
}

    @Override
    public String getServletInfo() {
        return "Task API Controller";
    }
}

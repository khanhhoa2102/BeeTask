package controller;

import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Task;

import java.io.IOException;
import java.util.List;

@WebServlet("/task")
public class TaskController extends HttpServlet {
    private TaskDAO taskDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "view":
                    viewTask(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteTask(request, response);
                    break;
                default:
                    listTasks(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "insert":
                    insertTask(request, response);
                    break;
                case "update":
                    updateTask(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }


    private void viewTask(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Task task = taskDAO.findById(id);
        request.setAttribute("task", task);
        request.getRequestDispatcher("/task-view.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Task task = taskDAO.findById(id);
        request.setAttribute("task", task);
        request.getRequestDispatcher("/task-form.jsp").forward(request, response);
    }

    private void insertTask(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        Task task = getTaskFromRequest(request);
        taskDAO.insert(task);
        response.sendRedirect("task?action=list");
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        Task task = getTaskFromRequest(request);
        task.setTaskId(Integer.parseInt(request.getParameter("id")));
        taskDAO.update(task);
        response.sendRedirect("task?action=list");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        taskDAO.delete(id);
        response.sendRedirect("task?action=list");
    }

    private Task getTaskFromRequest(HttpServletRequest request) {
        int boardId = Integer.parseInt(request.getParameter("boardId"));
        int listId = Integer.parseInt(request.getParameter("listId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int statusId = Integer.parseInt(request.getParameter("statusId"));
        String dueDateStr = request.getParameter("dueDate");

        java.util.Date dueDate = null;
        try {
            dueDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dueDateStr);
        } catch (Exception e) {
            e.printStackTrace();
        }

        int createdBy = Integer.parseInt(request.getParameter("createdBy"));

        return new Task(0, boardId, listId, title, description, statusId, dueDate, new java.util.Date(), createdBy);
    }
    
    private void listTasks(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        List<Task> todoTasks = taskDAO.findByStatus(1);
        List<Task> inProgressTasks = taskDAO.findByStatus(2);
        List<Task> doneTasks = taskDAO.findByStatus(3);

        request.setAttribute("todoTasks", todoTasks);
        request.setAttribute("inProgressTasks", inProgressTasks);
        request.setAttribute("doneTasks", doneTasks);

        request.getRequestDispatcher("/task.jsp").forward(request, response);
    }

}
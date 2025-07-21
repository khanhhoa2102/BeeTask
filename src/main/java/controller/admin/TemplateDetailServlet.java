package controller.admin;

import dao.admin.TemplateDetailDao;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Label;
import model.TemplateTask;

@WebServlet("/admin/templatedetailservlet")
public class TemplateDetailServlet extends HttpServlet {
    private TemplateDetailDao dao;

    @Override
    public void init() throws ServletException {
        dao = new TemplateDetailDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "addBoard":
                    addBoard(request, response);
                    break;
                case "editBoard":
                    editBoard(request, response);
                    break;
                case "deleteBoard":
                    deleteBoard(request, response);
                    break;
                case "addTask":
                    addTask(request, response);
                    break;
                case "editTask":
                    editTask(request, response);
                    break;
                case "deleteTask":
                    deleteTask(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing action: " + action);
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ==============================
    // Board handlers
    // ==============================

    private void addBoard(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int templateId = Integer.parseInt(request.getParameter("templateId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        dao.addTemplateBoard(templateId, name, description);
        response.sendRedirect(request.getContextPath() + "/Admin/TemplateDetail.jsp?templateId=" + templateId);
    }

    
    
    
    
//    private void editBoard(HttpServletRequest request, HttpServletResponse response) throws IOException {
//    try {
//        int boardId = Integer.parseInt(request.getParameter("boardId")); // Vẫn nhận boardId
//        String name = request.getParameter("name");
//        String description = request.getParameter("description");
//
//        boolean success = dao.updateTemplateBoard(boardId, name, description); // Giữ nguyên hàm DAO
//        
//        if (success) {
//            response.getWriter().write("success");
//        } else {
//            response.sendError(500, "Update failed");
//        }
//    } catch (Exception e) {
//        response.sendError(400, "Invalid data: " + e.getMessage());
//    }
//}
    private void editBoard(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int boardId = Integer.parseInt(request.getParameter("boardId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        dao.updateTemplateBoard(boardId, name, description);
        response.getWriter().write("success");
    }

    private void deleteBoard(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int boardId = Integer.parseInt(request.getParameter("boardId"));

        dao.deleteTemplateBoard(boardId);
        response.getWriter().write("deleted");
    }

    // ==============================
    // Task handlers
    // ==============================

    private void addTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int boardId = Integer.parseInt(request.getParameter("boardId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String dueDateStr = request.getParameter("dueDate");

        Timestamp dueDate = (dueDateStr == null || dueDateStr.isEmpty()) ? null : Timestamp.valueOf(dueDateStr + " 00:00:00");

        List<Integer> labelIds = extractLabelIds(request);

        dao.addTemplateTask(boardId, title, description, status, dueDate, labelIds);
        response.getWriter().write("added");
    }

    private void editTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String dueDateStr = request.getParameter("dueDate");

        Timestamp dueDate = (dueDateStr == null || dueDateStr.isEmpty()) ? null : Timestamp.valueOf(dueDateStr + " 00:00:00");

        List<Integer> labelIds = extractLabelIds(request);

        dao.updateTemplateTask(taskId, title, description, status, dueDate, labelIds);
        response.getWriter().write("updated");
    }

    
    
    
    
    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));

        dao.deleteTemplateTask(taskId);
        response.getWriter().write("deleted");
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // ==============================
    // Helper method to extract labelIds (priority or tags)
    // ==============================

    private List<Integer> extractLabelIds(HttpServletRequest request) {
    String raw = request.getParameter("labelIds");
    List<Integer> list = new ArrayList<>();
    if (raw != null && !raw.isEmpty()) {
        String[] parts = raw.split(",");
        for (String part : parts) {
            try {
                list.add(Integer.parseInt(part.trim()));
            } catch (NumberFormatException ignored) {}
        }
    }
    return list;
}

    
    
    
    
    
    
    
    
    // Method để lấy dữ liệu task cho form edit
    private void getTaskData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        
        // Lấy thông tin task từ database
        TemplateTask task = dao.getTemplateTaskById(taskId);
        
        if (task != null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder();
            json.append("{")
                .append("\"taskId\": ").append(task.getTemplateTaskId()).append(",")
                .append("\"title\": \"").append(escapeJson(task.getTitle())).append("\",")
                .append("\"description\": \"").append(escapeJson(task.getDescription())).append("\",")
                .append("\"status\": \"").append(escapeJson(task.getStatus())).append("\",")
                .append("\"dueDate\": \"").append(task.getDueDate() != null ? task.getDueDate().toString() : "").append("\",")
                .append("\"labels\": [");
            
            if (task.getLabels() != null) {
                for (int i = 0; i < task.getLabels().size(); i++) {
                    if (i > 0) json.append(",");
                    json.append(task.getLabels().get(i).getLabelId());
                }
            }
            json.append("]}");
            
            response.getWriter().write(json.toString());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
        }
    }

    // Method để lấy tất cả labels
    private void getLabels(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Label> labels = dao.getAllLabels();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < labels.size(); i++) {
            if (i > 0) json.append(",");
            Label label = labels.get(i);
            json.append("{")
                .append("\"labelId\": ").append(label.getLabelId()).append(",")
                .append("\"name\": \"").append(escapeJson(label.getName())).append("\",")
                .append("\"color\": \"").append(escapeJson(label.getColor())).append("\"")
                .append("}");
        }
        json.append("]");
        
        response.getWriter().write(json.toString());
    }

    // Helper method để escape JSON
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\r", "\\r")
                 .replace("\n", "\\n");
    }
    
}

    
    


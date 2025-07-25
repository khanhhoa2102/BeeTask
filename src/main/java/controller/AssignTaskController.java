package controller;

import dao.TaskAssigneeDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/assign")
public class AssignTaskController extends HttpServlet {

    private final TaskAssigneeDAO taskAssigneeDAO = new TaskAssigneeDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

        response.setContentType("application/json");

        try {
            BufferedReader reader = request.getReader();
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
            String json = jsonBuilder.toString();

            // Parse taskId and userIds
            org.json.JSONObject data = new org.json.JSONObject(json);
            int taskId = data.getInt("taskId");
            org.json.JSONArray userIdsArray = data.getJSONArray("userIds");

            java.util.List<Integer> userIds = new java.util.ArrayList<>();
            for (int i = 0; i < userIdsArray.length(); i++) {
                userIds.add(userIdsArray.getInt(i));
            }

            // Update DB
            taskAssigneeDAO.deleteAssigneesByTaskId(taskId);
            for (Integer uid : userIds) {
                taskAssigneeDAO.insert(taskId, uid);
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"message\": \"Task assigned successfully\"}");

        } catch (Exception e) {
            e.printStackTrace(); // In stack trace chi tiết ra log
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            // Ghi thêm thông tin lỗi vào response JSON để debug từ client
            response.getWriter().write("{\"error\": \"Internal error: " + e.toString().replace("\"", "\\\"") + "\"}");
        }
    }
}

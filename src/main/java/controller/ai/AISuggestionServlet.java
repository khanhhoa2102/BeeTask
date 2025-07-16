package controller.ai;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.CalendarEventDAO;
import dao.TaskDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.stream.Collectors;
import model.*;
import model.ai.*;
import service.AIService;

@WebServlet("/ai-suggest-preview")
public class AISuggestionServlet extends HttpServlet {

    private final TaskDAO taskDAO = new TaskDAO();
    private final CalendarEventDAO calendarDAO = new CalendarEventDAO();
    private final AIService aiService = new AIService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            System.out.println("🧪 [AI Servlet] POST /ai-suggest-preview triggered");

            User user = (User) req.getSession(false).getAttribute("user");
            System.out.println("🧪 [AI Servlet] Session user: " + (user != null ? user.getUsername() : "null"));
            if (user == null) {
                resp.setStatus(401);
                resp.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }

            int userId = user.getUserId();
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            System.out.println("🧪 [AI Servlet] taskId received: " + taskId);

            Task task = taskDAO.getTaskById(taskId);
            System.out.println("🧪 [AI Servlet] Task fetched: " + (task != null ? task.getTitle() : "null")
                    + ", CreatedBy: " + (task != null ? task.getCreatedBy() : "N/A")
                    + ", CurrentUserId: " + userId);

            if (task == null || task.getCreatedBy() != userId) {
                resp.setStatus(403);
                resp.getWriter().write("{\"error\":\"Access denied or task not found\"}");
                return;
            }

            // Convert java.util.Date to java.time.LocalDateTime
            LocalDateTime dueDateTime = null;
            if (task.getDueDate() != null) {
                dueDateTime = new java.sql.Timestamp(task.getDueDate().getTime()).toLocalDateTime(); // ✅ an toàn
            }

            SimpleTask simpleTask = new SimpleTask(
                    task.getTitle(),
                    task.getDescription(),
                    dueDateTime,
                    List.of(),
                    task.getStatusName(),
                    0,
                    task.getPriority()
            );

            List<CalendarEvent> events = calendarDAO.getEventsByUserId(userId);

            List<SimpleCalendarEvent> simpleEvents = events.stream()
                    .map(e -> new SimpleCalendarEvent(e.getTitle(), e.getStartTime(), e.getEndTime()))
                    .collect(Collectors.toList());

            AISuggestionRequest request = new AISuggestionRequest(List.of(simpleTask), simpleEvents);
            AISuggestionResponse aiResponse = aiService.sendSchedulingRequest(request);

            // Lọc suggestion theo title trùng với task
            ScheduledTaskSuggestion matched = aiResponse.getSchedules().stream()
                    .filter(s -> !Boolean.TRUE.equals(s.isEvent())) // bỏ calendar event
                    .filter(s -> s.getTitle().equalsIgnoreCase(task.getTitle())) // chỉ lấy task bạn bấm
                    .findFirst()
                    .orElse(null);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            if (matched != null) {
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDateTime.class, new utils.LocalDateTimeAdapter())
                        .create();
                gson.toJson(matched, resp.getWriter());
            } else {
                resp.setStatus(404);
                resp.getWriter().write("{\"error\":\"No matching suggestion found for this task\"}");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"AI scheduling failed\"}");
        }
    }
}

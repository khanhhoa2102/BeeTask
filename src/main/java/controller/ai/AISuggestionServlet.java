package controller.ai;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.AIScheduleDAO;
import dao.CalendarEventDAO;
import dao.TaskDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import model.ai.*;
import service.AIService;
import utils.LocalDateTimeAdapter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/ai-suggest-preview")
public class AISuggestionServlet extends HttpServlet {

    private final TaskDAO taskDAO = new TaskDAO();
    private final CalendarEventDAO calendarDAO = new CalendarEventDAO();
    private final AIScheduleDAO scheduleDAO = new AIScheduleDAO();
    private final AIService aiService = new AIService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            System.out.println("🧠 [AI Servlet] POST /ai-suggest-preview triggered");

            User user = (User) req.getSession(false).getAttribute("user");
            if (user == null) {
                resp.setStatus(401);
                resp.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }

            int userId = user.getUserId();
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                resp.setStatus(404);
                resp.getWriter().write("{\"error\":\"Task not found\"}");
                return;
            }

            // Convert target task
            LocalDateTime dueDateTime = null;
            if (task.getDueDate() != null) {
                dueDateTime = new java.sql.Timestamp(task.getDueDate().getTime()).toLocalDateTime();
            }

            SimpleTask targetTask = new SimpleTask(
                    task.getTitle(),
                    task.getDescription(),
                    dueDateTime,
                    List.of(),
                    task.getStatusName(),
                    0,
                    task.getPriority()
            );

            int projectId = task.getBoardId(); // Nếu cần bạn có thể sửa để map sang projectId
            List<Task> allProjectTasks = taskDAO.getTasksByProjectIdGrouped(projectId)
                    .values().stream().flatMap(List::stream).collect(Collectors.toList());

            List<SimpleTask> otherTasks = allProjectTasks.stream()
                    .filter(t -> t.getTaskId() != taskId)
                    .map(t -> new SimpleTask(
                    t.getTitle(),
                    t.getDescription(),
                    t.getDueDate() != null ? new java.sql.Timestamp(t.getDueDate().getTime()).toLocalDateTime() : null,
                    List.of(),
                    t.getStatusName(),
                    0,
                    t.getPriority()
            ))
                    .collect(Collectors.toList());

            List<CalendarEvent> events = calendarDAO.getEventsByUserId(userId);
            List<SimpleCalendarEvent> simpleEvents = events.stream()
                    .map(e -> new SimpleCalendarEvent(e.getTitle(), e.getStartTime(), e.getEndTime()))
                    .collect(Collectors.toList());

            String projectName = "Project " + projectId;

            AISuggestionRequest request = new AISuggestionRequest(targetTask, otherTasks, simpleEvents, projectName);
            AISuggestionResponse aiResponse = aiService.sendSchedulingRequest(request);

            ScheduledTaskSuggestion matched = aiResponse.getSchedules().stream()
                    .filter(s -> !Boolean.TRUE.equals(s.isEvent()))
                    .filter(s -> s.getTitle().equalsIgnoreCase(task.getTitle()))
                    .findFirst()
                    .orElse(aiResponse.getSchedules().isEmpty() ? null : aiResponse.getSchedules().get(0));

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            if (matched != null) {
                matched.setTaskId(taskId); // Gán TaskId cho suggestion để lưu

                // 🧠 Chỉ lưu nếu chưa tồn tại (Pending)
                scheduleDAO.insertIfNotExists(matched);

                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
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

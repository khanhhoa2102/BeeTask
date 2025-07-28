package controller.ai;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.AIScheduleDAO;
import dao.CalendarEventDAO;
import dao.TaskDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import model.ai.*;
import service.AIService;
import utils.LocalDateTimeAdapter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/ai-suggest-reset")
public class AiSuggestResetServlet extends HttpServlet {

    private final TaskDAO taskDAO = new TaskDAO();
    private final CalendarEventDAO calendarDAO = new CalendarEventDAO();
    private final AIScheduleDAO scheduleDAO = new AIScheduleDAO();
    private final AIService aiService = new AIService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            System.out.println("🔁 [AI Servlet] POST /ai-suggest-reset triggered");

            User user = (User) req.getSession(false).getAttribute("user");
            if (user == null) {
                resp.setStatus(401);
                resp.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }

            int taskId = Integer.parseInt(req.getParameter("taskId"));
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                resp.setStatus(404);
                resp.getWriter().write("{\"error\":\"Task not found\"}");
                return;
            }

            // 1. Đánh dấu bản ghi cũ là Overridden
            scheduleDAO.updateStatus(taskId, "Overridden");

            // 2. Chuẩn bị lại dữ liệu AI
            LocalDateTime dueDateTime = task.getDueDate() != null
                    ? new java.sql.Timestamp(task.getDueDate().getTime()).toLocalDateTime()
                    : null;

            SimpleTask targetTask = new SimpleTask(
                    task.getTitle(),
                    task.getDescription(),
                    dueDateTime,
                    List.of(),
                    task.getStatusName(),
                    0,
                    task.getPriority()
            );

            int projectId = task.getBoardId(); // hoặc dùng ProjectId nếu có
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

            List<CalendarEvent> events = calendarDAO.getEventsByUserId(user.getUserId());
            List<SimpleCalendarEvent> simpleEvents = events.stream()
                    .map(e -> new SimpleCalendarEvent(e.getTitle(), e.getStartTime(), e.getEndTime()))
                    .collect(Collectors.toList());

            // 3. Gửi lại yêu cầu cho AI
            AISuggestionRequest request = new AISuggestionRequest(targetTask, otherTasks, simpleEvents, "Project " + projectId);
            AISuggestionResponse aiResponse = aiService.sendSchedulingRequest(request);

            ScheduledTaskSuggestion matched = aiResponse.getSchedules().stream()
                    .filter(s -> !Boolean.TRUE.equals(s.isEvent()))
                    .filter(s -> s.getTitle().equalsIgnoreCase(task.getTitle()))
                    .findFirst()
                    .orElse(aiResponse.getSchedules().isEmpty() ? null : aiResponse.getSchedules().get(0));

            if (matched != null) {
                matched.setTaskId(taskId);
                scheduleDAO.insertAISchedules(user.getUserId(), List.of(matched), "Pending");

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                        .create();
                gson.toJson(matched, resp.getWriter());
            } else {
                resp.setStatus(404);
                resp.getWriter().write("{\"error\":\"No new suggestion returned\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"Failed to re-suggest\"}");
        }
    }
}

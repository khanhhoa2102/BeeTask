package controller;

import com.google.gson.Gson;
import dao.CalendarEventDAO;
import dao.TaskDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import model.*;
import model.ai.*;
import service.AIService;

@WebServlet("/ai-suggest-preview")
public class AISuggestionServlet extends HttpServlet {

    private TaskDAO taskDAO = new TaskDAO();
    private CalendarEventDAO calendarDAO = new CalendarEventDAO();
    private AIService aiService = new AIService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int userId = ((User) req.getSession().getAttribute("user")).getUserId();

            List<Task> tasks = taskDAO.getTasksByUserId(userId);
            List<CalendarEvent> events = calendarDAO.getEventsByUserId(userId);

            // Convert to simple format
            List<SimpleTask> simpleTasks = tasks.stream()
                .map(t -> new SimpleTask(t.getTitle(), t.getDueDate()))
                .collect(Collectors.toList());

            List<SimpleCalendarEvent> simpleEvents = events.stream()
                .map(e -> new SimpleCalendarEvent(e.getTitle(), e.getStartTime(), e.getEndTime()))
                .collect(Collectors.toList());

            AISuggestionRequest request = new AISuggestionRequest(simpleTasks, simpleEvents);

            AISuggestionResponse aiResponse = aiService.sendSchedulingRequest(request);

            // Trả về JSON cho frontend
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            new Gson().toJson(aiResponse, resp.getWriter());

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"AI scheduling failed\"}");
        }
    }
}

package controller.ai;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.AIScheduleDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import model.ai.AISuggestionResponse;
import model.ai.ScheduledTaskSuggestion;
import utils.LocalDateTimeAdapter;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/ai-suggest-apply")
public class AISuggestionApplyServlet extends HttpServlet {
    private final AIScheduleDAO scheduleDAO = new AIScheduleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.setStatus(401);
                resp.getWriter().write("{\"error\":\"Not logged in\"}");
                return;
            }

            String action = req.getParameter("action");

            // ====== Xử lý Rejection nếu có action=reject ======
            if ("reject".equalsIgnoreCase(action)) {
                int taskId = Integer.parseInt(req.getParameter("taskId"));
                scheduleDAO.updateStatus(taskId, "Rejected");

                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\": \"rejected\"}");
                return;
            }

            // ====== Nếu không phải reject ⇒ xử lý apply như bình thường ======
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, new utils.LocalDateTimeAdapter())
                    .create();

            AISuggestionResponse suggestion = gson.fromJson(req.getReader(), AISuggestionResponse.class);

            for (ScheduledTaskSuggestion s : suggestion.getSchedules()) {
                if (s.getTaskId() > 0) {
                    scheduleDAO.updateStatus(s.getTaskId(), "Accepted");
                }
            }

            resp.setContentType("application/json");
            resp.getWriter().write("{\"status\": \"accepted\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"Failed to apply/reject AI suggestion\"}");
        }
    }
}

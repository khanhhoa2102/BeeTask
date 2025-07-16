package controller;

import com.google.gson.Gson;
import dao.AIScheduleDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import model.ai.ScheduledTaskSuggestion;

import java.io.IOException;

@WebServlet("/ai-suggest-fetch")
public class AISuggestionFetchServlet extends HttpServlet {

    private AIScheduleDAO scheduleDAO = new AIScheduleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.setStatus(401);
                resp.getWriter().write("{\"error\": \"User not logged in\"}");
                return;
            }

            int taskId = Integer.parseInt(req.getParameter("taskId"));
            ScheduledTaskSuggestion suggestion = scheduleDAO.getSuggestionByTaskId(taskId);

            if (suggestion == null) {
                resp.setStatus(404);
                resp.getWriter().write("{\"error\": \"No AI suggestion found for this task\"}");
                return;
            }

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            new Gson().toJson(suggestion, resp.getWriter());

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
}

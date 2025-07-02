package controller;

import com.google.gson.Gson;
import dao.AIScheduleDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import model.ai.AISuggestionResponse;

@WebServlet("/ai-suggest-apply")
public class AISuggestionApplyServlet extends HttpServlet {

    private AIScheduleDAO scheduleDAO = new AIScheduleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int userId = ((User) req.getSession().getAttribute("user")).getUserId();
            AISuggestionResponse suggestion = new Gson().fromJson(req.getReader(), AISuggestionResponse.class);
            scheduleDAO.insertSchedules(userId, suggestion.getSchedules());

            resp.setStatus(200);
            resp.getWriter().write("{\"status\": \"saved\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"save failed\"}");
        }
    }
}

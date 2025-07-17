package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.EmailSender;

import java.io.IOException;

@WebServlet("/invite")
public class InvitationControllerServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain;charset=UTF-8");

        String email = req.getParameter("email");
        String projectIdStr = req.getParameter("projectId");

        if (email == null || projectIdStr == null) {
            resp.getWriter().write("INVALID_INPUT");
            return;
        }

        email = email.trim();
        if (email.isEmpty()) {
            resp.getWriter().write("INVALID_EMAIL");
            return;
        }

        int projectId;
        try {
            projectId = Integer.parseInt(projectIdStr);
        } catch (NumberFormatException e) {
            resp.getWriter().write("INVALID_PROJECT_ID");
            return;
        }

        String baseUrl = req.getRequestURL().toString().replace(req.getRequestURI(), req.getContextPath());

        String result = EmailSender.inviteUserToProject(email, projectId, baseUrl);
        resp.getWriter().write(result);
    }
}

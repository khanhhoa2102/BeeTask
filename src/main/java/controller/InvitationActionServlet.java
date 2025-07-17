package controller;

import dao.InvitationDAO;
import dao.ProjectDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Invitation;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/invitation-action")
public class InvitationActionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("invitationId");
        String action = req.getParameter("action");

        System.out.println("📥 Received invitation-action request: invitationId=" + idParam + ", action=" + action);

        if (idParam == null || idParam.trim().isEmpty()) {
            System.err.println("❌ Missing invitation ID");
            resp.sendRedirect(req.getContextPath() + "/ErrorPage.jsp?msg=Missing invitation ID");
            return;
        }

        int invitationId;
        try {
            invitationId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid invitation ID format: " + idParam);
            resp.sendRedirect(req.getContextPath() + "/ErrorPage.jsp?msg=Invalid invitation ID");
            return;
        }

        InvitationDAO invitationDAO = new InvitationDAO();
        ProjectDAO projectDAO = new ProjectDAO();

        Invitation invitation = invitationDAO.getInvitationById(invitationId);

        if (invitation == null) {
            System.err.println("❌ Invitation not found for ID: " + invitationId);
            resp.sendRedirect(req.getContextPath() + "/ErrorPage.jsp?msg=Invitation not found");
            return;
        }

        System.out.println("ℹ️ Invitation found: " + invitation);

        if (!"Pending".equalsIgnoreCase(invitation.getStatus())) {
            System.err.println("⚠️ Invitation already handled (status = " + invitation.getStatus() + ")");
            resp.sendRedirect(req.getContextPath() + "/ErrorPage.jsp?msg=Invitation expired or not found");
            return;
        }

        if ("accept".equalsIgnoreCase(action)) {
            // Cập nhật trạng thái
            boolean updated = invitationDAO.updateInvitationStatus(invitation.getInvitationId(), "Accepted");
            System.out.println("✅ Updated invitation status to 'Accepted': success=" + updated);

            if (invitation.getUserId() == null) {
                System.err.println("❌ Cannot add to project: UserId is null (user not logged in)");
                resp.sendRedirect(req.getContextPath() + "/Authentication/Login.jsp?msg=Please login before accepting the invitation.");
                return;
            }

            System.out.println("✅ Attempting to add user " + invitation.getUserId() + " to project " + invitation.getProjectId());

            boolean added = projectDAO.addMemberToProject(invitation.getProjectId(), invitation.getUserId(), "Member");
            if (added) {
                System.out.println("✅ User " + invitation.getUserId() + " successfully added to project " + invitation.getProjectId());
            } else {
                System.err.println("⚠️ User " + invitation.getUserId() + " was already a member or insert failed");
            }

            resp.sendRedirect(req.getContextPath() + "/Task.jsp?projectId=" + invitation.getProjectId());
        } else {
            boolean declined = invitationDAO.updateInvitationStatus(invitation.getInvitationId(), "Declined");
            System.out.println("ℹ️ Invitation declined: success=" + declined);
            resp.sendRedirect(req.getContextPath() + "/Home.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int invitationId = Integer.parseInt(req.getParameter("invitationId"));
        String action = req.getParameter("action");

        InvitationDAO invitationDAO = new InvitationDAO();
        ProjectDAO projectDAO = new ProjectDAO();

        Invitation invitation = invitationDAO.getInvitationById(invitationId);
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        if (invitation == null) {
            out.write("INVITATION_NOT_FOUND");
            return;
        }

        if (!"Pending".equalsIgnoreCase(invitation.getStatus())) {
            out.write("ALREADY_HANDLED");
            return;
        }

        boolean updated = invitationDAO.updateInvitationStatus(invitationId,
                "accept".equalsIgnoreCase(action) ? "Accepted" : "Declined");

        if (updated && "accept".equalsIgnoreCase(action)) {
            projectDAO.addMemberToProject(invitation.getProjectId(), invitation.getUserId(), "Member");
        }

        out.write("SUCCESS");
    }
}

package controller;

import dao.NoteDAO;
import model.Note;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "NoteServlet", urlPatterns = {"/notes"})
public class NoteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            List<Note> notes = NoteDAO.findAllByUserId(userId);

            if (notes == null) {
                System.err.println("[ERROR] notes is null from NoteDAO.findAllByUserId(" + userId + ")");
            }

            request.setAttribute("notes", notes);
            request.getRequestDispatcher("/Home/Note.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[ERROR] Lỗi trong NoteServlet.doGet(): " + e.getMessage());
            e.printStackTrace();  // In toàn bộ stack trace để debug

            request.setAttribute("error", "Không thể tải ghi chú: " + e.getMessage());
            request.getRequestDispatcher("/Home/Note.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("❌ Missing 'action' parameter.");
            return;
        }

        try {
            switch (action) {

                case "create": {
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String userIdStr = request.getParameter("userId");
                    String labelIdStr = request.getParameter("labelId");

                    // Kiểm tra các tham số bắt buộc
                    if (title == null || content == null || userIdStr == null) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("❌ Thiếu tham số bắt buộc");
                        return;
                    }

                    try {
                        int userId = Integer.parseInt(userIdStr);
                        int labelId = (labelIdStr == null || labelIdStr.trim().isEmpty()) ? 0 : Integer.parseInt(labelIdStr);

                        Note note = new Note(title, content, userId, labelId);
                        boolean created = new NoteDAO().createNote(note);

                        if (created) {
                            out.write("✅ Note created successfully.");
                        } else {
                            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                            out.write("❌ Failed to create note.");
                        }
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("❌ Định dạng số không hợp lệ");
                    }
                    break;
                }

                case "update": {
                    String noteIdStr = request.getParameter("noteId");
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String deadline = request.getParameter("deadline");

                    if (noteIdStr == null || noteIdStr.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("❌ Missing 'noteId'.");
                        return;
                    }

                    int noteId = Integer.parseInt(noteIdStr);
                    boolean updated = new NoteDAO().updateNote(noteId, title, content, deadline);
                    if (updated) {
                        out.write("✅ Note updated successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("❌ Failed to update note.");
                    }
                    break;
                }

                case "delete": {
                    String noteIdStr = request.getParameter("noteId");

                    if (noteIdStr == null || noteIdStr.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("❌ Missing 'noteId'.");
                        return;
                    }

                    int noteId = Integer.parseInt(noteIdStr);
                    boolean deleted = new NoteDAO().deleteNote(noteId);
                    if (deleted) {
                        out.write("✅ Note deleted successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("❌ Failed to delete note.");
                    }
                    break;
                }

                default: {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("❌ Invalid action value.");
                    break;
                }
            }

        } catch (NumberFormatException nfe) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("❌ Invalid number format: " + nfe.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("❌ Server error: " + e.getMessage());
        }
    }

}

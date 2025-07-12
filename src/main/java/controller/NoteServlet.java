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
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            List<Note> notes = NoteDAO.findAllByUserId(userId);

            request.setAttribute("notes", notes);
            request.getRequestDispatcher("/Home/Note.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
            out.write("❌ Thiếu tham số 'action'.");
            return;
        }

        try {
            switch (action) {

                case "create": {
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    int labelId = Integer.parseInt(request.getParameter("labelId"));

                    Note note = new Note(title, content, userId, labelId);
                    boolean created = new NoteDAO().createNote(note);

                    if (created) {
                        out.write("✅ Ghi chú đã tạo.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("❌ Không thể tạo ghi chú.");
                    }
                    break;
                }

                case "update": {
                    int noteId = Integer.parseInt(request.getParameter("noteId"));
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String deadline = request.getParameter("deadline"); // có thể rỗng

                    boolean updated = new NoteDAO().updateNote(noteId, title, content, deadline);
                    if (updated) {
                        out.write("✅ Ghi chú đã cập nhật.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("❌ Cập nhật ghi chú thất bại.");
                    }
                    break;
                }

                case "delete": {
                    int noteId = Integer.parseInt(request.getParameter("noteId"));
                    boolean deleted = new NoteDAO().deleteNote(noteId);
                    if (deleted) {
                        out.write("✅ Ghi chú đã bị xóa.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("❌ Xóa ghi chú thất bại.");
                    }
                    break;
                }

                default: {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("❌ Giá trị 'action' không hợp lệ.");
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("❌ Lỗi máy chủ: " + e.getMessage());
        }
    }
}

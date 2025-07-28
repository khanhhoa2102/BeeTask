package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/file")
public class FileController extends HttpServlet {

    // Lấy thư mục lưu file tương đối với thư mục gốc project
    private static final String UPLOAD_ROOT = System.getProperty("user.dir") + File.separator + "BeeTaskUploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskId = request.getParameter("taskId");
        String fileName = request.getParameter("filename"); // ❗ Sửa thành 'filename' cho khớp với JS

        if (taskId == null || fileName == null || taskId.isEmpty() || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters.");
            return;
        }

        File file = new File(UPLOAD_ROOT + File.separator + taskId, fileName);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
        response.setContentType(getServletContext().getMimeType(file.getName()));
        response.setContentLengthLong(file.length());
        Files.copy(file.toPath(), response.getOutputStream());
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskIdParam = request.getParameter("taskId");
        String filename = request.getParameter("filename");

        if (taskIdParam == null || filename == null || taskIdParam.isEmpty() || filename.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing taskId or filename");
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid taskId");
            return;
        }

        File file = new File(UPLOAD_ROOT + File.separator + taskId, filename);

        if (file.exists()) {
            boolean deleted = file.delete();
            if (deleted) {
                // Optional: remove DB record too if needed
                // new TaskAttachmentDAO().deleteByFilename(taskId, filename);

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("File deleted successfully.");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed to delete the file.");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("File not found.");
        }
    }
}

package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.TaskAttachmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TaskAttachment;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.*;

@WebServlet("/uploadAttachments")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UploadAttachmentController extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskId = request.getParameter("taskId");
        Part filePart = request.getPart("attachment");

        if (taskId == null || filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing taskId or file.");
            return;
        }

        // ✅ Lưu file vào thư mục webapp/uploads/{taskId}/
        String uploadPath = getServletContext().getRealPath("/uploads") + File.separator + taskId;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // ✅ Lưu file vật lý
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        filePart.write(uploadPath + File.separator + fileName);

        // ✅ Trả về JSON
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"fileName\": \"" + fileName + "\"}");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskId = request.getParameter("taskId");
        if (taskId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String uploadPath = getServletContext().getRealPath("/uploads") + File.separator + taskId;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            response.setContentType("application/json");
            response.getWriter().write("[]");
            return;
        }

        File[] files = uploadDir.listFiles();
        List<Map<String, String>> fileList = new ArrayList<>();

        if (files != null) {
            for (File file : files) {
                Map<String, String> fileData = new HashMap<>();
                fileData.put("fileName", file.getName());
                fileData.put("fileUrl", request.getContextPath() + "/uploads/" + taskId + "/" + file.getName());
                fileList.add(fileData);
            }
        }

        response.setContentType("application/json");
        response.getWriter().write(new Gson().toJson(fileList));
    }
}
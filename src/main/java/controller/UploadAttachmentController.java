package controller;

import com.google.gson.JsonObject;
import dao.TaskAttachmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TaskAttachment;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Paths;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/uploadAttachments")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10,      
                 maxRequestSize = 1024 * 1024 * 50)
public class UploadAttachmentController extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
    try {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        Part filePart = request.getPart("file");

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileType = filePart.getContentType();
        int fileSize = (int) filePart.getSize();
        String uniqueFileName = UUID.randomUUID() + "_" + fileName;

        // 🆕 Lưu bên ngoài thư mục webapp
        String projectRoot = System.getProperty("user.dir");
        String uploadRootPath = projectRoot + File.separator + "BeeTaskUploads";

        File uploadDir = new File(uploadRootPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Tạo thư mục BeeTaskUploads nếu chưa có
        }

        String taskUploadPath = uploadRootPath + File.separator + taskId;
        File taskUploadDir = new File(taskUploadPath);
        if (!taskUploadDir.exists()) {
            taskUploadDir.mkdirs(); // Tạo thư mục cho task
        }

        String filePath = taskUploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);

        TaskAttachment attachment = new TaskAttachment(taskId, taskId + "/" + uniqueFileName, fileName, fileType, fileSize);
        new TaskAttachmentDAO().insertAttachment(attachment);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.addProperty("message", "Uploaded");
        json.addProperty("fileName", fileName);
        response.getWriter().write(json.toString());

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json");
        response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
    }
}
    
    // GET method to load attachments for a given task
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskIdParam = request.getParameter("taskId");
        if (taskIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing taskId parameter");
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid taskId format");
            return;
        }

        // 🆕 Sử dụng đường dẫn tương đối với thư mục project
        String projectRoot = System.getProperty("user.dir");
        String uploadRootPath = projectRoot + File.separator + "BeeTaskUploads";
        File taskFolder = new File(uploadRootPath, String.valueOf(taskId));

        if (!taskFolder.exists() || !taskFolder.isDirectory()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("[]");
            return;
        }

        File[] files = taskFolder.listFiles();
        JSONArray fileArray = new JSONArray();

        if (files != null) {
            for (File file : files) {
                if (file.isFile()) {
                    JSONObject fileObj = new JSONObject();
                    fileObj.put("fileName", file.getName());

                    // Tạo URL download (giả định bạn có servlet /uploadDownload)
                    String fileUrl = request.getContextPath() + "/uploadDownload"
                            + "?taskId=" + taskId
                            + "&filename=" + URLEncoder.encode(file.getName(), "UTF-8");

                    fileObj.put("fileUrl", fileUrl);
                    fileArray.put(fileObj);
                }
            }
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(fileArray.toString());
    }
}
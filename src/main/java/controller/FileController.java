/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.nio.file.Files;

@WebServlet("/file")
public class FileController extends HttpServlet {
    // Sử dụng cùng UPLOAD_DIR với UploadAttachmentController
    private static final String UPLOAD_DIR = "C:\\Users\\ACER\\Documents\\Study\\FPT\\Project_BeeTask\\BeeTask\\BeeTaskUploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String taskId = request.getParameter("taskId");
        String fileName = request.getParameter("name");

        if (taskId == null || fileName == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters.");
            return;
        }

        File file = new File(UPLOAD_DIR + File.separator + taskId, fileName);
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

        // Define custom folder (outside target or webapp)
        String baseUploadPath = "C:/Users/ACER/Documents/Study/FPT/Project_BeeTask/BeeTask/BeeTaskUploads";
        File file = new File(baseUploadPath + File.separator + taskId, filename);

        if (file.exists()) {
            boolean deleted = file.delete();
            if (deleted) {
                // Optional: remove DB record too
                // new UploadDAO().deleteFileRecord(taskId, filename);

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

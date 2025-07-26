package controller;

import dao.UserProfileDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Objects;

@WebServlet(name = "AccountSettingsServlet", urlPatterns = {"/account/settings"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class AccountSettingsServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            request.setAttribute("user", null);
            request.getRequestDispatcher("/AccountSettings.jsp").forward(request, response);
            return;
        }

        User freshUser = UserProfileDAO.getUserById(sessionUser.getUserId());
        request.setAttribute("user", freshUser);
        request.getRequestDispatcher("/AccountSettings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            out.write("{\"success\": false, \"message\": \"No active session found.\"}");
            return;
        }

        try {
            // Get form parameters
            String username = request.getParameter("username");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");
            String dobString = request.getParameter("dob");
            String gender = request.getParameter("gender");
            Part filePart = request.getPart("avatarFile");

            // Use session username if parameter is empty
            if (username == null || username.trim().isEmpty()) {
                username = sessionUser.getUsername();
            } else {
                username = username.trim();

                // Validate username only if it was changed
                if (!username.equals(sessionUser.getUsername())) {
                    if (username.length() < 3 || username.length() > 100) {
                        out.write("{\"success\": false, \"message\": \"Username must be between 3 and 100 characters.\"}");
                        return;
                    }
                }
            }

            // Handle file upload
            String avatarUrl = sessionUser.getAvatarUrl();
            if (filePart != null && filePart.getSize() > 0) {
                // Validate file type
                if (!filePart.getContentType().startsWith("image/")) {
                    out.write("{\"success\": false, \"message\": \"Only image files are allowed.\"}");
                    return;
                }

                // Validate file size (max 2MB)
                if (filePart.getSize() > 2 * 1024 * 1024) {
                    out.write("{\"success\": false, \"message\": \"Image size should not exceed 2MB.\"}");
                    return;
                }

                // Create upload directory if it doesn't exist
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Generate unique filename
                String fileName = "avatar_" + sessionUser.getUserId() + "_"
                        + System.currentTimeMillis()
                        + getFileExtension(filePart.getSubmittedFileName());
                String filePath = uploadPath + File.separator + fileName;

                // Save file
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath));
                }

                // Set new avatar URL
                avatarUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;

                // Delete old avatar file if it exists and is not the default
                if (sessionUser.getAvatarUrl() != null
                        && !sessionUser.getAvatarUrl().contains("via.placeholder.com")) {
                    String oldFilePath = getServletContext().getRealPath("")
                            + sessionUser.getAvatarUrl().replace(request.getContextPath(), "");
                    new File(oldFilePath).delete();
                }
            }

            // Parse date of birth
            Date dob = null;
            try {
                if (dobString != null && !dobString.isEmpty()) {
                    dob = Date.valueOf(dobString);
                }
            } catch (IllegalArgumentException e) {
                out.write("{\"success\": false, \"message\": \"Invalid date format.\"}");
                return;
            }

            // Check for any changes
            // Trong method doPost
            boolean hasChanges = !username.equals(sessionUser.getUsername())
                    || !Objects.equals(phoneNumber, sessionUser.getPhoneNumber())
                    || !Objects.equals(address, sessionUser.getAddress())
                    || !Objects.equals(gender, sessionUser.getGender())
                    || !Objects.equals(dob, sessionUser.getDateOfBirth())
                    || (filePart != null && filePart.getSize() > 0); // Quan trọng: kiểm tra kích thước file

            if (!hasChanges) {
                out.write("{\"success\": true, \"message\": \"No changes were made.\"}");
                return;
            }

            // Create updated user object
            User updatedUser = new User();
            updatedUser.setUserId(sessionUser.getUserId());
            updatedUser.setUsername(username);
            updatedUser.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
            updatedUser.setAvatarUrl(avatarUrl);
            updatedUser.setAddress(address != null ? address.trim() : null);
            updatedUser.setDateOfBirth(dob);
            updatedUser.setGender(gender != null ? gender.trim() : null);

            // Update user in database
            boolean success = UserProfileDAO.updateUserProfile(updatedUser);

            if (success) {
                // Update session user
                sessionUser.setUsername(updatedUser.getUsername());
                sessionUser.setPhoneNumber(updatedUser.getPhoneNumber());
                sessionUser.setAvatarUrl(updatedUser.getAvatarUrl());
                sessionUser.setAddress(updatedUser.getAddress());
                sessionUser.setDateOfBirth(updatedUser.getDateOfBirth());
                sessionUser.setGender(updatedUser.getGender());

                // Return success with avatar URL if it was updated
                if (filePart != null && filePart.getSize() > 0) {
                    out.write("{\"success\": true, \"message\": \"Account updated successfully.\", \"avatarUrl\": \"" + avatarUrl + "\"}");
                } else {
                    out.write("{\"success\": true, \"message\": \"Account updated successfully.\"}");
                }
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to update account.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

    private String getFileExtension(String fileName) {
        return fileName.substring(fileName.lastIndexOf("."));
    }

    private Date parseDate(String dateString) {
        try {
            return dateString != null && !dateString.isEmpty() ? Date.valueOf(dateString) : null;
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

}

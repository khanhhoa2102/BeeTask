package controller;

import dao.UserProfileDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

@WebServlet(name = "AccountSettingsServlet", urlPatterns = {"/account/settings"})
public class AccountSettingsServlet extends HttpServlet {

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

        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            String json = "{\"success\": false, \"message\": \"Không có phiên đăng nhập.\", \"log\": \"Session user is null\"}";
            response.getWriter().write(json);
            return;
        }

        int userId = sessionUser.getUserId();
        String username = request.getParameter("username");
        String phoneNumber = request.getParameter("phoneNumber");
        String avatarUrl = request.getParameter("avatarUrl");
        String address = request.getParameter("address");
        String dobString = request.getParameter("dob");
        String gender = request.getParameter("gender");

        // Kiểm tra Username không rỗng
        if (username == null || username.trim().isEmpty()) {
            String json = "{\"success\": false, \"message\": \"Tên đăng nhập không được để trống.\", \"log\": \"Username is empty\"}";
            response.getWriter().write(json);
            return;
        }

        Date dob = null;
        try {
            if (dobString != null && !dobString.isEmpty()) {
                dob = Date.valueOf(dobString);
            }
        } catch (IllegalArgumentException e) {
            String json = "{\"success\": false, \"message\": \"Định dạng ngày sinh không hợp lệ.\", \"log\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
            response.getWriter().write(json);
            return;
        }

        User updatedUser = new User();
        updatedUser.setUserId(userId);
        updatedUser.setUsername(username.trim());
        updatedUser.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        updatedUser.setAvatarUrl(avatarUrl != null ? avatarUrl.trim() : null);
        updatedUser.setAddress(address != null ? address.trim() : null);
        updatedUser.setDateOfBirth(dob);
        updatedUser.setGender(gender != null ? gender.trim() : null);

        boolean success = UserProfileDAO.updateUserProfile(updatedUser);

        if (success) {
            // Cập nhật session user
            sessionUser.setUsername(username);
            sessionUser.setPhoneNumber(phoneNumber);
            sessionUser.setAvatarUrl(avatarUrl);
            sessionUser.setAddress(address);
            sessionUser.setDateOfBirth(dob);
            sessionUser.setGender(gender);
            response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật thành công\", \"log\": \"Cập nhật thành công cho userId = " + userId + "\"}");
        } else {
            String log = "ERROR Cập nhật thất bại - userId=" + userId
                    + ", username='" + username + "'"
                    + ", phoneNumber='" + phoneNumber + "'"
                    + ", avatarUrl='" + avatarUrl + "'"
                    + ", gender='" + gender + "'"
                    + ", dob='" + dob + "'"
                    + ", address='" + address + "'";
            String message = "Cập nhật thất bại. Vui lòng kiểm tra lại dữ liệu.";
            // Kiểm tra lỗi cụ thể
            User existingUser = UserProfileDAO.getUserById(userId);
            if (existingUser == null) {
                message = "Không tìm thấy người dùng với UserId: " + userId;
            } else if (existingUser.getUsername().equals(username)
                    && (existingUser.getPhoneNumber() == null ? phoneNumber == null : existingUser.getPhoneNumber().equals(phoneNumber))
                    && (existingUser.getAvatarUrl() == null ? avatarUrl == null : existingUser.getAvatarUrl().equals(avatarUrl))
                    && (existingUser.getGender() == null ? gender == null : existingUser.getGender().equals(gender))
                    && (existingUser.getDateOfBirth() == null ? dob == null : existingUser.getDateOfBirth().equals(dob))
                    && (existingUser.getAddress() == null ? address == null : existingUser.getAddress().equals(address))) {
                message = "Không có thay đổi nào được thực hiện.";
            }
            log = log.replace("\"", "\\\"");
            String json = "{\"success\": false, \"message\": \"" + message + "\", \"log\": \"" + log + "\"}";
            response.getWriter().write(json);
        }
    }
}

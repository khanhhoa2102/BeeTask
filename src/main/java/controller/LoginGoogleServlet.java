package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.InvitationDAO;
import dao.NotificationDAO;
import dao.ProjectDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.GoogleUserDTO;
import model.Invitation;
import model.User;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Notification;

@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/LoginGoogleServlet"})
public class LoginGoogleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'code' parameter from Google.");
            return;
        }

        try {
            // Step 1: Lấy access_token và refresh_token từ Google
            JsonObject tokenResponse = getTokenObject(code);
            String accessToken = tokenResponse.get("access_token").getAsString();
            String refreshToken = tokenResponse.has("refresh_token")
                    ? tokenResponse.get("refresh_token").getAsString()
                    : null;

            System.out.println("📥 Access Token: " + accessToken);
            System.out.println("📥 Refresh Token: " + refreshToken);

            // Step 2: Lấy thông tin người dùng
            GoogleUserDTO googleUser = getUserInfo(accessToken);
            String googleId = googleUser.getId();
            String email = googleUser.getEmail();

            // Step 3: Kiểm tra hoặc tạo người dùng
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByGoogleId(googleId);
            if (user == null) {
                user = new User();
                user.setUsername(googleUser.getName());
                user.setEmail(email);
                user.setAvatarUrl(googleUser.getPicture());
                user.setPasswordHash("GOOGLE_" + googleId);
                user.setLoginProvider("Google");
                user.setGoogleId(googleId);
                user.setEmailVerified(true);
                user.setActive(true);
                user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                user.setRole("User");
                userDAO.insert(user);
                System.out.println("✅ Created new Google user: " + email);
            } else {
                System.out.println("ℹ️ Google user logged in: " + email);
            }

            // ✅ Cập nhật lời mời và thêm vào project nếu cần (luôn chạy sau khi có user)
            InvitationDAO invitationDAO = new InvitationDAO();
            invitationDAO.updateUserIdForEmail(email, user.getUserId());

            List<Invitation> acceptedInvites = invitationDAO.getAcceptedInvitationsWithoutMembership(user.getUserId());
            for (Invitation inv : acceptedInvites) {
                boolean added = new ProjectDAO().addMemberToProject(inv.getProjectId(), user.getUserId(), "Member");
                if (added) {
                    System.out.println("✅ Auto-added user " + user.getUserId() + " to project " + inv.getProjectId() + " (post-login)");

                    // ✅ Gửi thông báo nội bộ
                    NotificationDAO notiDAO = new NotificationDAO();
                    Notification noti = new Notification();
                    noti.setUserId(user.getUserId());
                    noti.setMessage("Bạn đã được thêm vào dự án (ID: " + inv.getProjectId() + ") sau khi xác nhận lời mời.");
                    noti.setIsRead(false);
                    noti.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                    notiDAO.addNotification(noti);
                } else {
                    System.out.println("⚠️ User already in project or insert failed (post-login)");
                }
            }

            // Step 4: Lưu vào session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Step 5: Gửi refreshToken về client (qua query để lưu localStorage)
            if (refreshToken != null) {
                response.sendRedirect("Home/Home.jsp?googleRefresh=" + refreshToken + "&email=" + email);
            } else {
                response.sendRedirect("Home/Home.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("❌ Google OAuth error", e);
        }
    }

    private JsonObject getTokenObject(String code) throws IOException {
        String response = Request.Post(Constants.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", Constants.GOOGLE_CLIENT_ID)
                        .add("client_secret", Constants.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", Constants.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", "authorization_code")
                        .build())
                .execute().returnContent().asString();

        return new Gson().fromJson(response, JsonObject.class);
    }

    private GoogleUserDTO getUserInfo(String accessToken) throws IOException {
        String response = Request.Get(Constants.GOOGLE_LINK_GET_USER_INFO + accessToken)
                .execute().returnContent().asString();
        return new Gson().fromJson(response, GoogleUserDTO.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles login with Google OAuth";
    }
}


// Comment
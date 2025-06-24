package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.GoogleUserDTO;
import model.User;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/refresh-token-login")
public class RefreshTokenLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String refreshToken = request.getParameter("refreshToken");
        if (refreshToken == null || refreshToken.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing refresh token\"}");
            return;
        }

        try {
            // 1. Get new access_token using refresh_token
            String tokenJson = Request.Post("https://oauth2.googleapis.com/token")
                    .bodyForm(Form.form()
                            .add("client_id", Constants.GOOGLE_CLIENT_ID)
                            .add("client_secret", Constants.GOOGLE_CLIENT_SECRET)
                            .add("refresh_token", refreshToken)
                            .add("grant_type", "refresh_token")
                            .build())
                    .execute().returnContent().asString();

            JsonObject tokenObj = new Gson().fromJson(tokenJson, JsonObject.class);

            if (!tokenObj.has("access_token")) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"Invalid refresh token\"}");
                return;
            }

            String accessToken = tokenObj.get("access_token").getAsString();

            // 2. Get user info from Google
            String userInfoJson = Request.Get("https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken)
                    .execute().returnContent().asString();

            GoogleUserDTO googleUser = new Gson().fromJson(userInfoJson, GoogleUserDTO.class);

            // 3. Lookup or create user
            User user = new UserDAO().findByGoogleId(googleUser.getId());
            if (user == null) {
                user = new User();
                user.setUsername(googleUser.getName());
                user.setEmail(googleUser.getEmail());
                user.setAvatarUrl(googleUser.getPicture());
                user.setPasswordHash("GOOGLE_" + googleUser.getId());
                user.setLoginProvider("Google");
                user.setGoogleId(googleUser.getId());
                user.setEmailVerified(true);
                user.setActive(true);
                user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                new UserDAO().insert(user);
            }

            // 4. Save session and optionally refreshToken
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("refreshToken", refreshToken); // để lưu lại cho lần sau

            // 5. Success response
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Server error\"}");
        }
    }
}

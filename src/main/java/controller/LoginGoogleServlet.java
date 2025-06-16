package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import model.GoogleUserDTO;
import model.User;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

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

        System.out.println("Received code: " + code);
        System.out.println("GOOGLE_CLIENT_ID: " + Constants.GOOGLE_CLIENT_ID);
        System.out.println("GOOGLE_CLIENT_SECRET: " + Constants.GOOGLE_CLIENT_SECRET);
        System.out.println("GOOGLE_REDIRECT_URI: " + Constants.GOOGLE_REDIRECT_URI);

        try {
            String accessToken = getToken(code);
            GoogleUserDTO googleUser = getUserInfo(accessToken);

            System.out.println("Google JSON: " + googleUser);

            User user = new User(
                0,
                googleUser.getName(),
                googleUser.getEmail(),
                "GOOGLE_" + googleUser.getId(),
                googleUser.getPicture(),
                true,
                new Timestamp(System.currentTimeMillis())
            );

            System.out.println("Checking if user exists...");
            User existingUser = UserDAO.getUserByEmail(user.getEmail());

            if (existingUser == null) {
                System.out.println("User not found. Inserting new user...");
                UserDAO.insertUser(user);
            } else {
                System.out.println("User already exists.");
                user = existingUser;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect("Home/Home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("OAuth error", e);
        }
    }

    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(Constants.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", Constants.GOOGLE_CLIENT_ID)
                        .add("client_secret", Constants.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", Constants.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", Constants.GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    public static GoogleUserDTO getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = Constants.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();

        System.out.println("Google raw JSON: " + response);
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

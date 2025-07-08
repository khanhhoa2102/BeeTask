
import com.google.gson.Gson;
import dao.ProjectOverviewDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.ProjectOverview;
import model.User;

@WebServlet("/search-projects")
public class SearchProjectServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String keyword = request.getParameter("keyword");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (user == null || keyword == null || keyword.trim().isEmpty()) {
            out.write("[]");
            return;
        }

        try {
            ProjectOverviewDao dao = new ProjectOverviewDao();
            List<ProjectOverview> allProjects = dao.getAllProjectsByUser(user.getUserId());
            keyword = keyword.toLowerCase();

            List<Map<String, Object>> matched = new ArrayList<>();
            for (ProjectOverview po : allProjects) {
                if (po.getProjectName().toLowerCase().contains(keyword)) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("projectId", po.getProjectId());
                    map.put("projectName", po.getProjectName());
                    matched.add(map);
                }
            }

            out.write(new Gson().toJson(matched));
        } catch (Exception e) {
            e.printStackTrace();
            out.write("[]");
        }
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.ProjectDAO;
import dao.TaskAssigneeDAO;
import dao.TaskDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.List;
import model.User;

/**
 *
 * @author ACER
 */
@WebServlet(name = "AssignTaskController", urlPatterns = {"/task/assign"})
public class AssignTaskController extends HttpServlet {

    private TaskAssigneeDAO taskAssigneeDAO = new TaskAssigneeDAO();
    private TaskDAO taskDAO = new TaskDAO();
    private ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Chỉ Leader mới được gán người
        if (user == null || !"Leader".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            int userId = Integer.parseInt(request.getParameter("userId"));

            // Kiểm tra xem Leader có sở hữu project chứa task này không
            int projectId = taskDAO.getProjectIdByTaskId(taskId);
            if (!projectDAO.isLeaderOfProject(user.getUserId(), projectId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Gán user cho task (1-1)
            taskAssigneeDAO.delete(taskId, userId);
            taskAssigneeDAO.insert(taskId, userId);

            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            e.printStackTrace();
        }
    }
}
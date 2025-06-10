package controller;

import dao.TemplateDAO;
import model.Template;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/landing")
public class LandingPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TemplateDAO dao = new TemplateDAO();
        List<Template> templates = dao.getAllTemplates();

        // ✅ In log kiểm tra
        System.out.println("LandingPageServlet - Templates loaded: " + templates.size());

        request.setAttribute("templates", templates);
        request.getRequestDispatcher("/LandingPage.jsp").forward(request, response);
    }
}

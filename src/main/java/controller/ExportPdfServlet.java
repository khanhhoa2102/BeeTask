package controller;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import dao.ProjectOverviewDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ProjectOverview;
import model.User;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;


import java.util.Map;
import java.util.LinkedHashMap;
import java.util.Set;
import java.util.HashSet;





@WebServlet("/exportPDF")
public class ExportPdfServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load font
        InputStream fontStream = getClass().getClassLoader().getResourceAsStream("fonts/times.ttf");
        if (fontStream == null) {
            throw new IOException("Font file not found: fonts/times.ttf");
        }

        BaseFont bf;
        try {
            bf = BaseFont.createFont("times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED,
                    false, fontStream.readAllBytes(), null);
        } catch (DocumentException e) {
            throw new ServletException("Failed to load font", e);
        }
        Font font = new Font(bf, 12);

        // Check user login
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
            return;
        }

        int userId = user.getUserId();
        String userSystemRole = user.getRole(); // "User", "Premium", etc.

        // Block export if not Premium
        if (userSystemRole.trim().equalsIgnoreCase("User")) {
            //request.setAttribute("errorMessage", "You need to upgrade to Premium to export PDF reports.");
            //request.getRequestDispatcher("/Home/Statistic.jsp").forward(request, response);
            request.getRequestDispatcher("/VIP.jsp").forward(request, response);
            return;
        }

        // Get projectId from request
        String projectIdParam = request.getParameter("projectId");
        if (projectIdParam == null) {
            throw new ServletException("Missing projectId");
        }

        int projectId = Integer.parseInt(projectIdParam);

        try {
            ProjectOverviewDao dao = new ProjectOverviewDao();

            // Query only the projects that the user is a member of
            List<ProjectOverview> list = dao.getProjectDetailsByUser(userId, projectId);

            // If empty list, user is not allowed to access this project
            if (list == null || list.isEmpty()) {
                request.setAttribute("errorMessage", "You do not have permission to access this project.");
                request.getRequestDispatcher("/Home/Statistic.jsp").forward(request, response);
                return;
            }

            // Configure response for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=report.pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            document.add(new Paragraph("PROJECT REPORT", font));
            document.add(Chunk.NEWLINE);

            ProjectOverview first = list.get(0);
            document.add(new Paragraph("PROJECT: " + first.getProjectId() + " - " + first.getProjectName(), font));
            document.add(new Paragraph("Description: " + first.getProjectDescription(), font));
            document.add(new Paragraph("Created by: " + first.getProjectCreatedBy()
                    + " | Created at: " + first.getProjectCreatedAt()
                    + " | Leader: " + first.getUsername(), font));
            document.add(Chunk.NEWLINE);

            // Count number of tasks per user
            Map<String, Integer> userTaskCount = new LinkedHashMap<>();
            for (ProjectOverview po : list) {
                userTaskCount.put(po.getUsername(), userTaskCount.getOrDefault(po.getUsername(), 0) + 1);
            }

            // Create table
            PdfPTable table = new PdfPTable(8);
            table.setWidthPercentage(100);
            Font boldFont = new Font(bf, 12, Font.BOLD);

            table.addCell(new PdfPCell(new Phrase("Member", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Role", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Task Title", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Description", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Deadline", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Created At", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Created By", boldFont)));
            table.addCell(new PdfPCell(new Phrase("Status", boldFont)));

            Set<String> renderedUsers = new HashSet<>();
            for (ProjectOverview po : list) {
                boolean isNewUser = !renderedUsers.contains(po.getUsername());
                if (isNewUser) {
                    renderedUsers.add(po.getUsername());

                    PdfPCell userCell = new PdfPCell(new Phrase(po.getUsername(), font));
                    userCell.setRowspan(userTaskCount.get(po.getUsername()));
                    table.addCell(userCell);

                    PdfPCell roleCell = new PdfPCell(new Phrase(po.getRole(), font));
                    roleCell.setRowspan(userTaskCount.get(po.getUsername()));
                    table.addCell(roleCell);
                }

                table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
                table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
                table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
                table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
                table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
                table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
            }

            document.add(table);
            document.close();

        } catch (DocumentException | SQLException e) {
            throw new ServletException("Error generating PDF", e);
        }
    }
}




//
//@WebServlet("/exportPDF")
//public class ExportPdfServlet extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Load font
//        InputStream fontStream = getClass().getClassLoader().getResourceAsStream("fonts/times.ttf");
//        if (fontStream == null) {
//            throw new IOException("Font file not found: fonts/times.ttf");
//        }
//
//        BaseFont bf;
//        try {
//            bf = BaseFont.createFont("times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED,
//                    false, fontStream.readAllBytes(), null);
//        } catch (DocumentException e) {
//            throw new ServletException("Failed to load font", e);
//        }
//        Font font = new Font(bf, 12);
//
//        // Kiểm tra user đăng nhập
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//
//        if (user == null) {
//            response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
//            return;
//        }
//
//        int userId = user.getUserId();
//        String userSystemRole = user.getRole(); // "User", "Premium", etc.
//
//        // Chặn nếu không phải Premium
//        if (!"Premium".equalsIgnoreCase(userSystemRole)) {
//            request.setAttribute("errorMessage", "Bạn cần nâng cấp lên gói Premium để xuất báo cáo PDF.");
//            request.getRequestDispatcher("/Home/Statistic.jsp").forward(request, response);
//            return;
//        }
//
//        // Lấy projectId từ request
//        String projectIdParam = request.getParameter("projectId");
//        if (projectIdParam == null) {
//            throw new ServletException("Thiếu projectId");
//        }
//
//        int projectId = Integer.parseInt(projectIdParam);
//
//        try {
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//
//            // Truy vấn chỉ dự án mà user tham gia
//            List<ProjectOverview> list = dao.getProjectDetailsByUser(userId, projectId);
//
//            // Nếu list rỗng, tức user không được tham gia dự án đó
//            if (list == null || list.isEmpty()) {
//                request.setAttribute("errorMessage", "Bạn không có quyền truy cập dự án này.");
//                request.getRequestDispatcher("/Home/Statistic.jsp").forward(request, response);
//                return;
//            }
//
//            // Cấu hình response để tải về PDF
//            response.setContentType("application/pdf");
//            response.setHeader("Content-Disposition", "attachment; filename=report.pdf");
//
//            Document document = new Document();
//            PdfWriter.getInstance(document, response.getOutputStream());
//            document.open();
//
//            document.add(new Paragraph("BÁO CÁO DỰ ÁN", font));
//            document.add(Chunk.NEWLINE);
//
//            ProjectOverview first = list.get(0);
//            document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName(), font));
//            document.add(new Paragraph("Mô tả: " + first.getProjectDescription(), font));
//            document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy()
//                    + " | Ngày tạo: " + first.getProjectCreatedAt()
//                    + " | Leader: " + first.getUsername(), font));
//            document.add(Chunk.NEWLINE);
//            
//            
//            
//            
//            // Đếm số task theo từng user
//Map<String, Integer> userTaskCount = new LinkedHashMap<>();
//for (ProjectOverview po : list) {
//    userTaskCount.put(po.getUsername(), userTaskCount.getOrDefault(po.getUsername(), 0) + 1);
//}
//
//// Tạo bảng
//PdfPTable table = new PdfPTable(8);
//table.setWidthPercentage(100);
//Font boldFont = new Font(bf, 12, Font.BOLD);
//
//table.addCell(new PdfPCell(new Phrase("Thành viên", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Vai trò", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Tên công việc", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Mô tả", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Hạn", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Ngày tạo", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Người tạo", boldFont)));
//table.addCell(new PdfPCell(new Phrase("Trạng thái", boldFont)));
//
//Set<String> renderedUsers = new HashSet<>();
//for (ProjectOverview po : list) {
//    boolean isNewUser = !renderedUsers.contains(po.getUsername());
//    if (isNewUser) {
//        renderedUsers.add(po.getUsername());
//
//        PdfPCell userCell = new PdfPCell(new Phrase(po.getUsername(), font));
//        userCell.setRowspan(userTaskCount.get(po.getUsername()));
//        table.addCell(userCell);
//
//        PdfPCell roleCell = new PdfPCell(new Phrase(po.getRole(), font));
//        roleCell.setRowspan(userTaskCount.get(po.getUsername()));
//        table.addCell(roleCell);
//    }
//
//    table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
//    table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
//    table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
//    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
//    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
//    table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
//}
//
//            
//            
//            
//            
            
            
            
//            
//
//            PdfPTable table = new PdfPTable(8);
//            table.setWidthPercentage(100);
//
//            table.addCell(new PdfPCell(new Phrase("Thành viên", font)));
//            table.addCell(new PdfPCell(new Phrase("Vai trò", font)));
//            table.addCell(new PdfPCell(new Phrase("Tên công việc", font)));
//            table.addCell(new PdfPCell(new Phrase("Mô tả", font)));
//            table.addCell(new PdfPCell(new Phrase("Hạn", font)));
//            table.addCell(new PdfPCell(new Phrase("Ngày tạo", font)));
//            table.addCell(new PdfPCell(new Phrase("Người tạo", font)));
//            table.addCell(new PdfPCell(new Phrase("Trạng thái", font)));
//
//            String currentUsername = "";
//            for (ProjectOverview po : list) {
//                boolean showUser = !po.getUsername().equals(currentUsername);
//                currentUsername = po.getUsername();
//
//                table.addCell(new PdfPCell(new Phrase(showUser ? po.getUsername() : "", font)));
//                table.addCell(new PdfPCell(new Phrase(showUser ? po.getRole() : "", font)));
//                table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
//                table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
//                table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
//                table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
//                table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
//                table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
//            }

//            document.add(table);
//            document.close();
//
//        } catch (DocumentException | SQLException e) {
//            throw new ServletException("Lỗi khi tạo PDF", e);
//        }
//    }
//}






















//@WebServlet("/exportPDF")
//public class ExportPdfServlet extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Load font từ classpath
//        InputStream fontStream = getClass().getClassLoader().getResourceAsStream("fonts/times.ttf");
//        if (fontStream == null) {
//            throw new IOException("Font file not found: fonts/times.ttf");
//        }
//
//        BaseFont bf;
//        try {
//            bf = BaseFont.createFont("times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED,
//                    false, fontStream.readAllBytes(), null);
//        } catch (DocumentException e) {
//            throw new ServletException("Failed to load font", e);
//        }
//        Font font = new Font(bf, 12);
//
//        response.setContentType("application/pdf");
//        response.setHeader("Content-Disposition", "attachment; filename=report.pdf");
//
//        try {
//            HttpSession session = request.getSession();
//            User user = (User) session.getAttribute("user");
//
//            if (user == null) {
//                response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
//                return;
//            }
//
//            String projectIdParam = request.getParameter("projectId");
//            if (projectIdParam == null) {
//                throw new ServletException("Thiếu projectId");
//            }
//            int projectId = Integer.parseInt(projectIdParam);
//            int userId = user.getUserId();
//
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//
//            String userSystemRole = dao.getUserRole(userId); // Lấy role trong bảng Users
//            List<String> projectRoles = dao.getUserRolesInProjects(userId); // Lấy vai trò trong bảng ProjectMembers
//
//            List<ProjectOverview> list = new ArrayList<>();
//
//            if ("Premium".equals(userSystemRole)) {
//                // Premium được phép xem tất cả dự án họ tham gia, vai trò nào cũng được
//                if (projectRoles.contains("Leader")) {
//                    list.addAll(dao.getProjectsByUserAndRole(userId, "Leader"));
//                }
//                if (projectRoles.contains("Member")) {
//                    list.addAll(dao.getProjectsByUserAndRole(userId, "Member"));
//                }
//
//            } else if ("User".equals(userSystemRole)) {
//                // User thường chỉ được phép xuất nếu là Leader
//                if (projectRoles.contains("Leader")) {
//                    list = dao.getProjectsByUserAndRole(userId, "Leader");
//                } else if (projectRoles.contains("Member")) {
//                    throw new ServletException("Bạn cần nâng cấp lên Premium để xuất PDF cho dự án này.");
//                }
//
//            } else if ("Admin".equals(userSystemRole)) {
//                // Tùy bạn, ở đây ví dụ cho Admin có thể xuất hết
//                list.addAll(dao.getProjectsByUserAndRole(userId, "Leader"));
//                list.addAll(dao.getProjectsByUserAndRole(userId, "Member"));
//            }
//
//            Document document = new Document();
//            PdfWriter.getInstance(document, response.getOutputStream());
//            document.open();
//
//            document.add(new Paragraph("BÁO CÁO DỰ ÁN", font));
//            document.add(Chunk.NEWLINE);
//
//            if (list != null && !list.isEmpty()) {
//                ProjectOverview first = list.get(0);
//                document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName(), font));
//                document.add(new Paragraph("Mô tả: " + first.getProjectDescription(), font));
//                document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy()
//                        + " | Ngày tạo: " + first.getProjectCreatedAt()
//                        + " | Leader: " + first.getUsername(), font));
//                document.add(Chunk.NEWLINE);
//
//                PdfPTable table = new PdfPTable(8);
//                table.setWidthPercentage(100);
//
//                table.addCell(new PdfPCell(new Phrase("Thành viên", font)));
//                table.addCell(new PdfPCell(new Phrase("Vai trò", font)));
//                table.addCell(new PdfPCell(new Phrase("Tên công việc", font)));
//                table.addCell(new PdfPCell(new Phrase("Mô tả", font)));
//                table.addCell(new PdfPCell(new Phrase("Hạn", font)));
//                table.addCell(new PdfPCell(new Phrase("Ngày tạo", font)));
//                table.addCell(new PdfPCell(new Phrase("Người tạo", font)));
//                table.addCell(new PdfPCell(new Phrase("Trạng thái", font)));
//
//                String currentUsername = "";
//                for (ProjectOverview po : list) {
//                    boolean showUser = !po.getUsername().equals(currentUsername);
//                    currentUsername = po.getUsername();
//
//                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getUsername() : "", font)));
//                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getRole() : "", font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
//                }
//
//                document.add(table);
//            } else {
//                document.add(new Paragraph("Không có dữ liệu cho dự án này.", font));
//            }
//
//            document.close();
//
//        } catch (DocumentException | SQLException e) {
//            throw new ServletException("Lỗi khi tạo PDF", e);
//        }
//    }
//}

//@WebServlet("/exportPDF")
//public class ExportPdfServlet extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Load font từ classpath
//        InputStream fontStream = getClass().getClassLoader().getResourceAsStream("fonts/times.ttf");
//        if (fontStream == null) {
//            throw new IOException("Font file not found: fonts/times.ttf");
//        }
//
//        BaseFont bf;
//        try {
//            bf = BaseFont.createFont("times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED,
//                    false, fontStream.readAllBytes(), null);
//        } catch (DocumentException e) {
//            throw new ServletException("Failed to load font", e);
//        }
//        Font font = new Font(bf, 12);
//
//        response.setContentType("application/pdf");
//        response.setHeader("Content-Disposition", "attachment; filename=report.pdf");
//
//        try {
//            HttpSession session = request.getSession();
//            User user = (User) session.getAttribute("user");
//
//            if (user == null) {
//                response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
//                return;
//            }
//
//            String projectIdParam = request.getParameter("projectId");
//            if (projectIdParam == null) {
//                throw new ServletException("Thiếu projectId");
//            }
//
//            int projectId = Integer.parseInt(projectIdParam);
//            int userId = user.getUserId();
//
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//            // 🔽 Sửa ở đây: lấy danh sách theo cả leaderId và projectId
//            List<ProjectOverview> list = dao.getProjectByIdAndLeader(projectId, userId);
//
//            Document document = new Document();
//            PdfWriter.getInstance(document, response.getOutputStream());
//            document.open();
//
//            document.add(new Paragraph("BÁO CÁO DỰ ÁN", font));
//            document.add(Chunk.NEWLINE);
//
//            if (list != null && !list.isEmpty()) {
//                ProjectOverview first = list.get(0);
//                document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName(), font));
//                document.add(new Paragraph("Mô tả: " + first.getProjectDescription(), font));
//                document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy() +
//                        " | Ngày tạo: " + first.getProjectCreatedAt() +
//                        " | Leader: " + first.getUsername(), font));
//                document.add(Chunk.NEWLINE);
//
//                PdfPTable table = new PdfPTable(8);
//                table.setWidthPercentage(100);
//
//                table.addCell(new PdfPCell(new Phrase("Thành viên", font)));
//                table.addCell(new PdfPCell(new Phrase("Vai trò", font)));
//                table.addCell(new PdfPCell(new Phrase("Tên công việc", font)));
//                table.addCell(new PdfPCell(new Phrase("Mô tả", font)));
//                table.addCell(new PdfPCell(new Phrase("Hạn", font)));
//                table.addCell(new PdfPCell(new Phrase("Ngày tạo", font)));
//                table.addCell(new PdfPCell(new Phrase("Người tạo", font)));
//                table.addCell(new PdfPCell(new Phrase("Trạng thái", font)));
//
//                String currentUsername = "";
//                for (ProjectOverview po : list) {
//                    boolean showUser = !po.getUsername().equals(currentUsername);
//                    currentUsername = po.getUsername();
//
//                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getUsername() : "", font)));
//                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getRole() : "", font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
//                }
//
//                document.add(table);
//            } else {
//                document.add(new Paragraph("Không có dữ liệu cho dự án này.", font));
//            }
//
//            document.close();
//
//        } catch (DocumentException | SQLException e) {
//            throw new ServletException("Lỗi khi tạo PDF", e);
//        }
//    }
//}
//
//
//
//@WebServlet("/exportPDF")
//public class ExportPdfServlet extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Đọc font từ classpath
//        InputStream fontStream = getClass().getClassLoader().getResourceAsStream("fonts/times.ttf");
//        if (fontStream == null) {
//            throw new IOException("Font file not found: fonts/times.ttf");
//        }
//
//        BaseFont bf;
//        try {
//            bf = BaseFont.createFont("times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED,
//                    false, fontStream.readAllBytes(), null);
//        } catch (DocumentException e) {
//            throw new ServletException("Failed to load font", e);
//        }
//        Font font = new Font(bf, 12);
//
//        response.setContentType("application/pdf");
//        response.setHeader("Content-Disposition", "attachment; filename=report.pdf");
//
//        try {
//            HttpSession session = request.getSession();
//            User user = (User) session.getAttribute("user");
//
//            if (user == null) {
//                response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
//                return;
//            }
//
//            int userId = user.getUserId();
//
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//            List<ProjectOverview> list = dao.getProjectsByLeaderId(userId);
//
//            Document document = new Document();
//            PdfWriter.getInstance(document, response.getOutputStream());
//            document.open();
//
//            document.add(new Paragraph("BÁO CÁO DỰ ÁN", font));
//            document.add(Chunk.NEWLINE);
//
//            if (list != null && !list.isEmpty()) {
//                ProjectOverview first = list.get(0);
//                document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName(), font));
//                document.add(new Paragraph("Mô tả: " + first.getProjectDescription(), font));
//                document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy() +
//                        " | Ngày tạo: " + first.getProjectCreatedAt() +
//                        " | Leader: " + first.getUsername(), font));
//                document.add(Chunk.NEWLINE);
//
//                PdfPTable table = new PdfPTable(8);
//                table.setWidthPercentage(100);
//
//                table.addCell(new PdfPCell(new Phrase("Thành viên", font)));
//                table.addCell(new PdfPCell(new Phrase("Vai trò", font)));
//                table.addCell(new PdfPCell(new Phrase("Tên công việc", font)));
//                table.addCell(new PdfPCell(new Phrase("Mô tả", font)));
//                table.addCell(new PdfPCell(new Phrase("Hạn", font)));
//                table.addCell(new PdfPCell(new Phrase("Ngày tạo", font)));
//                table.addCell(new PdfPCell(new Phrase("Người tạo", font)));
//                table.addCell(new PdfPCell(new Phrase("Trạng thái", font)));
//
//                String currentUsername = "";
//                for (ProjectOverview po : list) {
//                    boolean showUser = !po.getUsername().equals(currentUsername);
//                    currentUsername = po.getUsername();
//
//                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getUsername() : "", font)));
//                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getRole() : "", font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
//                    table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
//                }
//
//                document.add(table);
//            } else {
//                document.add(new Paragraph("Không có dữ liệu.", font));
//            }
//
//            document.close();
//
//        } catch (DocumentException | SQLException e) {
//            throw new ServletException("Lỗi khi tạo PDF", e);
//        }
//    }
//}

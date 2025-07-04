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
import java.util.List;







@WebServlet("/exportPDF")
public class ExportPdfServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load font từ classpath
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

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=report.pdf");

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
                return;
            }

            String projectIdParam = request.getParameter("projectId");
            if (projectIdParam == null) {
                throw new ServletException("Thiếu projectId");
            }

            int projectId = Integer.parseInt(projectIdParam);
            int leaderUserId = user.getUserId();

            ProjectOverviewDao dao = new ProjectOverviewDao();
            // 🔽 Sửa ở đây: lấy danh sách theo cả leaderId và projectId
            List<ProjectOverview> list = dao.getProjectByIdAndLeader(projectId, leaderUserId);

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            document.add(new Paragraph("BÁO CÁO DỰ ÁN", font));
            document.add(Chunk.NEWLINE);

            if (list != null && !list.isEmpty()) {
                ProjectOverview first = list.get(0);
                document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName(), font));
                document.add(new Paragraph("Mô tả: " + first.getProjectDescription(), font));
                document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy() +
                        " | Ngày tạo: " + first.getProjectCreatedAt() +
                        " | Leader: " + first.getUsername(), font));
                document.add(Chunk.NEWLINE);

                PdfPTable table = new PdfPTable(8);
                table.setWidthPercentage(100);

                table.addCell(new PdfPCell(new Phrase("Thành viên", font)));
                table.addCell(new PdfPCell(new Phrase("Vai trò", font)));
                table.addCell(new PdfPCell(new Phrase("Tên công việc", font)));
                table.addCell(new PdfPCell(new Phrase("Mô tả", font)));
                table.addCell(new PdfPCell(new Phrase("Hạn", font)));
                table.addCell(new PdfPCell(new Phrase("Ngày tạo", font)));
                table.addCell(new PdfPCell(new Phrase("Người tạo", font)));
                table.addCell(new PdfPCell(new Phrase("Trạng thái", font)));

                String currentUsername = "";
                for (ProjectOverview po : list) {
                    boolean showUser = !po.getUsername().equals(currentUsername);
                    currentUsername = po.getUsername();

                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getUsername() : "", font)));
                    table.addCell(new PdfPCell(new Phrase(showUser ? po.getRole() : "", font)));
                    table.addCell(new PdfPCell(new Phrase(po.getTaskTitle(), font)));
                    table.addCell(new PdfPCell(new Phrase(po.getTaskDescription(), font)));
                    table.addCell(new PdfPCell(new Phrase(po.getDueDate(), font)));
                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedAt(), font)));
                    table.addCell(new PdfPCell(new Phrase(po.getTaskCreatedBy(), font)));
                    table.addCell(new PdfPCell(new Phrase(po.getTaskStatus(), font)));
                }

                document.add(table);
            } else {
                document.add(new Paragraph("Không có dữ liệu cho dự án này.", font));
            }

            document.close();

        } catch (DocumentException | SQLException e) {
            throw new ServletException("Lỗi khi tạo PDF", e);
        }
    }
}





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
//            int leaderUserId = user.getUserId();
//
//            ProjectOverviewDao dao = new ProjectOverviewDao();
//            List<ProjectOverview> list = dao.getProjectsByLeaderId(leaderUserId);
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
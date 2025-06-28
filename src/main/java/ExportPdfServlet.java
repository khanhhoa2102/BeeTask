
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.Font;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;




import java.io.IOException;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;
import dao.ProjectOverviewDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ProjectOverview;
import model.User;




@WebServlet("/exportPDF")
public class ExportPdfServlet extends HttpServlet {
   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
       
       String fontPath = getClass().getClassLoader().getResource("fonts/times.ttf").getPath();

//       String fontPath = getServletContext().getRealPath("src/main/resources/fonts/times.ttf");

BaseFont bf = null;
       try {
           bf = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
       } catch (DocumentException ex) {
           Logger.getLogger(ExportPdfServlet.class.getName()).log(Level.SEVERE, null, ex);
       }
Font font = new Font(bf, 12);


        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=report.pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            document.add(new Paragraph("BÁO CÁO DỰ ÁN", font));

//            // 🟡 Lấy dữ liệu trực tiếp từ DAO
//            int leaderUserId = Integer.parseInt(request.getParameter("leaderId")); // bạn cần truyền ?leaderId=...


 HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        
        int leaderUserId = user.getUserId();
        
       

            ProjectOverviewDao dao = new ProjectOverviewDao();
            List<ProjectOverview> list = dao.getProjectsByLeaderId(leaderUserId);

            
            ProjectOverview first = list.get(0); // Lấy dòng đầu tiên để lấy thông tin chung

document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName(), font));
document.add(new Paragraph("Mô tả: " + first.getProjectDescription(), font));
document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy() +
        " | Ngày tạo: " + first.getProjectCreatedAt() +
        " | Leader: " + first.getUsername(), font));
document.add(new Paragraph(" ", font)); // dòng trắng

            
            
//            ProjectOverview first = list.get(0); // Lấy dòng đầu tiên để lấy thông tin chung
//document.add(new Paragraph("DỰ ÁN: " + first.getProjectId() + " - " + first.getProjectName()));
//document.add(new Paragraph("Mô tả: " + first.getProjectDescription()));
//document.add(new Paragraph("Người tạo: " + first.getProjectCreatedBy() +
//        " | Ngày tạo: " + first.getProjectCreatedAt() +
//        " | Leader: " + first.getUsername()));
//document.add(new Paragraph(" ")); // dòng trắng
//            
            
            
            
            
            
            if (list != null && !list.isEmpty()) {
                
                
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


//table.addCell("Thành viên");
//table.addCell("Vai trò");
//table.addCell("Tên công việc");
//table.addCell("Mô tả");
//table.addCell("Hạn");
//table.addCell("Ngày tạo");
//table.addCell("Người tạo");
//table.addCell("Trạng thái");

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

                
                
//                PdfPTable table = new PdfPTable(8);
//               table.addCell("Thành viên");
//table.addCell("Vai trò");
//table.addCell("Tên công việc");
//table.addCell("Mô tả");
//table.addCell("Hạn");
//table.addCell("Ngày tạo");
//table.addCell("Người tạo");
//table.addCell("Trạng thái");
//
//
//                for (ProjectOverview po : list) {
//    table.addCell(po.getUsername());
//    table.addCell(po.getRole());
//    table.addCell(po.getTaskTitle());
//    table.addCell(po.getTaskDescription());
//    table.addCell(po.getDueDate());
//    table.addCell(po.getTaskCreatedAt());
//    table.addCell(po.getTaskCreatedBy());
//    table.addCell(po.getTaskStatus());
//}
//
//
//                document.add(table);
            } else {
                document.add(new Paragraph("Không có dữ liệu."));
            }

            document.close();

        } catch (DocumentException | SQLException e) {
            throw new ServletException("Lỗi khi tạo PDF", e);
        }
    }
}








//@WebServlet("/exportPDF")
//public class ExportPdfServlet extends HttpServlet {
//   @Override
//protected void doGet(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//    response.setContentType("application/pdf");
//    response.setHeader("Content-Disposition", "attachment; filename=report.pdf");
//
//    try {
//        Document document = new Document();
//        PdfWriter.getInstance(document, response.getOutputStream());
//        document.open();
//
//        document.add(new Paragraph("BÁO CÁO DỰ ÁN"));
//
//        List<ProjectOverview> list = (List<ProjectOverview>) request.getSession().getAttribute("overviewList");
//
//        if (list != null && !list.isEmpty()) {
//            PdfPTable table = new PdfPTable(4);
//            table.addCell("Thành viên");
//            table.addCell("Tên công việc");
//            table.addCell("Hạn");
//            table.addCell("Trạng thái");
//
//            for (ProjectOverview po : list) {
//                table.addCell(po.getUsername());
//                table.addCell(po.getTaskTitle());
//                table.addCell(po.getDueDate());
//                table.addCell(po.getTaskStatus());
//            }
//
//            document.add(table);
//        } else {
//            document.add(new Paragraph("Không có dữ liệu."));
//        }
//
//        document.close();
//
//    } catch (DocumentException e) {
//        throw new ServletException("Lỗi khi tạo PDF", e);
//    }
//}
//}

package controller;

import context.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.UUID;

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verify-code"})
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputCode = request.getParameter("verificationCode");
        HttpSession session = request.getSession(false);

        if (session == null) {
            request.setAttribute("message", "❌ Phiên làm việc không hợp lệ.");
            request.getRequestDispatcher("EnterOTP.jsp").forward(request, response);
            return;
        }

        String sessionOTP = (String) session.getAttribute("otp");
        Timestamp otpExpiry = (Timestamp) session.getAttribute("otpExpiry");
        String resetEmail = (String) session.getAttribute("resetEmail");

        System.out.println(">>>> [POST] OTP nhập: " + inputCode);
        System.out.println(">>>> [POST] OTP session: " + sessionOTP);
        System.out.println(">>>> [POST] OTP hết hạn: " + otpExpiry);
        System.out.println(">>>> [POST] Email session: " + resetEmail);

        if (sessionOTP == null || otpExpiry == null || inputCode == null || resetEmail == null) {
            request.setAttribute("message", "❌ Dữ liệu phiên không đầy đủ.");
            request.getRequestDispatcher("EnterOTP.jsp").forward(request, response);
            return;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());

        if (now.after(otpExpiry)) {
            request.setAttribute("message", "❌ Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        if (!sessionOTP.trim().equals(inputCode.trim())) {
            request.setAttribute("message", "❌ Mã OTP không chính xác.");
            request.getRequestDispatcher("EnterOTP.jsp").forward(request, response);
            return;
        }

        // ✅ OTP hợp lệ → sinh token và lưu vào DB
        String token = UUID.randomUUID().toString();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement getUserStmt = conn.prepareStatement("SELECT UserId FROM Users WHERE Email = ?");
            getUserStmt.setString(1, resetEmail);
            ResultSet rs = getUserStmt.executeQuery();

            if (!rs.next()) {
                request.setAttribute("message", "❌ Người dùng không tồn tại.");
                request.getRequestDispatcher("EnterOTP.jsp").forward(request, response);
                return;
            }

            int userId = rs.getInt("UserId");

            // Thêm token vào bảng TokenForgetPassword
            PreparedStatement insertToken = conn.prepareStatement(
                    "INSERT INTO TokenForgetPassword (Token, ExpiryTime, IsUsed, UserId) VALUES (?, ?, 0, ?)");
            Timestamp expiry = new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000); // +10 phút
            insertToken.setString(1, token);
            insertToken.setTimestamp(2, expiry);
            insertToken.setInt(3, userId);
            insertToken.executeUpdate();

            // Gán token vào session để chuyển sang ResetPasswordServlet xử lý
            session.removeAttribute("otp");
            session.removeAttribute("otpExpiry");
            session.setAttribute("resetToken", token);

            System.out.println(">>>>> ✅ OTP xác minh thành công. Token reset = " + token);

            response.sendRedirect("reset-password");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("EnterOTP.jsp").forward(request, response);
        }
    }
}

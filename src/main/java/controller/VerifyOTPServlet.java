package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;

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


        if (sessionOTP == null || otpExpiry == null || inputCode == null) {
            request.setAttribute("message", "❌ Mã OTP không tồn tại hoặc phiên đã hết hạn.");
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

        // ✅ OTP hợp lệ → chuyển đến trang đổi mật khẩu
        session.removeAttribute("otp");
        session.removeAttribute("otpExpiry");

        // Giữ lại email để xác định người dùng khi đổi mật khẩu
        String resetEmail = (String) session.getAttribute("resetEmail");
        request.setAttribute("resetEmail", resetEmail);

        request.setAttribute("message", "✅ Xác minh thành công, vui lòng đặt lại mật khẩu.");
        request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
    }
}

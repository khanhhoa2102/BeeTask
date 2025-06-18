package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import java.util.Random;

public class EmailSender {

    private static final String FROM_EMAIL = "khanhhoakt2k4@gmail.com"; // Email gửi đi
    private static final String PASSWORD = "srgf geef utea aita"; // App password

    public static String getRandom() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }

    public static boolean sendOTP(String toEmail, String otp) {
        try {
            // Cấu hình SMTP
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });

            session.setDebug(true); // Bật log gửi mail

            // Soạn nội dung email
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, "BeeTask Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Mã OTP xác thực BeeTask");

            String htmlContent = "<p>Xin chào,</p>"
                    + "<p>Bạn vừa yêu cầu đặt lại mật khẩu tài khoản BeeTask.</p>"
                    + "<p><b>Mã OTP của bạn là: <span style='font-size:18px; color:#2e6da4;'>" + otp + "</span></b></p>"
                    + "<p><i>Lưu ý: Mã OTP chỉ có hiệu lực trong 10 phút.</i></p>"
                    + "<p>Trân trọng,<br>Đội ngũ BeeTask</p>";

            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            return true;

        } catch (Exception e) {
            System.err.println("❌ Lỗi gửi email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public static void main(String[] args) {
        // Nhập email người nhận để test
        String toEmail = "nguyenhuusona6@gmail.com";  // ⚠️ Thay đổi thành email thật để test

        // Tạo và gửi OTP
        EmailSender sender = new EmailSender();
        String otp = sender.getRandom();

        boolean result = sendOTP(toEmail, otp);

        if (result) {
            System.out.println("✅ Gửi mã OTP thành công tới " + toEmail + ": " + otp);
        } else {
            System.out.println("❌ Gửi OTP thất bại.");
        }
    }

}

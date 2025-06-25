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
            // Validate email format
            if (toEmail == null || !toEmail.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                System.err.println("❌ Invalid email address: " + toEmail);
                return false;
            }

            // SMTP configuration
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

            session.setDebug(true); // Enable SMTP debug logging

            // Compose email content
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, "BeeTask Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Your BeeTask OTP Verification Code");

            String htmlContent = "<p>Hello,</p>"
                    + "<p>You have just requested to register a BeeTask account.</p>"
                    + "<p><b>Your OTP code is: <span style='font-size:18px; color:#2e6da4;'>" + otp + "</span></b></p>"
                    + "<p><i>Note: This OTP is valid for 10 minutes only.</i></p>"
                    + "<p>Best regards,<br>The BeeTask Team</p>";

            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            return true;

        } catch (Exception e) {
            System.err.println("❌ Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        // Nhập email người nhận để test
        String toEmail = "nguyenhuusona6@gmail.com";

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

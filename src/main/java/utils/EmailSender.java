package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.sql.Timestamp;
import java.util.Properties;
import java.util.Random;
import model.Notification;

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

    public static boolean sendEmail(String toEmail, String subject, String htmlContent) {
        try {
            if (toEmail == null || !toEmail.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                System.err.println("❌ Invalid email format: " + toEmail);
                return false;
            }

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

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, "BeeTask Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("✅ Email sent successfully to " + toEmail);
            return true;

        } catch (SendFailedException sfe) {
            System.err.println("❌ Email address unreachable or does not exist: " + toEmail);
            sfe.printStackTrace();
            return false;
        } catch (MessagingException me) {
            System.err.println("❌ Messaging error: " + me.getMessage());
            me.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("❌ General failure when sending email to: " + toEmail);
            e.printStackTrace();
            return false;
        }
    }

    public static String inviteUserToProject(String email, int projectId, String baseUrl) {
        dao.UserDAO userDAO = new dao.UserDAO();
        dao.ProjectDAO projectDAO = new dao.ProjectDAO();
        dao.NotificationDAO notiDAO = new dao.NotificationDAO();
        dao.InvitationDAO invitationDAO = new dao.InvitationDAO();

        // Kiểm tra email hợp lệ
        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "INVALID_EMAIL";
        }

        model.User invitedUser = userDAO.getUserByEmail(email);
        boolean isRegistered = invitedUser != null;

        Integer userId = isRegistered ? invitedUser.getUserId() : null;

        // Nếu chưa đăng ký, tạo thông tin tạm
        String username = isRegistered ? invitedUser.getUsername()
                : email.substring(0, email.indexOf("@"));

        // Đã là thành viên thì không mời
        if (isRegistered && projectDAO.isUserInProject(projectId, userId)) {
            return "ALREADY_MEMBER";
        }

        // Đã được mời rồi (kiểm tra theo email)
        if (invitationDAO.isAlreadyInvited(email, projectId)) {
            return "ALREADY_INVITED";
        }

        // Tạo invitation
        model.Invitation invitation = new model.Invitation();
        invitation.setProjectId(projectId);
        invitation.setUserId(userId); // có thể là null
        invitation.setEmail(email);
        invitation.setStatus("Pending");
        invitation.setSentAt(new Timestamp(System.currentTimeMillis()));
        int generatedId = invitationDAO.createInvitation(invitation);
        invitation.setInvitationId(generatedId);

        // Gửi thông báo nội bộ nếu đã đăng ký
        if (isRegistered) {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setMessage("Bạn đã nhận được lời mời tham gia một dự án mới.");
            notification.setIsRead(false);
            notification.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            notiDAO.addNotification(notification);
        }

        // Tạo đường dẫn xác nhận
        String link = baseUrl + "/invitation-action?invitationId=" + invitation.getInvitationId() + "&action=accept";
        String subject = "You're invited to join a BeeTask Project";

        String html = "<div style='font-family:Segoe UI, Roboto, sans-serif; max-width:600px; margin:auto; border:1px solid #e0e0e0; border-radius:10px; padding:20px;'>"
                + "<h2 style='color:#2e6da4;'>Hello <span style='color:#333;'>" + username + "</span>,</h2>"
                + "<p style='font-size:16px; color:#555;'>You've been invited to join a project on <strong>BeeTask</strong>.</p>"
                + "<p style='font-size:16px; color:#555;'>To accept the invitation and join the project, click the button below:</p>"
                + "<div style='text-align:center; margin:30px 0;'>"
                + "    <a href='" + link + "' style='background-color:#1a73e8; color:white; padding:12px 24px; text-decoration:none; border-radius:6px; font-weight:bold;'>"
                + "        Accept Invitation"
                + "    </a>"
                + "</div>"
                + "<p style='font-size:14px; color:#777;'>If this wasn't you, feel free to ignore this email.</p>"
                + "<p style='margin-top:30px; font-size:15px;'>Warm regards,<br><strong>BeeTask Team</strong></p>"
                + "</div>";

        boolean emailSent = sendEmail(email, subject, html);
        if (!emailSent) {
            return "INVALID_EMAIL";
        }

        return "SUCCESS";
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

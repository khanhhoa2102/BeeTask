package utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    // Hash mật khẩu với salt động
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    // So sánh mật khẩu người dùng nhập và mật khẩu đã hash trong DB
    public static boolean checkPassword(String password, String hashed) {
        return BCrypt.checkpw(password, hashed);
    }
}

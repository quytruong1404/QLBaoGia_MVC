package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // 1. Thông số kết nối (Dựa trên file crm.sql của bạn)
    private static String jdbcURL = "jdbc:mysql://localhost:3306/crm?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static String jdbcUsername = "root"; 
    private static String jdbcPassword = ""; 

    // 2. Hàm lấy kết nối
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Đăng ký Driver (Dùng cho MySQL 8.0/9.0 trở lên)
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (ClassNotFoundException e) {
            System.out.println("Lỗi: Không tìm thấy Driver MySQL!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Lỗi: Không thể kết nối đến database 'crm'!");
            e.printStackTrace();
        }
        return connection;
    }

    // 3. Hàm main để chạy kiểm tra (Chuột phải chọn Run As > Java Application)
    public static void main(String[] args) {
        Connection testConn = getConnection();
        if (testConn != null) {
            System.out.println("--- KẾT NỐI THÀNH CÔNG ĐẾN DATABASE CRM ---");
            try {
                testConn.close(); // Đóng kết nối sau khi test xong
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("--- KẾT NỐI THẤT BẠI! Kiểm tra lại MySQL Server nhé ---");
        }
    }
}
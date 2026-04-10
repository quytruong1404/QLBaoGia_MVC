📊 Hệ thống Quản lý Báo giá (QLBaoGia_MVC)
Dự án thực tập xây dựng mô đun Quản lý Báo giá (Quotes) thuộc hệ thống CRM, sử dụng ngôn ngữ Java theo mô hình MVC (Model-View-Controller).

🚀 Giới thiệu
Dự án tập trung vào việc số hóa quy trình lập báo giá, giúp bộ phận Sales quản lý các giao dịch với khách hàng tiềm năng một cách chuyên nghiệp và chính xác.

🛠 Công nghệ sử dụng
Backend: Java Servlet, JDBC.
Frontend: JSP, JSTL, Tailwind CSS (UI thiết kế theo Figma), FontAwesome.
Database: MySQL 9.1.0.
Server: Apache Tomcat 9.0.
IDE: Eclipse (Dynamic Web Project).

✨ Tính năng chính (Epic 5: Quản lý Báo giá)
Task 5.1: CRUD thông tin Báo giá cơ bản
Xem danh sách: Hiển thị danh sách báo giá với đầy đủ thông tin: Mã báo giá, Tên khách hàng (JOIN từ bảng Leads), Ngày lập, Trạng thái, Tổng tiền.
Thêm mới: Form tạo báo giá với các trường: Số BG, Lead ID, Ngày lập, Hiệu lực....
Cập nhật: Chỉnh sửa thông tin báo giá đã tồn tại.
Xóa: Hỗ trợ xóa báo giá (Có ràng buộc kiểm tra khóa ngoại).

Validation:
Kiểm tra trùng lặp Số báo giá (Server-side).
Kiểm tra logic ngày hết hạn không được nhỏ hơn ngày lập (Client & Server side).
Bắt lỗi ID khách hàng không tồn tại.

📁 Cấu trúc thư mục
Plaintext
QLBaoGia_MVC/
├── db/                 # Chứa file crm.sql khởi tạo database
├── src/main/java/
│   ├── controller/     # QuoteServlet (Xử lý điều hướng)
│   ├── dao/            # QuoteDAO (Truy vấn cơ sở dữ liệu)
│   ├── model/          # Quote (Đối tượng dữ liệu)
│   └── util/           # DBConnection (Kết nối MySQL)
├── src/main/webapp/    # Giao diện JSP và cấu hình Web
└── README.md
⚙️ Cài đặt và Chạy thử
Cơ sở dữ liệu:
Tạo database tên crm trong MySQL.
Import file db/crm.sql vào database vừa tạo.
Cấu hình kết nối:
Mở file util/DBConnection.java.
Cập nhật jdbcUsername và jdbcPassword theo cấu hình máy cá nhân.

Chạy dự án:
Import project vào Eclipse.
Add thư viện mysql-connector-java.jar và jstl-1.2.jar vào WEB-INF/lib.
Chuột phải vào dự án -> Run As -> Run on Server (Chọn Tomcat 9).

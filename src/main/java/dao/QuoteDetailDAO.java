package dao;

import java.sql.*;
import java.util.*;
import model.QuoteDetail;
import util.DBConnection;

public class QuoteDetailDAO {
    // Lấy danh sách sản phẩm theo ID báo giá
	public List<QuoteDetail> getDetailsByQuoteId(int quoteId) {
	    List<QuoteDetail> list = new ArrayList<>();
	    // JOIN với bảng products để lấy tên sản phẩm
	    String sql = "SELECT qd.*, p.name FROM crm_quote_details qd " +
	                 "JOIN products p ON qd.product_id = p.id WHERE qd.quote_id = ?";
	    try (Connection conn = util.DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, quoteId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            QuoteDetail d = new QuoteDetail();
	            d.setProductName(rs.getString("name"));
	            d.setQuantity(rs.getInt("quantity"));
	            d.setUnitPrice(rs.getDouble("unit_price"));
	            
	            // QUAN TRỌNG: Kiểm tra đúng tên cột trong crm.sql
	            d.setDiscountPercent(rs.getDouble("discount_percent")); 
	            d.setTaxRate(rs.getDouble("tax_rate"));
	            d.setLineTotal(rs.getDouble("line_total")); // Phải là line_total, không được nhầm với id
	            
	            list.add(d);
	        }
	    } catch (SQLException e) { e.printStackTrace(); }
	    return list;
	}

    // Thêm sản phẩm vào báo giá
    public void addDetail(QuoteDetail detail) throws SQLException {
        String sql = "INSERT INTO crm_quote_details (quote_id, product_id, quantity, " +
                     "unit_price, discount_percent, tax_rate, line_total) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            detail.calculateLineTotal(); // Tính toán trước khi lưu
            
            ps.setInt(1, detail.getQuoteId());
            ps.setInt(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setDouble(4, detail.getUnitPrice());
            ps.setDouble(5, detail.getDiscountPercent());
            ps.setDouble(6, detail.getTaxRate());
            ps.setDouble(7, detail.getLineTotal());
            ps.executeUpdate();
            
            // Sau khi thêm chi tiết, phải cập nhật lại tổng tiền ở bảng crm_quotes
            updateQuoteFinancials(detail.getQuoteId());
        }
    }
    public void updateQuoteFinancials(int quoteId) throws SQLException {
        // 1. Câu lệnh lấy tổng các thành phần tài chính từ bảng chi tiết
        String sumSql = "SELECT " +
                        "SUM(quantity * unit_price) as raw_total, " +
                        "SUM(quantity * unit_price * discount_percent / 100) as total_discount, " +
                        "SUM(line_total) as final_total " +
                        "FROM crm_quote_details WHERE quote_id = ?";

        // 2. Câu lệnh cập nhật ngược lại bảng báo giá
        String updateSql = "UPDATE crm_quotes SET total_amount = ?, discount_amount = ?, " +
                           "tax_amount = ?, grand_total = ? WHERE id = ?";

        try (Connection conn = util.DBConnection.getConnection()) {
            // Tắt auto-commit để đảm bảo tính toàn vẹn (Transaction)
            conn.setAutoCommit(false);
            try {
                double rawTotal = 0, totalDiscount = 0, finalTotal = 0;

                // BƯỚC 1: TÍNH TOÁN
                try (PreparedStatement psSum = conn.prepareStatement(sumSql)) {
                    psSum.setInt(1, quoteId);
                    ResultSet rs = psSum.executeQuery();
                    if (rs.next()) {
                        rawTotal = rs.getDouble("raw_total");
                        totalDiscount = rs.getDouble("total_discount");
                        finalTotal = rs.getDouble("final_total");
                    }
                }

                // Tính toán tiền thuế dựa trên chênh lệch
                double taxAmount = finalTotal - (rawTotal - totalDiscount);

                // BƯỚC 2: CẬP NHẬT
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setDouble(1, rawTotal);      // total_amount
                    psUpdate.setDouble(2, totalDiscount); // discount_amount
                    psUpdate.setDouble(3, taxAmount);      // tax_amount
                    psUpdate.setDouble(4, finalTotal);     // grand_total
                    psUpdate.setInt(5, quoteId);
                    psUpdate.executeUpdate();
                }

                conn.commit(); // Hoàn tất giao dịch
            } catch (SQLException e) {
                conn.rollback(); // Hủy bỏ nếu có lỗi
                throw e;
            }
        }
    }
}
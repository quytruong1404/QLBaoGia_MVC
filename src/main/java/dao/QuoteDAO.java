package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Quote;
import util.DBConnection;

public class QuoteDAO {
	private String SELECT_ALL = "SELECT q.*, l.FullName FROM crm_quotes q " +
            "LEFT JOIN leads l ON q.lead_id = l.LeadID";
    private String INSERT = "INSERT INTO crm_quotes (quote_number, lead_id, quote_date, valid_until, approval_status, stage) VALUES (?, ?, ?, ?, ?, ?)";
    private String DELETE = "DELETE FROM crm_quotes WHERE id = ?";
    private String GET_BY_ID = "SELECT * FROM crm_quotes WHERE id = ?";
    private String UPDATE = "UPDATE crm_quotes SET quote_number=?, lead_id=?, quote_date=?, valid_until=?, approval_status=?, stage=? WHERE id=?";

    public List<Quote> getAllQuotes() {
        List<Quote> list = new ArrayList<>();
        // Câu lệnh SQL JOIN lấy FullName từ bảng leads
        String sql = "SELECT q.*, l.FullName FROM crm_quotes q " +
                     "JOIN leads l ON q.lead_id = l.LeadID"; 

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Quote q = new Quote(
                    rs.getInt("id"),
                    rs.getString("quote_number"),
                    rs.getInt("lead_id"),
                    rs.getString("FullName"),
                    rs.getDate("quote_date"),
                    rs.getDate("valid_until"),
                    rs.getString("approval_status"),
                    rs.getString("stage"),
                    rs.getDouble("grand_total")
                );
                list.add(q);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public void addQuote(Quote q) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(INSERT)) {
            ps.setString(1, q.getQuoteNumber());
            ps.setInt(2, q.getLeadId());
            ps.setDate(3, q.getQuoteDate());
            ps.setDate(4, q.getValidUntil());
            ps.setString(5, q.getApprovalStatus());
            ps.setString(6, q.getStage());
            ps.executeUpdate();
        }
    }

    public void deleteQuote(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Quote getQuoteById(int id) {
        Quote quote = null;
        // Lấy đầy đủ các trường tài chính
        String sql = "SELECT q.*, l.FullName FROM crm_quotes q " +
                     "JOIN leads l ON q.lead_id = l.LeadID WHERE q.id = ?";
        try (Connection conn = util.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                quote = new Quote();
                quote.setId(rs.getInt("id"));
                quote.setQuoteNumber(rs.getString("quote_number"));
                quote.setCustomerName(rs.getString("FullName"));
                quote.setQuoteDate(rs.getDate("quote_date"));
                quote.setValidUntil(rs.getDate("valid_until"));
                quote.setStage(rs.getString("stage"));
                
                // BỔ SUNG: Ánh xạ chính xác các trường tài chính từ DB
                quote.setTotalAmount(rs.getDouble("total_amount"));
                quote.setDiscountAmount(rs.getDouble("discount_amount"));
                quote.setTaxAmount(rs.getDouble("tax_amount"));
                quote.setGrandTotal(rs.getDouble("grand_total"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return quote;
    }

    public void updateQuote(Quote q) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, q.getQuoteNumber());
            ps.setInt(2, q.getLeadId());
            ps.setDate(3, q.getQuoteDate());
            ps.setDate(4, q.getValidUntil());
            ps.setString(5, q.getApprovalStatus());
            ps.setString(6, q.getStage());
            ps.setInt(7, q.getId());
            ps.executeUpdate();
        }
    }
    public boolean isQuoteNumberExists(String quoteNumber, int currentId) {
        boolean exists = false;
        // Nếu là insert: currentId = 0. Nếu là update: loại trừ chính nó ra.
        String sql = "SELECT 1 FROM crm_quotes WHERE quote_number = ? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, quoteNumber);
            ps.setInt(2, currentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) exists = true;
        } catch (SQLException e) { e.printStackTrace(); }
        return exists;
    }
    public boolean updateQuoteStage(int id, String newStage) throws SQLException {
        String sql = "UPDATE crm_quotes SET stage = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStage);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }
    
}
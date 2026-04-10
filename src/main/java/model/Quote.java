package model;

import java.sql.Date;

public class Quote {
    private int id;
    private String quoteNumber;
    private int leadId;
    private Date quoteDate;
    private Date validUntil;
    private String approvalStatus;
    private String stage;
    private double grandTotal;
    private String customerName;

    public Quote() {}

    // Constructor để lấy dữ liệu từ DB (có ID và GrandTotal)
    public Quote(int id, String quoteNumber, int leadId, String customerName, Date quoteDate, 
            Date validUntil, String approvalStatus, String stage, double grandTotal) {
   this.id = id;
   this.quoteNumber = quoteNumber;
   this.leadId = leadId;
   this.customerName = customerName; // <--- Gán giá trị ở đây
   this.quoteDate = quoteDate;
   this.validUntil = validUntil;
   this.approvalStatus = approvalStatus;
   this.stage = stage;
   this.grandTotal = grandTotal;
}

    // Constructor để thêm mới (không cần ID)
    public Quote(String quoteNumber, int leadId, Date quoteDate, Date validUntil, String approvalStatus, String stage) {
        this.quoteNumber = quoteNumber;
        this.leadId = leadId;
        this.quoteDate = quoteDate;
        this.validUntil = validUntil;
        this.approvalStatus = approvalStatus;
        this.stage = stage;
    }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getQuoteNumber() {
		return quoteNumber;
	}

	public void setQuoteNumber(String quoteNumber) {
		this.quoteNumber = quoteNumber;
	}

	public int getLeadId() {
		return leadId;
	}

	public void setLeadId(int leadId) {
		this.leadId = leadId;
	}

	public Date getQuoteDate() {
		return quoteDate;
	}

	public void setQuoteDate(Date quoteDate) {
		this.quoteDate = quoteDate;
	}

	public Date getValidUntil() {
		return validUntil;
	}

	public void setValidUntil(Date validUntil) {
		this.validUntil = validUntil;
	}

	public String getApprovalStatus() {
		return approvalStatus;
	}

	public void setApprovalStatus(String approvalStatus) {
		this.approvalStatus = approvalStatus;
	}

	public String getStage() {
		return stage;
	}

	public void setStage(String stage) {
		this.stage = stage;
	}

	public double getGrandTotal() {
		return grandTotal;
	}

	public void setGrandTotal(double grandTotal) {
		this.grandTotal = grandTotal;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

    
}
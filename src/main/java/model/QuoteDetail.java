package model;

public class QuoteDetail {
    private int id;
    private int quoteId;
    private int productId;
    private String productName; 
    private int quantity;
    private double unitPrice;
    private double discountPercent; // % chiết khấu từng dòng 
    private double taxRate;         // % thuế suất từng dòng 
    private double lineTotal;       // Thành tiền của dòng này 

    
    public QuoteDetail() {
		super();
	}


	public QuoteDetail(int id, int quoteId, int productId, String productName, int quantity, double unitPrice,
			double discountPercent, double taxRate, double lineTotal) {
		super();
		this.id = id;
		this.quoteId = quoteId;
		this.productId = productId;
		this.productName = productName;
		this.quantity = quantity;
		this.unitPrice = unitPrice;
		this.discountPercent = discountPercent;
		this.taxRate = taxRate;
		this.lineTotal = lineTotal;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public int getQuoteId() {
		return quoteId;
	}


	public void setQuoteId(int quoteId) {
		this.quoteId = quoteId;
	}


	public int getProductId() {
		return productId;
	}


	public void setProductId(int productId) {
		this.productId = productId;
	}


	public String getProductName() {
		return productName;
	}


	public void setProductName(String productName) {
		this.productName = productName;
	}


	public int getQuantity() {
		return quantity;
	}


	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}


	public double getUnitPrice() {
		return unitPrice;
	}


	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}


	public double getDiscountPercent() {
		return discountPercent;
	}


	public void setDiscountPercent(double discountPercent) {
		this.discountPercent = discountPercent;
	}


	public double getTaxRate() {
		return taxRate;
	}


	public void setTaxRate(double taxRate) {
		this.taxRate = taxRate;
	}


	public double getLineTotal() {
		return lineTotal;
	}


	public void setLineTotal(double lineTotal) {
		this.lineTotal = lineTotal;
	}


	public void calculateLineTotal() {
        double base = this.quantity * this.unitPrice;
        double discounted = base - (base * this.discountPercent / 100);
        this.lineTotal = discounted + (discounted * this.taxRate / 100);
    }
}
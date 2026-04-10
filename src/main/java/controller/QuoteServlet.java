package controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.QuoteDAO;
import model.Quote;

@WebServlet("/quotes")
public class QuoteServlet extends HttpServlet {
    private QuoteDAO quoteDAO;

    public void init() { quoteDAO = new QuoteDAO(); }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new": showNewForm(request, response); break;
                case "insert": insertQuote(request, response); break;
                case "delete": deleteQuote(request, response); break;
                case "edit": showEditForm(request, response); break;
                case "update": updateQuote(request, response); break;
                default: listQuotes(request, response); break;
            }
        } catch (SQLException ex) { throw new ServletException(ex); }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private void listQuotes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Quote> listQuotes = quoteDAO.getAllQuotes();
        request.setAttribute("listQuotes", listQuotes);
        request.getRequestDispatcher("views/quote-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("views/quote-form.jsp").forward(request, response);
    }

    private void insertQuote(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String qNumber = request.getParameter("quoteNumber");
        String leadIdStr = request.getParameter("leadId");
        String qDateStr = request.getParameter("quoteDate");
        String vUntilStr = request.getParameter("validUntil");

        // 1. Kiểm tra trống (Server-side validation)
        if (qNumber == null || qNumber.trim().isEmpty() || leadIdStr == null) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc.");
            showNewForm(request, response);
            return;
        }

        // 2. Kiểm tra trùng số báo giá
        if (quoteDAO.isQuoteNumberExists(qNumber, 0)) {
            request.setAttribute("error", "Số báo giá này đã tồn tại trong hệ thống!");
            request.setAttribute("quote", new Quote(qNumber, Integer.parseInt(leadIdStr), 
                                   Date.valueOf(qDateStr), Date.valueOf(vUntilStr), "Draft", "Draft"));
            showNewForm(request, response);
            return;
        }

        // 3. Kiểm tra logic ngày tháng (Ngày hết hạn không được trước ngày lập)
        Date qDate = Date.valueOf(qDateStr);
        Date vUntil = Date.valueOf(vUntilStr);
        if (vUntil.before(qDate)) {
            request.setAttribute("error", "Ngày hết hạn không thể trước ngày lập báo giá.");
            showNewForm(request, response);
            return;
        }

        quoteDAO.addQuote(new Quote(qNumber, Integer.parseInt(leadIdStr), qDate, vUntil, "Draft", "Draft"));
        response.sendRedirect("quotes?action=list");
    }

    private void deleteQuote(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        quoteDAO.deleteQuote(id);
        response.sendRedirect("quotes?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Quote existingQuote = quoteDAO.getQuoteById(id);
        request.setAttribute("quote", existingQuote);
        request.getRequestDispatcher("views/quote-form.jsp").forward(request, response);
    }

    private void updateQuote(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String qNumber = request.getParameter("quoteNumber");
        int leadId = Integer.parseInt(request.getParameter("leadId"));
        Date qDate = Date.valueOf(request.getParameter("quoteDate"));
        Date vUntil = Date.valueOf(request.getParameter("validUntil"));
        String status = request.getParameter("approvalStatus");
        String stage = request.getParameter("stage");

        Quote quote = new Quote(id, qNumber, leadId, null, qDate, vUntil, status, stage, 0.0);
        quoteDAO.updateQuote(quote);
        response.sendRedirect("quotes?action=list");
    }
}
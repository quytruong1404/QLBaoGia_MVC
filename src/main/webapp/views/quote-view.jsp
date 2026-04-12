<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Báo giá #${quote.quoteNumber}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 p-10">

    <div class="max-w-5xl mx-auto">
        <a href="quotes?action=list" class="inline-flex items-center text-gray-500 hover:text-blue-600 mb-6 transition-all">
            <i class="fa-solid fa-arrow-left mr-2"></i> Quay lại danh sách
        </a>

        <div class="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden">
            
            <div class="p-8 bg-gradient-to-r from-blue-600 to-blue-700 text-white flex justify-between items-center">
                <div>
                    <h2 class="text-3xl font-black">BÁO GIÁ CHI TIẾT</h2>
                    <p class="opacity-80 mt-1">Số hiệu: #${quote.quoteNumber}</p>
                </div>
                <div class="text-right">
                    <span class="px-4 py-1.5 bg-white/20 rounded-full text-sm font-bold backdrop-blur-md">
                        Trạng thái: ${quote.stage}
                    </span>
                </div>
            </div>

            <div class="p-10">
                <div class="grid grid-cols-2 gap-10 mb-12">
                    <div>
                        <h4 class="text-gray-400 text-xs font-bold uppercase tracking-widest mb-3">Thông tin khách hàng</h4>
                        <p class="text-xl font-bold text-gray-800">${quote.customerName}</p>
                        <p class="text-gray-500">Mã Lead: ID-${quote.leadId}</p>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <h4 class="text-gray-400 text-xs font-bold uppercase tracking-widest mb-2">Ngày lập</h4>
                            <p class="font-semibold text-gray-700"><fmt:formatDate value="${quote.quoteDate}" pattern="dd/MM/yyyy" /></p>
                        </div>
                        <div>
                            <h4 class="text-gray-400 text-xs font-bold uppercase tracking-widest mb-2">Ngày hết hạn</h4>
                            <p class="font-semibold text-gray-700"><fmt:formatDate value="${quote.validUntil}" pattern="dd/MM/yyyy" /></p>
                        </div>
                    </div>
                </div>

                <div class="mb-10">
                    <h4 class="text-gray-800 font-bold mb-4 border-b pb-2">Danh mục sản phẩm & dịch vụ</h4>
                    <table class="w-full text-left">
                        <thead>
                            <tr class="text-gray-400 text-[11px] uppercase tracking-tighter border-b border-gray-100">
                                <th class="py-3 px-2">Sản phẩm</th>
                                <th class="py-3 px-2 text-center">Số lượng</th>
                                <th class="py-3 px-2 text-right">Đơn giá</th>
                                <th class="py-3 px-2 text-center">CK (%)</th>
                                <th class="py-3 px-2 text-center">Thuế (%)</th>
                                <th class="py-3 px-2 text-right">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50 text-sm">
                            <c:forEach var="item" items="${quoteDetails}">
                                <tr>
                                    <td class="py-5 px-2 font-bold text-gray-700">${item.productName}</td>
                                    <td class="py-5 px-2 text-center">${item.quantity}</td>
                                    <td class="py-5 px-2 text-right"><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="đ" /></td>
                                    <td class="py-5 px-2 text-center text-red-500">-${item.discountPercent}%</td>
                                    <td class="py-5 px-2 text-center text-blue-500">${item.taxRate}%</td>
                                    <td class="py-5 px-2 text-right font-bold text-gray-800">
                                        <fmt:formatNumber value="${item.lineTotal}" type="currency" currencySymbol="đ" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="flex justify-end">
                    <div class="w-full max-w-sm bg-gray-50 rounded-2xl p-6 space-y-3">
                        <div class="flex justify-between text-sm text-gray-500">
                            <span>Tổng tiền hàng (trước thuế):</span>
                            <span class="font-semibold text-gray-800"><fmt:formatNumber value="${quote.totalAmount}" type="currency" currencySymbol="đ" /></span>
                        </div>
                        <div class="flex justify-between text-sm text-red-500">
                            <span>Chiết khấu tổng cộng:</span>
                            <span class="font-semibold">-<fmt:formatNumber value="${quote.discountAmount}" type="currency" currencySymbol="đ" /></span>
                        </div>
                        <div class="flex justify-between text-sm text-blue-500 pb-4 border-b border-gray-200">
                            <span>Thuế giá trị gia tăng (VAT):</span>
                            <span class="font-semibold">+<fmt:formatNumber value="${quote.taxAmount}" type="currency" currencySymbol="đ" /></span>
                        </div>
                        <div class="flex justify-between items-center pt-2">
                            <span class="text-lg font-black text-gray-800">TỔNG THANH TOÁN:</span>
                            <span class="text-2xl font-black text-blue-600"><fmt:formatNumber value="${quote.grandTotal}" type="currency" currencySymbol="đ" /></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
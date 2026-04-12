<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRM PRO - Quản lý Báo giá</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 flex">

    <div class="w-64 h-screen bg-white border-r border-gray-200 fixed left-0 top-0">
        <div class="p-6">
            <h1 class="text-2xl font-bold text-gray-800">CRM</h1>
        </div>
        <nav class="mt-6 px-4">
            <a href="#" class="flex items-center p-3 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg mb-2">
                <i class="fa-solid fa-chart-line mr-3"></i> Dashboard
            </a>
            <a href="#" class="flex items-center p-3 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg mb-2">
                <i class="fa-solid fa-users mr-3"></i> Khách hàng
            </a>
            <a href="quotes?action=list" class="flex items-center p-3 bg-blue-50 text-blue-600 rounded-lg mb-2 font-medium">
                <i class="fa-solid fa-file-invoice mr-3"></i> Báo giá
            </a>
            <a href="#" class="flex items-center p-3 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg mb-2">
                <i class="fa-solid fa-file-contract mr-3"></i> Hợp đồng
            </a>
            <a href="#" class="flex items-center p-3 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg mb-2">
                <i class="fa-solid fa-file-invoice-dollar mr-3"></i> Hóa đơn
            </a>
        </nav>
    </div>

    <div class="ml-64 w-full p-10">
        <div class="flex justify-between items-center mb-8">
            <h2 class="text-3xl font-bold text-gray-800">Tất cả Báo giá</h2>
            <a href="quotes?action=new" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2.5 rounded-md font-medium flex items-center shadow-sm">
                <span class="mr-2">+</span> Tạo Báo giá
            </a>
        </div>

        <div class="bg-white p-4 rounded-xl shadow-sm border border-gray-100 mb-6 flex gap-4">
            <div class="flex-grow">
                <input type="text" placeholder="Tìm kiếm theo mã, khách hàng..." 
                       class="w-full border border-gray-200 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <button class="px-6 py-2 border border-gray-200 rounded-lg text-gray-600 hover:bg-gray-50 font-medium">Lọc</button>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50 text-gray-500 uppercase text-xs font-semibold">
                    <tr>
                        <th class="px-6 py-4">Mã Báo giá</th>
                        <th class="px-6 py-4">Khách hàng</th>
                        <th class="px-6 py-4">Ngày lập</th>
                        <th class="px-6 py-4 text-center">Trạng thái duyệt</th>
                        <th class="px-6 py-4">Giai đoạn</th>
                        <th class="px-6 py-4 text-right">Tổng cộng</th>
                        <th class="px-6 py-4 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
    <c:forEach var="q" items="${listQuotes}">
        <tr class="hover:bg-gray-50 transition-colors">
            <td class="px-6 py-4 font-medium text-blue-600">#${q.quoteNumber}</td>
            
            <td class="px-6 py-4 text-gray-700">${q.customerName}</td>
            
            <td class="px-6 py-4 text-gray-500">
                <fmt:formatDate value="${q.quoteDate}" pattern="dd/MM/yyyy" />
            </td>
            
            <td class="px-6 py-4 text-center">
                <span class="px-3 py-1 rounded-full text-xs font-medium
                    ${q.approvalStatus == 'Approved' ? 'bg-green-100 text-green-700' : 
                      q.approvalStatus == 'Pending' ? 'bg-blue-100 text-blue-700' : 
                      q.approvalStatus == 'Rejected' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-700'}">
                    ${q.approvalStatus}
                </span>
            </td>

            <td class="px-6 py-4 text-center">
                <span class="px-3 py-1 rounded-full text-xs font-medium
                    ${q.stage == 'Accepted' ? 'bg-green-100 text-green-700' : 
                      q.stage == 'Negotiating' ? 'bg-blue-100 text-blue-700' : 
                      q.stage == 'Suspended' ? 'bg-yellow-100 text-yellow-700' : 
                      q.stage == 'Declined' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-600'}">
                    ${q.stage}
                </span>
            </td>

            <td class="px-6 py-4 text-right font-bold text-gray-800">
                <fmt:formatNumber value="${q.grandTotal}" type="currency" currencySymbol="đ" />
            </td>

            <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-2 mb-2">
                    <c:choose>
                        <c:when test="${q.stage == 'Draft'}">
                            <a href="quotes?action=changeStage&id=${q.id}&stage=Negotiating" class="text-blue-500 hover:text-blue-700" title="Bắt đầu thương thuyết">
                                <i class="fa-solid fa-comments"></i>
                            </a>
                        </c:when>
                        <c:when test="${q.stage == 'Negotiating'}">
                            <a href="quotes?action=changeStage&id=${q.id}&stage=Accepted" class="text-green-500 hover:text-green-700" title="Chốt báo giá"><i class="fa-solid fa-circle-check"></i></a>
                            <a href="quotes?action=changeStage&id=${q.id}&stage=Suspended" class="text-yellow-500 hover:text-yellow-700" title="Tạm dừng"><i class="fa-solid fa-circle-pause"></i></a>
                        </c:when>
                        <c:when test="${q.stage == 'Suspended'}">
                            <a href="quotes?action=changeStage&id=${q.id}&stage=Negotiating" class="text-blue-400 hover:text-blue-600" title="Tiếp tục"><i class="fa-solid fa-circle-play"></i></a>
                        </c:when>
                    </c:choose>
                </div>
                <div class="flex items-center justify-center gap-3 border-t border-gray-50 pt-2">
                    <a href="quotes?action=edit&id=${q.id}" class="text-gray-400 hover:text-blue-500"><i class="fa-solid fa-pen-to-square"></i></a>
                    <a href="quotes?action=delete&id=${q.id}" class="text-gray-400 hover:text-red-500" onclick="return confirm('Xóa báo giá này?')"><i class="fa-solid fa-trash-can"></i></a>
                    <a href="quotes?action=view&id=${q.id}" class="text-gray-400 hover:text-green-500 transition-colors" title="Xem chi tiết">
    			<i class="fa-solid fa-eye text-lg"></i>
</a>
                </div>
            </td>
        </tr>
    </c:forEach>
</tbody>
            </table>
            
            <div class="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-between items-center text-sm text-gray-500">
                <span>Hiển thị 1 đến ${listQuotes.size()} báo giá</span>
                <div class="flex gap-1">
                    <button class="w-8 h-8 flex items-center justify-center border border-blue-500 bg-white text-blue-500 rounded">1</button>
                    <button class="w-8 h-8 flex items-center justify-center border border-gray-200 bg-white hover:bg-gray-50 rounded text-gray-400">2</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
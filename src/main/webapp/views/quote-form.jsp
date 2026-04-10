<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRM  - ${quote != null ? 'Cập nhật' : 'Tạo'} Báo giá</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 flex">

    <div class="w-64 h-screen bg-white border-r border-gray-200 fixed left-0 top-0">
        <div class="p-6"><h1 class="text-2xl font-bold text-gray-800">CRM PRO</h1></div>
        <nav class="mt-6 px-4">
            <a href="quotes?action=list" class="flex items-center p-3 bg-blue-50 text-blue-600 rounded-lg font-medium">
                <i class="fa-solid fa-file-invoice mr-3"></i> Báo giá
            </a>
        </nav>
    </div>

    <div class="ml-64 w-full p-10">
        <div class="max-w-3xl mx-auto">
            <div class="flex items-center mb-8">
                <a href="quotes?action=list" class="mr-4 text-gray-400 hover:text-gray-600"><i class="fa-solid fa-arrow-left text-xl"></i></a>
                <h2 class="text-3xl font-bold text-gray-800">${quote != null ? 'Cập nhật Báo giá' : 'Tạo Báo giá mới'}</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r-lg shadow-sm">
                    <div class="flex items-center">
                        <i class="fa-solid fa-triangle-exclamation text-red-500 mr-3"></i>
                        <p class="text-red-700 font-medium">${error}</p>
                    </div>
                </div>
            </c:if>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
                <form action="quotes" method="post" id="quoteForm" onsubmit="return validateClient()">
                    <input type="hidden" name="action" value="${quote != null ? 'update' : 'insert'}" />
                    <c:if test="${quote != null}">
                        <input type="hidden" name="id" value="${quote.id}" />
                    </c:if>

                    <div class="grid grid-cols-2 gap-6">
                        <div class="col-span-2 sm:col-span-1">
                            <label class="block text-sm font-semibold text-gray-700 mb-2">Số báo giá <span class="text-red-500">*</span></label>
                            <input type="text" name="quoteNumber" value="${quote.quoteNumber}" required 
                                   class="w-full border border-gray-200 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-blue-500 focus:outline-none transition-all"
                                   placeholder="VD: BG-2026-001">
                        </div>

                        <div class="col-span-2 sm:col-span-1">
                            <label class="block text-sm font-semibold text-gray-700 mb-2">Mã khách hàng (ID) <span class="text-red-500">*</span></label>
                            <input type="number" name="leadId" value="${quote.leadId}" required 
                                   class="w-full border border-gray-200 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-blue-500 focus:outline-none transition-all"
                                   placeholder="Nhập ID khách hàng">
                            <p class="text-xs text-gray-400 mt-1 italic">ID phải tồn tại trong danh sách Lead.</p>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">Ngày lập <span class="text-red-500">*</span></label>
                            <input type="date" name="quoteDate" id="quoteDate" value="${quote.quoteDate}" required
                                   class="w-full border border-gray-200 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-blue-500 focus:outline-none">
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">Ngày hết hạn <span class="text-red-500">*</span></label>
                            <input type="date" name="validUntil" id="validUntil" value="${quote.validUntil}" required
                                   class="w-full border border-gray-200 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-blue-500 focus:outline-none">
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">Trạng thái duyệt</label>
                            <select name="approvalStatus" class="w-full border border-gray-200 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white">
                                <option value="Draft" ${quote.approvalStatus == 'Draft' ? 'selected' : ''}>Nháp</option>
                                <option value="Pending" ${quote.approvalStatus == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                                <option value="Approved" ${quote.approvalStatus == 'Approved' ? 'selected' : ''}>Đã duyệt</option>
                                <option value="Rejected" ${quote.approvalStatus == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">Giai đoạn</label>
                            <select name="stage" class="w-full border border-gray-200 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white">
                                <option value="Draft" ${quote.stage == 'Draft' ? 'selected' : ''}>Mới tạo</option>
                                <option value="Sent" ${quote.stage == 'Sent' ? 'selected' : ''}>Đã gửi khách</option>
                                <option value="Negotiating" ${quote.stage == 'Negotiating' ? 'selected' : ''}>Thương thảo</option>
                                <option value="Accepted" ${quote.stage == 'Accepted' ? 'selected' : ''}>Đồng ý</option>
                                <option value="Declined" ${quote.stage == 'Declined' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>
                    </div>

                    <div class="mt-10 flex gap-4">
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-10 py-3 rounded-xl font-bold shadow-lg shadow-blue-100 transition-all active:scale-95">
                            <i class="fa-solid fa-floppy-disk mr-2"></i> ${quote != null ? 'Cập nhật' : 'Lưu báo giá'}
                        </button>
                        <a href="quotes?action=list" class="bg-gray-100 hover:bg-gray-200 text-gray-600 px-10 py-3 rounded-xl font-bold transition-all">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function validateClient() {
            const qDate = new Date(document.getElementById('quoteDate').value);
            const vUntil = new Date(document.getElementById('validUntil').value);
            
            if (vUntil < qDate) {
                alert("⚠️ Lỗi: Ngày hết hạn không thể sớm hơn ngày lập báo giá!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${not empty jobToEdit ? 'Chỉnh sửa bài đăng' : 'Đăng tin mới'} - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.8">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/employer/employer_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-primary text-white py-3">
                        <h4 class="mb-0 fw-bold">
                            <i class="fas ${not empty jobToEdit ? 'fa-edit' : 'fa-plus-circle'} me-2"></i>
                            ${not empty jobToEdit ? 'Chỉnh sửa bài đăng' : 'Đăng tin tuyển dụng mới'}
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/createJob" method="post">
                            <c:if test="${not empty jobToEdit}">
                                <input type="hidden" name="jobId" value="${jobToEdit.jobId}">
                            </c:if>

                            <h5 class="text-info fw-bold mb-3 border-bottom pb-2">Thông tin cơ bản</h5>
                            
                            <div class="row mb-3">
                                <div class="col-md-8">
                                    <label class="form-label fw-semibold">Tiêu đề công việc <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="title" value="${jobToEdit.title}" required placeholder="VD: Nhân viên phục vụ ca tối">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Danh mục <span class="text-danger">*</span></label>
                                    <select class="form-select" name="categoryId" required>
                                        <option value="" disabled ${empty jobToEdit ? 'selected' : ''}>-- Chọn ngành nghề --</option>
                                        <c:forEach items="${listCategories}" var="cat">
                                            <option value="${cat.categoryId}" ${jobToEdit.categoryId == cat.categoryId ? 'selected' : ''}>
                                                ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Mô tả chi tiết công việc <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="description" rows="4" required placeholder="Nhập các công việc cần làm, yêu cầu...">${jobToEdit.description}</textarea>
                            </div>

                            <h5 class="text-info fw-bold mb-3 border-bottom pb-2">Thời gian & Lương</h5>

                            <div class="row mb-4">
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Mức lương (VNĐ/ca) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="salary" value="${jobToEdit.salary}" required placeholder="VD: 30000" min="10000">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Giờ bắt đầu <span class="text-danger">*</span></label>
                                    <input type="time" class="form-control" name="startTime" value="${jobToEdit.startTime}" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Giờ kết thúc <span class="text-danger">*</span></label>
                                    <input type="time" class="form-control" name="endTime" value="${jobToEdit.endTime}" required>
                                </div>
                            </div>

                            <h5 class="text-info fw-bold mb-3 border-bottom pb-2">Địa điểm làm việc</h5>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                                    <select class="form-select" name="city" id="city" data-selected="${jobToEdit.city}" required>
                                        <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Quận/Huyện <span class="text-danger">*</span></label>
                                    <select class="form-select" name="ward" id="ward" data-selected="${jobToEdit.ward}" required>
                                        <option value="">-- Chọn Quận/Huyện --</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Số nhà, Tên đường <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="detailAddress" value="${jobToEdit.detailAddress}" required placeholder="VD: Số 10 Nguyễn Thái Học">
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/manageJobs" class="btn btn-outline-secondary fw-semibold">Hủy</a>
                                <button type="submit" class="btn btn-primary fw-semibold">
                                    <i class="fas fa-save me-1"></i> ${not empty jobToEdit ? 'Lưu thay đổi' : 'Đăng tin tuyển dụng'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/location-filter.js?v=2.1"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
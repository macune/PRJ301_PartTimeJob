<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý ứng viên - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.8">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/employer/employer_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/employer/manageJobs" class="text-decoration-none text-muted mb-2 d-inline-block">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách bài đăng
                </a>
                <h3 class="text-primary fw-bold mb-0">
                    <i class="fas fa-users me-2"></i>Ứng viên: <span class="text-dark">${jobDetail.job.title}</span>
                </h3>
            </div>
        </div>

        <c:if test="${empty listApplicants}">
            <div class="alert alert-info text-center py-4 rounded-4 shadow-sm">
                <i class="fas fa-info-circle fs-4 mb-2 d-block"></i>
                Hiện chưa có sinh viên nào nộp đơn ứng tuyển vào vị trí này.
            </div>
        </c:if>

        <div class="row">
            <c:forEach items="${listApplicants}" var="item">
                <div class="col-md-6 mb-4">
                    <div class="card shadow-sm border-0 h-100 rounded-4">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3 border-bottom-0">
                            <h5 class="fw-bold text-dark mb-0">
                                <i class="fas fa-user-graduate text-primary me-2"></i>${item.student.fullName}
                            </h5>
                            <c:choose>
                                <c:when test="${item.application.status == 0}">
                                    <span class="badge bg-warning text-dark"><i class="fas fa-hourglass-half me-1"></i>Chờ duyệt</span>
                                </c:when>
                                <c:when test="${item.application.status == 1}">
                                    <span class="badge bg-success"><i class="fas fa-check-circle me-1"></i>Đã chấp nhận</span>
                                </c:when>
                                <c:when test="${item.application.status == 2}">
                                    <span class="badge bg-danger"><i class="fas fa-times-circle me-1"></i>Đã từ chối</span>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="card-body bg-light rounded-bottom-4 mx-2 mb-2 p-3">
                            <div class="row mb-3">
                                <div class="col-sm-6">
                                    <p class="mb-1"><small class="text-muted">Đại học:</small><br><strong>${not empty item.student.university ? item.student.university : 'Chưa cập nhật'}</strong></p>
                                    <p class="mb-1"><small class="text-muted">SĐT:</small><br><strong>${item.student.phone}</strong></p>
                                </div>
                                <div class="col-sm-6">
                                    <p class="mb-1"><small class="text-muted">Đánh giá:</small><br>
                                        <strong class="text-warning"><i class="fas fa-star"></i> ${item.student.averageRating}/5</strong>
                                    </p>
                                    <p class="mb-1"><small class="text-muted">Lương mong muốn:</small><br>
                                        <strong class="text-success"><fmt:formatNumber value="${item.application.desiredSalary}" pattern="#,###"/> đ/ca</strong>
                                    </p>
                                </div>
                            </div>
                            
                            <button class="btn btn-outline-info w-100 mb-3 fw-semibold rounded-pill bg-white" data-bs-toggle="modal" data-bs-target="#studentProfileModal${item.student.studentId}">
                                <i class="fas fa-id-badge me-2"></i>Xem Hồ Sơ & Đánh Giá Chi Tiết
                            </button>
                            
                            <div class="mb-3">
                                <small class="text-muted">Kinh nghiệm làm việc tóm tắt:</small>
                                <p class="mb-0 bg-white p-2 border rounded text-dark fs-6">
                                    ${not empty item.student.experience ? item.student.experience : 'Chưa cập nhật kinh nghiệm'}
                                </p>
                            </div>
                            
                            <div class="mb-3">
                                <small class="text-muted">Lời nhắn từ ứng viên:</small>
                                <p class="mb-0 bg-white p-2 border rounded text-dark fw-semibold fs-6">
                                    <i class="fas fa-quote-left text-muted me-1"></i> ${item.application.message}
                                </p>
                            </div>

                            <c:if test="${item.application.status == 0}">
                                <hr>
                                <form action="${pageContext.request.contextPath}/employer/manageApplicants" method="post" class="mt-3">
                                    <input type="hidden" name="applicationId" value="${item.application.applicationID}">
                                    <input type="hidden" name="jobId" value="${jobId}">
                                    
                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold">Lời nhắn / Hẹn lịch (Employer Note):</label>
                                        <input type="text" name="employerNote" class="form-control form-control-sm border-primary" placeholder="VD: Sáng mai 8h em qua quán phỏng vấn nhé..." required>
                                    </div>
                                    
                                    <div class="d-flex gap-2">
                                        <button type="submit" name="status" value="1" class="btn btn-success flex-grow-1 fw-semibold">
                                            <i class="fas fa-check me-1"></i> Chấp nhận
                                        </button>
                                        <button type="submit" name="status" value="2" class="btn btn-danger flex-grow-1 fw-semibold">
                                            <i class="fas fa-times me-1"></i> Từ chối
                                        </button>
                                    </div>
                                </form>
                            </c:if>

                            <c:if test="${item.application.status != 0}">
                                <div class="mt-3">
                                    <small class="text-muted">Lời nhắn của bạn:</small>
                                    <p class="mb-0 text-primary fw-semibold"><i class="fas fa-reply me-1"></i> ${not empty item.application.employerNote ? item.application.employerNote : 'Không có'}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="studentProfileModal${item.student.studentId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                        <div class="modal-content rounded-4 border-0 shadow">
                            
                            <div class="modal-header bg-info text-white border-bottom-0 pb-3 rounded-top-4">
                                <h5 class="modal-title fw-bold text-dark"><i class="fas fa-id-card me-2"></i>Hồ Sơ Ứng Viên Chi Tiết</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            
                            <div class="modal-body p-4 bg-light">
                                
                                <div class="card border-0 shadow-sm rounded-4 mb-4">
                                    <div class="card-body p-4">
                                        <h3 class="fw-bold text-center text-primary mb-2">${item.student.fullName}</h3>
                                        <div class="d-flex justify-content-center align-items-center mb-4">
                                            <span class="text-warning fw-bold fs-5">
                                                ${item.student.averageRating} <i class="fas fa-star"></i>
                                            </span>
                                        </div>
                                        
                                        <div class="row g-4">
                                            <div class="col-md-6">
                                                <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-phone-alt me-2"></i>Số điện thoại</p>
                                                <p class="fw-bold text-dark ms-4">${item.student.phone}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-envelope me-2"></i>Email liên hệ</p>
                                                <p class="fw-bold text-dark ms-4">${not empty item.student.contactEmail ? item.student.contactEmail : '<span class="text-muted fw-normal fst-italic">Chưa cập nhật</span>'}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-university me-2"></i>Trường đang học</p>
                                                <p class="fw-bold text-dark ms-4">${not empty item.student.university ? item.student.university : '<span class="text-muted fw-normal fst-italic">Chưa cập nhật</span>'}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ hiện tại</p>
                                                <p class="fw-bold text-dark ms-4">${not empty item.student.address ? item.student.address : '<span class="text-muted fw-normal fst-italic">Chưa cập nhật</span>'}</p>
                                            </div>
                                            
                                            <div class="col-12 mt-4">
                                                <p class="mb-2 text-muted small fw-semibold"><i class="fas fa-user-circle me-2"></i>Giới thiệu bản thân</p>
                                                <div class="p-3 bg-white rounded-3 text-secondary border" style="white-space: pre-wrap; font-size: 0.95rem;">${not empty item.student.introduction ? item.student.introduction : 'Chưa cập nhật thông tin giới thiệu.'}</div>
                                            </div>
                                            <div class="col-12 mt-2">
                                                <p class="mb-2 text-muted small fw-semibold"><i class="fas fa-briefcase me-2"></i>Kinh nghiệm làm việc</p>
                                                <div class="p-3 bg-white rounded-3 text-secondary border" style="white-space: pre-wrap; font-size: 0.95rem;">${not empty item.student.experience ? item.student.experience : 'Chưa cập nhật kinh nghiệm làm việc.'}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <h5 class="fw-bold text-dark mb-3">
                                    <i class="fas fa-comments text-warning me-2"></i>Nhận xét từ Nhà tuyển dụng cũ
                                </h5>
                                
                                <c:choose>
                                    <c:when test="${empty studentReviewsMap[item.student.studentId]}">
                                        <div class="text-center text-muted py-4 bg-white rounded-4 shadow-sm border-0">
                                            <i class="fas fa-comment-slash fa-2x mb-2 opacity-50"></i>
                                            <p class="mb-0 small">Sinh viên này chưa có đánh giá nào.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${studentReviewsMap[item.student.studentId]}">
                                            <div class="card mb-3 p-3 border-0 bg-white shadow-sm rounded-4">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="fw-bold text-dark"><i class="fas fa-store text-secondary me-2"></i>${r.reviewerName}</span>
                                                    <span class="text-warning fw-bold">
                                                        ${r.rating} <i class="fas fa-star"></i>
                                                    </span>
                                                </div>
                                                <p class="mb-2 text-secondary ms-4">${r.comment}</p>
                                                <div class="text-end">
                                                    <small class="text-muted fst-italic">
                                                        <i class="fas fa-clock me-1"></i> <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                                    </small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                            
                            <div class="modal-footer border-top-0 pt-0 bg-light rounded-bottom-4 justify-content-end">
                                <button type="button" class="btn btn-secondary rounded-pill px-4 fw-semibold" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
                </div>
                </c:forEach>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
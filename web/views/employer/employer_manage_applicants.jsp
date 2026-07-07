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
                                    <p class="mb-1"><small class="text-muted">Đại học:</small><br><strong>${item.student.university}</strong></p>
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
                            
                            <div class="mb-3">
                                <small class="text-muted">Kinh nghiệm làm việc:</small>
                                <p class="mb-0 bg-white p-2 border rounded text-dark" style="font-size: 0.9rem;">
                                    ${not empty item.student.experience ? item.student.experience : 'Chưa cập nhật kinh nghiệm'}
                                </p>
                            </div>
                            
                            <div class="mb-3">
                                <small class="text-muted">Lời nhắn từ ứng viên:</small>
                                <p class="mb-0 bg-white p-2 border rounded text-dark fw-semibold" style="font-size: 0.9rem;">
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
            </c:forEach>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
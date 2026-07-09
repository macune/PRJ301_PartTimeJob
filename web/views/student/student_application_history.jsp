<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử ứng tuyển - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.0">
    <style>
        .star-rating { direction: rtl; display: inline-block; padding: 10px 0; }
        .star-rating input[type=radio] { display: none; }
        .star-rating label { font-size: 2rem; color: #d1d5db; cursor: pointer; transition: color 0.2s; padding: 0 5px; }
        .star-rating label:hover, .star-rating label:hover ~ label, .star-rating input[type=radio]:checked ~ label { color: #f59e0b; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/student/student_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-primary">
                <i class="fas fa-history me-2"></i>Lịch sử ứng tuyển
            </h3>
            <p class="text-muted mb-0">Bạn đã nộp tổng cộng <strong>${countAll}</strong> đơn ứng tuyển.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-sm-4">
                <div class="card stat-card p-3 shadow-sm border-0" style="border-left: 5px solid #f59e0b !important;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Đang chờ duyệt</div>
                            <div class="fs-3 fw-bold text-warning">${countPending}</div>
                        </div>
                        <i class="fas fa-hourglass-half fa-2x text-warning opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="card stat-card p-3 shadow-sm border-0" style="border-left: 5px solid #16a34a !important;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Đã được nhận</div>
                            <div class="fs-3 fw-bold text-success">${countAccepted}</div>
                        </div>
                        <i class="fas fa-check-circle fa-2x text-success opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="card stat-card p-3 shadow-sm border-0" style="border-left: 5px solid #dc2626 !important;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Bị từ chối</div>
                            <div class="fs-3 fw-bold text-danger">${countRejected}</div>
                        </div>
                        <i class="fas fa-times-circle fa-2x text-danger opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex flex-column gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/student/application-history?status=all" 
               class="btn ${currentStatus == 'all' ? 'btn-success' : 'btn-success opacity-75'} fw-semibold w-100 text-white border-0" style="background-color: #2e7d32;">
                Tất cả (${countAll})
            </a>
            
            <a href="${pageContext.request.contextPath}/student/application-history?status=0" 
               class="btn ${currentStatus == '0' ? 'btn-primary' : 'btn-primary opacity-75'} fw-semibold w-100 text-white border-0" style="background-color: #0d6efd;">
                <i class="fas fa-hourglass-half me-1"></i> Đang chờ (${countPending})
            </a>
            
            <a href="${pageContext.request.contextPath}/student/application-history?status=1" 
               class="btn ${currentStatus == '1' ? 'btn-primary' : 'btn-primary opacity-75'} fw-semibold w-100 text-white border-0" style="background-color: #0d6efd;">
                <i class="fas fa-check me-1"></i> Chấp nhận (${countAccepted})
            </a>
            
            <a href="${pageContext.request.contextPath}/student/application-history?status=2" 
               class="btn ${currentStatus == '2' ? 'btn-primary' : 'btn-primary opacity-75'} fw-semibold w-100 text-white border-0" style="background-color: #0d6efd;">
                <i class="fas fa-times me-1"></i> Từ chối (${countRejected})
            </a>
        </div>

        <c:if test="${empty applicationList}">
            <div class="card border-0 shadow-sm text-center py-5 rounded-4">
                <i class="fas fa-inbox fa-4x text-muted mb-3 opacity-25"></i>
                <h5 class="text-muted">Không có đơn ứng tuyển nào ở trạng thái này.</h5>
            </div>
        </c:if>

        <div class="row">
            <c:forEach items="${applicationList}" var="item">
                
                <c:choose>
                    <c:when test="${item.application.status == 1}"><c:set var="barColor" value="#16a34a"/></c:when>
                    <c:when test="${item.application.status == 2}"><c:set var="barColor" value="#dc2626"/></c:when>
                    <c:otherwise><c:set var="barColor" value="#f59e0b"/></c:otherwise>
                </c:choose>

                <div class="col-12 app-card-wrapper">
                    <div class="card app-card mb-3">
                        <div class="d-flex">
                            <div class="status-bar" style="background:${barColor};"></div>
                            <div class="flex-grow-1 p-3">
                                
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h5 class="fw-bold mb-1">
                                            <a href="${pageContext.request.contextPath}/student/jobDetail?id=${item.job.jobId}" class="text-decoration-none text-primary">
                                                ${item.job.title}
                                            </a>
                                        </h5>
                                        <div class="text-muted small fw-semibold"><i class="fas fa-store me-1"></i> ${item.employer.businessName}</div>
                                    </div>
                                    
                                    <c:choose>
                                        <c:when test="${item.application.status == 0}">
                                            <span class="badge bg-warning text-dark px-3 py-2"><i class="fas fa-hourglass-half me-1"></i>Đang chờ</span>
                                        </c:when>
                                        <c:when test="${item.application.status == 1}">
                                            <span class="badge bg-success px-3 py-2"><i class="fas fa-check-circle me-1"></i>Đã nhận</span>
                                        </c:when>
                                        <c:when test="${item.application.status == 2}">
                                            <span class="badge bg-danger px-3 py-2"><i class="fas fa-times-circle me-1"></i>Từ chối</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <c:if test="${not empty sessionScope.successMsg}">
                                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="successMsg" scope="session"/>
                                </c:if>

                                <c:if test="${not empty sessionScope.errorMsg}">
                                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="errorMsg" scope="session"/>
                                </c:if>

                                <div class="row g-2 mb-3">
                                    <div class="col-md-3 col-sm-6 text-muted small">
                                        <i class="fas fa-money-bill-wave text-success me-1"></i> 
                                        Lương gốc: <strong class="text-dark"><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/>đ</strong>
                                    </div>
                                    <div class="col-md-3 col-sm-6 text-muted small">
                                        <i class="fas fa-hand-holding-usd text-primary me-1"></i> 
                                        Lương MM: 
                                        <strong class="text-dark">
                                            <c:choose>
                                                <c:when test="${item.application.desiredSalary > 0}"><fmt:formatNumber value="${item.application.desiredSalary}" pattern="#,###"/>đ</c:when>
                                                <c:otherwise>Không đề xuất</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                    <div class="col-md-3 col-sm-6 text-muted small">
                                        <i class="fas fa-clock text-warning me-1"></i>
                                        Ca: <strong class="text-dark">${item.job.startTime} - ${item.job.endTime}</strong>
                                    </div>
                                    <div class="col-md-3 col-sm-6 text-muted small">
                                        <i class="fas fa-calendar-check text-info me-1"></i>
                                        Nộp lúc: <strong class="text-dark"><fmt:formatDate value="${item.application.appliedAt}" pattern="dd/MM/yyyy HH:mm" /></strong>
                                    </div>
                                </div>

                                <c:if test="${not empty item.application.message}">
                                    <div class="mt-2">
                                        <div class="text-muted small fw-semibold mb-1"><i class="fas fa-comment me-1"></i>Lời nhắn của bạn:</div>
                                        <div class="note-box" style="border-color: #64748b; border-left-width: 3px;">${item.application.message}</div>
                                    </div>
                                </c:if>

                                <c:choose>
                                    <c:when test="${not empty item.application.employerNote}">
                                        <div class="mt-3">
                                            <div class="text-muted small fw-semibold mb-1"><i class="fas fa-reply me-1 text-success"></i>Nhà tuyển dụng phản hồi:</div>
                                            <div class="note-box">${item.application.employerNote}</div>
                                        </div>
                                    </c:when>
                                    <c:when test="${item.application.status == 0}">
                                        <div class="mt-3 text-muted small fst-italic">
                                            <i class="fas fa-circle-notch fa-spin me-1"></i> Đang chờ nhà tuyển dụng xem xét đơn...
                                        </div>
                                    </c:when>
                                </c:choose>
                                <!-- Hiện nút đánh giá nếu Status = 1 (Đã nhận) -->
                                <c:if test="${item.application.status == 1}">
                                    <button class="btn btn-sm btn-outline-warning fw-semibold mt-3" data-bs-toggle="modal" data-bs-target="#reviewEmployerModal${item.employer.employerId}">
                                        <i class="fas fa-star me-1"></i> Đánh giá cửa hàng
                                    </button>
                                    
                                    <!-- Modal Đánh giá Cửa hàng -->
                                    <div class="modal fade" id="reviewEmployerModal${item.employer.employerId}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 border-0 shadow">
                                                <div class="modal-header bg-warning text-dark border-0 pb-3 rounded-top-4">
                                                    <h5 class="modal-title fw-bold"><i class="fas fa-star me-2"></i>Đánh giá nơi làm việc</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/student/review" method="POST">
                                                    <div class="modal-body p-4 text-center">
                                                        <p class="mb-2">Bạn đánh giá trải nghiệm làm việc tại <strong>${item.employer.businessName}</strong> như thế nào?</p>
                                                        <input type="hidden" name="employerId" value="${item.employer.employerId}">
                                                        
                                                        <div class="star-rating">
                                                            <input type="radio" id="star5_${item.employer.employerId}" name="rating" value="5" required/><label for="star5_${item.employer.employerId}"><i class="fas fa-star"></i></label>
                                                            <input type="radio" id="star4_${item.employer.employerId}" name="rating" value="4"/><label for="star4_${item.employer.employerId}"><i class="fas fa-star"></i></label>
                                                            <input type="radio" id="star3_${item.employer.employerId}" name="rating" value="3"/><label for="star3_${item.employer.employerId}"><i class="fas fa-star"></i></label>
                                                            <input type="radio" id="star2_${item.employer.employerId}" name="rating" value="2"/><label for="star2_${item.employer.employerId}"><i class="fas fa-star"></i></label>
                                                            <input type="radio" id="star1_${item.employer.employerId}" name="rating" value="1"/><label for="star1_${item.employer.employerId}"><i class="fas fa-star"></i></label>
                                                        </div>
                                                        <textarea class="form-control mt-3" name="comment" rows="3" placeholder="Chia sẻ thêm về môi trường làm việc, quản lý..." required></textarea>
                                                    </div>
                                                    <div class="modal-footer bg-light border-top-0 rounded-bottom-4">
                                                        <button type="submit" class="btn btn-warning fw-semibold w-100">Gửi đánh giá</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

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
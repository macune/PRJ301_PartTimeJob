<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý việc làm - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6.0">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/student/student_navbar.jsp" />

    <div class="container flex-grow-1 mb-5 mt-4">
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-primary">
                <i class="fas fa-briefcase me-2"></i>Công việc đang làm
            </h3>
            <p class="text-muted">Danh sách các công việc bạn đã trúng tuyển và đang làm việc.</p>
        </div>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <ul class="nav nav-pills mb-4 border-bottom pb-2" id="jobTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-semibold" data-bs-toggle="pill" data-bs-target="#working" type="button">
                    <i class="fas fa-running me-1"></i> Đang làm việc (${workingJobs.size()})
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold text-secondary" data-bs-toggle="pill" data-bs-target="#history" type="button">
                    <i class="fas fa-history me-1"></i> Lịch sử đã làm (${historyJobs.size()})
                </button>
            </li>
        </ul>

        <div class="tab-content" id="jobTabsContent">
            
            <div class="tab-pane fade show active" id="working">
                <c:if test="${empty workingJobs}">
                    <div class="card border-0 shadow-sm text-center py-5 rounded-4 mt-4">
                        <i class="fas fa-briefcase fa-4x text-muted mb-3 opacity-25"></i>
                        <h5 class="text-muted">Bạn chưa có công việc nào đang làm.</h5>
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/student/findJob" class="btn btn-primary rounded-pill px-4">Tìm việc ngay</a>
                        </div>
                    </div>
                </c:if>
                <div class="row">
                    <c:forEach items="${workingJobs}" var="w">
                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm border-0 rounded-4 h-100 border-left-success">
                                <div class="card-body p-4">
                                    <h5 class="fw-bold text-dark mb-1">${w.job.title}</h5>
                                    <div class="text-muted small fw-semibold mb-1"><i class="fas fa-store me-1"></i> ${w.employer.businessName}</div>
                                    
                                    <div class="text-muted small mb-3">
                                        <i class="fas fa-phone-alt text-secondary me-1"></i> Liên hệ: <strong class="text-dark">${w.employer.phone}</strong>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between text-muted small mb-2">
                                        <span><i class="fas fa-money-bill-wave text-success me-1"></i> Lương chốt: <strong class="text-dark"><fmt:formatNumber value="${w.application.desiredSalary}" pattern="#,###"/>đ/ca</strong></span>
                                        <span><i class="fas fa-clock text-warning me-1"></i> Ca: <strong class="text-dark"><fmt:formatDate value="${w.job.startTime}" type="time" pattern="HH:mm" /> - <fmt:formatDate value="${w.job.endTime}" type="time" pattern="HH:mm" /></strong></span>
                                    </div>
                                    
                                    <div class="text-muted small mb-3">
                                        <span><i class="fas fa-map-marker-alt text-danger me-1"></i> Địa chỉ: <strong class="text-dark">${w.job.detailAddress}, ${w.job.ward}, ${w.job.city}</strong></span>
                                    </div>
                                    
                                    <hr>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2"><i class="fas fa-check-circle me-1"></i> Đang làm việc</span>
                                        <div>
                                            <button type="button" class="btn btn-sm btn-outline-danger fw-semibold px-3 me-2" data-bs-toggle="modal" data-bs-target="#resignModal${w.application.applicationID}">
                                                <i class="fas fa-sign-out-alt me-1"></i> Xin nghỉ
                                            </button>
                                            <a href="${pageContext.request.contextPath}/student/jobDetail?id=${w.job.jobId}" class="btn btn-sm btn-outline-primary fw-semibold px-3">Chi tiết</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="resignModal${w.application.applicationID}" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content rounded-4 border-0">
                                    <div class="modal-header bg-danger text-white border-0"><h5 class="modal-title fw-bold">Xác nhận Xin nghỉ việc</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                                    <form action="${pageContext.request.contextPath}/student/manageJobs" method="POST">
                                        <div class="modal-body p-4 text-center">
                                            <p>Xác nhận nghỉ làm tại <strong>${w.employer.businessName}</strong>?</p>
                                            <input type="hidden" name="action" value="resign">
                                            <input type="hidden" name="applicationId" value="${w.application.applicationID}">
                                            <textarea class="form-control" name="reason" rows="3" placeholder="Nhập lý do..." required></textarea>
                                        </div>
                                        <div class="modal-footer border-0">
                                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold">Gửi yêu cầu</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="tab-pane fade" id="history">
                <c:if test="${empty historyJobs}">
                    <div class="text-center py-5"><p class="text-muted">Chưa có lịch sử công việc.</p></div>
                </c:if>
                <div class="row">
                    <c:forEach items="${historyJobs}" var="h">
                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm border-0 rounded-4 h-100 border-left-secondary bg-light">
                                <div class="card-body p-4 opacity-75">
                                    <h5 class="fw-bold text-dark mb-1 text-decoration-line-through">${h.job.title}</h5>
                                    <div class="text-muted small fw-semibold mb-3"><i class="fas fa-store me-1"></i> ${h.employer.businessName}</div>
                                    <div class="p-2 mb-3 bg-white border border-danger border-opacity-25 rounded-3 small">
                                        <span class="fw-bold text-danger"><i class="fas fa-info-circle me-1"></i> Lý do kết thúc:</span> ${h.application.employerNote}
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-secondary px-3 py-2">Đã kết thúc</span>
                                        <div>
                                            <c:choose>
                                                <c:when test="${h.isReviewed}">
                                                    <button class="btn btn-sm btn-secondary fw-semibold px-3" disabled>Đã đánh giá</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-warning fw-semibold px-3 text-dark" data-bs-toggle="modal" data-bs-target="#reviewEmployerModal${h.employer.employerId}"><i class="fas fa-star me-1"></i> Đánh giá</button>

                                                    <div class="modal fade text-start" id="reviewEmployerModal${h.employer.employerId}" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content rounded-4 border-0">
                                                                <div class="modal-header bg-warning border-0"><h5 class="modal-title fw-bold text-dark">Đánh giá Nơi làm việc</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                                                <form action="${pageContext.request.contextPath}/student/review" method="POST">
                                                                    <div class="modal-body p-4 text-center">
                                                                        <input type="hidden" name="employerId" value="${h.employer.employerId}">
                                                                        <div class="star-rating mb-2">
                                                                            <input type="radio" id="s5_${h.employer.employerId}" name="rating" value="5" required/><label for="s5_${h.employer.employerId}"><i class="fas fa-star"></i></label>
                                                                            <input type="radio" id="s4_${h.employer.employerId}" name="rating" value="4"/><label for="s4_${h.employer.employerId}"><i class="fas fa-star"></i></label>
                                                                            <input type="radio" id="s3_${h.employer.employerId}" name="rating" value="3"/><label for="s3_${h.employer.employerId}"><i class="fas fa-star"></i></label>
                                                                            <input type="radio" id="s2_${h.employer.employerId}" name="rating" value="2"/><label for="s2_${h.employer.employerId}"><i class="fas fa-star"></i></label>
                                                                            <input type="radio" id="s1_${h.employer.employerId}" name="rating" value="1"/><label for="s1_${h.employer.employerId}"><i class="fas fa-star"></i></label>
                                                                        </div>
                                                                        <textarea class="form-control" name="comment" rows="3" placeholder="Chia sẻ trải nghiệm của bạn..." required></textarea>
                                                                    </div>
                                                                    <div class="modal-footer border-0"><button type="submit" class="btn btn-warning rounded-pill px-4 w-100 fw-bold">Gửi đánh giá</button></div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
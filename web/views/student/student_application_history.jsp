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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=5.0">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/student/student_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <div class="mb-4 mt-4">
            <h3 class="fw-bold mb-0 text-primary">
                <i class="fas fa-history me-2"></i>Lịch sử ứng tuyển
            </h3>
            <p class="text-muted mb-0">Bạn đã nộp tổng cộng <strong>${countAll}</strong> đơn ứng tuyển.</p>
        </div>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div><c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div><c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="d-flex flex-column gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/student/application-history?status=all" class="btn ${currentStatus == 'all' ? 'btn-filter-all' : 'btn-filter-all opacity-75'} fw-semibold w-100 border-0">Tất cả (${countAll})</a>
            <a href="${pageContext.request.contextPath}/student/application-history?status=0" class="btn ${currentStatus == '0' ? 'btn-filter-status' : 'btn-filter-status opacity-75'} fw-semibold w-100 border-0"><i class="fas fa-hourglass-half me-1"></i> Đang chờ (${countPending})</a>
            <a href="${pageContext.request.contextPath}/student/application-history?status=1" class="btn ${currentStatus == '1' ? 'btn-filter-status' : 'btn-filter-status opacity-75'} fw-semibold w-100 border-0"><i class="fas fa-check me-1"></i> Chấp nhận (${countAccepted})</a>
            <a href="${pageContext.request.contextPath}/student/application-history?status=2" class="btn ${currentStatus == '2' ? 'btn-filter-status' : 'btn-filter-status opacity-75'} fw-semibold w-100 border-0"><i class="fas fa-times me-1"></i> Từ chối (${countRejected})</a>
            <a href="${pageContext.request.contextPath}/student/application-history?status=3" class="btn ${currentStatus == '3' ? 'btn-filter-status' : 'btn-filter-status opacity-75'} fw-semibold w-100 border-0"><i class="fas fa-clipboard-check me-1"></i> Đã hoàn thành (${countFinished})</a>
        </div>

        <c:if test="${empty applicationList}">
            <div class="card border-0 shadow-sm text-center py-5 rounded-4">
                <i class="fas fa-inbox fa-4x text-muted mb-3 opacity-25"></i>
                <h5 class="text-muted">Không có đơn ứng tuyển nào ở trạng thái này.</h5>
            </div>
        </c:if>

        <div class="row">
            <c:forEach items="${applicationList}" var="item">

                <div class="col-12 app-card-wrapper">
                    <div class="card app-card mb-3">
                        <div class="d-flex">
                            <div class="status-bar status-bar-${item.application.status}"></div>
                            <div class="flex-grow-1 p-3">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h5 class="fw-bold mb-1">
                                            <a href="${pageContext.request.contextPath}/student/jobDetail?id=${item.job.jobId}" class="text-decoration-none text-primary">${item.job.title}</a>
                                        </h5>
                                        <div class="text-muted small fw-semibold"><i class="fas fa-store me-1"></i> ${item.employer.businessName}</div>
                                    </div>
                                    <div class="text-end">
                                        <c:choose>
                                            <c:when test="${item.application.status == 0}">
                                                <span class="badge bg-warning text-dark px-3 py-2 mb-2 d-inline-block"><i class="fas fa-hourglass-half me-1"></i>Đang chờ</span><br>
                                                <button type="button" class="btn btn-sm btn-outline-danger fw-semibold" data-bs-toggle="modal" data-bs-target="#cancelModal${item.application.applicationID}">
                                                    <i class="fas fa-times me-1"></i> Rút đơn
                                                </button>
                                            </c:when>
                                            <c:when test="${item.application.status == 1}">
                                                <span class="badge bg-success px-3 py-2"><i class="fas fa-check-circle me-1"></i>Đã nhận</span>
                                            </c:when>
                                            <c:when test="${item.application.status == 2}">
                                                <span class="badge bg-danger px-3 py-2"><i class="fas fa-times-circle me-1"></i>Từ chối</span>
                                            </c:when>
                                            <c:when test="${item.application.status == 3}">
                                                <span class="badge bg-secondary px-3 py-2"><i class="fas fa-clipboard-check me-1"></i>Đã hoàn thành</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="row g-2 mb-3">
                                    <div class="col-md-3 col-sm-6 text-muted small"><i class="fas fa-money-bill-wave text-success me-1"></i> Lương gốc: <strong class="text-dark"><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/>đ</strong></div>
                                    <div class="col-md-3 col-sm-6 text-muted small"><i class="fas fa-hand-holding-usd text-primary me-1"></i> Lương MM: 
                                        <strong class="text-dark">
                                            <c:choose>
                                                <c:when test="${item.application.desiredSalary > 0}"><fmt:formatNumber value="${item.application.desiredSalary}" pattern="#,###"/>đ</c:when>
                                                <c:otherwise>Không đề xuất</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                    <div class="col-md-3 col-sm-6 text-muted small"><i class="fas fa-clock text-warning me-1"></i>Ca: <strong class="text-dark"><fmt:formatDate value="${item.job.startTime}" type="time" pattern="HH:mm" /> - <fmt:formatDate value="${item.job.endTime}" type="time" pattern="HH:mm" /></strong></div>
                                    <div class="col-md-3 col-sm-6 text-muted small"><i class="fas fa-calendar-check text-info me-1"></i>Nộp lúc: <strong class="text-dark"><fmt:formatDate value="${item.application.appliedAt}" pattern="dd/MM/yyyy HH:mm" /></strong></div>
                                </div>

                                <c:if test="${not empty item.application.message}">
                                    <div class="mt-2">
                                        <div class="text-muted small fw-semibold mb-1"><i class="fas fa-comment me-1"></i>Lời nhắn của bạn:</div>
                                        <div class="note-box note-box-student">${item.application.message}</div>
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
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${item.application.status == 0}">
                        <div class="modal fade" id="cancelModal${item.application.applicationID}" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content rounded-4 border-0">
                                    <div class="modal-header bg-danger text-white border-0">
                                        <h5 class="modal-title fw-bold"><i class="fas fa-trash-alt me-2"></i>Xác nhận Rút đơn</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/student/application-history" method="POST">
                                        <div class="modal-body p-4 text-center">
                                            <p>Bạn có chắc chắn muốn rút đơn ứng tuyển công việc <strong>${item.job.title}</strong>?</p>
                                            <p class="small text-muted">Hành động này sẽ xóa hoàn toàn đơn ứng tuyển của bạn và không thể hoàn tác.</p>
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="applicationId" value="${item.application.applicationID}">
                                        </div>
                                        <div class="modal-footer border-0 p-3 pt-0">
                                            <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold" data-bs-dismiss="modal">Đóng</button>
                                            <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold">Xác nhận Rút đơn</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>

                </div>
            </c:forEach>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
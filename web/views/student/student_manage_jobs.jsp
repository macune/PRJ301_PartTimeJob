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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.0">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/student/student_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-primary">
                <i class="fas fa-briefcase me-2"></i>Quản lý việc làm
            </h3>
        </div>

        <ul class="nav nav-pills mb-4 border-bottom pb-2" id="jobTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-semibold" id="working-tab" data-bs-toggle="pill" data-bs-target="#working" type="button" role="tab">
                    <i class="fas fa-user-check me-1"></i> Công việc đang làm (${workingJobs.size()})
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold" id="saved-tab" data-bs-toggle="pill" data-bs-target="#saved" type="button" role="tab">
                    <i class="fas fa-bookmark me-1"></i> Việc làm đã lưu (${savedJobs.size()})
                </button>
            </li>
        </ul>

        <div class="tab-content" id="jobTabsContent">
            
            <div class="tab-pane fade show active" id="working" role="tabpanel">
                <c:if test="${empty workingJobs}">
                    <div class="card border-0 shadow-sm text-center py-5 rounded-4">
                        <i class="fas fa-briefcase fa-4x text-muted mb-3 opacity-25"></i>
                        <h5 class="text-muted">Bạn chưa có công việc nào đang làm.</h5>
                    </div>
                </c:if>
                <div class="row">
                    <c:forEach items="${workingJobs}" var="w">
                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm border-0 rounded-4 h-100" style="border-left: 5px solid #16a34a !important;">
                                <div class="card-body p-4">
                                    <h5 class="fw-bold text-dark mb-1">${w.job.title}</h5>
                                    <div class="text-muted small fw-semibold mb-1"><i class="fas fa-store me-1"></i> ${w.employer.businessName}</div>
                                    
                                    <div class="text-muted small mb-3">
                                        <i class="fas fa-phone-alt text-secondary me-1"></i> Liên hệ: <strong class="text-dark">${w.employer.phone}</strong>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between text-muted small mb-2">
                                        <span><i class="fas fa-money-bill-wave text-success me-1"></i> Lương chốt: <strong class="text-dark"><fmt:formatNumber value="${w.application.desiredSalary}" pattern="#,###"/>đ/ca</strong></span>
                                        <span><i class="fas fa-clock text-warning me-1"></i> Ca: <strong class="text-dark">${w.job.startTime} - ${w.job.endTime}</strong></span>
                                    </div>
                                    
                                    <div class="text-muted small mb-3">
                                        <span><i class="fas fa-map-marker-alt text-danger me-1"></i> Địa chỉ: <strong class="text-dark">${w.job.detailAddress}, ${w.job.ward}, ${w.job.city}</strong></span>
                                    </div>
                                    
                                    <hr>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2"><i class="fas fa-check-circle me-1"></i> Đang làm việc</span>
                                        <a href="${pageContext.request.contextPath}/student/jobDetail?id=${w.job.jobId}" class="btn btn-sm btn-outline-primary fw-semibold px-3">Chi tiết công việc</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="tab-pane fade" id="saved" role="tabpanel">
                <c:if test="${empty savedJobs}">
                    <div class="card border-0 shadow-sm text-center py-5 rounded-4">
                        <i class="far fa-bookmark fa-4x text-muted mb-3 opacity-25"></i>
                        <h5 class="text-muted">Bạn chưa lưu công việc nào.</h5>
                    </div>
                </c:if>
                <div class="row">
                    <c:forEach items="${savedJobs}" var="s">
                        <div class="col-md-4 mb-4">
                            <div class="card shadow-sm border-0 rounded-4 h-100 position-relative">
                                
                                <form action="${pageContext.request.contextPath}/student/save-job" method="post" class="position-absolute" style="top: 15px; right: 15px;">
                                    <input type="hidden" name="action" value="unsave">
                                    <input type="hidden" name="jobID" value="${s.job.jobId}">
                                    <button type="submit" class="btn btn-sm btn-light text-warning shadow-sm rounded-circle" title="Bỏ lưu" style="width: 35px; height: 35px;">
                                        <i class="fas fa-bookmark"></i>
                                    </button>
                                </form>

                                <div class="card-body p-4 pt-4 mt-2">
                                    <h5 class="fw-bold text-dark mb-1 pe-4">${s.job.title}</h5>
                                    <div class="text-muted small fw-semibold mb-3"><i class="fas fa-store me-1"></i> ${s.employer.businessName}</div>
                                    
                                    <div class="mb-1 text-muted small"><i class="fas fa-money-bill-wave text-success me-1"></i> Lương: <strong class="text-dark"><fmt:formatNumber value="${s.job.salary}" pattern="#,###"/>đ/ca</strong></div>
                                    <div class="mb-1 text-muted small"><i class="fas fa-clock text-warning me-1"></i> Thời gian: <strong class="text-dark">${s.job.startTime} - ${s.job.endTime}</strong></div>
                                    <div class="mb-3 text-muted small"><i class="fas fa-calendar-alt text-info me-1"></i> Đã lưu lúc: <strong class="text-dark"><fmt:formatDate value="${s.job.createdAt}" pattern="dd/MM/yyyy"/></strong></div>
                                    
                                    <a href="${pageContext.request.contextPath}/student/jobDetail?id=${s.job.jobId}" class="btn btn-outline-primary w-100 fw-semibold rounded-pill">
                                        Xem chi tiết & Ứng tuyển
                                    </a>
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
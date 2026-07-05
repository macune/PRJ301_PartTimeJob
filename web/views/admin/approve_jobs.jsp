<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiểm duyệt bài đăng - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=8.1">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/admin/admin_navbar.jsp" />

    <div class="container flex-grow-1 mt-3 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-primary mb-0">
                <i class="fas fa-clipboard-check me-2"></i>Kiểm duyệt bài đăng
            </h3>
        </div>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="card admin-card p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover mb-0 custom-admin-table align-middle">
                    <thead>
                        <tr>
                            <th>Thời gian tạo</th>
                            <th>Doanh nghiệp</th>
                            <th>Tiêu đề bài đăng</th>
                            <th>Danh mục</th>
                            <th>Lương / Ca</th>
                            <th class="text-center" style="width: 280px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty pendingJobs}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3 opacity-25"></i>
                                        <p class="mb-0">Hiện không có bài đăng nào cần kiểm duyệt.</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${pendingJobs}">
                                    <tr>
                                        <td class="text-muted small">
                                            <fmt:formatDate value="${item.job.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td class="fw-bold text-dark">${item.employer.businessName}</td>
                                        <td class="fw-semibold text-primary">${item.job.title}</td>
                                        <td><span class="badge bg-secondary">${item.category.categoryName}</span></td>
                                        <td><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/> đ</td>
                                        
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-info fw-semibold text-white" data-bs-toggle="modal" data-bs-target="#detailModal${item.job.jobId}" title="Xem chi tiết">
                                                <i class="fas fa-eye me-1"></i> Xem
                                            </button>
                                            
                                            <form action="${pageContext.request.contextPath}/admin/approveJobs" method="post" class="d-inline ms-1" onsubmit="return confirm('Xác nhận DUYỆT bài đăng này?');">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="jobId" value="${item.job.jobId}">
                                                <button type="submit" class="btn btn-sm btn-success fw-semibold" title="Duyệt bài">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </form>
                                            
                                            <form action="${pageContext.request.contextPath}/admin/approveJobs" method="post" class="d-inline ms-1" onsubmit="return confirm('Xác nhận TỪ CHỐI bài đăng này?');">
                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="jobId" value="${item.job.jobId}">
                                                <button type="submit" class="btn btn-sm btn-danger fw-semibold" title="Từ chối">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <c:if test="${not empty pendingJobs}">
        <c:forEach var="item" items="${pendingJobs}">
            <div class="modal fade" id="detailModal${item.job.jobId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                    <div class="modal-content rounded-4 border-0 shadow">
                        <div class="modal-header bg-light border-bottom-0">
                            <h5 class="modal-title fw-bold text-primary">Chi tiết: ${item.job.title}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body pt-3">
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-building me-2"></i>Doanh nghiệp</p>
                                    <p class="fw-bold text-dark ms-4">${item.employer.businessName}</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-tags me-2"></i>Danh mục</p>
                                    <p class="fw-bold text-dark ms-4">${item.category.categoryName}</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-money-bill-wave me-2"></i>Mức lương</p>
                                    <p class="fw-bold text-danger ms-4"><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/> đ/ca</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-clock me-2"></i>Thời gian ca làm</p>
                                    <p class="fw-bold text-dark ms-4">
                                        <fmt:formatDate value="${item.job.startTime}" type="time" pattern="HH:mm" /> - 
                                        <fmt:formatDate value="${item.job.endTime}" type="time" pattern="HH:mm" />
                                    </p>
                                </div>
                                <div class="col-12">
                                    <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-map-marker-alt me-2"></i>Địa điểm làm việc</p>
                                    <p class="fw-bold text-dark ms-4">${item.job.detailAddress}, ${item.job.ward}, ${item.job.city}</p>
                                </div>
                                <div class="col-12 mt-4">
                                    <p class="mb-2 text-muted small fw-semibold"><i class="fas fa-align-left me-2"></i>Mô tả công việc</p>
                                    <div class="p-3 bg-light rounded-3 text-secondary border" style="white-space: pre-wrap; font-size: 0.95rem;">${item.job.description}</div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-top-0 pt-0 justify-content-end bg-light">
                            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê hệ thống - Admin PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6.0">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/admin/admin_navbar.jsp" />
    
    <div class="container flex-grow-1 mb-5 mt-4">
        <h3 class="fw-bold text-primary mb-4"><i class="fas fa-chart-line me-2"></i>Tổng quan Thống kê Hệ thống</h3>

        <div class="row g-4 mb-4">
            <div class="col-md-3 col-sm-6">
                <div class="card admin-stat-card border-left-primary">
                    <div class="card-body p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-bold text-uppercase mb-1">Tổng Sinh viên</div>
                            <div class="fs-2 fw-bold text-primary">${totalStudents}</div>
                        </div>
                        <i class="fas fa-user-graduate fa-3x text-primary opacity-25"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card admin-stat-card border-left-purple">
                    <div class="card-body p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-bold text-uppercase mb-1">Nhà tuyển dụng</div>
                            <div class="fs-2 fw-bold text-purple">${totalEmployers}</div>
                        </div>
                        <i class="fas fa-store fa-3x text-purple opacity-25"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card admin-stat-card border-left-success">
                    <div class="card-body p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-bold text-uppercase mb-1">Tổng Việc làm</div>
                            <div class="fs-2 fw-bold text-success">${totalJobs}</div>
                        </div>
                        <i class="fas fa-briefcase fa-3x text-success opacity-25"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card admin-stat-card border-left-orange">
                    <div class="card-body p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-bold text-uppercase mb-1">Lượt ứng tuyển</div>
                            <div class="fs-2 fw-bold text-orange">${totalApps}</div>
                        </div>
                        <i class="fas fa-paper-plane fa-3x text-orange opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            
            <div class="col-lg-5 d-flex flex-column gap-4">
                
                <div class="card border-0 shadow-sm rounded-4 flex-grow-1">
                    <div class="card-header bg-white border-bottom pt-4 pb-3">
                        <h5 class="fw-bold text-dark mb-0"><i class="fas fa-tasks text-warning me-2"></i>Trạng thái Ứng tuyển</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-borderless align-middle mb-0">
                            <tbody>
                                <c:forEach items="${appStats}" var="item">
                                    <c:set var="percent" value="${totalApps > 0 ? (item.value * 100.0 / totalApps) : 0}" />
                                    <c:choose>
                                        <c:when test="${item.label == 'Chấp nhận'}"><c:set var="barBg" value="bg-success"/></c:when>
                                        <c:when test="${item.label == 'Từ chối'}"><c:set var="barBg" value="bg-danger"/></c:when>
                                        <c:otherwise><c:set var="barBg" value="bg-warning"/></c:otherwise>
                                    </c:choose>

                                    <tr>
                                        <td class="ps-4 fw-semibold text-secondary w-25">${item.label}</td>
                                        <td class="w-50">
                                            <div class="progress progress-bar-thin">
                                                <div class="progress-bar ${barBg}" role="progressbar" style="width: ${percent}%;"></div>
                                            </div>
                                        </td>
                                        <td class="text-end pe-4">
                                            <span class="fw-bold text-dark">${item.value}</span>
                                            <small class="text-muted ms-1">(<fmt:formatNumber value="${percent}" maxFractionDigits="1"/>%)</small>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-4 flex-grow-1">
                    <div class="card-header bg-white border-bottom pt-4 pb-3">
                        <h5 class="fw-bold text-dark mb-0"><i class="fas fa-server text-secondary me-2"></i>Tình trạng Hệ thống</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3 p-3 bg-light rounded-3">
                            <span class="fw-bold text-dark"><i class="fas fa-hourglass-half text-warning me-2"></i>Bài đăng chờ duyệt:</span>
                            <span class="badge bg-warning text-dark fs-6 rounded-pill px-3">${pendingJobs}</span>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between align-items-center px-2 border-0">
                                <span class="text-secondary"><i class="fas fa-user-check text-success me-2"></i>Tài khoản hoạt động</span>
                                <strong class="text-success">${activeAccs}</strong>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center px-2 border-0">
                                <span class="text-secondary"><i class="fas fa-user-lock text-warning me-2"></i>Tài khoản bị khóa</span>
                                <strong class="text-warning">${lockedAccs}</strong>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center px-2 border-0">
                                <span class="text-secondary"><i class="fas fa-user-times text-danger me-2"></i>Tài khoản đã xóa</span>
                                <strong class="text-danger">${deletedAccs}</strong>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>

            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-header bg-white border-bottom pt-4 pb-3">
                        <h5 class="fw-bold text-dark mb-0"><i class="fas fa-list-ul text-info me-2"></i>Tỉ trọng Việc làm theo Danh mục</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive table-container-scroll">
                            <table class="table table-borderless table-hover align-middle mb-0">
                                <thead class="table-light sticky-top">
                                    <tr>
                                        <th class="ps-4 text-muted small">Tên danh mục</th>
                                        <th class="text-muted small">Tỉ trọng</th>
                                        <th class="text-end pe-4 text-muted small">Số bài đăng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${jobStats}" var="item">
                                        <c:set var="percent" value="${totalJobs > 0 ? (item.value * 100.0 / totalJobs) : 0}" />
                                        <tr>
                                            <td class="ps-4 fw-semibold text-dark">${item.label}</td>
                                            <td class="min-w-150">
                                                <div class="progress progress-bar-xs">
                                                    <div class="progress-bar bg-info" role="progressbar" style="width: ${percent}%;"></div>
                                                </div>
                                            </td>
                                            <td class="text-end pe-4">
                                                <span class="fw-bold text-primary">${item.value}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tìm kiếm Việc làm - Part Time Job</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=9.2">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light"> 
        <jsp:include page="/views/common/header.jsp" />
        <jsp:include page="/views/student/student_navbar.jsp" />
        
        <div class="container mt-4 flex-grow-1">
            <div class="filter-wrapper shadow-sm bg-white p-3 rounded mb-4">
                <form action="${pageContext.request.contextPath}/student/findJob" method="GET" class="row filter-form g-2 align-items-end">
                    <div class="col-md-2">
                        <label class="filter-label fw-semibold small mb-1 text-muted">Ngành nghề</label>
                        <select name="categoryId" class="form-select filter-input">
                            <option value="">Tất cả ngành nghề</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="filter-label fw-semibold small mb-1 text-muted">Tỉnh / Thành</label>
                        <select name="city" id="city" class="form-select filter-input" data-selected="${param.city}">
                            <option value="">Chọn Tỉnh/Thành</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="filter-label fw-semibold small mb-1 text-muted">Xã / Phường</label>
                        <select name="ward" id="ward" class="form-select filter-input" data-selected="${param.ward}">
                            <option value="">Chọn Xã/Phường</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="filter-label fw-semibold small mb-1 text-muted">Từ giờ</label>
                        <input type="time" name="startTime" class="form-control filter-input" value="${param.startTime}">
                    </div>
                    <div class="col-md-2">
                        <label class="filter-label fw-semibold small mb-1 text-muted">Đến giờ</label>
                        <input type="time" name="endTime" class="form-control filter-input" value="${param.endTime}">
                    </div>
                    <div class="col-md-2">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100 fw-semibold filter-btn"><i class="fas fa-filter"></i> Lọc</button>
                            <a href="${pageContext.request.contextPath}/student/findJob" class="btn btn-outline-secondary w-100 fw-semibold"><i class="fas fa-sync-alt"></i> Xóa</a>
                        </div>
                    </div>
                </form>
            </div>

            <div class="job-list-wrapper">
                
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="section-title mb-0">Việc Làm Bán Thời Gian Mới Nhất</h2>
                    <button class="btn btn-outline-warning fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#savedJobsModal">
                        <i class="fas fa-bookmark me-1"></i> Việc đã lưu (${savedJobs.size()})
                    </button>
                </div>

                <div class="row">
                    <c:forEach items="${listJobs}" var="item">
                        <div class="col-md-4 mb-4">
                            <div class="card job-card h-100">
                                <div class="card-body">
                                    <h5 class="card-title job-title">${item.job.title}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">
                                        <i class="fas fa-store"></i> ${item.employer.businessName}
                                    </h6>
                                    <p class="card-text mb-1">
                                        <i class="fas fa-money-bill-wave text-success"></i> 
                                        <strong><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/> VNĐ/ca</strong>
                                    </p>
                                    <p class="card-text mb-1">
                                        <i class="fas fa-clock text-warning"></i> ${item.job.startTime} - ${item.job.endTime}
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-map-marker-alt text-danger"></i> ${item.job.ward}, ${item.job.city}
                                    </p>
                                </div>
                                <div class="card-footer job-card-footer">
                                    <a href="${pageContext.request.contextPath}/student/jobDetail?id=${item.job.jobId}" class="btn btn-outline-primary w-100">Xem Chi Tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center mt-4">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/student/findJob?page=${i}&categoryId=${param.categoryId}&city=${param.city}&ward=${param.ward}&startTime=${param.startTime}&endTime=${param.endTime}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </c:if>
            </div> 
        </div>

        <div class="modal fade" id="savedJobsModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-warning border-0 pb-3 rounded-top-4">
                        <h5 class="modal-title fw-bold text-dark"><i class="fas fa-bookmark me-2"></i>Danh sách Việc làm đã lưu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-0">
                        <c:if test="${empty savedJobs}">
                            <div class="text-center py-5">
                                <i class="far fa-folder-open fa-3x text-muted mb-3 opacity-50"></i>
                                <p class="text-muted mb-0">Bạn chưa lưu công việc nào.</p>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty savedJobs}">
                            <div class="table-responsive">
                                <table class="table table-hover table-saved-jobs mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">Tên công việc</th>
                                            <th>Cửa hàng</th>
                                            <th>Mức lương</th>
                                            <th>Thời gian ca</th>
                                            <th class="text-center pe-4">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${savedJobs}" var="s">
                                            <tr>
                                                <td class="ps-4 fw-bold text-dark">
                                                    <a href="${pageContext.request.contextPath}/student/jobDetail?id=${s.job.jobId}" class="text-decoration-none text-primary">
                                                        ${s.job.title}
                                                    </a>
                                                </td>
                                                <td>
                                                    <span class="text-muted small fw-semibold"><i class="fas fa-store me-1"></i> ${s.employer.businessName}</span>
                                                </td>
                                                <td>
                                                    <strong class="text-success"><fmt:formatNumber value="${s.job.salary}" pattern="#,###"/>đ/ca</strong>
                                                </td>
                                                <td>
                                                    <span class="text-dark small"><i class="fas fa-clock text-warning me-1"></i> <fmt:formatDate value="${s.job.startTime}" type="time" pattern="HH:mm" /> - <fmt:formatDate value="${s.job.endTime}" type="time" pattern="HH:mm" /></span>
                                                </td>
                                                <td class="text-center pe-4">
                                                    <div class="d-flex justify-content-center align-items-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/student/jobDetail?id=${s.job.jobId}" class="btn btn-sm btn-primary fw-semibold rounded-pill px-3">
                                                            Chi tiết
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/student/save-job" method="post" class="m-0">
                                                            <input type="hidden" name="action" value="unsave">
                                                            <input type="hidden" name="jobID" value="${s.job.jobId}">
                                                            <button type="submit" class="btn-unsave" title="Bỏ lưu công việc này">
                                                                <i class="fas fa-trash-alt fs-5"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                    <div class="modal-footer bg-light border-0 rounded-bottom-4">
                        <button type="button" class="btn btn-secondary rounded-pill px-4 fw-semibold" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/location-filter.js?v=2.1"></script>
        <jsp:include page="/views/common/footer.jsp" />
    </body>
</html>
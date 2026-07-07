<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý bài đăng - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.8">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/employer/employer_navbar.jsp" />

    <div class="container flex-grow-1">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-primary fw-bold"><i class="fas fa-briefcase me-2"></i>Quản lý bài đăng</h3>
            <a href="${pageContext.request.contextPath}/employer/createJob" class="btn btn-outline-primary fw-semibold">
                <i class="fas fa-plus me-1"></i> Đăng tin mới
            </a>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Tiêu đề công việc</th>
                                <th>Danh mục</th>
                                <th>Mức lương</th>
                                <th>Thời gian</th>
                                <th>Trạng thái</th>
                                <th class="text-end pe-4">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listJobs}" var="item">
                                <tr>
                                    <td class="ps-4 fw-semibold text-dark">${item.job.title}</td>
                                    <td><span class="badge bg-secondary">${item.category.categoryName}</span></td>
                                    <td><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/> đ/ca</td>
                                    <td class="text-muted small">
                                        <fmt:formatDate value="${item.job.startTime}" type="time" pattern="HH:mm" /> - 
                                        <fmt:formatDate value="${item.job.endTime}" type="time" pattern="HH:mm" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.job.status == 0}">
                                                <span class="badge bg-warning text-dark"><i class="fas fa-hourglass-half me-1"></i>Chờ duyệt</span>
                                            </c:when>
                                            <c:when test="${item.job.status == 1}">
                                                <span class="badge bg-success"><i class="fas fa-check-circle me-1"></i>Đã duyệt</span>
                                            </c:when>
                                            <c:when test="${item.job.status == 2}">
                                                <span class="badge bg-danger"><i class="fas fa-times-circle me-1"></i>Từ chối</span>
                                            </c:when>
                                            <c:when test="${item.job.status == 3}">
                                                <span class="badge bg-secondary"><i class="fas fa-lock me-1"></i>Đã đóng</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/employer/createJob?id=${item.job.jobId}" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/employer/manageApplicants?jobId=${item.job.jobId}" class="btn btn-sm btn-outline-info" title="Xem ứng viên">
                                            <i class="fas fa-users"></i>
                                        </a>
                                        <c:if test="${item.job.status != 3}">
                                            <form action="${pageContext.request.contextPath}/employer/manageJobs" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn ĐÓNG bài tuyển dụng này? Sinh viên sẽ không thể nộp đơn nữa.');">
                                                <input type="hidden" name="action" value="close">
                                                <input type="hidden" name="jobId" value="${item.job.jobId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Đóng bài">
                                                    <i class="fas fa-power-off"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listJobs}">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">Bạn chưa đăng tin tuyển dụng nào.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách nhân sự - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.8">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/employer/employer_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-primary fw-bold"><i class="fas fa-users-cog me-2"></i>Quản lý nhân sự hiện tại</h3>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Họ và tên</th>
                                <th>Vị trí công việc</th>
                                <th>Cơ sở làm việc</th>
                                <th>Liên hệ ứng viên</th>
                                <th>Ca làm việc</th>
                                <th>Mức lương duyệt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listAccepted}" var="item">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-dark">${item.student.fullName}</div>
                                        <div class="text-muted small"><i class="fas fa-star text-warning"></i> ${item.student.averageRating}/5</div>
                                    </td>
                                    <td><span class="badge bg-info text-dark px-2 py-2">${item.job.title}</span></td>
                                    <td>
                                        <div class="text-dark small fw-semibold">
                                            <i class="fas fa-map-marker-alt text-danger me-1"></i> ${item.job.detailAddress}
                                        </div>
                                        <div class="text-muted small">${item.job.ward}, ${item.job.city}</div>
                                    </td>
                                    <td>
                                        <div class="text-dark fw-semibold"><i class="fas fa-phone-alt text-secondary me-1"></i> ${item.student.phone}</div>
                                        <div class="text-muted small"><i class="fas fa-envelope text-secondary me-1"></i> ${not empty item.student.contactEmail ? item.student.contactEmail : 'Không có'}</div>
                                    </td>
                                    <td>
                                        <div class="text-dark fw-semibold">
                                            <i class="fas fa-clock text-warning me-1"></i>
                                            <fmt:formatDate value="${item.job.startTime}" type="time" pattern="HH:mm" /> - <fmt:formatDate value="${item.job.endTime}" type="time" pattern="HH:mm" />
                                        </div>
                                    </td>
                                    <td>
                                        <strong class="text-success fs-6"><fmt:formatNumber value="${item.application.desiredSalary}" pattern="#,###"/> đ/ca</strong>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listAccepted}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="fas fa-user-slash fa-2x mb-2 opacity-50 d-block"></i>
                                        Bạn chưa có nhân viên nào đang làm việc.
                                    </td>
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
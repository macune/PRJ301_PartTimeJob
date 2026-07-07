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
                                <th>Liên hệ</th>
                                <th>Mức lương duyệt</th>
                                <th>Lời hẹn của bạn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listAccepted}" var="item">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-dark">${item.student.fullName}</div>
                                        <div class="text-muted small"><i class="fas fa-star text-warning"></i> ${item.student.averageRating}/5</div>
                                    </td>
                                    <td><span class="badge bg-info text-dark">${item.job.title}</span></td>
                                    <td>
                                        <div class="text-dark fw-semibold"><i class="fas fa-phone-alt text-secondary me-1"></i> ${item.student.phone}</div>
                                        <div class="text-muted small"><i class="fas fa-envelope text-secondary me-1"></i> ${not empty item.student.contactEmail ? item.student.contactEmail : 'Không có'}</div>
                                    </td>
                                    <td>
                                        <strong class="text-success"><fmt:formatNumber value="${item.application.desiredSalary}" pattern="#,###"/> đ/ca</strong>
                                    </td>
                                    <td>
                                        <p class="mb-0 text-secondary small" style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${item.application.employerNote}">
                                            ${item.application.employerNote}
                                        </p>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listAccepted}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="fas fa-user-slash fa-2x mb-2 opacity-50 d-block"></i>
                                        Bạn chưa duyệt chấp nhận ứng viên nào.
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
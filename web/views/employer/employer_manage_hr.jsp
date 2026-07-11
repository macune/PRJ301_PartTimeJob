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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=5.0">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/employer/employer_navbar.jsp" />

    <div class="container flex-grow-1 mb-5">
        <h3 class="text-primary fw-bold mb-4"><i class="fas fa-users-cog me-2"></i>Quản lý nhân sự</h3>

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

        <ul class="nav nav-pills mb-4 border-bottom pb-2" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-semibold" data-bs-toggle="pill" data-bs-target="#activeHR" type="button"><i class="fas fa-user-check me-1"></i> Nhân sự hiện tại (${listAccepted.size()})</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold" data-bs-toggle="pill" data-bs-target="#historyHR" type="button"><i class="fas fa-history me-1"></i> Lịch sử nhân sự (${listHistory.size()})</button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="activeHR">
                <div class="card shadow-sm border-0 rounded-4"><div class="card-body p-0"><div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">Họ và tên</th><th>Vị trí</th><th>Liên hệ</th><th>Ca làm việc</th><th class="text-center pe-4">Hành động</th></tr></thead>
                        <tbody>
                            <c:forEach items="${listAccepted}" var="item">
                                <tr>
                                    <td class="ps-4"><div class="fw-bold text-dark">${item.student.fullName}</div><div class="text-muted small"><i class="fas fa-star text-warning"></i> ${item.student.averageRating}/5</div></td>
                                    <td><span class="badge bg-info text-dark px-2">${item.job.title}</span></td>
                                    <td><div class="text-dark fw-semibold"><i class="fas fa-phone-alt me-1"></i> ${item.student.phone}</div></td>
                                    <td><div class="text-dark fw-semibold"><i class="fas fa-clock text-warning me-1"></i> <fmt:formatDate value="${item.job.startTime}" type="time" pattern="HH:mm" /> - <fmt:formatDate value="${item.job.endTime}" type="time" pattern="HH:mm" /></div></td>
                                    <td class="text-center pe-4">
                                        <button class="btn btn-sm btn-outline-danger fw-semibold rounded-pill" data-bs-toggle="modal" data-bs-target="#fireModal${item.application.applicationID}"><i class="fas fa-user-times me-1"></i> Cho nghỉ</button>
                                        
                                        <div class="modal fade text-start" id="fireModal${item.application.applicationID}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered"><div class="modal-content rounded-4 border-0">
                                                <div class="modal-header bg-danger text-white border-0"><h5 class="modal-title fw-bold">Xác nhận Cho nghỉ</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                                                <form action="${pageContext.request.contextPath}/employer/manageHR" method="POST">
                                                    <div class="modal-body p-4 text-center">
                                                        <p>Xác nhận cho <strong>${item.student.fullName}</strong> nghỉ việc?</p>
                                                        <input type="hidden" name="action" value="fire"><input type="hidden" name="applicationId" value="${item.application.applicationID}">
                                                        <textarea class="form-control" name="reason" rows="3" placeholder="Nhập lý do..." required></textarea>
                                                    </div>
                                                    <div class="modal-footer border-0 p-3 pt-0"><button type="submit" class="btn btn-danger w-100 fw-bold">Xác nhận</button></div>
                                                </form>
                                            </div></div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listAccepted}"><tr><td colspan="5" class="text-center py-5 text-muted">Chưa có nhân sự nào đang làm việc.</td></tr></c:if>
                        </tbody>
                    </table>
                </div></div></div>
            </div>

            <div class="tab-pane fade" id="historyHR">
                <div class="card shadow-sm border-0 rounded-4"><div class="card-body p-0"><div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">Họ và tên</th><th>Vị trí</th><th>Lý do kết thúc</th><th class="text-center pe-4">Đánh giá</th></tr></thead>
                        <tbody>
                            <c:forEach items="${listHistory}" var="item">
                                <tr class="bg-light opacity-75">
                                    <td class="ps-4"><div class="fw-bold text-dark">${item.student.fullName}</div></td>
                                    <td><span class="badge bg-secondary px-2">${item.job.title}</span></td>
                                    <td><div class="text-danger small fw-semibold"><i class="fas fa-info-circle me-1"></i> ${item.application.employerNote}</div></td>
                                    <td class="text-center pe-4">
                                        <c:choose>
                                            <c:when test="${item.isReviewed}"><button class="btn btn-sm btn-secondary fw-semibold rounded-pill" disabled>Đã đánh giá</button></c:when>
                                            <c:otherwise>
                                                <button class="btn btn-sm btn-warning fw-semibold rounded-pill text-dark" data-bs-toggle="modal" data-bs-target="#reviewStudentModal${item.student.studentId}"><i class="fas fa-star me-1"></i> Đánh giá</button>

                                                <div class="modal fade text-start" id="reviewStudentModal${item.student.studentId}" tabindex="-1">
                                                    <div class="modal-dialog modal-dialog-centered"><div class="modal-content rounded-4 border-0">
                                                        <div class="modal-header border-0 bg-warning"><h5 class="modal-title fw-bold text-dark">Đánh giá Ứng viên</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                                        <form action="${pageContext.request.contextPath}/employer/review" method="POST">
                                                            <div class="modal-body p-4 text-center">
                                                                <input type="hidden" name="studentId" value="${item.student.studentId}">
                                                                <div class="star-rating mb-2">
                                                                    <input type="radio" id="r5_${item.student.studentId}" name="rating" value="5" required/><label for="r5_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                    <input type="radio" id="r4_${item.student.studentId}" name="rating" value="4"/><label for="r4_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                    <input type="radio" id="r3_${item.student.studentId}" name="rating" value="3"/><label for="r3_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                    <input type="radio" id="r2_${item.student.studentId}" name="rating" value="2"/><label for="r2_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                    <input type="radio" id="r1_${item.student.studentId}" name="rating" value="1"/><label for="r1_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                </div>
                                                                <textarea class="form-control" name="comment" rows="3" placeholder="Nhận xét của bạn..." required></textarea>
                                                            </div>
                                                            <div class="modal-footer"><button type="submit" class="btn btn-warning w-100 fw-bold">Gửi đánh giá</button></div>
                                                        </form>
                                                    </div></div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listHistory}"><tr><td colspan="4" class="text-center py-5 text-muted">Chưa có lịch sử nhân sự.</td></tr></c:if>
                        </tbody>
                    </table>
                </div></div></div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-primary fw-bold"><i class="fas fa-users-cog me-2"></i>Quản lý nhân sự hiện tại</h3>
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

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Họ và tên</th>
                                <th>Vị trí</th>
                                <th>Cơ sở làm việc</th>
                                <th>Liên hệ</th>
                                <th>Ca làm việc</th>
                                <th>Mức lương</th>
                                <th class="text-center pe-4">Hành động</th>
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
                                        <div class="text-dark small fw-semibold"><i class="fas fa-map-marker-alt text-danger me-1"></i> ${item.job.detailAddress}</div>
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
                                        <strong class="text-success fs-6"><fmt:formatNumber value="${item.application.desiredSalary}" pattern="#,###"/>đ/ca</strong>
                                    </td>
                                    <td class="text-center pe-4">
                                        <c:choose>
                                            <c:when test="${item.isReviewed}">
                                                <button class="btn btn-sm btn-secondary fw-semibold rounded-pill opacity-75" disabled>
                                                    <i class="fas fa-check-circle me-1"></i> Đã đánh giá
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-sm btn-outline-warning fw-semibold rounded-pill" data-bs-toggle="modal" data-bs-target="#reviewStudentModal${item.student.studentId}">
                                                    <i class="fas fa-star me-1"></i> Đánh giá
                                                </button>

                                                <div class="modal fade text-start" id="reviewStudentModal${item.student.studentId}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content rounded-4 border-0 shadow-lg">
                                                            <div class="modal-header border-0 rounded-top-4 modal-header-yellow">
                                                                <h5 class="modal-title fw-bold text-dark"><i class="fas fa-star me-2"></i>Đánh giá Ứng viên</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <form action="${pageContext.request.contextPath}/employer/review" method="POST">
                                                                <div class="modal-body p-4 text-center">
                                                                    <p class="mb-3 text-dark review-prompt-text">
                                                                        Thái độ và hiệu suất làm việc của <strong>${item.student.fullName}</strong> như thế nào?
                                                                    </p>
                                                                    <input type="hidden" name="studentId" value="${item.student.studentId}">
                                                                    <div class="star-rating mb-2">
                                                                        <input type="radio" id="st5_${item.student.studentId}" name="rating" value="5" required/><label for="st5_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                        <input type="radio" id="st4_${item.student.studentId}" name="rating" value="4"/><label for="st4_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                        <input type="radio" id="st3_${item.student.studentId}" name="rating" value="3"/><label for="st3_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                        <input type="radio" id="st2_${item.student.studentId}" name="rating" value="2"/><label for="st2_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                        <input type="radio" id="st1_${item.student.studentId}" name="rating" value="1"/><label for="st1_${item.student.studentId}"><i class="fas fa-star"></i></label>
                                                                    </div>
                                                                    <textarea class="form-control rounded-3 border-light shadow-sm review-textarea" name="comment" rows="4" placeholder="Nhận xét về giờ giấc, thái độ..." required></textarea>
                                                                </div>
                                                                <div class="modal-footer border-0 p-3 pt-0">
                                                                    <button type="submit" class="btn fw-bold w-100 text-dark rounded-3 btn-submit-yellow">Gửi đánh giá</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listAccepted}">
                                <tr><td colspan="7" class="text-center py-5 text-muted">Bạn chưa có nhân viên nào đang làm việc.</td></tr>
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
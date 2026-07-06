<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${jobDetail.job.title} - Part Time Job</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=9.1">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light">
        <jsp:include page="/views/common/header.jsp" />
        <jsp:include page="/views/student/student_navbar.jsp" />

        <div class="container mt-4 flex-grow-1">
            
            <%-- Alert thông báo --%>
            <c:if test="${param.result == 'success'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm">
                    <i class="fas fa-check-circle me-2"></i><strong>Ứng tuyển thành công!</strong> Đơn đang chờ duyệt.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.result == 'already'}">
                <div class="alert alert-warning alert-dismissible fade show shadow-sm">
                    <i class="fas fa-exclamation-triangle me-2"></i>Bạn đã ứng tuyển công việc này rồi!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.saved == '1'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm">
                    <i class="fas fa-bookmark me-2"></i>Đã lưu vào danh sách yêu thích!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.saved == '0'}">
                <div class="alert alert-secondary alert-dismissible fade show shadow-sm">
                    <i class="far fa-bookmark me-2"></i>Đã bỏ lưu bài viết.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <%-- BỔ SUNG: Cảnh báo trùng thời gian làm việc --%>
            <c:if test="${param.result == 'overlap'}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm">
                    <i class="fas fa-user-clock me-2"></i><strong>Không thể ứng tuyển!</strong> Thời gian của ca làm này bị TRÙNG LỊCH với một công việc khác mà bạn đã nộp đơn hoặc đang làm.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <%-- BỔ SUNG: Alert khi có lỗi từ Server/Database --%>
            <c:if test="${param.result == 'error'}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm">
                    <i class="fas fa-times-circle me-2"></i><strong>Ứng tuyển thất bại!</strong> Đã có lỗi xảy ra hoặc bạn nhập thông tin chưa đúng, vui lòng thử lại sau.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4 mb-5">
                <!-- CỘT TRÁI: CHI TIẾT CÔNG VIỆC -->
                <div class="col-md-8">
                    <div class="card shadow-sm border-0 rounded-4 h-100">
                        <div class="card-body p-4">
                            <h2 class="text-primary fw-bold">${jobDetail.job.title}</h2>
                            <span class="badge bg-info text-dark fs-6 px-3 py-2 rounded-pill mt-2">${jobDetail.category.categoryName}</span>
                            
                            <hr class="my-4">
                            
                            <h5 class="fw-bold mb-3"><i class="fas fa-file-alt text-success me-2"></i>Mô Tả Công Việc:</h5>
                            <div class="p-3 bg-light rounded-3 text-secondary mb-4" style="white-space: pre-wrap;">${jobDetail.job.description}</div>
                            
                            <h5 class="fw-bold mb-3"><i class="fas fa-info-circle text-primary me-2"></i>Thông Tin Chi Tiết:</h5>
                            <ul class="list-group list-group-flush mb-4">
                                <li class="list-group-item bg-transparent px-0"><i class="fas fa-money-bill-wave text-success me-2"></i> <strong>Mức lương:</strong> <fmt:formatNumber value="${jobDetail.job.salary}" pattern="#,###"/> VNĐ/ca</li>
                                <li class="list-group-item bg-transparent px-0"><i class="fas fa-clock text-warning me-2"></i> <strong>Thời gian:</strong> ${jobDetail.job.startTime} đến ${jobDetail.job.endTime}</li>
                                <li class="list-group-item bg-transparent px-0"><i class="fas fa-map-marked-alt text-danger me-2"></i> <strong>Địa điểm:</strong> ${jobDetail.job.detailAddress}, ${jobDetail.job.ward}, ${jobDetail.job.city}</li>
                                <li class="list-group-item bg-transparent px-0"><i class="fas fa-calendar-alt text-secondary me-2"></i> <strong>Ngày đăng:</strong> <fmt:formatDate value="${jobDetail.job.createdAt}" pattern="dd/MM/yyyy"/></li>
                            </ul>
                            
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-4">
                                <a href="${pageContext.request.contextPath}/student/findJob" class="btn btn-outline-secondary px-4 fw-semibold">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                </a>
                                <div class="d-flex gap-2">
                                    <!-- Form Lưu Bài -->
                                    <form action="${pageContext.request.contextPath}/student/save-job" method="post">
                                        <input type="hidden" name="jobID" value="${jobDetail.job.jobId}">
                                        <c:choose>
                                            <c:when test="${isSaved}">
                                                <input type="hidden" name="action" value="unsave">
                                                <button type="submit" class="btn btn-warning fw-semibold px-4"><i class="fas fa-bookmark me-2"></i>Đã lưu</button>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="action" value="save">
                                                <button type="submit" class="btn btn-outline-secondary fw-semibold px-4"><i class="far fa-bookmark me-2"></i>Lưu bài</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>

                                    <!-- Nút Ứng Tuyển -->
                                    <c:choose>
                                        <c:when test="${hasApplied}">
                                            <button class="btn btn-secondary px-5 fw-semibold" disabled><i class="fas fa-check-circle me-2"></i>Đã Ứng Tuyển</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-success px-5 fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#applyModal">
                                                Ứng Tuyển Ngay <i class="fas fa-paper-plane ms-2"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI: THÔNG TIN NHÀ TUYỂN DỤNG TÓM TẮT -->
                <div class="col-md-4">
                    <div class="card shadow-sm border-0 rounded-4">
                        <div class="card-header bg-primary text-white py-3 rounded-top-4">
                            <h5 class="mb-0 fw-bold text-center"><i class="fas fa-building me-2"></i>Nhà Tuyển Dụng</h5>
                        </div>
                        <div class="card-body text-center p-4">
                            <h4 class="fw-bold mt-2 text-dark">${jobDetail.employer.businessName}</h4>
                            
                            <!-- Hiển thị sao đánh giá động -->
                            <div class="d-flex justify-content-center align-items-center mt-2 mb-4">
                                <div class="star-rating-wrapper fs-5">
                                    <div class="star-rating-background">
                                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                    </div>
                                    <div class="star-rating-overlay" style="width: ${(jobDetail.employer.averageRating / 5.0) * 100}%;">
                                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                    </div>
                                </div>
                                <span class="ms-2 fw-bold text-muted">(${jobDetail.employer.averageRating})</span>
                            </div>

                            <button class="btn btn-outline-primary w-100 fw-semibold rounded-pill" data-bs-toggle="modal" data-bs-target="#employerProfileModal">
                                <i class="fas fa-id-card me-2"></i>Xem Hồ Sơ & Đánh Giá
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL 1: NỘP ĐƠN ỨNG TUYỂN -->
        <div class="modal fade" id="applyModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content rounded-4 border-0 shadow">
                    <div class="modal-header bg-success text-white border-bottom-0 pb-3 rounded-top-4">
                        <h5 class="modal-title fw-bold"><i class="fas fa-paper-plane me-2"></i>Nộp đơn ứng tuyển</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/student/apply" method="post">
                        <input type="hidden" name="jobID" value="${jobDetail.job.jobId}">
                        <div class="modal-body pt-4">
                            <div class="alert alert-light border mb-4">
                                <span class="text-muted small d-block mb-1">Công việc ứng tuyển:</span>
                                <strong class="text-primary">${jobDetail.job.title}</strong>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-dark"><i class="fas fa-money-bill-wave text-success me-1"></i> Mức lương mong muốn (VNĐ/ca)</label>
                                <input type="number" class="form-control" name="desiredSalary" placeholder="Mức gốc: ${jobDetail.job.salary}" min="10000" step="1000">
                                <small class="text-muted mt-1 d-block">Có thể để trống nếu bạn đồng ý với mức lương gốc.</small>
                            </div>
                            <div class="mb-3">
                                <!-- Đã dùng maxlength="500" thay cho JS -->
                                <label class="form-label fw-semibold text-dark"><i class="fas fa-comment-alt text-primary me-1"></i> Lời nhắn (Cover Letter)</label>
                                <textarea class="form-control" id="message" name="message" rows="4" maxlength="500" placeholder="Giới thiệu bản thân, kinh nghiệm, lý do bạn phù hợp..."></textarea>
                                <small class="text-muted mt-1 d-block text-end">Tối đa 500 ký tự.</small>
                            </div>
                        </div>
                        <div class="modal-footer border-top-0 pt-0 bg-light rounded-bottom-4">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success rounded-pill px-4 fw-semibold shadow-sm">Gửi đơn ứng tuyển</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- MODAL 2: HỒ SƠ & ĐÁNH GIÁ NHÀ TUYỂN DỤNG -->
        <div class="modal fade" id="employerProfileModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content rounded-4 border-0 shadow">
                    
                    <div class="modal-header bg-primary text-white border-bottom-0 pb-3 rounded-top-4">
                        <h5 class="modal-title fw-bold"><i class="fas fa-store me-2"></i>Hồ Sơ Nhà Tuyển Dụng</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    
                    <div class="modal-body p-4 bg-light">
                        
                        <!-- Block 1: THÔNG TIN DOANH NGHIỆP FULL INFO (KHÔNG LOGO) -->
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-body p-4">
                                <h3 class="fw-bold text-center text-primary mb-2">${jobDetail.employer.businessName}</h3>
                                <div class="d-flex justify-content-center align-items-center mb-4">
                                    <span class="text-warning fw-bold fs-5">
                                        ${jobDetail.employer.averageRating} <i class="fas fa-star"></i>
                                    </span>
                                </div>
                                
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-phone-alt me-2"></i>Số điện thoại</p>
                                        <p class="fw-bold text-dark ms-4">${jobDetail.employer.phone}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-envelope me-2"></i>Email liên hệ</p>
                                        <p class="fw-bold text-dark ms-4">${jobDetail.employer.contactEmail}</p>
                                    </div>
                                    <div class="col-12">
                                        <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-globe me-2"></i>Website</p>
                                        <p class="fw-bold text-dark ms-4">
                                            <c:choose>
                                                <c:when test="${not empty jobDetail.employer.website}">
                                                    <a href="${jobDetail.employer.website}" target="_blank" class="text-decoration-none">${jobDetail.employer.website}</a>
                                                </c:when>
                                                <c:otherwise><span class="text-muted fw-normal fst-italic">Chưa cập nhật</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="col-12">
                                        <p class="mb-1 text-muted small fw-semibold"><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ trụ sở</p>
                                        <p class="fw-bold text-dark ms-4">${jobDetail.employer.address}</p>
                                    </div>
                                    <div class="col-12 mt-2">
                                        <p class="mb-2 text-muted small fw-semibold"><i class="fas fa-info-circle me-2"></i>Giới thiệu doanh nghiệp</p>
                                        <div class="p-3 bg-white rounded-3 text-secondary border" style="white-space: pre-wrap; font-size: 0.95rem;">${jobDetail.employer.description}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Block 2: KHU VỰC ĐÁNH GIÁ -->
                        <h5 class="fw-bold text-dark mb-3">
                            <i class="fas fa-comments text-warning me-2"></i>Nhận xét từ ứng viên
                        </h5>
                        
                        <c:choose>
                            <c:when test="${empty reviewList}">
                                <div class="text-center text-muted py-4 bg-white rounded-4 shadow-sm border-0">
                                    <i class="fas fa-comment-slash fa-2x mb-2 opacity-50"></i>
                                    <p class="mb-0 small">Chưa có đánh giá nào cho nhà tuyển dụng này.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${reviewList}">
                                    <div class="card mb-3 p-3 border-0 bg-white shadow-sm rounded-4">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="fw-bold text-dark">${r.reviewerName}</span>
                                            <span class="text-warning fw-bold">
                                                ${r.rating} <i class="fas fa-star"></i>
                                            </span>
                                        </div>
                                        <p class="mb-2 text-secondary">${r.comment}</p>
                                        <small class="text-muted fst-italic">
                                            <i class="fas fa-clock me-1"></i> <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                        </small>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>

                    </div>
                    
                    <div class="modal-footer border-top-0 pt-0 bg-light rounded-bottom-4 justify-content-end">
                        <button type="button" class="btn btn-secondary rounded-pill px-4 fw-semibold" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/views/common/footer.jsp" />
    </body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Account, models.Employer_Profile" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Account account = (Account) session.getAttribute("account");
    Employer_Profile profile = (Employer_Profile) request.getAttribute("profile");
    java.util.function.Function<String, String> safe = s -> s == null ? "" : s;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ doanh nghiệp - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6.2">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/employer/employer_navbar.jsp" />

    <div class="container flex-grow-1 mt-2 mb-5">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold text-primary mb-0"><i class="fas fa-store me-2"></i>Hồ sơ doanh nghiệp</h3>
                <p class="text-muted small mb-0 mt-1">Cập nhật thông tin để ứng viên dễ dàng nhận diện và tin tưởng</p>
            </div>
            <span class="badge bg-info px-3 py-2 fs-6 rounded-pill shadow-sm">
                <i class="fas fa-star me-1 text-warning"></i>
                Đánh giá: <%= profile != null ? profile.getAverageRating() : "0.0" %>/5
            </span>
        </div>

        <% if ("1".equals(request.getParameter("updated"))) { %>
        <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4">
            <i class="fas fa-check-circle me-2"></i><strong>Cập nhật thành công!</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (request.getAttribute("errorMsg") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4">
            <i class="fas fa-exclamation-circle me-2"></i><%= request.getAttribute("errorMsg") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/employer/profile" method="post">
            <input type="hidden" id="accountUsername" value="<%= account.getUsername() %>">
            
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card settings-card rounded-4 p-4 text-center h-100">
                        <% String displayBizName = (profile != null && profile.getBusinessName() != null && !profile.getBusinessName().isEmpty()) 
                                                   ? profile.getBusinessName() : account.getUsername(); %>
                        
                        <img id="logoPreview"
                             src="<%= profile != null && profile.getLogoUrl() != null && !profile.getLogoUrl().isEmpty()
                                      ? profile.getLogoUrl()
                                      : "https://ui-avatars.com/api/?name=" + displayBizName.substring(0,1) + "&background=087990&color=fff&size=130&bold=true" %>"
                             class="logo-preview mx-auto mb-3" alt="Logo">
                             
                        <h5 class="fw-bold mb-1"><%= displayBizName %></h5>
                        <span class="badge bg-info bg-opacity-10 text-info border border-info mb-4 px-3 py-1 rounded-pill">Nhà tuyển dụng</span>

                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small text-muted">Đường dẫn Logo (URL)</label>
                            <input type="url" class="form-control" name="logoUrl" id="logoUrlInput"
                                   placeholder="https://..." value="<%= profile != null ? safe.apply(profile.getLogoUrl()) : "" %>"
                                   oninput="previewLogo(this.value)">
                        </div>
                        
                        <div class="star-rating fs-4 mt-2">
                            <% double rating = profile != null ? profile.getAverageRating() : 0;
                               for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star<%= i <= rating ? "" : "-o" %> text-warning"></i>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card settings-card rounded-4 p-5 h-100">
                        <h5 class="fw-bold mb-4 text-info border-bottom pb-3">Thông tin liên hệ</h5>
                        <div class="row g-4 mb-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-muted">Tên doanh nghiệp / Cửa hàng <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="businessName" value="<%= profile != null ? safe.apply(profile.getBusinessName()) : "" %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-muted">Số điện thoại</label>
                                <input type="text" class="form-control" name="phone" value="<%= profile != null ? safe.apply(profile.getPhone()) : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-muted">Email liên hệ</label>
                                <input type="email" class="form-control" name="contactEmail" value="<%= profile != null ? safe.apply(profile.getContactEmail()) : "" %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold text-muted">Website / Fanpage</label>
                                <input type="url" class="form-control" name="website" placeholder="https://..." value="<%= profile != null ? safe.apply(profile.getWebsite()) : "" %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold text-muted">Địa chỉ văn phòng / Cửa hàng chính</label>
                                <input type="text" class="form-control" name="address" value="<%= profile != null ? safe.apply(profile.getAddress()) : "" %>">
                            </div>
                        </div>

                        <h5 class="fw-bold mb-4 text-info border-bottom pb-3 mt-2">Giới thiệu doanh nghiệp</h5>
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted">Mô tả ngắn gọn</label>
                            <textarea class="form-control" name="description" rows="4" placeholder="Giới thiệu về môi trường làm việc, văn hoá doanh nghiệp..."><%= profile != null ? safe.apply(profile.getDescription()) : "" %></textarea>
                        </div>

                        <div class="d-flex justify-content-end pt-3 border-top">
                            <button type="submit" class="btn btn-info text-white fw-semibold px-4 rounded-pill">Lưu hồ sơ</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
                                        <%-- KHU VỰC HIỂN THỊ ĐÁNH GIÁ (READ-ONLY) --%>
        <div class="card settings-card rounded-4 p-4 mt-4 mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold text-dark mb-0">
                    <i class="fas fa-comments text-warning me-2"></i>Nhận xét từ người dùng
                </h5>
                <span class="text-muted small">
                    Tổng: <strong class="text-dark">${empty reviewList ? 0 : reviewList.size()}</strong> đánh giá
                </span>
            </div>
            
            <div class="review-scroll-container">
                <c:choose>
                    <c:when test="${empty reviewList}">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-comment-slash fa-2x mb-2 opacity-50"></i>
                            <p class="mb-0 small">Chưa có đánh giá nào.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="r" items="${reviewList}">
                            <div class="card mb-3 p-3 border-0 bg-light shadow-sm review-card">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold text-dark">${r.reviewerName}</span>
                                    <span class="text-warning fw-bold">
                                        ${r.rating} <i class="fas fa-star"></i>
                                    </span>
                                </div>
                                
                                <p class="mb-2 text-secondary review-comment-text">${r.comment}</p>
                                
                                <small class="text-muted fst-italic">
                                    <i class="fas fa-clock me-1"></i>${r.createdAt}
                                </small>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/employer_profile.js"></script>
</body>
</html>
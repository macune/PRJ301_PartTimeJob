<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Account, models.Student_Profile" %>
<%
    Account account = (Account) session.getAttribute("account");
    Student_Profile profile = (Student_Profile) request.getAttribute("profile");
    java.util.function.Function<String, String> safe = s -> s == null ? "" : s;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=6.2">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/student/student_navbar.jsp" />

    <div class="container flex-grow-1 mt-2 mb-5">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold text-primary mb-0"><i class="fas fa-id-card me-2"></i>Hồ sơ cá nhân</h3>
                <p class="text-muted small mb-0 mt-1">Cập nhật thông tin để thu hút nhà tuyển dụng</p>
            </div>
            <span class="badge bg-success px-3 py-2 fs-6 rounded-pill shadow-sm">
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

        <form action="${pageContext.request.contextPath}/student/profile" method="post">
            <input type="hidden" id="accountUsername" value="<%= account.getUsername() %>">
            
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card settings-card rounded-4 p-4 text-center h-100">
                        <% String displayName = (profile != null && profile.getFullName() != null && !profile.getFullName().isEmpty()) 
                                                ? profile.getFullName() : account.getUsername(); %>
                                                
                        <img id="avatarPreview"
                             src="<%= profile != null && profile.getAvatarUrl() != null && !profile.getAvatarUrl().isEmpty()
                                      ? profile.getAvatarUrl()
                                      : "https://ui-avatars.com/api/?name=" + displayName + "&background=2e7d32&color=fff&size=130" %>"
                             class="avatar-preview mx-auto mb-3" alt="Avatar">
                             
                        <h5 class="fw-bold mb-1"><%= displayName %></h5>
                        <span class="badge bg-success bg-opacity-10 text-success border border-success mb-4 px-3 py-1 rounded-pill">Sinh viên</span>

                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small text-muted">Đường dẫn ảnh đại diện (URL)</label>
                            <input type="url" class="form-control" name="avatarUrl" id="avatarUrlInput"
                                   placeholder="https://..." value="<%= profile != null ? safe.apply(profile.getAvatarUrl()) : "" %>"
                                   oninput="previewAvatar(this.value)">
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
                        <h5 class="fw-bold mb-4 text-success border-bottom pb-3">Thông tin cá nhân</h5>
                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-muted">Họ và tên</label>
                                <input type="text" class="form-control" name="fullName" value="<%= profile != null ? safe.apply(profile.getFullName()) : "" %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-muted">Trường đại học</label>
                                <input type="text" class="form-control" name="university" value="<%= profile != null ? safe.apply(profile.getUniversity()) : "" %>">
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
                                <label class="form-label fw-semibold text-muted">Địa chỉ</label>
                                <input type="text" class="form-control" name="address" value="<%= profile != null ? safe.apply(profile.getAddress()) : "" %>">
                            </div>
                        </div>

                        <h5 class="fw-bold mb-4 text-success border-bottom pb-3">Giới thiệu & Kinh nghiệm</h5>
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted">Giới thiệu bản thân</label>
                            <textarea class="form-control" name="introduction" rows="3"><%= profile != null ? safe.apply(profile.getIntroduction()) : "" %></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted">Kinh nghiệm làm việc</label>
                            <textarea class="form-control" name="experience" rows="3"><%= profile != null ? safe.apply(profile.getExperience()) : "" %></textarea>
                        </div>

                        <div class="d-flex justify-content-end pt-3 border-top">
                            <button type="submit" class="btn btn-success fw-semibold px-4 rounded-pill">Lưu hồ sơ</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.1">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />

    <div class="container flex-grow-1 mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                
                <div class="d-flex align-items-center gap-3 mb-4">
                    <a href="#" onclick="history.back(); return false;" class="btn-back-circle rounded-circle shadow-sm text-secondary text-decoration-none" title="Quay về trang trước">
                        <i class="fas fa-arrow-left fs-5"></i>
                    </a>
                    <h3 class="fw-bold text-primary mb-0">Thay đổi mật khẩu</h3>
                </div>
                
                <div class="card settings-card rounded-4">
                    <div class="card-body p-5">
                        
                        <c:if test="${not empty successMsg}">
                            <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${successMsg}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty errorMsg}">
                            <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/userAccount" method="post">
                            <input type="hidden" name="action" value="change_password">
                          
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-muted">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-lock text-secondary"></i></span>
                                    <input type="password" class="form-control border-start-0" name="oldPassword" id="oldPassword" placeholder="Nhập mật khẩu đang sử dụng" required>
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('oldPassword', this)" tabindex="-1">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold text-muted">Mật khẩu mới <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-key text-primary"></i></span>
                                    <input type="password" class="form-control border-start-0" name="newPassword" id="newPassword" placeholder="Tối thiểu 6 ký tự" required>
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('newPassword', this)" tabindex="-1">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-muted">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-check-double text-success"></i></span>
                                    <input type="password" class="form-control border-start-0" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword', this)" tabindex="-1">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="d-grid mt-5">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold rounded-pill">
                                    <i class="fas fa-check me-2"></i>Cập nhật mật khẩu
                                </button>
                            </div>
                        </form>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/auth.js?v=1.0"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.7">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />

    <div class="container flex-grow-1 mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">Thông Tin Cốt Lõi</h4>
                    </div>
                    <div class="card-body p-4">
                        
                        <c:if test="${not empty successMsg}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${successMsg}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty errorMsg}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/userAccount" method="post">
                            <input type="hidden" name="action" value="update_info">
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-muted">
                                    <i class="fas fa-user me-1 text-primary"></i>Tên đăng nhập
                                </label>
                                <input type="text" class="form-control bg-light" value="${sessionScope.account.username}" readonly>
                                <div class="form-text">Tên đăng nhập là định danh cố định, không thể thay đổi.</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">
                                    <i class="fas fa-envelope me-1 text-primary"></i>Email hệ thống
                                </label>
                                <input type="email" class="form-control" name="email" value="${sessionScope.account.email}" required>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-muted">
                                    <i class="fas fa-id-badge me-1 text-primary"></i>Vai trò
                                </label>
                                <input type="text" class="form-control bg-light" 
                                       value="${sessionScope.account.role == 1 ? 'Admin' : (sessionScope.account.role == 2 ? 'Sinh viên' : 'Nhà tuyển dụng')}" readonly>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary fw-semibold"><i class="fas fa-save me-2"></i>Cập nhật thông tin</button>
                                <a href="${pageContext.request.contextPath}/userAccount?action=change_password" class="btn btn-outline-secondary fw-semibold">
                                    <i class="fas fa-key me-2"></i>Chuyển đến Đổi mật khẩu
                                </a>
                            </div>
                        </form>

                        <hr class="my-4">
                        
                        <div class="text-center">
                            <p class="text-muted small mb-2">Nếu bạn không muốn tiếp tục sử dụng dịch vụ, bạn có thể vô hiệu hóa tài khoản.</p>
                            <form action="${pageContext.request.contextPath}/userAccount" method="post" 
                                  onsubmit="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản? Hành động này sẽ đăng xuất bạn ngay lập tức!');">
                                <input type="hidden" name="action" value="delete_account">
                                <button type="submit" class="btn btn-danger fw-semibold"><i class="fas fa-trash-alt me-2"></i>Vô hiệu hóa tài khoản</button>
                            </form>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
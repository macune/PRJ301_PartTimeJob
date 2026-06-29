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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.2">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />

    <div class="container flex-grow-1 mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                
                <div class="d-flex align-items-center gap-3 mb-4">
                    <a href="#" onclick="history.back(); return false;" class="btn-back-circle rounded-circle shadow-sm text-secondary text-decoration-none" title="Quay về trang trước">
                        <i class="fas fa-arrow-left fs-5"></i>
                    </a>
                    <h3 class="fw-bold text-primary mb-0">Cài đặt tài khoản</h3>
                </div>

                <div class="card settings-card rounded-4 mb-4">
                    <div class="card-body p-5">
                        
                        <h4 class="fw-bold mb-4 border-bottom pb-3">Thông tin tài khoản</h4>
                        
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
                            <input type="hidden" name="action" value="update_info">
                        
                            <div class="row mb-3 align-items-center">
                                <label class="col-sm-3 col-form-label fw-semibold text-muted">Tên đăng nhập:</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-readonly" value="${sessionScope.account.username}" readonly>
                                </div>
                            </div>

                            <div class="row mb-3 align-items-center">
                                <label class="col-sm-3 col-form-label fw-semibold text-muted">Email hệ thống <span class="text-danger">*</span>:</label>
                                <div class="col-sm-9">
                                    <input type="email" class="form-control" name="email" value="${sessionScope.account.email}" required>
                                </div>
                            </div>

                            <div class="row mb-4 align-items-center">
                                <label class="col-sm-3 col-form-label fw-semibold text-muted">Mật khẩu:</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control input-readonly" value="********" readonly>
                                </div>
                            </div>
                                
                            <div class="row mb-3 align-items-center">
                                <label class="col-sm-3 col-form-label fw-semibold text-muted">Vai trò:</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-readonly text-primary fw-bold" 
                                           value="${sessionScope.account.role == 1 ? 'Admin' : (sessionScope.account.role == 2 ? 'Sinh viên' : 'Nhà tuyển dụng')}" readonly>
                                </div>
                            </div>

                            <div class="row mb-3 align-items-center">
                                <label class="col-sm-3 col-form-label fw-semibold text-muted">Trạng thái:</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-readonly text-success fw-bold" 
                                           value="${sessionScope.account.status == 1 ? 'Đang hoạt động' : 'Bị khóa'}" readonly>
                                </div>
                            </div>    

                            <div class="d-flex justify-content-end gap-3 border-top pt-4 mt-2">
                                <a href="${pageContext.request.contextPath}/userAccount?action=change_password" class="btn btn-outline-primary fw-semibold px-4 rounded-pill">
                                    <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                </a>
                                <button type="submit" class="btn btn-primary fw-semibold px-5 rounded-pill">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card danger-zone rounded-4">
                    <div class="card-body p-4 d-flex justify-content-between align-items-center rounded-4">
                        <div>
                            <h6 class="fw-bold text-danger mb-1">Vô hiệu hóa tài khoản</h6>
                            <p class="text-danger opacity-75 small mb-0">Hành động này sẽ tạm khóa tài khoản và đăng xuất bạn ngay lập tức.</p>
                        </div>
                        <form action="${pageContext.request.contextPath}/userAccount" method="post" 
                              onsubmit="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản?');">
                            <input type="hidden" name="action" value="delete_account">
                            <button type="submit" class="btn btn-outline-danger fw-semibold px-4">Vô hiệu hóa</button>
                        </form>
                    </div>
                </div>
                
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
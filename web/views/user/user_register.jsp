<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.7">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />

    <div class="container flex-grow-1">
        <div class="card auth-card auth-card-register">
            <div class="card-header text-center py-4">
                <h4 class="text-white mb-0 fw-bold">Tạo tài khoản</h4>
                <p class="text-white-50 small mb-0">Đăng ký để tìm việc làm bán thời gian</p>
            </div>

            <div class="card-body p-4">

                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/userRegister" method="post" novalidate>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">
                            <i class="fas fa-user-tag me-1 text-primary"></i>Bạn là:
                        </label>
                        <div class="d-flex gap-4">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="role" id="roleStudent" value="2" checked>
                                <label class="form-check-label text-dark" for="roleStudent">Sinh viên (Tìm việc)</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="role" id="roleEmployer" value="3">
                                <label class="form-check-label text-dark" for="roleEmployer">Nhà tuyển dụng</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="username" class="form-label fw-semibold">
                            <i class="fas fa-user me-1 text-primary"></i>Tên đăng nhập
                        </label>
                        <input type="text" class="form-control" id="username"
                               name="username" placeholder="Nhập tên đăng nhập"
                               value="${filledUsername}" required autofocus>
                        <div class="form-text">Không dùng khoảng trắng, tối thiểu 4 ký tự.</div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">
                            <i class="fas fa-envelope me-1 text-primary"></i>Email
                        </label>
                        <input type="email" class="form-control" id="email"
                               name="email" placeholder="example@email.com"
                               value="${filledEmail}" required>
                    </div>

                    <div class="mb-1">
                        <label for="password" class="form-label fw-semibold">
                            <i class="fas fa-lock me-1 text-primary"></i>Mật khẩu
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password"
                                   name="password" placeholder="Tối thiểu 6 ký tự"
                                   oninput="checkStrength(this.value)" required>
                            <button class="btn btn-outline-secondary" type="button"
                                    onclick="togglePassword('password', this)" tabindex="-1">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="bg-light rounded" style="height:4px;">
                            <div id="strengthBar" class="password-strength-bar" style="width:0%;"></div>
                        </div>
                        <div id="strengthText" class="form-text"></div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label fw-semibold">
                            <i class="fas fa-lock me-1 text-primary"></i>Xác nhận mật khẩu
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="confirmPassword"
                                   name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                            <button class="btn btn-outline-secondary" type="button"
                                    onclick="togglePassword('confirmPassword', this)" tabindex="-1">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-primary btn-lg fw-semibold">
                            <i class="fas fa-user-plus me-2"></i>Đăng ký
                        </button>
                    </div>

                </form>

                <hr>
                <p class="text-center mb-0">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/userLogin" class="fw-semibold">
                        Đăng nhập
                    </a>
                </p>

            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/auth.js?v=1.0"></script>
</body>
</html>
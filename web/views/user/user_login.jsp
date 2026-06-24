<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.7">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />

    <div class="container flex-grow-1">
        <div class="card auth-card auth-card-login">
            <div class="card-header text-center py-4">
                <div class="logo-box mx-auto mb-2" style="width:48px;height:48px;font-size:1.2rem;">PTJ</div>
                <h4 class="text-white mb-0 fw-bold">Đăng nhập</h4>
                <p class="text-white-50 small mb-0">Chào mừng bạn trở lại!</p>
            </div>

            <div class="card-body p-4">

                <c:if test="${param.registered == '1'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        Đăng ký thành công! Hãy đăng nhập để tiếp tục.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/userLogin" method="post" novalidate>

                    <div class="mb-3">
                        <label for="usernameOrEmail" class="form-label fw-semibold">
                            <i class="fas fa-user me-1 text-primary"></i>Tên đăng nhập/Email
                        </label>
                        <input type="text" class="form-control" id="usernameOrEmail"
                               name="usernameOrEmail" placeholder="Nhập username hoặc email"
                               value="${filledValue}" required autofocus>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">
                            <i class="fas fa-lock me-1 text-primary"></i>Mật khẩu
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password"
                                   name="password" placeholder="Nhập mật khẩu" required>
                            <button class="btn btn-outline-secondary" type="button"
                                    onclick="togglePassword('password', this)" tabindex="-1">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-primary btn-lg fw-semibold">
                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                        </button>
                    </div>

                </form>

                <hr>
                <p class="text-center mb-0">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/userRegister" class="fw-semibold">
                        Đăng ký ngay
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
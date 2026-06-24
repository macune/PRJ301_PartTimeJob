<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Employer Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.7">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />

    <div class="container flex-grow-1 mt-5 text-center">
        <div class="card shadow-sm border-0 p-5 rounded-4 mt-5">
            <h1 class="text-info fw-bold mb-3"><i class="fas fa-building me-2"></i>Xin chào Nhà tuyển dụng</h1>
            <h4 class="text-muted">Chào mừng <span class="text-dark fw-bold">${sessionScope.account.username}</span> quay trở lại hệ thống.</h4>
            <p class="mt-4">Bắt đầu đăng tin tuyển dụng mới và quản lý hồ sơ ứng viên ngay hôm nay.</p>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
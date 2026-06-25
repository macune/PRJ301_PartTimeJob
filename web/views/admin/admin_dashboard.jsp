<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - PartTimeJobs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.8">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/admin/admin_navbar.jsp" />

    <div class="container flex-grow-1 text-center">
        <div class="card shadow-sm border-0 p-5 rounded-4">
            <h1 class="text-primary fw-bold mb-3"><i class="fas fa-user-shield me-2"></i>Xin chào Quản trị viên</h1>
            <h4 class="text-muted">Chào mừng <span class="text-dark fw-bold">${sessionScope.account.username}</span></h4>
            <p class="mt-4">Đây là không gian dành riêng cho Admin để duyệt bài, quản lý tài khoản và thống kê.</p>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="main-header sticky-top">
    <div class="container d-flex align-items-center justify-content-between py-2">
        
        <a class="navbar-brand fw-bold text-primary d-flex align-items-center gap-2" 
           href="<c:choose>
                    <c:when test="${empty sessionScope.account}">${pageContext.request.contextPath}/home</c:when>
                    <c:when test="${sessionScope.account.role == 1}">${pageContext.request.contextPath}/adminDashboard</c:when>
                    <c:when test="${sessionScope.account.role == 2}">${pageContext.request.contextPath}/studentDashboard</c:when>
                    <c:when test="${sessionScope.account.role == 3}">${pageContext.request.contextPath}/employerDashboard</c:when>
                    <c:otherwise>${pageContext.request.contextPath}/home</c:otherwise>
                 </c:choose>">
            <i class="fas fa-briefcase fs-3"></i>
            <span class="fs-4">PartTimeJobs</span>
        </a>

        <nav class="d-flex align-items-center gap-4">
            <a class="nav-link fw-semibold text-dark hover-blue"
               href="<c:choose>
                    <c:when test="${empty sessionScope.account}">${pageContext.request.contextPath}/home</c:when>
                    <c:when test="${sessionScope.account.role == 1}">${pageContext.request.contextPath}/adminDashboard</c:when>
                    <c:when test="${sessionScope.account.role == 2}">${pageContext.request.contextPath}/studentDashboard</c:when>
                    <c:when test="${sessionScope.account.role == 3}">${pageContext.request.contextPath}/employerDashboard</c:when>
                    <c:otherwise>${pageContext.request.contextPath}/home</c:otherwise>
                 </c:choose>">Trang chủ
            </a>
               
            <c:choose>
                <c:when test="${empty sessionScope.account}">
                    <a class="btn btn-outline-primary fw-semibold rounded-pill px-4" href="${pageContext.request.contextPath}/userLogin">Đăng nhập</a>
                    <a class="btn btn-primary fw-semibold rounded-pill px-4" href="${pageContext.request.contextPath}/userRegister">Đăng ký</a>
                </c:when>
                <c:otherwise>
                    <div class="dropdown auth-dropdown">
                        <a class="dropdown-toggle d-flex align-items-center gap-2 text-dark text-decoration-none" href="#" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle fs-2 text-primary"></i>
                            <span class="fw-bold">${sessionScope.account.username}</span>
                        </a>
                        <ul class="dropdown-menu border-0 shadow mt-2">
                            <li>
                                <div class="dropdown-item-text pb-2 border-bottom">
                                    <small class="text-muted d-block mb-1">Đang đăng nhập với vai trò:</small>
                                    <c:choose>
                                        <c:when test="${sessionScope.account.role == 1}">
                                            <strong class="text-primary"><i class="fas fa-user-shield me-1"></i> Quản trị viên</strong>
                                        </c:when>
                                        <c:when test="${sessionScope.account.role == 2}">
                                            <strong class="text-success"><i class="fas fa-user-graduate me-1"></i> Sinh viên</strong>
                                        </c:when>
                                        <c:when test="${sessionScope.account.role == 3}">
                                            <strong class="text-info"><i class="fas fa-building me-1"></i> Nhà tuyển dụng</strong>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </li>
                            <li><a class="dropdown-item py-2 mt-1" href="${pageContext.request.contextPath}/userAccount"><i class="fas fa-user-edit me-2 text-secondary"></i> Thông tin tài khoản</a></li>
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/userAccount?action=change_password"><i class="fas fa-key me-2 text-secondary"></i> Thay đổi mật khẩu</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/userLogout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=8.1">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/admin/admin_navbar.jsp" />

    <div class="container flex-grow-1 mt-2 mb-5">
        <h3 class="fw-bold text-primary mb-4">
            <i class="fas fa-users-cog me-2"></i>Quản lý người dùng
        </h3>

        <div class="card admin-card">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="d-flex gap-2">
                <input type="text" class="form-control" name="search" value="${searchKeyword}" placeholder="Nhập Username hoặc Email để tìm kiếm...">
                <button type="submit" class="btn btn-primary px-4">
                    <i class="fas fa-search me-2"></i>Tìm kiếm
                </button>
                <c:if test="${not empty searchKeyword}">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">Xóa lọc</a>
                </c:if>
            </form>
        </div>

        <div class="card admin-card p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover mb-0 custom-admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty userList}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">Không tìm thấy tài khoản nào.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="u" items="${userList}">
                                    <tr>
                                        <td class="fw-bold">#${u.accountId}</td>
                                        <td>${u.username}</td>
                                        <td>${u.email}</td>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role == 1}"><span class="badge badge-role-admin">Admin</span></c:when>
                                                <c:when test="${u.role == 2}"><span class="badge badge-role-student">Sinh viên</span></c:when>
                                                <c:when test="${u.role == 3}"><span class="badge badge-role-employer">Nhà tuyển dụng</span></c:when>
                                                <c:otherwise><span class="badge badge-role-unknown">Unknown</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.isDeleted == 1}">
                                                    <span class="badge badge-status-deleted">Đã xóa</span>
                                                </c:when>
                                                <c:when test="${u.status == 1}">
                                                    <span class="badge badge-status-active">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-status-locked">Đã khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <td>${u.createdAt}</td>
                                        
                                        <td class="text-center">
                                            <%-- Chỉ hiện nút nếu KHÔNG phải admin VÀ tài khoản CHƯA bị xóa --%>
                                            <c:if test="${u.role != 1 && u.isDeleted == 0}">
                                                <form action="${pageContext.request.contextPath}/admin/users" method="post" class="form-inline-action">
                                                    <input type="hidden" name="accountId" value="${u.accountId}">
                                                    <input type="hidden" name="searchKeyword" value="${searchKeyword}">
                                                    
                                                    <c:choose>
                                                        <c:when test="${u.status == 1}">
                                                            <input type="hidden" name="newStatus" value="0">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Khóa tài khoản">
                                                                <i class="fas fa-lock"></i> Khóa
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="hidden" name="newStatus" value="1">
                                                            <button type="submit" class="btn btn-sm btn-outline-success" title="Mở khóa tài khoản">
                                                                <i class="fas fa-unlock"></i> Mở
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
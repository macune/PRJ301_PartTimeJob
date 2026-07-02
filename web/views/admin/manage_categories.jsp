<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=8.1">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <jsp:include page="/views/common/header.jsp" />
    <jsp:include page="/views/admin/admin_navbar.jsp" />

    <div class="container flex-grow-1 mt-3 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-primary mb-0">
                <i class="fas fa-tags me-2"></i>Quản lý Danh mục (Ngành nghề)
            </h3>
            
            <button class="btn btn-primary fw-semibold rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                <i class="fas fa-plus me-2"></i>Thêm danh mục mới
            </button>
        </div>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="card admin-card p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover mb-0 custom-admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên danh mục</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty categoryList}">
                                <tr>
                                    <td colspan=\"4\" class="text-center py-4 text-muted">Chưa có danh mục nào.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${categoryList}">
                                    <tr>
                                        <td class="fw-bold">#${c.categoryId}</td>
                                        <td class="fw-semibold text-dark">${c.categoryName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 1}">
                                                    <span class="badge badge-status-active">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-status-deleted">Đã ẩn (Khóa)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            
                                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editModal${c.categoryId}" title="Sửa tên danh mục">
                                                <i class="fas fa-edit"></i> Sửa
                                            </button>
                                            
                                            <form action="${pageContext.request.contextPath}/admin/categories" method="post" class="form-inline-action ms-1">
                                                <input type="hidden" name="action" value="toggle_status">
                                                <input type="hidden" name="categoryId" value="${c.categoryId}">
                                                <c:choose>
                                                    <c:when test="${c.status == 1}">
                                                        <input type="hidden" name="newStatus" value="0">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger text-nowrap" title="Ẩn danh mục này">
                                                            <i class="fas fa-eye-slash"></i> Ẩn
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="newStatus" value="1">
                                                        <button type="submit" class="btn btn-sm btn-outline-success text-nowrap" title="Mở khóa danh mục">
                                                            <i class="fas fa-eye"></i> Hiện
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>

                                        </td>
                                    </tr>

                                    <div class="modal fade" id="editModal${c.categoryId}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 border-0 shadow">
                                                <div class="modal-header border-bottom-0 pb-0">
                                                    <h5 class="modal-title fw-bold text-primary">Sửa danh mục</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                                                    <div class="modal-body pt-3">
                                                        <input type="hidden" name="action" value="edit">
                                                        <input type="hidden" name="categoryId" value="${c.categoryId}">
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold text-muted small">Tên danh mục</label>
                                                            <input type="text" class="form-control" name="categoryName" value="${c.categoryName}" required>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-top-0 pt-0">
                                                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary rounded-pill px-4">Lưu thay đổi</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold text-primary">Thêm danh mục mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                    <div class="modal-body pt-3">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted small">Tên danh mục <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="categoryName" placeholder="VD: F&B, Gia sư, IT..." required>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Thêm mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="/views/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
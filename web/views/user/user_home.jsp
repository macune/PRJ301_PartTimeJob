<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Chu - Part Time Job</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.5">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light"> 
        <jsp:include page="/views/common/header.jsp" />
        
        <div class="container mt-5 flex-grow-1">
            
            <div class="filter-wrapper">
                <form action="${pageContext.request.contextPath}/home" method="GET" class="row filter-form">
                    
                    <div class="col-md-2">
                        <label class="filter-label">Ngành nghề</label>
                        <select name="categoryId" class="form-select filter-input">
                            <option value="">Tất cả ngành nghề</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="filter-label">Tỉnh / Thành</label>
                        <select name="city" id="city" class="form-select filter-input" data-selected="${param.city}">
                            <option value="">Chọn Tỉnh/Thành</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="filter-label">Xã / Phường</label>
                        <select name="ward" id="ward" class="form-select filter-input" data-selected="${param.ward}">
                            <option value="">Chọn Xã/Phường</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="filter-label">Từ giờ (Bắt đầu)</label>
                        <input type="time" name="startTime" class="form-control filter-input" value="${param.startTime}">
                    </div>

                    <div class="col-md-2">
                        <label class="filter-label">Đến giờ (Kết thúc)</label>
                        <input type="time" name="endTime" class="form-control filter-input" value="${param.endTime}">
                    </div>

                    <div class="col-md-2">
                        <button type="submit" class="filter-btn">
                            <i class="fas fa-filter"></i> Lọc Việc Làm
                        </button>
                    </div>
                    
                </form>
            </div>


            <div class="job-list-wrapper">
                <h2 class="section-title">Việc Làm Bán Thời Gian Mới Nhất</h2>
                
                <div class="row">
                    <c:forEach items="${listJobs}" var="item">
                        <div class="col-md-4 mb-4">
                            <div class="card job-card">
                                <div class="card-body">
                                    <h5 class="card-title job-title">${item.job.title}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">
                                        <i class="fas fa-store"></i> ${item.employer.businessName}
                                    </h6>
                                    <p class="card-text mb-1">
                                        <i class="fas fa-money-bill-wave text-success"></i> 
                                        <strong><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/> VNĐ/ca</strong>
                                    </p>
                                    <p class="card-text mb-1">
                                        <i class="fas fa-clock text-warning"></i> ${item.job.startTime} - ${item.job.endTime}
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-map-marker-alt text-danger"></i> ${item.job.ward}, ${item.job.city}
                                    </p>
                                </div>
                                <div class="card-footer job-card-footer">
                                    <a href="${pageContext.request.contextPath}/job-detail?id=${item.job.jobId}" class="btn btn-outline-primary w-100">Xem Chi Tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center mt-4">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/home?page=${i}&categoryId=${param.categoryId}&city=${param.city}&ward=${param.ward}&startTime=${param.startTime}&endTime=${param.endTime}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </c:if>
            </div> 

        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/location-filter.js?v=2.1"></script>
        <jsp:include page="/views/common/footer.jsp" />
    </body>
</html>
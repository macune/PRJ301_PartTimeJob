<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Chu - Part Time Job</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/style.css?v=1.2">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light"> 
        <jsp:include page="/views/common/header.jsp" />
        
        <div class="container mt-5 flex-grow-1">
            <h2 class="mb-4 text-primary text-center">Việc Làm Bán Thời Gian Mới Nhất</h2>
            
            <div class="row">
                <c:forEach items="${listJobs}" var="item">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title text-success">${item.job.title}</h5>
                                <h6 class="card-subtitle mb-2 text-muted"><i class="fas fa-store"></i> ${item.employer.businessName}</h6>
                                <p class="card-text mb-1">
                                    <i class="fas fa-money-bill-wave text-warning"></i> 
                                    <strong><fmt:formatNumber value="${item.job.salary}" pattern="#,###"/> VNĐ/ca</strong>
                                </p>
                                <p class="card-text mb-1"><i class="fas fa-clock"></i> ${item.job.startTime} - ${item.job.endTime}</p>
                                <p class="card-text"><i class="fas fa-map-marker-alt text-danger"></i> ${item.job.ward}, ${item.job.city}</p>
                            </div>
                            <div class="card-footer bg-white border-top-0">
                                <a href="job-detail?id=${item.job.jobId}" class="btn btn-outline-primary w-100">Xem Chi Tiết</a>
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
                                <a class="page-link" href="home?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </c:if>
        </div>

        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/views/common/footer.jsp" />
    </body>
</html>
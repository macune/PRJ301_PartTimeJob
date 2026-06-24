<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${jobDetail.job.title} - Part Time Job</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light">
        <jsp:include page="/views/common/header.jsp" />

        <div class="container mt-5 flex-grow-1">
            <div class="row">
                <div class="col-md-8">
                    <div class="card shadow-sm mb-4">
                        <div class="card-body">
                            <h2 class="text-primary">${jobDetail.job.title}</h2>
                            <p class="badge bg-info text-dark fs-6">${jobDetail.category.categoryName}</p>
                            <hr>
                            <h5 class="mt-3">Mô Tả Công Việc:</h5>
                            <p>${jobDetail.job.description}</p>
                            
                            <h5 class="mt-4">Thông Tin Chi Tiết:</h5>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item"><i class="fas fa-money-bill-wave text-success"></i> <strong> Mức lương:</strong> <fmt:formatNumber value="${jobDetail.job.salary}" pattern="#,###"/> VNĐ</li>
                                <li class="list-group-item"><i class="fas fa-clock text-warning"></i> <strong> Thời gian làm việc:</strong> ${jobDetail.job.startTime} đến ${jobDetail.job.endTime}</li>
                                <li class="list-group-item"><i class="fas fa-map-marked-alt text-danger"></i> <strong> Địa điểm:</strong> ${jobDetail.job.detailAddress}, ${jobDetail.job.ward}, ${jobDetail.job.city}</li>
                                <li class="list-group-item"><i class="fas fa-calendar-alt text-secondary"></i> <strong> Ngày đăng:</strong> <fmt:formatDate value="${jobDetail.job.createdAt}" pattern="dd/MM/yyyy"/></li>
                            </ul>
                            
                            <div class="mt-4 text-center">
                                <a href="${pageContext.request.contextPath}/apply-job?id=${jobDetail.job.jobId}" class="btn btn-success btn-lg px-5">Ứng Tuyển Ngay</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Thông Tin Cửa Hàng</h5>
                        </div>
                        <div class="card-body text-center">
                            <h4 class="card-title mt-2">${jobDetail.employer.businessName}</h4>
                            <p class="text-warning mb-1">
                                <i class="fas fa-star"></i> ${jobDetail.employer.averageRating}/5
                            </p>
                            <hr>
                            <p class="text-start mb-2"><i class="fas fa-phone-alt"></i> <strong> Liên hệ:</strong> ${jobDetail.employer.phone}</p>
                            <p class="text-start mb-2"><i class="fas fa-envelope"></i> <strong> Email:</strong> ${jobDetail.employer.contactEmail}</p>
                            <p class="text-start"><i class="fas fa-info-circle"></i> <strong> Giới thiệu:</strong> ${jobDetail.employer.description}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/views/common/footer.jsp" />
    </body>
</html>
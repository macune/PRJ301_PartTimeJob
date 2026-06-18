<%-- 
    Document   : index
    Created on : Jun 15, 2026, 9:00:02 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Chu - Part Time Job</title>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/style.css?v=1.2">
    </head>
    <body class="d-flex flex-column min-vh-100"> 
        <jsp:include page="/views/common/header.jsp" />
        
        <div class="container mt-5 text-center flex-grow-1">
            <h1 class="display-4 text-primary">Chao mung den voi he thong tim viec</h1>
            <p class="lead">Du an mon hoc PRJ301 - Chuan form framework</p>
            <button class="btn btn-success btn-lg shadow">Tim Kiem Viec Lam Ngay</button>
        </div>

        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/views/common/footer.jsp" />
    </body>
</html>

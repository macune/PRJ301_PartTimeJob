<%--
    Document   : application_history
    Created on : Jul 07, 2026
    Author     : PRJ301
    Access     : GET /student/application-history  (ApplicationHistoryController.java)
    Role       : Student (role = 2)
    Mô tả      : Xem danh sách việc đã nộp, trạng thái (Chờ/Nhận/Từ chối), lời nhắn NTD
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Account, models.Application, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    Account account = (Account) session.getAttribute("account");
    List<Application> applicationList =
        (List<Application>) request.getAttribute("applicationList");
    long countPending  = (Long) request.getAttribute("countPending");
    long countAccepted = (Long) request.getAttribute("countAccepted");
    long countRejected = (Long) request.getAttribute("countRejected");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử ứng tuyển - PartTimeJobs</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1.2">
        <style>
            .sidebar {
                min-height: calc(100vh - 130px);
                background: #1e293b;
                width: 240px;
                flex-shrink: 0;
            }
            .sidebar .nav-link {
                color: #cbd5e1; padding: 10px 20px; border-radius: 8px;
                margin: 2px 8px; font-size: 0.9rem; transition: all .2s;
            }
            .sidebar .nav-link:hover,
            .sidebar .nav-link.active { background: rgba(255,255,255,.1); color: #fff; }
            .sidebar .nav-link i { width: 20px; }
            .sidebar-title {
                color: #64748b; font-size: 0.72rem; font-weight: 700;
                text-transform: uppercase; letter-spacing: 1px; padding: 16px 20px 4px;
            }
            .stat-card { border: none; border-radius: 14px; }
            .app-card {
                border: none; border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,.07);
                transition: transform .15s;
            }
            .app-card:hover { transform: translateY(-2px); }
            .status-bar {
                width: 5px; border-radius: 4px 0 0 4px; flex-shrink: 0;
            }
            .note-box {
                background: #f8f9fa; border-left: 3px solid #2e7d32;
                border-radius: 0 8px 8px 0; padding: 10px 14px;
                font-size: .88rem;
            }
            .filter-btn.active { background: #2e7d32 !important; color: #fff !important; }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">

        <jsp:include page="/views/common/header.jsp" />
        <jsp:include page="/views/common/navbar.jsp" />

        <div class="d-flex flex-grow-1">

            <%-- ===== SIDEBAR ===== --%>
            <aside class="sidebar py-3">
                <div class="text-center py-3 px-3 border-bottom border-secondary mb-2">
                    <div class="logo-box mx-auto mb-2" style="background:#2e7d32;">PTJ</div>
                    <div class="text-white fw-semibold small"><%= account.getUsername() %></div>
                    <span class="badge bg-success mt-1">Sinh viên</span>
                </div>
                <div class="sidebar-title">Việc làm</div>
                <ul class="nav flex-column">
                    <li><a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard</a></li>
                    <li><a class="nav-link" href="#">
                        <i class="fas fa-search me-2"></i>Tìm việc làm</a></li>
                    <li><a class="nav-link active"
                           href="${pageContext.request.contextPath}/student/application-history">
                        <i class="fas fa-history me-2"></i>Lịch sử ứng tuyển</a></li>
                    <li><a class="nav-link" href="#">
                        <i class="fas fa-bookmark me-2"></i>Việc đã lưu</a></li>
                </ul>
                <div class="sidebar-title mt-3">Hồ sơ</div>
                <ul class="nav flex-column">
                    <li><a class="nav-link" href="${pageContext.request.contextPath}/student/profile">
                        <i class="fas fa-id-card me-2"></i>Hồ sơ cá nhân</a></li>
                    <li><a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                </ul>
            </aside>

            <%-- ===== MAIN CONTENT ===== --%>
            <main class="flex-grow-1 bg-light p-4">

                <%-- Tiêu đề --%>
                <div class="mb-4">
                    <h4 class="fw-bold mb-0">
                        <i class="fas fa-history me-2 text-success"></i>Lịch sử ứng tuyển
                    </h4>
                    <p class="text-muted small mb-0">
                        Tổng cộng <strong><%= applicationList != null ? applicationList.size() : 0 %></strong> đơn đã nộp
                    </p>
                </div>

                <%-- ===== THỐNG KÊ ===== --%>
                <div class="row g-3 mb-4">
                    <div class="col-sm-4">
                        <div class="card stat-card p-3" style="border-left: 4px solid #f59e0b;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Đang chờ</div>
                                    <div class="fs-3 fw-bold text-warning"><%= countPending %></div>
                                </div>
                                <i class="fas fa-hourglass-half fa-2x text-warning opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="card stat-card p-3" style="border-left: 4px solid #16a34a;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Được chấp nhận</div>
                                    <div class="fs-3 fw-bold text-success"><%= countAccepted %></div>
                                </div>
                                <i class="fas fa-check-circle fa-2x text-success opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="card stat-card p-3" style="border-left: 4px solid #dc2626;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Bị từ chối</div>
                                    <div class="fs-3 fw-bold text-danger"><%= countRejected %></div>
                                </div>
                                <i class="fas fa-times-circle fa-2x text-danger opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ===== FILTER ===== --%>
                <div class="d-flex gap-2 mb-3 flex-wrap">
                    <button class="btn btn-sm btn-outline-secondary filter-btn active"
                            onclick="filterCards('all', this)">
                        Tất cả (<%= applicationList != null ? applicationList.size() : 0 %>)
                    </button>
                    <button class="btn btn-sm btn-outline-warning filter-btn"
                            onclick="filterCards('0', this)">
                        <i class="fas fa-hourglass-half me-1"></i>Đang chờ (<%= countPending %>)
                    </button>
                    <button class="btn btn-sm btn-outline-success filter-btn"
                            onclick="filterCards('1', this)">
                        <i class="fas fa-check me-1"></i>Chấp nhận (<%= countAccepted %>)
                    </button>
                    <button class="btn btn-sm btn-outline-danger filter-btn"
                            onclick="filterCards('2', this)">
                        <i class="fas fa-times me-1"></i>Từ chối (<%= countRejected %>)
                    </button>
                </div>

                <%-- ===== DANH SÁCH ĐƠN ===== --%>
                <% if (applicationList == null || applicationList.isEmpty()) { %>
                <div class="card border-0 shadow-sm text-center py-5">
                    <i class="fas fa-inbox fa-4x text-muted mb-3 opacity-25"></i>
                    <h5 class="text-muted">Bạn chưa nộp đơn ứng tuyển nào</h5>
                    <p class="text-muted small">Hãy tìm kiếm và ứng tuyển vào các việc làm phù hợp!</p>
                    <div>
                        <a href="#" class="btn btn-success btn-sm">
                            <i class="fas fa-search me-1"></i>Tìm việc ngay
                        </a>
                    </div>
                </div>
                <% } else {
                    for (Application app : applicationList) {
                        String barColor;
                        switch (app.getStatus()) {
                            case 1:  barColor = "#16a34a"; break;
                            case 2:  barColor = "#dc2626"; break;
                            default: barColor = "#f59e0b";
                        }
                %>
                <div class="card app-card mb-3 overflow-hidden" data-status="<%= app.getStatus() %>">
                    <div class="d-flex">
                        <%-- Thanh màu trạng thái bên trái --%>
                        <div class="status-bar" style="background:<%= barColor %>;"></div>

                        <div class="flex-grow-1 p-3">
                            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">

                                <%-- Thông tin Job --%>
                                <div>
                                    <h6 class="fw-bold mb-1">
                                        <i class="fas fa-briefcase me-1 text-success"></i>
                                        <%= app.getJobTitle() != null ? app.getJobTitle() : "Job #" + app.getJobID() %>
                                    </h6>
                                    <div class="d-flex flex-wrap gap-3 text-muted small">
                                        <span>
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            <%= app.getJobCity() != null ? app.getJobCity() : "--" %>
                                        </span>
                                        <span>
                                            <i class="fas fa-money-bill-wave me-1"></i>
                                            <%= app.getJobSalary() > 0
                                                ? String.format("%,d", app.getJobSalary()) + " đ/giờ"
                                                : "--" %>
                                        </span>
                                        <span>
                                            <i class="fas fa-clock me-1"></i>
                                            <%= app.getJobStartTime() != null ? app.getJobStartTime() : "--" %>
                                            –
                                            <%= app.getJobEndTime()   != null ? app.getJobEndTime()   : "--" %>
                                        </span>
                                    </div>
                                </div>

                                <%-- Badge trạng thái --%>
                                <span class="badge <%= app.getStatusBadgeClass() %> px-3 py-2">
                                    <i class="<%= app.getStatusIcon() %> me-1"></i>
                                    <%= app.getStatusLabel() %>
                                </span>
                            </div>

                            <%-- Thông tin đơn ứng tuyển --%>
                            <div class="row g-2 mt-2">
                                <div class="col-sm-6">
                                    <div class="text-muted small">
                                        <i class="fas fa-money-bill me-1"></i>
                                        <strong>Lương mong muốn:</strong>
                                        <%= app.getDesiredSalary() > 0
                                            ? String.format("%,d", app.getDesiredSalary()) + " đ/giờ"
                                            : "Không đề xuất" %>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="text-muted small">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        <strong>Ngày nộp:</strong>
                                        <%= app.getAppliedAt() != null
                                            ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm")
                                                .format(app.getAppliedAt())
                                            : "--" %>
                                    </div>
                                </div>
                            </div>

                            <%-- Lời nhắn của sinh viên (có thể collapse) --%>
                            <% if (app.getMessage() != null && !app.getMessage().trim().isEmpty()) { %>
                            <div class="mt-2">
                                <div class="text-muted small fw-semibold mb-1">
                                    <i class="fas fa-comment me-1"></i>Lời nhắn của bạn:
                                </div>
                                <div class="note-box" style="border-color: #64748b;">
                                    <%= app.getMessage() %>
                                </div>
                            </div>
                            <% } %>

                            <%-- Lời nhắn từ Nhà tuyển dụng (nếu có) --%>
                            <% if (app.getEmployerNote() != null && !app.getEmployerNote().trim().isEmpty()) { %>
                            <div class="mt-2">
                                <div class="text-muted small fw-semibold mb-1">
                                    <i class="fas fa-building me-1 text-success"></i>
                                    Phản hồi từ nhà tuyển dụng:
                                </div>
                                <div class="note-box">
                                    <%= app.getEmployerNote() %>
                                </div>
                            </div>
                            <% } else if (app.getStatus() == 0) { %>
                            <div class="mt-2 text-muted small fst-italic">
                                <i class="fas fa-clock me-1"></i>
                                Đang chờ nhà tuyển dụng xem xét...
                            </div>
                            <% } %>

                        </div><%-- /flex-grow-1 --%>
                    </div><%-- /d-flex --%>
                </div><%-- /app-card --%>
                <%  } // end for
                  } // end else
                %>

            </main>
        </div>

        <jsp:include page="/views/common/footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <script>
            function filterCards(status, btn) {
                // Cập nhật nút active
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                // Lọc card
                document.querySelectorAll('.app-card').forEach(card => {
                    if (status === 'all' || card.dataset.status === status) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }
        </script>
    </body>
</html>

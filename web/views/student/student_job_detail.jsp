<%--
    Document   : student_job_detail
    Created on : Jul 05, 2026
    Author     : PRJ301
    Access     : GET /student/job-detail?id={jobID}
    Mô tả      : Trang chi tiết việc làm - có Modal ứng tuyển và nút Lưu bài
    Phụ thuộc  : T11 - cần JobDAO để lấy thông tin Job theo ID
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Account, models.Application, models.SavedJob" %>
<%@ page import="dal.ApplicationDAO, dal.SavedJobDAO" %>
<%
    /* -------------------------------------------------------
     * Trang này cần được gọi từ JobDetailController (T11)
     * Controller sẽ set request attribute "job" là object Job.
     * Ở đây mock bằng request parameter để có thể test độc lập.
     * ------------------------------------------------------- */
    Account account = (Account) session.getAttribute("account");

    // Lấy jobID từ URL param (do JobDetailController set hoặc link trực tiếp)
    String jobIDParam = request.getParameter("id");
    int jobID = 0;
    if (jobIDParam != null) {
        try { jobID = Integer.parseInt(jobIDParam); } catch (NumberFormatException ignored) {}
    }

    // Kiểm tra trạng thái ứng tuyển và lưu (nếu đã đăng nhập là Student)
    boolean hasApplied = false;
    boolean isSaved    = false;
    if (account != null && account.getRole() == 2 && jobID > 0) {
        ApplicationDAO appDao = new ApplicationDAO();
        SavedJobDAO    svDao  = new SavedJobDAO();
        hasApplied = appDao.hasApplied(account.getAccountID(), jobID);
        isSaved    = svDao.isSaved(account.getAccountID(), jobID);
    }

    // Thông báo kết quả từ redirect
    String result = request.getParameter("result"); // success | already | error
    String saved  = request.getParameter("saved");  // 1 | 0
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết việc làm - PartTimeJobs</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1.2">
        <style>
            .job-header-card {
                background: linear-gradient(135deg, #1e293b 0%, #2e7d32 100%);
                border-radius: 16px;
                color: white;
            }
            .info-chip {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: rgba(255,255,255,0.15);
                border-radius: 20px;
                padding: 4px 12px;
                font-size: 0.85rem;
            }
            .section-card {
                border: none;
                border-radius: 14px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            }
            .badge-status-0 { background: #f59e0b; }
            .badge-status-1 { background: #16a34a; }
            .badge-status-2 { background: #dc2626; }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100 bg-light">

        <jsp:include page="/views/common/header.jsp" />
        <jsp:include page="/views/common/navbar.jsp" />

        <div class="container py-4 flex-grow-1">

            <%-- ===== THÔNG BÁO KẾT QUẢ ===== --%>
            <% if ("success".equals(result)) { %>
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Ứng tuyển thành công!</strong> Đơn của bạn đang ở trạng thái <strong>Đang chờ</strong>. Nhà tuyển dụng sẽ liên hệ sớm.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } else if ("already".equals(result)) { %>
            <div class="alert alert-warning alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Bạn đã ứng tuyển vào việc làm này rồi. Hãy chờ phản hồi từ nhà tuyển dụng.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } else if ("error".equals(result)) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-times-circle me-2"></i>
                Ứng tuyển thất bại. Vui lòng thử lại sau.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if ("1".equals(saved)) { %>
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-bookmark me-2"></i> Đã lưu việc làm vào danh sách yêu thích.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } else if ("0".equals(saved)) { %>
            <div class="alert alert-secondary alert-dismissible fade show">
                <i class="fas fa-bookmark me-2"></i> Đã bỏ lưu việc làm này.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <%-- ===== HEADER CARD (Job info từ T11 JobDetailController) ===== --%>
            <%-- Controller T11 set request.setAttribute("job", jobObject)     --%>
            <%
                // Lấy Job object do T11 JobDetailController set vào request
                Object jobObj = request.getAttribute("job");
                // Nếu chưa có T11, hiển thị placeholder để không báo lỗi
            %>

            <div class="job-header-card p-4 mb-4">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                    <div>
                        <h3 class="fw-bold mb-2">
                            <% if (jobObj != null) { %>
                                ${job.title}
                            <% } else { %>
                                [Tên công việc - do JobDetailController cung cấp]
                            <% } %>
                        </h3>
                        <div class="d-flex flex-wrap gap-2 mb-3">
                            <span class="info-chip">
                                <i class="fas fa-map-marker-alt"></i>
                                <% if (jobObj != null) { %>${job.city} - ${job.ward}<% } else { %>Hà Nội<% } %>
                            </span>
                            <span class="info-chip">
                                <i class="fas fa-clock"></i>
                                <% if (jobObj != null) { %>${job.startTime} – ${job.endTime}<% } else { %>08:00 – 17:00<% } %>
                            </span>
                            <span class="info-chip">
                                <i class="fas fa-money-bill-wave"></i>
                                <% if (jobObj != null) { %>${job.salary} đ/giờ<% } else { %>-- đ/giờ<% } %>
                            </span>
                        </div>
                    </div>

                    <%-- Nút hành động: chỉ hiện khi đã đăng nhập là Student --%>
                    <% if (account != null && account.getRole() == 2) { %>
                    <div class="d-flex gap-2 flex-wrap">

                        <%-- Nút Lưu / Bỏ lưu --%>
                        <form action="${pageContext.request.contextPath}/student/save-job" method="post">
                            <input type="hidden" name="jobID" value="<%= jobID %>">
                            <% if (isSaved) { %>
                                <input type="hidden" name="action" value="unsave">
                                <button type="submit" class="btn btn-warning fw-semibold">
                                    <i class="fas fa-bookmark me-2"></i>Đã lưu
                                </button>
                            <% } else { %>
                                <input type="hidden" name="action" value="save">
                                <button type="submit" class="btn btn-outline-light fw-semibold">
                                    <i class="far fa-bookmark me-2"></i>Lưu bài
                                </button>
                            <% } %>
                        </form>

                        <%-- Nút Ứng tuyển -> mở Modal --%>
                        <% if (hasApplied) { %>
                            <button class="btn btn-secondary fw-semibold" disabled>
                                <i class="fas fa-check me-2"></i>Đã ứng tuyển
                            </button>
                        <% } else { %>
                            <button class="btn btn-success fw-semibold"
                                    data-bs-toggle="modal" data-bs-target="#applyModal">
                                <i class="fas fa-paper-plane me-2"></i>Ứng tuyển ngay
                            </button>
                        <% } %>
                    </div>
                    <% } else if (account == null) { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-success fw-semibold">
                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập để ứng tuyển
                    </a>
                    <% } %>
                </div>
            </div>

            <%-- ===== NỘI DUNG CHI TIẾT ===== --%>
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card section-card p-4 mb-4">
                        <h5 class="fw-bold mb-3">
                            <i class="fas fa-file-alt me-2 text-success"></i>Mô tả công việc
                        </h5>
                        <div class="text-secondary">
                            <% if (jobObj != null) { %>
                                ${job.description}
                            <% } else { %>
                                <p>[Mô tả chi tiết công việc - do JobDetailController (T11) cung cấp]</p>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card section-card p-4">
                        <h5 class="fw-bold mb-3">
                            <i class="fas fa-info-circle me-2 text-success"></i>Thông tin tuyển dụng
                        </h5>
                        <ul class="list-unstyled mb-0">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Địa điểm</span>
                                <span class="fw-semibold text-end">
                                    <% if (jobObj != null) { %>${job.detailAddress}<% } else { %>--<% } %>
                                </span>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Mức lương</span>
                                <span class="fw-semibold text-success">
                                    <% if (jobObj != null) { %>${job.salary} đ/giờ<% } else { %>--<% } %>
                                </span>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Ca làm</span>
                                <span class="fw-semibold">
                                    <% if (jobObj != null) { %>${job.startTime} – ${job.endTime}<% } else { %>--<% } %>
                                </span>
                            </li>
                            <li class="d-flex justify-content-between py-2">
                                <span class="text-muted">Thành phố</span>
                                <span class="fw-semibold">
                                    <% if (jobObj != null) { %>${job.city}<% } else { %>--<% } %>
                                </span>
                            </li>
                        </ul>

                        <% if (account != null && account.getRole() == 2 && !hasApplied) { %>
                        <div class="d-grid mt-4">
                            <button class="btn btn-success fw-semibold"
                                    data-bs-toggle="modal" data-bs-target="#applyModal">
                                <i class="fas fa-paper-plane me-2"></i>Ứng tuyển ngay
                            </button>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

        </div><%-- /container --%>

        <%-- ===== MODAL ỨNG TUYỂN ===== --%>
        <div class="modal fade" id="applyModal" tabindex="-1"
             aria-labelledby="applyModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title fw-bold" id="applyModalLabel">
                            <i class="fas fa-paper-plane me-2"></i>Nộp đơn ứng tuyển
                        </h5>
                        <button type="button" class="btn-close btn-close-white"
                                data-bs-dismiss="modal"></button>
                    </div>

                    <%-- Form POST -> /student/apply --%>
                    <form action="${pageContext.request.contextPath}/student/apply" method="post">

                        <%-- Hidden: jobID --%>
                        <input type="hidden" name="jobID" value="<%= jobID %>">

                        <div class="modal-body">

                            <%-- Thông tin việc làm tóm tắt --%>
                            <div class="alert alert-light border mb-3 p-2">
                                <div class="small text-muted">Bạn đang ứng tuyển vào:</div>
                                <div class="fw-semibold">
                                    <% if (jobObj != null) { %>${job.title}<% } else { %>ID: <%= jobID %><% } %>
                                </div>
                            </div>

                            <%-- Mức lương mong muốn --%>
                            <div class="mb-3">
                                <label for="desiredSalary" class="form-label fw-semibold">
                                    <i class="fas fa-money-bill-wave me-1 text-success"></i>
                                    Mức lương mong muốn (đ/giờ)
                                </label>
                                <input type="number" class="form-control"
                                       id="desiredSalary" name="desiredSalary"
                                       placeholder="VD: 30000"
                                       min="1" step="1000">
                                <div class="form-text">
                                    Mức đăng: <strong>
                                        <% if (jobObj != null) { %>${job.salary}<% } else { %>--<% } %>
                                    </strong> đ/giờ. Để trống nếu chấp nhận mức hiện tại.
                                </div>
                            </div>

                            <%-- Lời nhắn --%>
                            <div class="mb-3">
                                <label for="message" class="form-label fw-semibold">
                                    <i class="fas fa-comment-alt me-1 text-success"></i>
                                    Lời nhắn gửi nhà tuyển dụng
                                </label>
                                <textarea class="form-control" id="message" name="message"
                                          rows="4"
                                          placeholder="Giới thiệu ngắn về bản thân, lý do muốn ứng tuyển, kinh nghiệm liên quan..."></textarea>
                                <div class="form-text">Tối đa 500 ký tự.</div>
                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary"
                                    data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Huỷ
                            </button>
                            <button type="submit" class="btn btn-success fw-semibold">
                                <i class="fas fa-paper-plane me-2"></i>Nộp đơn
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
        <%-- ===== /MODAL ===== --%>

        <jsp:include page="/views/common/footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <script>
            // Giới hạn ký tự textarea message
            document.getElementById('message').addEventListener('input', function () {
                if (this.value.length > 500) {
                    this.value = this.value.substring(0, 500);
                }
            });
        </script>
    </body>
</html>

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers.student;

import dal.ApplicationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Account;
import models.Application;

/**
 * Lịch sử ứng tuyển của Student (T14)
 *
 * GET /student/application-history
 *   -> Gọi ApplicationDAO.getApplicationsByStudentId() JOIN Job_Post
 *   -> Set list vào request attribute "applicationList"
 *   -> Forward đến application_history.jsp
 *
 * Hiển thị: Tên job, Thành phố, Mức lương, Ca làm, Trạng thái, Lời nhắn từ NTD
 *
 * @author PRJ301
 */
@WebServlet(name = "ApplicationHistoryController",
            urlPatterns = {"/student/application-history"})
public class ApplicationHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account account = (Account) session.getAttribute("account");

        // Chỉ Student (role = 2) mới được vào
        if (account.getRole() != 2) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Lấy danh sách đơn ứng tuyển có JOIN thông tin Job
        ApplicationDAO dao = new ApplicationDAO();
        List<Application> applicationList =
                dao.getApplicationsByStudentId(account.getAccountID());

        // Đếm theo từng trạng thái để hiển thị thống kê
        long countPending  = applicationList.stream().filter(a -> a.getStatus() == 0).count();
        long countAccepted = applicationList.stream().filter(a -> a.getStatus() == 1).count();
        long countRejected = applicationList.stream().filter(a -> a.getStatus() == 2).count();

        request.setAttribute("applicationList", applicationList);
        request.setAttribute("countPending",    countPending);
        request.setAttribute("countAccepted",   countAccepted);
        request.setAttribute("countRejected",   countRejected);

        request.getRequestDispatcher("/views/student/application_history.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

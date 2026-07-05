/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers.student;

import dal.ApplicationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Account;

/**
 * Xử lý Ứng tuyển việc làm (Student)
 *
 * POST /student/apply
 *   - Nhận jobID, desiredSalary, message từ modal form trên student_job_detail.jsp
 *   - Kiểm tra đã ứng tuyển chưa
 *   - Insert vào bảng Application với Status = 0 (Pending)
 *   - Redirect lại trang chi tiết việc làm kèm ?result=success/already/error
 *
 * @author PRJ301
 */
@WebServlet(name = "StudentApplyJobController", urlPatterns = {"/student/apply"})
public class StudentApplyJobController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập và role Student
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRole() != 2) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Lấy tham số từ form
        String jobIDStr        = request.getParameter("jobID");
        String desiredSalaryStr = request.getParameter("desiredSalary");
        String message         = request.getParameter("message");

        // Validate
        if (jobIDStr == null || jobIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        int jobID = 0;
        int desiredSalary = 0;
        try {
            jobID = Integer.parseInt(jobIDStr.trim());
            if (desiredSalaryStr != null && !desiredSalaryStr.trim().isEmpty()) {
                desiredSalary = Integer.parseInt(desiredSalaryStr.trim());
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/student/job-detail?id=" + jobIDStr + "&result=error");
            return;
        }

        int studentID = account.getAccountID();
        ApplicationDAO dao = new ApplicationDAO();

        // Kiểm tra đã ứng tuyển chưa
        if (dao.hasApplied(studentID, jobID)) {
            response.sendRedirect(request.getContextPath()
                    + "/student/job-detail?id=" + jobID + "&result=already");
            return;
        }

        // Insert đơn ứng tuyển
        boolean success = dao.apply(studentID, jobID, desiredSalary,
                message != null ? message.trim() : "");

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/student/job-detail?id=" + jobID + "&result=success");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/student/job-detail?id=" + jobID + "&result=error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET không hợp lệ -> về trang chủ
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}

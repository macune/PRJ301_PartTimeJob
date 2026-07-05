/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers.student;

import dal.SavedJobDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Account;

/**
 * Xử lý Lưu / Bỏ lưu việc làm (Student)
 *
 * POST /student/save-job
 *   - Nhận jobID, action (save | unsave) từ form trên student_job_detail.jsp
 *   - Toggle trạng thái lưu trong bảng Saved_Job
 *   - Redirect lại trang chi tiết kèm ?saved=1 hoặc ?saved=0
 *
 * @author PRJ301
 */
@WebServlet(name = "StudentSaveJobController", urlPatterns = {"/student/save-job"})
public class StudentSaveJobController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập
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

        String jobIDStr = request.getParameter("jobID");
        String action   = request.getParameter("action"); // "save" hoặc "unsave"

        if (jobIDStr == null || jobIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        int jobID;
        try {
            jobID = Integer.parseInt(jobIDStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        int studentID = account.getAccountID();
        SavedJobDAO dao = new SavedJobDAO();

        if ("unsave".equals(action)) {
            dao.unsave(studentID, jobID);
            response.sendRedirect(request.getContextPath()
                    + "/student/job-detail?id=" + jobID + "&saved=0");
        } else {
            // Chỉ lưu nếu chưa lưu
            if (!dao.isSaved(studentID, jobID)) {
                dao.save(studentID, jobID);
            }
            response.sendRedirect(request.getContextPath()
                    + "/student/job-detail?id=" + jobID + "&saved=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.ApplicationDAO;
import dal.JobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Account;
import viewmodels.JobDetailDTO;
import java.sql.Time;

/**
 *
 * @author ADMIN
 */
public class StudentApplyJobController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet StudentApplyJobController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentApplyJobController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/findJob");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        String jobIDStr = request.getParameter("jobID");
        String desiredSalaryStr = request.getParameter("desiredSalary");
        String message = request.getParameter("message");

        if (jobIDStr == null || jobIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/findJob");
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
            response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobIDStr + "&result=error");
            return;
        }

        int studentID = account.getAccountId();
        ApplicationDAO dao = new ApplicationDAO();

        // 1. Kiểm tra xem đã từng ứng tuyển vào chính bài đăng này chưa
        if (dao.hasApplied(studentID, jobID)) {
            response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobID + "&result=already");
            return;
        }

        // 2. TÍNH NĂNG MỚI: KIỂM TRA TRÙNG GIỜ LÀM VIỆC VỚI CÁC ĐƠN KHÁC
        JobDAO jobDao = new JobDAO();
        JobDetailDTO newJobDetail = jobDao.getJobById(jobID);
        
        if (newJobDetail != null) {
            Time newStart = newJobDetail.getJob().getStartTime();
            Time newEnd = newJobDetail.getJob().getEndTime();
            
            // Nếu có đơn nào trùng lịch -> Chặn lại và báo lỗi Overlap
            if (dao.hasTimeOverlap(studentID, newStart, newEnd)) {
                response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobID + "&result=overlap");
                return;
            }
        }

        // 3. Nếu mọi thứ an toàn -> Insert đơn ứng tuyển
        boolean success = dao.apply(studentID, jobID, desiredSalary, message != null ? message.trim() : "");

        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobID + "&result=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobID + "&result=error");
        }
    }
    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.ApplicationDAO;
import dal.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import models.Account;
import viewmodels.ApplicationDTO;

/**
 *
 * @author ADMIN
 */
public class StudentManageJobController extends HttpServlet {
   
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
            out.println("<title>Servlet StudentManageJobController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentManageJobController at " + request.getContextPath () + "</h1>");
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
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        int studentId = account.getAccountId();
        
        ApplicationDAO appDAO = new ApplicationDAO();
        List<ApplicationDTO> allApps = appDAO.getApplicationHistoryByStudentId(studentId);
        
        List<ApplicationDTO> workingJobs = new ArrayList<>();
        List<ApplicationDTO> historyJobs = new ArrayList<>();
        
        dal.ReviewDAO reviewDAO = new dal.ReviewDAO();
        
        for (ApplicationDTO app : allApps) {
            if (app.getApplication().getStatus() == 1) { 
                workingJobs.add(app);
            } else if (app.getApplication().getStatus() == 3) {
                // ĐÃ NGHỈ -> Gắn nút Đánh giá vào đây
                boolean hasReviewed = reviewDAO.hasStudentReviewedEmployer(studentId, app.getEmployer().getEmployerId());
                app.setIsReviewed(hasReviewed);
                historyJobs.add(app);
            }
        }
        
        request.setAttribute("workingJobs", workingJobs);
        request.setAttribute("historyJobs", historyJobs);
        request.getRequestDispatcher("/views/student/student_manage_jobs.jsp").forward(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        String action = request.getParameter("action");
        
        if ("resign".equals(action)) {
            try {
                int applicationId = Integer.parseInt(request.getParameter("applicationId"));
                String reason = request.getParameter("reason");
                
                ApplicationDAO appDAO = new ApplicationDAO();
                // Truyền "STUDENT" để DAO biết gắn tiền tố [SV Xin nghỉ]
                boolean success = appDAO.updateStatusToFinished(applicationId, account.getAccountId(), "STUDENT", reason);
                
                if (success) {
                    session.setAttribute("successMsg", "Đã báo cáo xin nghỉ thành công. Công việc đã được chuyển vào lịch sử.");
                } else {
                    session.setAttribute("errorMsg", "Không thể thực hiện yêu cầu. Vui lòng thử lại.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMsg", "Dữ liệu không hợp lệ.");
            }
            
            // Reload lại trang Quản lý việc làm (Thay đường dẫn này bằng URL Mapping thực tế của bạn nếu cần)
            response.sendRedirect(request.getContextPath() + "/student/manageJobs"); 
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

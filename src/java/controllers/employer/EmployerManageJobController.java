/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.employer;

import dal.ApplicationDAO;
import dal.JobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Account;
import viewmodels.JobDetailDTO;

/**
 *
 * @author acer
 */
public class EmployerManageJobController extends HttpServlet {
   
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
            out.println("<title>Servlet ManageJobController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageJobController at " + request.getContextPath () + "</h1>");
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

        JobDAO jobDAO = new JobDAO();
        List<JobDetailDTO> listJobs = jobDAO.getJobsByEmployerId(account.getAccountId());
        request.setAttribute("listJobs", listJobs);
        
        request.getRequestDispatcher("/views/employer/employer_manage_jobs.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        String action = request.getParameter("action");
        String jobIdStr = request.getParameter("jobId");
        
        if ("close".equals(action) && jobIdStr != null) {
            try {
                int jobId = Integer.parseInt(jobIdStr);
                ApplicationDAO appDao = new ApplicationDAO();
                if (appDao.hasPendingApplicationsByJob(jobId)) {
                    session.setAttribute("errorMsg", "Không thể đóng bài đăng! Vẫn còn đơn ứng tuyển đang chờ duyệt. Vui lòng xử lý (chấp nhận/từ chối) các đơn này trước.");
                    response.sendRedirect(request.getContextPath() + "/employer/manageJobs");
                    return; 
                }
                JobDAO jobDAO = new JobDAO();
                jobDAO.updateJobStatus(jobId, account.getAccountId(), 3); 
                session.setAttribute("successMsg", "Đã đóng bài đăng thành công.");
                
            } catch (Exception e) {
                session.setAttribute("errorMsg", "Đã xảy ra lỗi hệ thống, vui lòng thử lại.");
            }
            response.sendRedirect(request.getContextPath() + "/employer/manageJobs");
            return;
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

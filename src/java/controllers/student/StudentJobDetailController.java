/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.ApplicationDAO;
import dal.EmployerReviewDAO;
import dal.JobDAO;
import dal.SavedJobDAO;
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
import viewmodels.ReviewDTO;

/**
 *
 * @author ADMIN
 */
public class StudentJobDetailController extends HttpServlet {
   
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
            out.println("<title>Servlet StudentJobDetailController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentJobDetailController at " + request.getContextPath () + "</h1>");
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
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/findJob");
            return;
        }
        
        try {
            int jobId = Integer.parseInt(idParam);
            JobDAO dao = new JobDAO();
            JobDetailDTO jobDetail = dao.getJobById(jobId);
            
            if (jobDetail != null) {
                HttpSession session = request.getSession();
                Account account = (Account) session.getAttribute("account");
                
                // Kiểm tra trạng thái ứng tuyển và lưu bài
                ApplicationDAO appDao = new ApplicationDAO();
                SavedJobDAO svDao = new SavedJobDAO();
                
                boolean hasApplied = appDao.hasApplied(account.getAccountId(), jobId);
                boolean isSaved = svDao.isSaved(account.getAccountId(), jobId);
                
                EmployerReviewDAO reviewDao = new EmployerReviewDAO();
                List<ReviewDTO> reviewList = reviewDao.getReviewsForEmployer(jobDetail.getEmployer().getEmployerId());
                request.setAttribute("reviewList", reviewList);
                
                request.setAttribute("jobDetail", jobDetail);
                request.setAttribute("hasApplied", hasApplied);
                request.setAttribute("isSaved", isSaved);
                
                request.getRequestDispatcher("/views/student/student_job_detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/student/findJob");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/findJob");
        }
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
        processRequest(request, response);
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

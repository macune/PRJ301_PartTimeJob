/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.employer;

import dal.ApplicationDAO;
import dal.JobDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.List;
import models.Account;
import viewmodels.ApplicationDTO;
import viewmodels.JobDetailDTO;
import viewmodels.ReviewDTO;

/**
 *
 * @author acer
 */
public class EmployerManageApplicantController extends HttpServlet {
   
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
            out.println("<title>Servlet EmployerManageApplicantController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EmployerManageApplicantController at " + request.getContextPath () + "</h1>");
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
        
        String jobIdStr = request.getParameter("jobId");
        if (jobIdStr == null || jobIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employer/manageJobs");
            return;
        }

        try {
            int jobId = Integer.parseInt(jobIdStr);
            
            JobDAO jobDAO = new JobDAO();
            JobDetailDTO jobDetail = jobDAO.getJobById(jobId);
            request.setAttribute("jobDetail", jobDetail);

            ApplicationDAO appDAO = new ApplicationDAO();
            List<ApplicationDTO> listApplicants = appDAO.getApplicationsByJobId(jobId);
            dal.StudentReviewDAO studentReviewDao = new dal.StudentReviewDAO();
            
            for (ApplicationDTO app : listApplicants) {
                int sId = app.getStudent().getStudentId();
                // Lấy danh sách review của sinh viên này
                List<ReviewDTO> reviews = studentReviewDao.getReviewsForStudent(sId);
                
                // Gắn thẳng list review vào đối tượng app
                app.setReviews(reviews);
            }
            // =========================================================

            request.setAttribute("listApplicants", listApplicants);
            request.setAttribute("jobId", jobId);

            request.getRequestDispatcher("/views/employer/employer_manage_applicants.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/manageJobs");
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        try {
            int applicationId = Integer.parseInt(request.getParameter("applicationId"));
            int status = Integer.parseInt(request.getParameter("status")); 
            String employerNote = request.getParameter("employerNote");
            String jobIdStr = request.getParameter("jobId");
            int employerId = account.getAccountId(); 

            ApplicationDAO appDAO = new ApplicationDAO();
            appDAO.updateApplicationStatus(applicationId, status, employerNote, employerId);

            response.sendRedirect(request.getContextPath() + "/employer/manageApplicants?jobId=" + jobIdStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/employer/manageJobs");
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

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.employer;

import dal.CategoryDAO;
import dal.JobDAO;
import java.io.IOException;
import java.sql.Time;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Account;
import models.Category;
import models.Job_Post;
import viewmodels.JobDetailDTO;

/**
 *
 * @author acer
 */
public class EmployerCreateJobController extends HttpServlet {
   
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
            out.println("<title>Servlet CreateJobController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateJobController at " + request.getContextPath () + "</h1>");
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

        CategoryDAO catDAO = new CategoryDAO();
        List<Category> listCategories = catDAO.getAllCategories();
        request.setAttribute("listCategories", listCategories);

        String jobIdStr = request.getParameter("id");
        if (jobIdStr != null && !jobIdStr.isEmpty()) {
            try {
                int jobId = Integer.parseInt(jobIdStr);
                JobDAO jobDAO = new JobDAO();
                JobDetailDTO jobDetail = jobDAO.getJobById(jobId);
                // Đảm bảo chỉ được sửa bài của chính mình
                if (jobDetail != null && jobDetail.getEmployer().getEmployerId() == account.getAccountId()) {
                    request.setAttribute("jobToEdit", jobDetail.getJob());
                }
            } catch (Exception e) {}
        }
        
        request.getRequestDispatcher("/views/employer/employer_create_job.jsp").forward(request, response);
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
            Job_Post job = new Job_Post();
            job.setEmployerId(account.getAccountId());
            job.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            job.setTitle(request.getParameter("title"));
            job.setDescription(request.getParameter("description"));
            job.setSalary(Integer.parseInt(request.getParameter("salary")));
            
            String startStr = request.getParameter("startTime");
            String endStr = request.getParameter("endTime");
            job.setStartTime(Time.valueOf(startStr.length() == 5 ? startStr + ":00" : startStr));
            job.setEndTime(Time.valueOf(endStr.length() == 5 ? endStr + ":00" : endStr));

            job.setCity(request.getParameter("city"));
            job.setWard(request.getParameter("ward"));
            job.setDetailAddress(request.getParameter("detailAddress"));

            JobDAO jobDAO = new JobDAO();
            String jobIdStr = request.getParameter("jobId");

            if (jobIdStr != null && !jobIdStr.isEmpty()) {
                job.setJobId(Integer.parseInt(jobIdStr));
                jobDAO.updateJob(job);
            } else {
                jobDAO.insertJob(job);
            }
            
            response.sendRedirect(request.getContextPath() + "/employer/manageJobs");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/employer/createJob");
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

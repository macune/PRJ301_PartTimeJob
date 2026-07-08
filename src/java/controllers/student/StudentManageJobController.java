/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.ApplicationDAO;
import dal.SavedJobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import models.Account;
import viewmodels.ApplicationDTO;
import viewmodels.JobDetailDTO;

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
        
        // 1. Lấy danh sách Việc đã lưu
        SavedJobDAO savedJobDAO = new SavedJobDAO();
        List<JobDetailDTO> savedJobs = savedJobDAO.getSavedJobsWithDetails(studentId);
        
        // 2. Lấy danh sách Công việc đang làm (Status = 1)
        ApplicationDAO appDAO = new ApplicationDAO();
        List<ApplicationDTO> allApps = appDAO.getApplicationHistoryByStudentId(studentId);
        List<ApplicationDTO> workingJobs = new ArrayList<>();
        
        for (ApplicationDTO app : allApps) {
            if (app.getApplication().getStatus() == 1) { // 1 = Chấp nhận
                workingJobs.add(app);
            }
        }
        
        request.setAttribute("savedJobs", savedJobs);
        request.setAttribute("workingJobs", workingJobs);
        
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

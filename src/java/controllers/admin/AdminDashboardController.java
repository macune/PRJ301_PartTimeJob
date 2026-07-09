/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.admin;

import dal.AccountDAO;
import dal.ApplicationDAO;
import dal.JobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import viewmodels.StatDTO;

/**
 *
 * @author ADMIN
 */
public class AdminDashboardController extends HttpServlet {
   
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
            out.println("<title>Servlet AdminDashboardController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDashboardController at " + request.getContextPath () + "</h1>");
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
        
        AccountDAO accDAO = new AccountDAO();
        JobDAO jobDAO = new JobDAO();
        ApplicationDAO appDAO = new ApplicationDAO();

        // 1. Số liệu tổng quan 4 thẻ Card
        request.setAttribute("totalStudents", accDAO.countUsersByRole(2));
        request.setAttribute("totalEmployers", accDAO.countUsersByRole(3));
        request.setAttribute("totalJobs", jobDAO.countAllJobs());
        request.setAttribute("totalApps", appDAO.getTotalApplications());

        // 2. Số liệu trạng thái mới thêm (Bài đăng & Tài khoản)
        request.setAttribute("pendingJobs", jobDAO.countPendingJobs());
        request.setAttribute("activeAccs", accDAO.countAccountsByState(1));
        request.setAttribute("lockedAccs", accDAO.countAccountsByState(2));
        request.setAttribute("deletedAccs", accDAO.countAccountsByState(3));

        // 3. Danh sách đối tượng thống kê chi tiết (Không dùng Map)
        List<StatDTO> appStats = appDAO.getApplicationStatsByStatus();
        List<StatDTO> jobStats = jobDAO.getJobStatsByCategory();

        request.setAttribute("appStats", appStats);
        request.setAttribute("jobStats", jobStats);

        request.getRequestDispatcher("/views/admin/admin_dashboard.jsp").forward(request, response);
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

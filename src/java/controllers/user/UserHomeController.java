/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.user;

import dal.CategoryDAO;
import dal.JobDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import models.Category;
import viewmodels.JobDetailDTO;

/**
 *
 * @author acer
 */
public class UserHomeController extends HttpServlet {
   
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
            out.println("<title>Servlet JobListController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JobListController at " + request.getContextPath () + "</h1>");
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
        
        JobDAO jobDao = new JobDAO();
        CategoryDAO catDao = new CategoryDAO();
        
        String categoryId = request.getParameter("categoryId");
        String city = request.getParameter("city");
        String ward = request.getParameter("ward");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        int pageSize = 6;
        String pageParam = request.getParameter("page");
        int pageIndex = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        
        boolean isFiltering = (categoryId != null && !categoryId.trim().isEmpty())
                || (city != null && !city.trim().isEmpty())
                || (ward != null && !ward.trim().isEmpty())
                || (startTime != null && !startTime.trim().isEmpty())
                || (endTime != null && !endTime.trim().isEmpty());
        
        int totalJobs = 0;
        List<JobDetailDTO> listJobs = null;
        
        if (isFiltering) {
            totalJobs = jobDao.countSearchJobs(categoryId, city, ward, startTime, endTime);
            listJobs = jobDao.searchJobs(categoryId, city, ward, startTime, endTime, pageIndex, pageSize);
        } else {
            totalJobs = jobDao.getTotalJobs();
            listJobs = jobDao.getAllJobs(pageIndex, pageSize);
        }
        
        int totalPages = (totalJobs % pageSize == 0) ? (totalJobs / pageSize) : (totalJobs / pageSize) + 1;
        List<Category> listCategories = catDao.getAllCategories();
        
        request.setAttribute("listJobs", listJobs);
        request.setAttribute("categories", listCategories);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("param", request.getParameterMap());
        
        request.getRequestDispatcher("views/user/user_home.jsp").forward(request, response);
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

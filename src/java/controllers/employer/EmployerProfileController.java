/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.employer;

import dal.EmployerProfileDAO;
import dal.EmployerReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Account;
import models.Employer_Profile;
import viewmodels.ReviewDTO;

/**
 *
 * @author ADMIN
 */
public class EmployerProfileController extends HttpServlet {
   
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
            out.println("<title>Servlet EmployerProfileController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EmployerProfileController at " + request.getContextPath () + "</h1>");
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
        Account account = getAccountFromSession(request, response);
        if (account == null) return;

        EmployerProfileDAO dao = new EmployerProfileDAO();
        Employer_Profile profile = dao.getByID(account.getAccountId());

        if (profile == null) {
            dao.createDefault(account.getAccountId(), account.getUsername());
            profile = dao.getByID(account.getAccountId());
        }
        request.setAttribute("profile", profile);
        
        EmployerReviewDAO reviewDao = new EmployerReviewDAO();
        List<ReviewDTO> reviewList = reviewDao.getReviewsForEmployer(account.getAccountId());
        request.setAttribute("reviewList", reviewList);
        
        request.getRequestDispatcher("/views/employer/employer_profile.jsp").forward(request, response);
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
        Account account = getAccountFromSession(request, response);
        if (account == null) return;

        String businessName = request.getParameter("businessName");
        String logoUrl = request.getParameter("logoUrl");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String contactEmail = request.getParameter("contactEmail");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        if (isBlank(businessName)) {
            request.setAttribute("errorMsg", "Tên doanh nghiệp không được để trống.");
            Employer_Profile profile = buildProfile(account.getAccountId(), businessName, logoUrl, website, phone, contactEmail, address, description, 0);
            request.setAttribute("profile", profile);
            fetchAndSetReviews(request, account.getAccountId());
            request.getRequestDispatcher("/views/employer/employer_profile.jsp").forward(request, response);
            return;
        }

        Employer_Profile profile = buildProfile(
                account.getAccountId(), 
                trim(businessName), 
                trim(logoUrl), 
                trim(website), 
                trim(phone), 
                trim(contactEmail), 
                trim(address), 
                trim(description), 
                0);
        EmployerProfileDAO dao = new EmployerProfileDAO();
        boolean success = dao.update(profile);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/employer/profile?updated=1");
        } else {
            request.setAttribute("errorMsg", "Cập nhật thất bại. Vui lòng thử lại.");
            request.setAttribute("profile", profile);
            fetchAndSetReviews(request, account.getAccountId());
            request.getRequestDispatcher("/views/employer/employer_profile.jsp").forward(request, response);
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
    
    private void fetchAndSetReviews(HttpServletRequest request, int employerId) {
        EmployerReviewDAO reviewDao = new EmployerReviewDAO();
        List<ReviewDTO> reviewList = reviewDao.getReviewsForEmployer(employerId);
        request.setAttribute("reviewList", reviewList);
    }
    private Account getAccountFromSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin");
            return null;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRole() != 3) { 
            response.sendRedirect(request.getContextPath() + "/home");
            return null;
        }
        return account;
    }

    private Employer_Profile buildProfile(int id, String businessName, String logoUrl,
            String website, String phone, String contactEmail, 
            String address, String description, double rating) {
        return new Employer_Profile(id, businessName, logoUrl,
                website, phone, contactEmail, address, 
                description, rating);
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private String trim(String s) { return s == null ? null : s.trim(); }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.StudentProfileDAO;
import dal.StudentReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.List;
import models.Account;
import models.Student_Profile;
import viewmodels.ReviewDTO;

/**
 *
 * @author ADMIN
 */
public class StudentProfileController extends HttpServlet {
   
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
            out.println("<title>Servlet StudentProfileController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentProfileController at " + request.getContextPath () + "</h1>");
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

        StudentProfileDAO dao = new StudentProfileDAO();
        Student_Profile profile = dao.getByID(account.getAccountId());

        if (profile == null) {
            dao.createDefault(account.getAccountId(), account.getUsername());
            profile = dao.getByID(account.getAccountId());
        }
        request.setAttribute("profile", profile);
        
        StudentReviewDAO reviewDao = new StudentReviewDAO();
        List<ReviewDTO> reviewList = reviewDao.getReviewsForStudent(account.getAccountId());
        request.setAttribute("reviewList", reviewList);
        
        request.getRequestDispatcher("/views/student/student_profile.jsp").forward(request, response);
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

        String fullName = request.getParameter("fullName");
        String contactEmail = request.getParameter("contactEmail");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String university = request.getParameter("university");
        String introduction = request.getParameter("introduction");
        String experience = request.getParameter("experience");
        String avatarUrl = request.getParameter("avatarUrl");

        if (isBlank(fullName)) {
            request.setAttribute("errorMsg", "Họ tên không được để trống.");
            Student_Profile profile = buildProfile(account.getAccountId(), fullName, avatarUrl, contactEmail, phone, address, university, introduction, experience, 0);
            request.setAttribute("profile", profile);
            fetchAndSetReviews(request, account.getAccountId());
            request.getRequestDispatcher("/views/student/student_profile.jsp").forward(request, response);
            return;
        }

        Student_Profile profile = buildProfile(
                account.getAccountId(), 
                trim(fullName), 
                trim(avatarUrl), 
                trim(contactEmail), 
                trim(phone), 
                trim(address), 
                trim(university), 
                trim(introduction), 
                trim(experience), 
                0);
        StudentProfileDAO dao = new StudentProfileDAO();
        boolean success = dao.update(profile);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/profile?updated=1");
        } else {
            request.setAttribute("errorMsg", "Cập nhật thất bại. Vui lòng thử lại.");
            request.setAttribute("profile", profile);
            fetchAndSetReviews(request, account.getAccountId());
            request.getRequestDispatcher("/views/student/student_profile.jsp").forward(request, response);
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

    private void fetchAndSetReviews(HttpServletRequest request, int studentId) {
        StudentReviewDAO reviewDao = new StudentReviewDAO();
        List<ReviewDTO> reviewList = reviewDao.getReviewsForStudent(studentId);
        request.setAttribute("reviewList", reviewList);
    }
    
    private Student_Profile buildProfile(int id, String fullName, String avatarUrl, 
            String contactEmail, String phone, String address, String university, 
            String introduction, String experience, double rating) {
        return new Student_Profile(id, fullName, avatarUrl, 
                contactEmail, phone, address, university, 
                introduction, experience, rating);
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private String trim(String s) { return s == null ? null : s.trim(); }
}

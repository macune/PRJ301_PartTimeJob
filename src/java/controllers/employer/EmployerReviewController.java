/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.employer;

import dal.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import models.Account;

/**
 *
 * @author acer
 */
public class EmployerReviewController extends HttpServlet {
   
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
            out.println("<title>Servlet EmployerReviewController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EmployerReviewController at " + request.getContextPath () + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            dal.ReviewDAO reviewDAO = new dal.ReviewDAO();
            
            if (reviewDAO.hasEmployerReviewedStudent(account.getAccountId(), studentId)) {
                session.setAttribute("errorMsg", "Bạn đã đánh giá ứng viên này trước đó rồi!");
            } else {
                if (reviewDAO.insertStudentReview(account.getAccountId(), studentId, rating, comment)) {
                    session.setAttribute("successMsg", "Đã ghi nhận đánh giá về sinh viên.");
                } else {
                    session.setAttribute("errorMsg", "Đã xảy ra lỗi, vui lòng thử lại sau.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra NetBeans Output
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ, vui lòng tải lại trang.");
        }
        
        response.sendRedirect(request.getContextPath() + "/employer/manageHR");
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

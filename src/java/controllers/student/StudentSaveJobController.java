/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.SavedJobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Account;

/**
 *
 * @author ADMIN
 */
public class StudentSaveJobController extends HttpServlet {
   
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
            out.println("<title>Servlet StudentSaveJobController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentSaveJobController at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
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

        String jobIDStr = request.getParameter("jobID");
        String action = request.getParameter("action"); 

        if (jobIDStr == null || jobIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/findJob");
            return;
        }

        int jobID;
        try {
            jobID = Integer.parseInt(jobIDStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/findJob");
            return;
        }

        int studentID = account.getAccountId();
        SavedJobDAO dao = new SavedJobDAO();

        // Lấy URL trang trước đó người dùng vừa đứng
        String referer = request.getHeader("Referer");

        if ("unsave".equals(action)) {
            dao.unsave(studentID, jobID);
            // Nếu thao tác từ trang findJob thì Load lại nguyên trang findJob
            if (referer != null && referer.contains("findJob")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobID + "&saved=0");
            }
        } else {
            if (!dao.isSaved(studentID, jobID)) {
                dao.save(studentID, jobID);
            }
            if (referer != null && referer.contains("findJob")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/student/jobDetail?id=" + jobID + "&saved=1");
            }
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

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.employer;

import dal.ApplicationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Account;
import viewmodels.ApplicationDTO;

/**
 *
 * @author ADMIN
 */
public class EmployerManageHRController extends HttpServlet {
   
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
            out.println("<title>Servlet EmployerManageHRController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EmployerManageHRController at " + request.getContextPath () + "</h1>");
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
        int employerId = account.getAccountId(); 
        
        ApplicationDAO appDAO = new ApplicationDAO();
        List<ApplicationDTO> listAccepted = appDAO.getAcceptedApplicationsByEmployerId(employerId);
        List<ApplicationDTO> listHistory = appDAO.getHRHistoryByEmployerId(employerId);
        
        dal.ReviewDAO reviewDAO = new dal.ReviewDAO();
        for (ApplicationDTO item : listHistory) {
            boolean hasReviewed = reviewDAO.hasEmployerReviewedApplication(item.getApplication().getApplicationID());
            item.setIsReviewed(hasReviewed);
        }
        
        request.setAttribute("listAccepted", listAccepted);
        request.setAttribute("listHistory", listHistory);
        request.getRequestDispatcher("/views/employer/employer_manage_hr.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        
        // XỬ LÝ LOGIC CHO NGHỈ / SA THẢI
        if ("fire".equals(action)) {
            try {
                int applicationId = Integer.parseInt(request.getParameter("applicationId"));
                String reason = request.getParameter("reason");
                
                ApplicationDAO appDAO = new ApplicationDAO();
                // Truyền "EMPLOYER" để DAO biết gắn tiền tố [NTD Cho nghỉ]
                boolean success = appDAO.updateStatusToFinished(applicationId, account.getAccountId(), "EMPLOYER", reason);
                
                if (success) {
                    session.setAttribute("successMsg", "Đã cho nhân viên nghỉ việc thành công. Hồ sơ đã chuyển vào lịch sử.");
                } else {
                    session.setAttribute("errorMsg", "Không thể thực hiện yêu cầu. Vui lòng thử lại.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMsg", "Dữ liệu không hợp lệ.");
            }
            
            // Reload lại trang Quản lý nhân sự
            response.sendRedirect(request.getContextPath() + "/employer/manageHR"); 
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

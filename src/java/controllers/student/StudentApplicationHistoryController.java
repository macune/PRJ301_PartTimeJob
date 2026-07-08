/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.student;

import dal.ApplicationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import models.Account;
import viewmodels.ApplicationDTO;

/**
 *
 * @author ADMIN
 */
public class StudentApplicationHistoryController extends HttpServlet {
   
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
            out.println("<title>Servlet StudentApplicationHistoryController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentApplicationHistoryController at " + request.getContextPath () + "</h1>");
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
        
        ApplicationDAO appDAO = new ApplicationDAO();
        // Lấy TOÀN BỘ lịch sử để đếm số lượng
        List<ApplicationDTO> allApps = appDAO.getApplicationHistoryByStudentId(account.getAccountId());
        
        long countPending = 0, countAccepted = 0, countRejected = 0;
        List<ApplicationDTO> filteredList = new ArrayList<>();
        String statusParam = request.getParameter("status");
        
        for (ApplicationDTO dto : allApps) {
            int status = dto.getApplication().getStatus();
            
            // Đếm số lượng thực tế
            if (status == 0) countPending++;
            else if (status == 1) countAccepted++;
            else if (status == 2) countRejected++;
            
            // Lọc danh sách theo tham số URL
            if (statusParam == null || statusParam.equals("all")) {
                filteredList.add(dto);
            } else {
                try {
                    if (status == Integer.parseInt(statusParam)) {
                        filteredList.add(dto);
                    }
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu param bị lỗi
                }
            }
        }
        
        // Gửi danh sách ĐÃ LỌC và các con số thống kê sang JSP
        request.setAttribute("applicationList", filteredList);
        request.setAttribute("countAll", allApps.size());
        request.setAttribute("countPending", countPending);
        request.setAttribute("countAccepted", countAccepted);
        request.setAttribute("countRejected", countRejected);
        request.setAttribute("currentStatus", statusParam == null ? "all" : statusParam);
        
        request.getRequestDispatcher("/views/student/student_application_history.jsp").forward(request, response);
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

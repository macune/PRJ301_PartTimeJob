/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.admin;

import dal.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Account;

/**
 *
 * @author ADMIN
 */
public class AdminManageUserController extends HttpServlet {
   
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
            out.println("<title>Servlet AdminManageUserController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminManageUserController at " + request.getContextPath () + "</h1>");
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
        if (!isAdmin(request, response)) return;

        String keyword = request.getParameter("search");
        AccountDAO dao = new AccountDAO();
        List<Account> userList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            userList = dao.searchAccount(keyword.trim());
            request.setAttribute("searchKeyword", keyword.trim());
        } else {
            userList = dao.getAllAccounts();
        }

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/views/admin/manage_users.jsp").forward(request, response);
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
        if (!isAdmin(request, response)) return;

        String accountIdStr = request.getParameter("accountId");
        String newStatusStr = request.getParameter("newStatus");

        if (accountIdStr != null && newStatusStr != null) {
            try {
                int accountId = Integer.parseInt(accountIdStr);
                int newStatus = Integer.parseInt(newStatusStr);
                
                AccountDAO dao = new AccountDAO();
                dao.updateAccountStatus(accountId, newStatus);
            } catch (NumberFormatException e) {
                System.out.println("Parse Error: Invalid ID or Status");
            }
        }
        
        // Trả về trang cũ, giữ nguyên từ khóa tìm kiếm (nếu có)
        String keyword = request.getParameter("searchKeyword");
        if (keyword != null && !keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?search=" + keyword);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
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
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin");
            return false;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRole() != 1) { 
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }
}

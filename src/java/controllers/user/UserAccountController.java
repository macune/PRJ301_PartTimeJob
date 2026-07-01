/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.user;

import dal.AccountDAO;
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
public class UserAccountController extends HttpServlet {
   
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
            out.println("<title>Servlet UserAccountController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserAccountController at " + request.getContextPath () + "</h1>");
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
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin");
            return;
        }

        String action = request.getParameter("action");
        if ("change_password".equals(action)) {
            request.getRequestDispatcher("/views/user/change_password.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/user/account_detail.jsp").forward(request, response);
        }
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
        
        // Trực tiếp lấy Account ra xài, không cần check null nữa
        HttpSession session = request.getSession();
        Account currentAccount = (Account) session.getAttribute("account");
        
        AccountDAO dao = new AccountDAO();
        String action = request.getParameter("action");

        // 1. XỬ LÝ CẬP NHẬT THÔNG TIN
        if ("update_info".equals(action)) {
            String newEmail = request.getParameter("email");
            
            if (newEmail == null || newEmail.trim().isEmpty()) {
                request.setAttribute("errorMsg", "Email không được để trống.");
                request.getRequestDispatcher("/views/user/account_detail.jsp").forward(request, response);
                return;
            }
            
            // Check trùng email (chỉ check nếu email mới khác email cũ)
            if (!currentAccount.getEmail().equals(newEmail) && dao.isEmailExist(newEmail)) {
                request.setAttribute("errorMsg", "Email đã tồn tại trong hệ thống. Vui lòng chọn email khác.");
                request.getRequestDispatcher("/views/user/account_detail.jsp").forward(request, response);
                return;
            }
            
            if (dao.updateAccountInfo(currentAccount.getAccountId(), newEmail)) {
                currentAccount.setEmail(newEmail); 
                session.setAttribute("account", currentAccount); // Ép Session cập nhật lại
                request.setAttribute("successMsg", "Cập nhật thông tin tài khoản thành công!");
            } else {
                request.setAttribute("errorMsg", "Có lỗi hệ thống, vui lòng thử lại sau.");
            }
            request.getRequestDispatcher("/views/user/account_detail.jsp").forward(request, response);
        }
        
        // 2. XỬ LÝ ĐỔI MẬT KHẨU
        else if ("change_password".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!currentAccount.getPassword().equals(oldPassword)) {
                request.setAttribute("errorMsg", "Mật khẩu hiện tại không chính xác.");
                request.getRequestDispatcher("/views/user/change_password.jsp").forward(request, response);
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp.");
                request.getRequestDispatcher("/views/user/change_password.jsp").forward(request, response);
                return;
            }
            
            if (dao.changePassword(currentAccount.getAccountId(), newPassword)) {
                currentAccount.setPassword(newPassword);
                session.setAttribute("account", currentAccount);
                request.setAttribute("successMsg", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMsg", "Có lỗi hệ thống, vui lòng thử lại sau.");
            }
            request.getRequestDispatcher("/views/user/change_password.jsp").forward(request, response);
        }
        
        // 3. XỬ LÝ XÓA TÀI KHOẢN (XÓA MỀM)
        else if ("delete_account".equals(action)) {
            if (dao.softDeleteAccount(currentAccount.getAccountId())) {
                session.invalidate(); // Hủy session ngay lập tức, đuổi ra khỏi hệ thống
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("errorMsg", "Không thể xóa tài khoản lúc này. Vui lòng thử lại sau.");
                request.getRequestDispatcher("/views/user/account_detail.jsp").forward(request, response);
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

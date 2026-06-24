/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.user;

import dal.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

/**
 *
 * @author ADMIN
 */
public class UserRegisterController extends HttpServlet {
   
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
            out.println("<title>Servlet UserRegisterController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserRegisterController at " + request.getContextPath () + "</h1>");
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
        //processRequest(request, response);
        request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
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
        //processRequest(request, response);
        request.setCharacterEncoding("UTF-8");

        String username        = request.getParameter("username");
        String email           = request.getParameter("email");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleStr         = request.getParameter("role"); 

        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()
                || roleStr == null) {
            request.setAttribute("errorMsg", "Vui lòng nhập đầy đủ thông tin.");
            keepFormValues(request, username, email);
            request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
            return;
        }

        int role = Integer.parseInt(roleStr); 

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp.");
            keepFormValues(request, username, email);
            request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMsg", "Mật khẩu phải có ít nhất 6 ký tự.");
            keepFormValues(request, username, email);
            request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
            return;
        }

        AccountDAO dao = new AccountDAO();

        if (dao.isUsernameExist(username)) {
            request.setAttribute("errorMsg", "Tên đăng nhập đã được sử dụng.");
            keepFormValues(request, username, email);
            request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
            return;
        }

        if (dao.isEmailExist(email)) {
            request.setAttribute("errorMsg", "Email đã được đăng ký.");
            keepFormValues(request, username, email);
            request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
            return;
        }

        boolean success = dao.register(username, email, password, role);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/userLogin?registered=1");
        } else {
            request.setAttribute("errorMsg", "Đăng ký thất bại. Vui lòng thử lại sau.");
            keepFormValues(request, username, email);
            request.getRequestDispatcher("/views/user/user_register.jsp").forward(request, response);
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

    private void keepFormValues(HttpServletRequest request, String username, String email) {
        request.setAttribute("filledUsername", username);
        request.setAttribute("filledEmail", email);
    }

}

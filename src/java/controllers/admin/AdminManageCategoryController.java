/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers.admin;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Category;

/**
 *
 * @author ADMIN
 */
public class AdminManageCategoryController extends HttpServlet {
   
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
            out.println("<title>Servlet AdminManageCategoryController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminManageCategoryController at " + request.getContextPath () + "</h1>");
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
        CategoryDAO dao = new CategoryDAO();
        List<Category> categoryList = dao.getAllAdminCategories();
        
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/views/admin/manage_categories.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        CategoryDAO dao = new CategoryDAO();
        HttpSession session = request.getSession();

        try {
            // 1. THÊM DANH MỤC
            if ("add".equals(action)) {
                String catName = request.getParameter("categoryName");
                if (catName != null && !catName.trim().isEmpty()) {
                    if (dao.isCategoryExist(catName.trim())) {
                        session.setAttribute("errorMsg", "Tên danh mục đã tồn tại!");
                    } else {
                        dao.insertCategory(catName.trim());
                        session.setAttribute("successMsg", "Thêm danh mục thành công!");
                    }
                }
            } 
            // 2. SỬA DANH MỤC
            else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                String catName = request.getParameter("categoryName");
                
                if (catName != null && !catName.trim().isEmpty()) {
                    // Kiểm tra xem tên mới có trùng với danh mục KHÁC không
                    List<Category> allCats = dao.getAllAdminCategories();
                    boolean isDuplicate = false;
                    for (Category c : allCats) {
                        if (c.getCategoryName().equalsIgnoreCase(catName.trim()) && c.getCategoryId() != id) {
                            isDuplicate = true;
                            break;
                        }
                    }
                    
                    if (isDuplicate) {
                        session.setAttribute("errorMsg", "Tên danh mục bị trùng lặp!");
                    } else {
                        dao.updateCategory(id, catName.trim());
                        session.setAttribute("successMsg", "Cập nhật danh mục thành công!");
                    }
                }
            } 
            // 3. ẨN / HIỆN DANH MỤC (XÓA MỀM)
            else if ("toggle_status".equals(action)) {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                int newStatus = Integer.parseInt(request.getParameter("newStatus"));
                
                dao.updateCategoryStatus(id, newStatus);
                session.setAttribute("successMsg", "Cập nhật trạng thái thành công!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        // Sau khi xử lý xong (POST), dùng sendRedirect (GET) về trang danh sách để tránh lỗi submit lại form
        response.sendRedirect(request.getContextPath() + "/admin/categories");
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

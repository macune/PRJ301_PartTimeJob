package dal;

import models.Category;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = """
                     SELECT CategoryID, CategoryName, Status FROM Category 
                     WHERE Status = 1
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setStatus(rs.getInt("Status"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("Error getAllCategories: " + e.getMessage());
        }
        return list;
    }
    
    public List<Category> getAllAdminCategories() {
        List<Category> list = new ArrayList<>();
        String sql = """
                     SELECT CategoryID, CategoryName, Status FROM Category 
                     ORDER BY CategoryID DESC
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setStatus(rs.getInt("Status"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("Error getAllAdminCategories: " + e.getMessage());
        }
        return list;
    }
    
    public boolean insertCategory(String categoryName) {
        String sql = "INSERT INTO Category (CategoryName, Status) VALUES (?, 1)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, categoryName);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error insertCategory: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateCategory(int categoryId, String categoryName) {
        String sql = "UPDATE Category SET CategoryName = ? WHERE CategoryID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, categoryName);
            st.setInt(2, categoryId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateCategory: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateCategoryStatus(int categoryId, int status) {
        String sql = "UPDATE Category SET Status = ? WHERE CategoryID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, categoryId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateCategoryStatus: " + e.getMessage());
        }
        return false;
    }
    
    public boolean isCategoryExist(String categoryName) {
        String sql = "SELECT 1 FROM Category WHERE CategoryName = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, categoryName);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) {
            System.out.println("Error isCategoryExist: " + e.getMessage());
        }
        return false;
    }
}
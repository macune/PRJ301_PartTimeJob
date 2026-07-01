package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import models.Account;

public class AccountDAO extends DBContext {

    public Account login(String usernameOrEmail, String password) {
        try {
            String sql = """
                         SELECT AccountID, Username, Email, Password, Role, Status, CreatedAt, IsDeleted 
                         FROM Account 
                         WHERE (Username = ? OR Email = ?) AND Password = ? AND IsDeleted = 0
                         """; 
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("AccountID"));
                a.setUsername(rs.getString("Username"));
                a.setEmail(rs.getString("Email"));
                a.setPassword(rs.getString("Password"));
                a.setRole(rs.getInt("Role"));
                a.setStatus(rs.getInt("Status"));
                a.setCreatedAt(rs.getDate("CreatedAt"));
                a.setIsDeleted(rs.getInt("IsDeleted"));
                return a;
            }
        } catch (Exception e) {
            System.out.println("Error login: " + e.getMessage());
        }
        return null;
    }

    public boolean register(String username, String email, String password, int role) {
        try {
            String sql = """
                         INSERT INTO Account (Username, Email, Password, Role, Status, IsDeleted) 
                         VALUES (?, ?, ?, ?, 1, 0)
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setInt(4, role); 
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error register: " + e.getMessage());
        }
        return false;
    }

    public boolean isUsernameExist(String username) {
        try {
            String sql = "SELECT 1 FROM Account WHERE Username = ? AND IsDeleted = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) {
            System.out.println("Error isUsernameExist: " + e.getMessage());
        }
        return false;
    }

    public boolean isEmailExist(String email) {
        try {
            String sql = "SELECT 1 FROM Account WHERE Email = ? AND IsDeleted = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) {
            System.out.println("Error isEmailExist: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateAccountInfo(int accountId, String email) {
        try {
            String sql = "UPDATE Account SET Email = ? WHERE AccountID = ? AND IsDeleted = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateAccountInfo: " + e.getMessage());
        }
        return false;
    }
    
    public boolean changePassword(int accountId, String newPassword) {
        try {
            String sql = "UPDATE Account SET Password = ? WHERE AccountID = ? AND IsDeleted = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error changePassword: " + e.getMessage());
        }
        return false;
    }

    // --- HÀM XÓA MỀM TÀI KHOẢN ---
    public boolean softDeleteAccount(int accountId) {
        try {
            String sql = """
                         UPDATE Account 
                         SET Status = 0, 
                             IsDeleted = 1,
                             Username = CONCAT(LEFT(Username, 35), '_del_', AccountID),
                             Email = CONCAT(LEFT(Email, 80), '_del_', AccountID)
                         WHERE AccountID = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error softDeleteAccount: " + e.getMessage());
        }
        return false;
    }

    // --- CÁC HÀM CỦA ADMIN (KHÔNG LỌC ISDELETED ĐỂ XEM ĐƯỢC LỊCH SỬ) ---
    public List<Account> searchAccount(String keyword) {
        List<Account> list = new ArrayList<>();
        try {
            String sql = """
                         SELECT AccountID, Username, Email, Password, Role, Status, CreatedAt, IsDeleted 
                         FROM Account 
                         WHERE Username LIKE ? OR Email LIKE ?
                         ORDER BY AccountID DESC
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("AccountID"));
                a.setUsername(rs.getString("Username"));
                a.setEmail(rs.getString("Email"));
                a.setPassword(rs.getString("Password"));
                a.setRole(rs.getInt("Role"));
                a.setStatus(rs.getInt("Status"));
                a.setCreatedAt(rs.getDate("CreatedAt"));
                a.setIsDeleted(rs.getInt("IsDeleted"));
                list.add(a);
            }
        } catch (Exception e) {
            System.out.println("Error searchAccount: " + e.getMessage());
        }
        return list;
    }

    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        try {
            String sql = """
                         SELECT AccountID, Username, Email, Password, Role, Status, CreatedAt, IsDeleted 
                         FROM Account 
                         ORDER BY AccountID DESC
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("AccountID"));
                a.setUsername(rs.getString("Username"));
                a.setEmail(rs.getString("Email"));
                a.setPassword(rs.getString("Password"));
                a.setRole(rs.getInt("Role"));
                a.setStatus(rs.getInt("Status"));
                a.setCreatedAt(rs.getDate("CreatedAt"));
                a.setIsDeleted(rs.getInt("IsDeleted"));
                list.add(a);
            }
        } catch (Exception e) {
            System.out.println("Error getAllAccounts: " + e.getMessage());
        }
        return list;
    }

    public boolean updateAccountStatus(int accountId, int status) {
        try {
            String sql = """
                         UPDATE Account SET Status = ? 
                         WHERE AccountID = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateAccountStatus: " + e.getMessage());
        }
        return false;
    }
}
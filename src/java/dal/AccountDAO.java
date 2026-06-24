package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Account;

public class AccountDAO extends DBContext {

    public Account login(String usernameOrEmail, String password) {
        try {
            String sql = """
                         SELECT AccountID, Username, Email, Password, Role, Status, CreatedAt 
                         FROM Account 
                         WHERE (Username = ? OR Email = ?) AND Password = ? AND Status = 1
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
                a.setCreatedAt(rs.getTimestamp("CreatedAt"));
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
                         INSERT INTO Account (Username, Email, Password, Role, Status) 
                         VALUES (?, ?, ?, ?, 1)
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
            String sql = "SELECT 1 FROM Account WHERE Username = ?";
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
            String sql = "SELECT 1 FROM Account WHERE Email = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) {
            System.out.println("Error isEmailExist: " + e.getMessage());
        }
        return false;
    }
}
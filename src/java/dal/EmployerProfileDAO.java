package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Employer_Profile;

public class EmployerProfileDAO extends DBContext {

    public Employer_Profile getByID(int employerID) {
        try {
            String sql = """
                         SELECT EmployerID, BusinessName, LogoUrl, Website, 
                                Phone, ContactEmail, Address, Description, AverageRating 
                         FROM Employer_Profile 
                         WHERE EmployerID = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Employer_Profile p = new Employer_Profile();
                p.setEmployerId(rs.getInt("EmployerID"));
                p.setBusinessName(rs.getString("BusinessName"));
                p.setLogoUrl(rs.getString("LogoUrl"));
                p.setWebsite(rs.getString("Website"));
                p.setPhone(rs.getString("Phone"));
                p.setContactEmail(rs.getString("ContactEmail"));
                p.setAddress(rs.getString("Address"));
                p.setDescription(rs.getString("Description"));
                p.setAverageRating(rs.getDouble("AverageRating"));
                return p;
            }
        } catch (Exception e) {
            System.out.println("Error getByID (Employer): " + e.getMessage());
        }
        return null;
    }

    public boolean update(Employer_Profile profile) {
        try {
            String sql = """
                         UPDATE Employer_Profile SET 
                         BusinessName = ?, LogoUrl = ?, Website = ?, 
                         Phone = ?, ContactEmail = ?, Address = ?, Description = ? 
                         WHERE EmployerID = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, profile.getBusinessName());
            ps.setString(2, profile.getLogoUrl());
            ps.setString(3, profile.getWebsite());
            ps.setString(4, profile.getPhone());
            ps.setString(5, profile.getContactEmail());
            ps.setString(6, profile.getAddress());
            ps.setString(7, profile.getDescription());
            ps.setInt(8, profile.getEmployerId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update (Employer): " + e.getMessage());
        }
        return false;
    }

    public boolean createDefault(int employerID, String businessName) {
        try {
            String sql = """
                         INSERT INTO Employer_Profile (EmployerID, BusinessName) 
                         VALUES (?, ?)
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerID);
            ps.setString(2, businessName);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error createDefault (Employer): " + e.getMessage());
        }
        return false;
    }
}
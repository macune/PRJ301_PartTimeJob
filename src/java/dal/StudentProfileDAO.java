package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Student_Profile;

public class StudentProfileDAO extends DBContext {

    public Student_Profile getByID(int studentID) {
        try {
            String sql = """
                         SELECT StudentID, FullName, AvatarUrl, ContactEmail, 
                                Phone, Address, University, Introduction, Experience, AverageRating 
                         FROM Student_Profile 
                         WHERE StudentID = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Student_Profile p = new Student_Profile();
                p.setStudentId(rs.getInt("StudentID"));
                p.setFullName(rs.getString("FullName"));
                p.setAvatarUrl(rs.getString("AvatarUrl"));
                p.setContactEmail(rs.getString("ContactEmail"));
                p.setPhone(rs.getString("Phone"));
                p.setAddress(rs.getString("Address"));
                p.setUniversity(rs.getString("University"));
                p.setIntroduction(rs.getString("Introduction"));
                p.setExperience(rs.getString("Experience"));
                p.setAverageRating(rs.getDouble("AverageRating"));
                return p;
            }
        } catch (Exception e) {
            System.out.println("Error getByID: " + e.getMessage());
        }
        return null;
    }

    public boolean update(Student_Profile profile) {
        try {
            String sql = """
                         UPDATE Student_Profile SET 
                         FullName = ?, AvatarUrl = ?, ContactEmail = ?, 
                         Phone = ?, Address = ?, University = ?, 
                         Introduction = ?, Experience = ? 
                         WHERE StudentID = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, profile.getFullName());
            ps.setString(2, profile.getAvatarUrl());
            ps.setString(3, profile.getContactEmail());
            ps.setString(4, profile.getPhone());
            ps.setString(5, profile.getAddress());
            ps.setString(6, profile.getUniversity());
            ps.setString(7, profile.getIntroduction());
            ps.setString(8, profile.getExperience());
            ps.setInt(9, profile.getStudentId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update: " + e.getMessage());
        }
        return false;
    }

    public boolean createDefault(int studentID, String fullName) {
        try {
            String sql = """
                         INSERT INTO Student_Profile (StudentID, FullName) 
                         VALUES (?, ?)
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setString(2, fullName);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error createDefault: " + e.getMessage());
        }
        return false;
    }
}
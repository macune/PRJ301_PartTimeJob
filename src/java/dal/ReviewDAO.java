package dal;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ReviewDAO extends DBContext {

    // 1. Sinh viên đánh giá Cửa hàng
    public boolean hasStudentReviewedApplication(int applicationId) {
        String sql = "SELECT 1 FROM Student_Review WHERE ApplicationID = ?";
        try {
            java.sql.PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, applicationId);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            System.out.println("Error hasStudentReviewedApplication: " + e.getMessage());
        }
        return false;
    }

    public boolean insertStudentReview(int applicationId, int employerId, int studentId, int rating, String comment) {
        String sql = "INSERT INTO Student_Review (ApplicationID, EmployerID, StudentID, Rating, Comment) VALUES (?, ?, ?, ?, ?)";
        try {
            java.sql.PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, applicationId); // Thêm ApplicationID vào DB
            ps.setInt(2, employerId);
            ps.setInt(3, studentId);
            ps.setInt(4, rating);
            ps.setString(5, comment);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error insertStudentReview: " + e.getMessage());
        }
        return false;
    }

    // 2. Chủ cửa hàng đánh giá Sinh viên
    public boolean hasEmployerReviewedApplication(int applicationId) {
        String sql = "SELECT 1 FROM Employer_Review WHERE ApplicationID = ?";
        try {
            java.sql.PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, applicationId);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            System.out.println("Error hasEmployerReviewedApplication: " + e.getMessage());
        }
        return false;
    }

    public boolean insertEmployerReview(int applicationId, int studentId, int employerId, int rating, String comment) {
        String sql = "INSERT INTO Employer_Review (ApplicationID, StudentID, EmployerID, Rating, Comment) VALUES (?, ?, ?, ?, ?)";
        try {
            java.sql.PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, applicationId); // Thêm ApplicationID vào DB
            ps.setInt(2, studentId);
            ps.setInt(3, employerId);
            ps.setInt(4, rating);
            ps.setString(5, comment);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error insertEmployerReview: " + e.getMessage());
        }
        return false;
    }
}
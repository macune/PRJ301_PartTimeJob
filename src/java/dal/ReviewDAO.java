package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReviewDAO extends DBContext {

    // 1. Sinh viên đánh giá Cửa hàng (Lưu vào Employer_Review)
    public boolean hasStudentReviewedEmployer(int studentId, int employerId) {
        String sql = "SELECT 1 FROM Employer_Review WHERE StudentID = ? AND EmployerID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, employerId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.out.println("Error hasStudentReviewedEmployer: " + e.getMessage());
        }
        return false;
    }

    public boolean insertEmployerReview(int studentId, int employerId, int rating, String comment) {
        String sql = "INSERT INTO Employer_Review (StudentID, EmployerID, Rating, Comment, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, employerId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error insertEmployerReview: " + e.getMessage());
        }
        return false;
    }

    // 2. Chủ cửa hàng đánh giá Sinh viên (Lưu vào Student_Review)
    public boolean hasEmployerReviewedStudent(int employerId, int studentId) {
        String sql = "SELECT 1 FROM Student_Review WHERE EmployerID = ? AND StudentID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerId);
            ps.setInt(2, studentId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.out.println("Error hasEmployerReviewedStudent: " + e.getMessage());
        }
        return false;
    }

    public boolean insertStudentReview(int employerId, int studentId, int rating, String comment) {
        String sql = "INSERT INTO Student_Review (EmployerID, StudentID, Rating, Comment, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerId);
            ps.setInt(2, studentId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error insertStudentReview: " + e.getMessage());
        }
        return false;
    }
}
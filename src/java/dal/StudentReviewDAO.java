package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import viewmodels.ReviewDTO;

public class StudentReviewDAO extends DBContext {

    public List<ReviewDTO> getReviewsForStudent(int studentId) {
        List<ReviewDTO> list = new ArrayList<>();
        try {
            String sql = """
                         SELECT r.Rating, r.Comment, r.CreatedAt, ISNULL(e.BusinessName, a.Username) AS ReviewerName
                         FROM Student_Review r
                         JOIN Account a ON r.EmployerID = a.AccountID
                         LEFT JOIN Employer_Profile e ON r.EmployerID = e.EmployerID
                         WHERE r.StudentID = ?
                         ORDER BY r.CreatedAt DESC
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO();
                dto.setReviewerName(rs.getString("ReviewerName"));
                dto.setRating(rs.getInt("Rating"));
                dto.setComment(rs.getString("Comment"));
                dto.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("Error getReviewsForStudent: " + e.getMessage());
        }
        return list;
    }
}
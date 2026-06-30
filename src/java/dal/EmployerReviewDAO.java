package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import viewmodels.ReviewDTO;

public class EmployerReviewDAO extends DBContext {

    public List<ReviewDTO> getReviewsForEmployer(int employerId) {
        List<ReviewDTO> list = new ArrayList<>();
        try {
            String sql = """
                         SELECT r.Rating, r.Comment, r.CreatedAt, ISNULL(s.FullName, a.Username) AS ReviewerName
                         FROM Employer_Review r
                         JOIN Account a ON r.StudentID = a.AccountID
                         LEFT JOIN Student_Profile s ON r.StudentID = s.StudentID
                         WHERE r.EmployerID = ?
                         ORDER BY r.CreatedAt DESC
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerId);
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
            System.out.println("Error getReviewsForEmployer: " + e.getMessage());
        }
        return list;
    }
}
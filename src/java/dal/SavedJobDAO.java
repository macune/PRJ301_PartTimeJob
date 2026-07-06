package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.SavedJob;

public class SavedJobDAO extends DBContext {

    public boolean save(int studentID, int jobID) {
        // ĐÃ BỔ SUNG: GETDATE() để ghi nhận thời gian lưu bài
        String sql = "INSERT INTO Saved_Job (StudentID, JobID, SavedAt) VALUES (?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[SavedJobDAO.save] Error: " + e.getMessage());
        }
        return false;
    }

    public boolean unsave(int studentID, int jobID) {
        String sql = "DELETE FROM Saved_Job WHERE StudentID = ? AND JobID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[SavedJobDAO.unsave] Error: " + e.getMessage());
        }
        return false;
    }

    public boolean isSaved(int studentID, int jobID) {
        String sql = "SELECT 1 FROM Saved_Job WHERE StudentID = ? AND JobID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.out.println("[SavedJobDAO.isSaved] Error: " + e.getMessage());
        }
        return false;
    }

    public List<SavedJob> getByStudentID(int studentID) {
        List<SavedJob> list = new ArrayList<>();
        String sql = """
                     SELECT SavedID, StudentID, JobID, SavedAt 
                     FROM Saved_Job WHERE StudentID = ? ORDER BY SavedAt DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SavedJob sj = new SavedJob();
                sj.setSavedID(rs.getInt("SavedID"));
                sj.setStudentID(rs.getInt("StudentID"));
                sj.setJobID(rs.getInt("JobID"));
                sj.setSavedAt(rs.getTimestamp("SavedAt"));
                list.add(sj);
            }
        } catch (SQLException e) {
            System.out.println("[SavedJobDAO.getByStudentID] Error: " + e.getMessage());
        }
        return list;
    }
}
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Category;
import models.Employer_Profile;
import models.Job_Post;
import models.SavedJob;
import viewmodels.JobDetailDTO;

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
    
    // =====================================================================
    // HÀM LẤY CHI TIẾT CÁC CÔNG VIỆC ĐÃ LƯU
    // =====================================================================
    public List<JobDetailDTO> getSavedJobsWithDetails(int studentId) {
        List<JobDetailDTO> list = new ArrayList<>();
        String sql = """
                     SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress, sj.SavedAt 
                     FROM Saved_Job sj
                     JOIN Job_Post j ON sj.JobID = j.JobID
                     JOIN Category c ON j.CategoryID = c.CategoryID
                     JOIN Employer_Profile e ON j.EmployerID = e.EmployerID
                     WHERE sj.StudentID = ?
                     ORDER BY sj.SavedAt DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setSalary(rs.getInt("Salary"));
                job.setCity(rs.getString("City"));
                job.setWard(rs.getString("Ward"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                // Mượn field CreatedAt để chứa thời gian Lưu bài (hiển thị cho tiện)
                job.setCreatedAt(rs.getTimestamp("SavedAt"));

                Category cat = new Category();
                cat.setCategoryName(rs.getString("CategoryName"));

                Employer_Profile emp = new Employer_Profile();
                emp.setBusinessName(rs.getString("BusinessName"));
                emp.setLogoUrl(rs.getString("LogoUrl"));
                emp.setAddress(rs.getString("EmployerAddress"));

                list.add(new JobDetailDTO(job, cat, emp));
            }
        } catch (SQLException e) {
            System.out.println("[SavedJobDAO.getSavedJobsWithDetails] Error: " + e.getMessage());
        }
        return list;
    }
}
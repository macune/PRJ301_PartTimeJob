/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Application;

/**
 * DAO xử lý bảng Application
 * @author PRJ301
 */
public class ApplicationDAO extends DBContext {

    /**
     * Nộp đơn ứng tuyển mới (Status mặc định = 0: Pending)
     *
     * @param studentID    ID sinh viên
     * @param jobID        ID việc làm
     * @param desiredSalary mức lương mong muốn (VNĐ/giờ)
     * @param message      lời nhắn gửi nhà tuyển dụng
     * @return true nếu insert thành công
     */
    public boolean apply(int studentID, int jobID, int desiredSalary, String message) {
        String sql = "INSERT INTO Application (StudentID, JobID, DesiredSalary, Message) "
                + "VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            ps.setInt(3, desiredSalary);
            ps.setString(4, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.apply] " + e.getMessage());
        }
        return false;
    }

    /**
     * Kiểm tra sinh viên đã ứng tuyển vào Job này chưa
     * (DB đã có UNIQUE constraint nhưng check trước để báo lỗi thân thiện)
     *
     * @param studentID ID sinh viên
     * @param jobID     ID việc làm
     * @return true nếu đã ứng tuyển rồi
     */
    public boolean hasApplied(int studentID, int jobID) {
        String sql = "SELECT 1 FROM Application WHERE StudentID = ? AND JobID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.hasApplied] " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy danh sách tất cả đơn ứng tuyển của một sinh viên
     *
     * @param studentID ID sinh viên
     * @return List<Application>
     */
    public List<Application> getByStudentID(int studentID) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT ApplicationID, StudentID, JobID, DesiredSalary, "
                + "Message, Status, EmployerNote, AppliedAt "
                + "FROM Application WHERE StudentID = ? ORDER BY AppliedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.getByStudentID] " + e.getMessage());
        }
        return list;
    }
      public List<Application> getApplicationsByStudentId(int studentID) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.ApplicationID, a.StudentID, a.JobID, "
                + "       a.DesiredSalary, a.Message, a.Status, "
                + "       a.EmployerNote, a.AppliedAt, "
                + "       jp.Title      AS JobTitle, "
                + "       jp.City       AS JobCity, "
                + "       jp.Salary     AS JobSalary, "
                + "       jp.StartTime  AS JobStartTime, "
                + "       jp.EndTime    AS JobEndTime "
                + "FROM Application a "
                + "JOIN Job_Post jp ON a.JobID = jp.JobID "
                + "WHERE a.StudentID = ? "
                + "ORDER BY a.AppliedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application a = mapRow(rs);
                // Gắn thêm thông tin Job vào các transient field
                a.setJobTitle(rs.getString("JobTitle"));
                a.setJobCity(rs.getString("JobCity"));
                a.setJobSalary(rs.getInt("JobSalary"));
                a.setJobStartTime(rs.getString("JobStartTime"));
                a.setJobEndTime(rs.getString("JobEndTime"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.getApplicationsByStudentId] " + e.getMessage());
        }
        return list;
    }

    // -------- Helper --------
    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationID(rs.getInt("ApplicationID"));
        a.setStudentID(rs.getInt("StudentID"));
        a.setJobID(rs.getInt("JobID"));
        a.setDesiredSalary(rs.getInt("DesiredSalary"));
        a.setMessage(rs.getString("Message"));
        a.setStatus(rs.getInt("Status"));
        a.setEmployerNote(rs.getString("EmployerNote"));
        a.setAppliedAt(rs.getTimestamp("AppliedAt"));
        return a;
    }
}

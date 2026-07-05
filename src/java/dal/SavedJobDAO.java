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
import models.SavedJob;

/**
 * DAO xử lý bảng Saved_Job
 * @author PRJ301
 */
public class SavedJobDAO extends DBContext {

    /**
     * Lưu việc làm yêu thích
     * DB có UNIQUE(StudentID, JobID) nên gọi isSaved() trước để tránh lỗi
     *
     * @param studentID ID sinh viên
     * @param jobID     ID việc làm
     * @return true nếu insert thành công
     */
    public boolean save(int studentID, int jobID) {
        String sql = "INSERT INTO Saved_Job (StudentID, JobID) VALUES (?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[SavedJobDAO.save] " + e.getMessage());
        }
        return false;
    }

    /**
     * Bỏ lưu (xoá khỏi danh sách yêu thích)
     *
     * @param studentID ID sinh viên
     * @param jobID     ID việc làm
     * @return true nếu xoá thành công
     */
    public boolean unsave(int studentID, int jobID) {
        String sql = "DELETE FROM Saved_Job WHERE StudentID = ? AND JobID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[SavedJobDAO.unsave] " + e.getMessage());
        }
        return false;
    }

    /**
     * Kiểm tra sinh viên đã lưu Job này chưa
     *
     * @param studentID ID sinh viên
     * @param jobID     ID việc làm
     * @return true nếu đã lưu
     */
    public boolean isSaved(int studentID, int jobID) {
        String sql = "SELECT 1 FROM Saved_Job WHERE StudentID = ? AND JobID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[SavedJobDAO.isSaved] " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy danh sách tất cả việc làm đã lưu của sinh viên
     *
     * @param studentID ID sinh viên
     * @return List<SavedJob>
     */
    public List<SavedJob> getByStudentID(int studentID) {
        List<SavedJob> list = new ArrayList<>();
        String sql = "SELECT SavedID, StudentID, JobID, SavedAt "
                + "FROM Saved_Job WHERE StudentID = ? ORDER BY SavedAt DESC";
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
            System.err.println("[SavedJobDAO.getByStudentID] " + e.getMessage());
        }
        return list;
    }
}

package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Application;

public class ApplicationDAO extends DBContext {

    public boolean apply(int studentID, int jobID, int desiredSalary, String message) {
        // ĐÃ BỔ SUNG: GETDATE() để SQL Server tự động ghi nhận thời gian nộp đơn
        String sql = """
                     INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, AppliedAt) 
                     VALUES (?, ?, ?, ?, 0, GETDATE())
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            ps.setInt(3, desiredSalary);
            ps.setString(4, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.apply] Error: " + e.getMessage());
        }
        return false;
    }

    public boolean hasApplied(int studentID, int jobID) {
        String sql = "SELECT 1 FROM Application WHERE StudentID = ? AND JobID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ps.setInt(2, jobID);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.hasApplied] Error: " + e.getMessage());
        }
        return false;
    }

    public List<Application> getByStudentID(int studentID) {
        List<Application> list = new ArrayList<>();
        String sql = """
                    SELECT ApplicationID, StudentID, JobID, DesiredSalary, 
                    Message, Status, EmployerNote, AppliedAt 
                    FROM Application WHERE StudentID = ? ORDER BY AppliedAt DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application a = new Application();
                a.setApplicationID(rs.getInt("ApplicationID"));
                a.setStudentID(rs.getInt("StudentID"));
                a.setJobID(rs.getInt("JobID"));
                a.setDesiredSalary(rs.getInt("DesiredSalary"));
                a.setMessage(rs.getString("Message"));
                a.setStatus(rs.getInt("Status"));
                a.setEmployerNote(rs.getString("EmployerNote"));
                a.setAppliedAt(rs.getTimestamp("AppliedAt"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.getByStudentID] Error: " + e.getMessage());
        }
        return list;
    }
    
    // --- BỔ SUNG: KIỂM TRA TRÙNG GIỜ LÀM VIỆC (ĐÃ FIX LỖI LỆCH NGÀY & QUA ĐÊM) ---
    public boolean hasTimeOverlap(int studentID, java.sql.Time newStartTime, java.sql.Time newEndTime) {
        String sql = """
                     WITH Params AS (
                         SELECT CAST(? AS TIME) AS NewStart, CAST(? AS TIME) AS NewEnd, ? AS StudentID
                     )
                     SELECT TOP 1 1 
                     FROM Application a
                     JOIN Job_Post j ON a.JobID = j.JobID
                     CROSS JOIN Params p
                     WHERE a.StudentID = p.StudentID AND a.Status IN (0, 1)
                     AND (
                         -- TH1: Cả 2 ca đều làm trong ngày (VD: 05:00 - 17:00 và 12:00 - 18:00)
                         (CAST(j.StartTime AS TIME) <= CAST(j.EndTime AS TIME) AND p.NewStart <= p.NewEnd
                          AND CAST(j.StartTime AS TIME) < p.NewEnd AND CAST(j.EndTime AS TIME) > p.NewStart)
                         
                         -- TH2: Ca cũ làm qua đêm (VD: 22:00 - 06:00), Ca mới làm trong ngày
                         OR (CAST(j.StartTime AS TIME) > CAST(j.EndTime AS TIME) AND p.NewStart <= p.NewEnd
                             AND (p.NewEnd > CAST(j.StartTime AS TIME) OR p.NewStart < CAST(j.EndTime AS TIME)))
                             
                         -- TH3: Ca cũ trong ngày, Ca mới làm qua đêm
                         OR (CAST(j.StartTime AS TIME) <= CAST(j.EndTime AS TIME) AND p.NewStart > p.NewEnd
                             AND (CAST(j.EndTime AS TIME) > p.NewStart OR CAST(j.StartTime AS TIME) < p.NewEnd))
                             
                         -- TH4: Cả 2 ca đều làm qua đêm (Chắc chắn đè lên nhau ở khoảng nửa đêm)
                         OR (CAST(j.StartTime AS TIME) > CAST(j.EndTime AS TIME) AND p.NewStart > p.NewEnd)
                     )
                     """;
        try {
            java.sql.PreparedStatement ps = connection.prepareStatement(sql);
            // Lưu ý: Đã đổi lại thứ tự set tham số cho khớp với lệnh WITH ở trên
            ps.setTime(1, newStartTime);
            ps.setTime(2, newEndTime);
            ps.setInt(3, studentID);
            
            return ps.executeQuery().next(); // Có bất kỳ 1 dòng nào trả về -> Bị trùng giờ
        } catch (java.sql.SQLException e) {
            System.out.println("[ApplicationDAO.hasTimeOverlap] Error: " + e.getMessage());
        }
        return false;
    }
}
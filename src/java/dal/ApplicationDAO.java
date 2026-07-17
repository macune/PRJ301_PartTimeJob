package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import models.Application;
import models.Employer_Profile;
import models.Job_Post;
import models.Student_Profile;
import viewmodels.ApplicationDTO;
import viewmodels.StatDTO;
import viewmodels.UserActivityDTO;

public class ApplicationDAO extends DBContext {

    public boolean apply(int studentID, int jobID, int desiredSalary, String message) {
        String sql = "INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, AppliedAt) "
                   + "VALUES (?, ?, ?, ?, 0, GETDATE())";
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
        String sql = "SELECT ApplicationID, StudentID, JobID, DesiredSalary, "
                + "Message, Status, EmployerNote, AppliedAt "
                + "FROM Application WHERE StudentID = ? ORDER BY AppliedAt DESC";
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
    
    public boolean hasTimeOverlap(int studentID, Time newStartTime, Time newEndTime) {
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
                         (CAST(j.StartTime AS TIME) <= CAST(j.EndTime AS TIME) AND p.NewStart <= p.NewEnd
                          AND CAST(j.StartTime AS TIME) < p.NewEnd AND CAST(j.EndTime AS TIME) > p.NewStart)
                         OR (CAST(j.StartTime AS TIME) > CAST(j.EndTime AS TIME) AND p.NewStart <= p.NewEnd
                             AND (p.NewEnd > CAST(j.StartTime AS TIME) OR p.NewStart < CAST(j.EndTime AS TIME)))
                         OR (CAST(j.StartTime AS TIME) <= CAST(j.EndTime AS TIME) AND p.NewStart > p.NewEnd
                             AND (CAST(j.EndTime AS TIME) > p.NewStart OR CAST(j.StartTime AS TIME) < p.NewEnd))
                         OR (CAST(j.StartTime AS TIME) > CAST(j.EndTime AS TIME) AND p.NewStart > p.NewEnd)
                     )
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setTime(1, newStartTime);
            ps.setTime(2, newEndTime);
            ps.setInt(3, studentID);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.hasTimeOverlap] Error: " + e.getMessage());
        }
        return false;
    }

    // =====================================================================
    // CÁC HÀM DÀNH CHO NHÀ TUYỂN DỤNG (EMPLOYER)
    // =====================================================================
    
    public List<ApplicationDTO> getApplicationsByJobId(int jobId) {
        List<ApplicationDTO> list = new ArrayList<>();
        // ĐÃ BỔ SUNG: ContactEmail, Address, Introduction
        String sql = """
                     SELECT a.ApplicationID, a.StudentID, a.JobID, a.DesiredSalary, a.Message, a.Status, a.EmployerNote, a.AppliedAt,
                            s.FullName, s.Phone, s.University, s.Experience, s.AverageRating,
                            s.ContactEmail, s.Address, s.Introduction
                     FROM Application a
                     JOIN Student_Profile s ON a.StudentID = s.StudentID
                     WHERE a.JobID = ?
                     ORDER BY a.AppliedAt ASC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, jobId);
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

                Student_Profile sp = new Student_Profile();
                sp.setStudentId(rs.getInt("StudentID"));
                sp.setFullName(rs.getString("FullName"));
                sp.setPhone(rs.getString("Phone"));
                sp.setUniversity(rs.getString("University"));
                sp.setExperience(rs.getString("Experience"));
                sp.setAverageRating(rs.getDouble("AverageRating"));
                
                // Đã Mapping các trường mới
                sp.setContactEmail(rs.getString("ContactEmail"));
                sp.setAddress(rs.getString("Address"));
                sp.setIntroduction(rs.getString("Introduction"));

                list.add(new ApplicationDTO(a, sp));
            }
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.getApplicationsByJobId] Error: " + e.getMessage());
        }
        return list;
    }
    
    // =====================================================================
    // HÀM RÚT/HỦY ĐƠN ỨNG TUYỂN KHI ĐANG CHỜ DUYỆT (STATUS = 0)
    // =====================================================================
    public boolean deletePendingApplication(int applicationId, int studentId) {
        String sql = "DELETE FROM Application WHERE ApplicationID = ? AND StudentID = ? AND Status = 0";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, applicationId);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deletePendingApplication: " + e.getMessage());
        }
        return false;
    }

    public boolean updateApplicationStatus(int applicationId, int status, String employerNote, int employerId) {
        String sql = """
                     UPDATE Application 
                     SET Status = ?, EmployerNote = ? 
                     WHERE ApplicationID = ? 
                     AND JobID IN (SELECT JobID FROM Job_Post WHERE EmployerID = ?)
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setString(2, employerNote);
            ps.setInt(3, applicationId);
            ps.setInt(4, employerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.updateApplicationStatus] Error: " + e.getMessage());
        }
        return false;
    }
    
    // =====================================================================
    // HÀM LẤY DANH SÁCH NHÂN SỰ ĐÃ ĐƯỢC DUYỆT (HR MANAGEMENT)
    // =====================================================================
    public List<ApplicationDTO> getAcceptedApplicationsByEmployerId(int employerId) {
        List<ApplicationDTO> list = new ArrayList<>();
        String sql = """
                     SELECT a.ApplicationID, a.StudentID, a.JobID, a.DesiredSalary, a.Message, a.Status, a.EmployerNote, a.AppliedAt,
                            s.FullName, s.Phone, s.University, s.Experience, s.AverageRating,
                            s.ContactEmail, s.Address, s.Introduction,
                            j.Title AS JobTitle, j.Salary AS BaseSalary, j.StartTime, j.EndTime,
                            j.DetailAddress AS JobDetailAddress, j.Ward AS JobWard, j.City AS JobCity
                     FROM Application a
                     JOIN Student_Profile s ON a.StudentID = s.StudentID
                     JOIN Job_Post j ON a.JobID = j.JobID
                     WHERE j.EmployerID = ? AND a.Status = 1
                     ORDER BY a.AppliedAt DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application a = new Application();
                a.setApplicationID(rs.getInt("ApplicationID"));
                a.setStudentID(rs.getInt("StudentID"));
                a.setJobID(rs.getInt("JobID"));
                
                int desired = rs.getInt("DesiredSalary");
                a.setDesiredSalary(desired > 0 ? desired : rs.getInt("BaseSalary"));
                
                a.setMessage(rs.getString("Message"));
                a.setStatus(rs.getInt("Status"));
                a.setEmployerNote(rs.getString("EmployerNote"));
                a.setAppliedAt(rs.getTimestamp("AppliedAt"));

                Student_Profile sp = new Student_Profile();
                sp.setStudentId(rs.getInt("StudentID"));
                sp.setFullName(rs.getString("FullName"));
                sp.setPhone(rs.getString("Phone"));
                sp.setUniversity(rs.getString("University"));
                sp.setExperience(rs.getString("Experience"));
                sp.setAverageRating(rs.getDouble("AverageRating"));
                sp.setContactEmail(rs.getString("ContactEmail"));
                sp.setAddress(rs.getString("Address"));
                sp.setIntroduction(rs.getString("Introduction"));

                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("JobTitle"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setDetailAddress(rs.getString("JobDetailAddress"));
                job.setWard(rs.getString("JobWard"));
                job.setCity(rs.getString("JobCity"));

                list.add(new ApplicationDTO(a, sp, job));
            }
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.getAcceptedApplications] Error: " + e.getMessage());
        }
        return list;
    }
    
    // =====================================================================
    // HÀM DÀNH CHO SINH VIÊN: XEM LỊCH SỬ ỨNG TUYỂN & ĐÁNH GIÁ
    // =====================================================================
    public List<ApplicationDTO> getApplicationHistoryByStudentId(int studentId) {
        List<ApplicationDTO> list = new ArrayList<>();
        String sql = """
                     SELECT a.ApplicationID, a.StudentID, a.JobID, a.DesiredSalary, a.Message, a.Status, a.EmployerNote, a.AppliedAt,
                            j.Title AS JobTitle, j.City AS JobCity, j.Ward AS JobWard, j.DetailAddress AS JobDetailAddress, j.Salary AS JobSalary, j.StartTime, j.EndTime,
                            e.EmployerID, e.BusinessName, e.Phone AS EmployerPhone,
                            sr.Rating AS ReviewRating, sr.Comment AS ReviewComment
                     FROM Application a
                     JOIN Job_Post j ON a.JobID = j.JobID
                     JOIN Employer_Profile e ON j.EmployerID = e.EmployerID
                     LEFT JOIN Student_Review sr ON a.ApplicationID = sr.ApplicationID
                     WHERE a.StudentID = ?
                     ORDER BY a.AppliedAt DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, studentId);
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

                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("JobTitle"));
                job.setCity(rs.getString("JobCity"));
                job.setWard(rs.getString("JobWard"));
                job.setDetailAddress(rs.getString("JobDetailAddress"));
                job.setSalary(rs.getInt("JobSalary"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));

                Employer_Profile emp = new Employer_Profile();
                emp.setEmployerId(rs.getInt("EmployerID")); 
                emp.setBusinessName(rs.getString("BusinessName"));
                emp.setPhone(rs.getString("EmployerPhone"));

                ApplicationDTO dto = new ApplicationDTO(a, job, emp);
                
                // Lấy dữ liệu Review nếu có
                int rating = rs.getInt("ReviewRating");
                if (!rs.wasNull()) { // Nếu có đánh giá
                    dto.setIsReviewed(true);
                    dto.setReviewRating(rating);
                    dto.setReviewComment(rs.getString("ReviewComment"));
                } else {
                    dto.setIsReviewed(false);
                }
                
                list.add(dto);
            }
        } catch (SQLException e) {
            System.out.println("[ApplicationDAO.getApplicationHistory] Error: " + e.getMessage());
        }
        return list;
    }
    
    // =====================================================================
    // HÀM THỐNG KÊ CHO ADMIN DASHBOARD 
    // =====================================================================
    public int getTotalApplications() {
        String sql = "SELECT COUNT(ApplicationID) FROM Application";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {}
        return 0;
    }

    public List<StatDTO> getApplicationStatsByStatus() {
        List<StatDTO> list = new ArrayList<>();
        int pending = 0, accepted = 0, rejected = 0, finished = 0; // Thêm finished

        String sql = "SELECT Status, COUNT(ApplicationID) AS Total FROM Application GROUP BY Status";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int status = rs.getInt("Status");
                int count = rs.getInt("Total");
                if (status == 0) pending = count;
                else if (status == 1) accepted = count;
                else if (status == 2) rejected = count;
                else if (status == 3) finished = count; // Bắt thêm Status = 3
            }
        } catch (SQLException e) {
            System.out.println("Error getApplicationStatsByStatus: " + e.getMessage());
        }
        
        // Add vào list theo thứ tự
        list.add(new StatDTO("Đang chờ", pending));
        list.add(new StatDTO("Chấp nhận", accepted));
        list.add(new StatDTO("Từ chối", rejected));
        list.add(new StatDTO("Đã kết thúc", finished)); // Thêm dòng này

        return list;
    }
    
    public List<UserActivityDTO> getStudentActivities() {
        List<UserActivityDTO> list = new ArrayList<>();
        String sql = """
                     SELECT s.StudentID, s.FullName, s.Phone, 
                            COUNT(a.ApplicationID) as Total 
                     FROM Student_Profile s 
                     JOIN Application a ON s.StudentID = a.StudentID 
                     WHERE a.Status IN (1, 3) 
                     GROUP BY s.StudentID, s.FullName, s.Phone 
                     ORDER BY Total DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserActivityDTO dto = new UserActivityDTO();
                dto.setUserId(rs.getInt("StudentID"));
                dto.setUserName(rs.getString("FullName"));
                dto.setContactInfo(rs.getString("Phone"));
                dto.setTotalCount(rs.getInt("Total"));
                
                // Lấy chi tiết công việc
                List<String> details = new ArrayList<>();
                String sql2 = "SELECT j.Title, e.BusinessName FROM Application a JOIN Job_Post j ON a.JobID = j.JobID JOIN Employer_Profile e ON j.EmployerID = e.EmployerID WHERE a.StudentID = ? AND a.Status IN (1, 3)";
                PreparedStatement ps2 = connection.prepareStatement(sql2);
                ps2.setInt(1, dto.getUserId());
                ResultSet rs2 = ps2.executeQuery();
                while(rs2.next()) {
                    details.add(rs2.getString("Title") + " (Tại: " + rs2.getString("BusinessName") + ")");
                }
                dto.setDetails(details);

                // Lấy danh sách Review đánh giá Sinh viên này
                List<String> reviews = new ArrayList<>();
                String sqlRev = "SELECT Rating, Comment FROM Employer_Review WHERE StudentID = ?";
                PreparedStatement psRev = connection.prepareStatement(sqlRev);
                psRev.setInt(1, dto.getUserId());
                ResultSet rsRev = psRev.executeQuery();
                while(rsRev.next()) {
                    reviews.add("⭐ " + rsRev.getInt("Rating") + "/5: " + rsRev.getString("Comment"));
                }
                dto.setReviews(reviews);

                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("Error getStudentActivities: " + e.getMessage());
        }
        return list;
    }
    
    // =====================================================================
    // HÀM XỬ LÝ XIN NGHỈ / SA THẢI (STATUS = 3)
    // =====================================================================
    public boolean updateStatusToFinished(int applicationId, int actorId, String role, String reason) {
        // Gắn tiền tố để phân biệt ai là người ghi chú
        String prefix = role.equals("STUDENT") ? "[SV Xin nghỉ] " : "[NTD Cho nghỉ] ";
        String finalNote = prefix + reason;
        
        String sql = "";
        if (role.equals("STUDENT")) {
            // Xác thực đúng Sinh viên đó mới được xin nghỉ
            sql = "UPDATE Application SET Status = 3, EmployerNote = ? WHERE ApplicationID = ? AND StudentID = ?";
        } else {
            // Xác thực đúng NTD sở hữu bài đăng đó mới được cho nghỉ
            sql = "UPDATE Application SET Status = 3, EmployerNote = ? WHERE ApplicationID = ? AND JobID IN (SELECT JobID FROM Job_Post WHERE EmployerID = ?)";
        }
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, finalNote);
            ps.setInt(2, applicationId);
            ps.setInt(3, actorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateStatusToFinished: " + e.getMessage());
        }
        return false;
    }
    
    // =====================================================================
    // HÀM LẤY LỊCH SỬ NHÂN SỰ ĐÃ NGHỈ (STATUS = 3) CHO EMPLOYER
    // =====================================================================
    public List<ApplicationDTO> getHRHistoryByEmployerId(int employerId) {
        List<ApplicationDTO> list = new ArrayList<>();
        String sql = """
                     SELECT a.ApplicationID, a.StudentID, a.JobID, a.DesiredSalary, a.Message, a.Status, a.EmployerNote, a.AppliedAt,
                            s.FullName, s.Phone, s.University, s.Experience, s.AverageRating,
                            s.ContactEmail, s.Address, s.Introduction,
                            j.Title AS JobTitle, j.Salary AS BaseSalary, j.StartTime, j.EndTime,
                            j.DetailAddress AS JobDetailAddress, j.Ward AS JobWard, j.City AS JobCity,
                            er.Rating AS ReviewRating, er.Comment AS ReviewComment
                     FROM Application a
                     JOIN Student_Profile s ON a.StudentID = s.StudentID
                     JOIN Job_Post j ON a.JobID = j.JobID
                     LEFT JOIN Employer_Review er ON a.ApplicationID = er.ApplicationID
                     WHERE j.EmployerID = ? AND a.Status = 3
                     ORDER BY a.AppliedAt DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application a = new Application();
                a.setApplicationID(rs.getInt("ApplicationID"));
                a.setStudentID(rs.getInt("StudentID"));
                a.setJobID(rs.getInt("JobID"));
                
                int desired = rs.getInt("DesiredSalary");
                a.setDesiredSalary(desired > 0 ? desired : rs.getInt("BaseSalary"));
                
                a.setMessage(rs.getString("Message"));
                a.setStatus(rs.getInt("Status"));
                a.setEmployerNote(rs.getString("EmployerNote")); 
                a.setAppliedAt(rs.getTimestamp("AppliedAt"));

                Student_Profile sp = new Student_Profile();
                sp.setStudentId(rs.getInt("StudentID"));
                sp.setFullName(rs.getString("FullName"));
                sp.setPhone(rs.getString("Phone"));
                sp.setUniversity(rs.getString("University"));
                sp.setExperience(rs.getString("Experience"));
                sp.setAverageRating(rs.getDouble("AverageRating"));
                sp.setContactEmail(rs.getString("ContactEmail"));

                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("JobTitle"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setDetailAddress(rs.getString("JobDetailAddress"));
                job.setWard(rs.getString("JobWard"));
                job.setCity(rs.getString("JobCity"));

                ApplicationDTO dto = new ApplicationDTO(a, sp, job);
                
                // Lấy dữ liệu Review nếu có
                int rating = rs.getInt("ReviewRating");
                if (!rs.wasNull()) {
                    dto.setIsReviewed(true);
                    dto.setReviewRating(rating);
                    dto.setReviewComment(rs.getString("ReviewComment"));
                } else {
                    dto.setIsReviewed(false);
                }

                list.add(dto);
            }
        } catch (SQLException e) {}
        return list;
    }

    public boolean hasPendingApplicationsByJob(int jobId) {
        String sql = "SELECT TOP 1 1 FROM Application WHERE JobID = ? AND Status = 0";
        try {
            java.sql.PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, jobId);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true; // Có ít nhất 1 đơn đang chờ
            }
        } catch (Exception e) {
            System.out.println("Error hasPendingApplicationsByJob: " + e.getMessage());
        }
        return false; // Không có đơn nào chờ
    }
    
    
}
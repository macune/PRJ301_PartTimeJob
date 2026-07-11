package dal;

import models.Category;
import models.Employer_Profile;
import models.Job_Post;
import viewmodels.JobDetailDTO; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import viewmodels.StatDTO;
import viewmodels.UserActivityDTO;


public class JobDAO extends DBContext {

    private String safeFormatTime(String timeStr) {
        if (timeStr == null || timeStr.trim().isEmpty()) return null;
        try {
            String st = timeStr.trim();
            if (st.length() == 5) {
                st += ":00"; 
            }
            Time.valueOf(st); 
            return st;
        } catch (Exception e) {
            return null;
        }
    }

    public int getTotalJobs() {
        String sql = """
                     SELECT COUNT(j.JobID) 
                     FROM Job_Post j
                     JOIN Category c ON j.CategoryID = c.CategoryID
                     WHERE j.Status = 1 AND c.Status = 1
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error getTotalJobs: " + e.getMessage());
        }
        return 0;
    }

    public List<JobDetailDTO> getAllJobs(int pageIndex, int pageSize) {
        List<JobDetailDTO> list = new ArrayList<>();
        String sql = """
                     SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress 
                     FROM Job_Post j 
                     JOIN Category c ON j.CategoryID = c.CategoryID 
                     JOIN Employer_Profile e ON j.EmployerID = e.EmployerID 
                     WHERE j.Status = 1 AND c.Status = 1
                     ORDER BY j.JobID DESC 
                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, (pageIndex - 1) * pageSize);
            st.setInt(2, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setSalary(rs.getInt("Salary"));
                job.setCity(rs.getString("City"));
                job.setWard(rs.getString("Ward"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setCreatedAt(rs.getTimestamp("CreatedAt"));

                Category cat = new Category();
                cat.setCategoryName(rs.getString("CategoryName"));

                Employer_Profile emp = new Employer_Profile();
                emp.setBusinessName(rs.getString("BusinessName"));
                emp.setLogoUrl(rs.getString("LogoUrl"));
                emp.setAddress(rs.getString("EmployerAddress"));

                list.add(new JobDetailDTO(job, cat, emp));
            }
        } catch (Exception e) {
            System.out.println("Error getAllJobs: " + e.getMessage());
        }
        return list;
    }

    public int countSearchJobs(String categoryId, String city, String ward, String startTime, String endTime) {
        StringBuilder sql = new StringBuilder("""
                                             SELECT COUNT(j.JobID) 
                                             FROM Job_Post j
                                             JOIN Category c ON j.CategoryID = c.CategoryID
                                             WHERE j.Status = 1 AND c.Status = 1
                                             """);
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            try {
                sql.append(" AND j.CategoryID = ? ");
                params.add(Integer.parseInt(categoryId.trim()));
            } catch (Exception e) {}
        }
        
        if (city != null && !city.trim().isEmpty()) {
            sql.append(" AND j.City LIKE ? ");
            params.add("%" + city.trim() + "%");
        }
        
        if (ward != null && !ward.trim().isEmpty()) {
            sql.append(" AND j.Ward LIKE ? ");
            params.add("%" + ward.trim() + "%");
        }
        
        String pStartTime = safeFormatTime(startTime);
        String pEndTime = safeFormatTime(endTime);

        if (pStartTime != null && pEndTime != null) {
            if (pStartTime.compareTo(pEndTime) <= 0) {
                sql.append(" AND j.StartTime <= j.EndTime "); 
                sql.append(" AND j.StartTime >= CAST(? AS TIME) ");
                sql.append(" AND j.EndTime <= CAST(? AS TIME) ");
                params.add(pStartTime);
                params.add(pEndTime);
            } else {
                sql.append(" AND (j.StartTime >= CAST(? AS TIME) OR j.StartTime <= CAST(? AS TIME)) ");
                sql.append(" AND (j.EndTime >= CAST(? AS TIME) OR j.EndTime <= CAST(? AS TIME)) ");
                params.add(pStartTime);
                params.add(pEndTime);
                params.add(pStartTime);
                params.add(pEndTime);
            }
        } else if (pStartTime != null) {
            sql.append(" AND j.StartTime >= CAST(? AS TIME) ");
            params.add(pStartTime);
        } else if (pEndTime != null) {
            sql.append(" AND j.EndTime <= CAST(? AS TIME) ");
            params.add(pEndTime);
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error countSearchJobs: " + e.getMessage());
        }
        return 0;
    }

    public List<JobDetailDTO> searchJobs(String categoryId, String city, String ward, String startTime, String endTime, int pageIndex, int pageSize) {
        List<JobDetailDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                                             SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress 
                                             FROM Job_Post j 
                                             JOIN Category c ON j.CategoryID = c.CategoryID 
                                             JOIN Employer_Profile e ON j.EmployerID = e.EmployerID 
                                             WHERE j.Status = 1 AND c.Status = 1
                                             """);
        
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            try {
                sql.append(" AND j.CategoryID = ? ");
                params.add(Integer.parseInt(categoryId.trim()));
            } catch (Exception e) {}
        }
        
        if (city != null && !city.trim().isEmpty()) {
            sql.append(" AND j.City LIKE ? ");
            params.add("%" + city.trim() + "%");
        }
        
        if (ward != null && !ward.trim().isEmpty()) {
            sql.append(" AND j.Ward LIKE ? ");
            params.add("%" + ward.trim() + "%");
        }
        
        String pStartTime = safeFormatTime(startTime);
        String pEndTime = safeFormatTime(endTime);

        if (pStartTime != null && pEndTime != null) {
            if (pStartTime.compareTo(pEndTime) <= 0) {
                sql.append(" AND j.StartTime <= j.EndTime "); 
                sql.append(" AND j.StartTime >= CAST(? AS TIME) ");
                sql.append(" AND j.EndTime <= CAST(? AS TIME) ");
                params.add(pStartTime);
                params.add(pEndTime);
            } else {
                sql.append(" AND (j.StartTime >= CAST(? AS TIME) OR j.StartTime <= CAST(? AS TIME)) ");
                sql.append(" AND (j.EndTime >= CAST(? AS TIME) OR j.EndTime <= CAST(? AS TIME)) ");
                params.add(pStartTime);
                params.add(pEndTime);
                params.add(pStartTime);
                params.add(pEndTime);
            }
        } else if (pStartTime != null) {
            sql.append(" AND j.StartTime >= CAST(? AS TIME) ");
            params.add(pStartTime);
        } else if (pEndTime != null) {
            sql.append(" AND j.EndTime <= CAST(? AS TIME) ");
            params.add(pEndTime);
        }

        sql.append(" ORDER BY j.JobID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;
            for (Object param : params) {
                st.setObject(index++, param);
            }
            st.setInt(index++, (pageIndex - 1) * pageSize);
            st.setInt(index, pageSize);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setSalary(rs.getInt("Salary"));
                job.setCity(rs.getString("City"));
                job.setWard(rs.getString("Ward"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setCreatedAt(rs.getTimestamp("CreatedAt"));

                Category cat = new Category();
                cat.setCategoryName(rs.getString("CategoryName"));

                Employer_Profile emp = new Employer_Profile();
                emp.setBusinessName(rs.getString("BusinessName"));
                emp.setLogoUrl(rs.getString("LogoUrl"));
                emp.setAddress(rs.getString("EmployerAddress"));

                list.add(new JobDetailDTO(job, cat, emp));
            }
        } catch (Exception e) {
            System.out.println("Error searchJobs: " + e.getMessage());
        }
        return list;
    }

    public JobDetailDTO getJobById(int id) {
        String sql = """
                     SELECT j.*, c.CategoryName, 
                            e.EmployerID, e.BusinessName, e.Phone, e.ContactEmail, 
                            e.Address AS EmployerAddress, e.Description AS EmployerDescription, 
                            e.AverageRating, e.LogoUrl, e.Website 
                     FROM Job_Post j 
                     JOIN Category c ON j.CategoryID = c.CategoryID 
                     JOIN Employer_Profile e ON j.EmployerID = e.EmployerID 
                     WHERE j.JobID = ? AND c.Status = 1
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setDescription(rs.getString("Description")); 
                job.setSalary(rs.getInt("Salary"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setCity(rs.getString("City"));
                job.setWard(rs.getString("Ward"));
                job.setDetailAddress(rs.getString("DetailAddress"));
                job.setCreatedAt(rs.getTimestamp("CreatedAt"));
                job.setStatus(rs.getInt("Status"));

                Category cat = new Category();
                cat.setCategoryName(rs.getString("CategoryName"));

                Employer_Profile emp = new Employer_Profile();
                emp.setEmployerId(rs.getInt("EmployerID"));
                emp.setBusinessName(rs.getString("BusinessName"));
                emp.setPhone(rs.getString("Phone"));
                emp.setContactEmail(rs.getString("ContactEmail"));
                emp.setAddress(rs.getString("EmployerAddress"));
                emp.setDescription(rs.getString("EmployerDescription")); 
                emp.setAverageRating(rs.getDouble("AverageRating"));
                emp.setLogoUrl(rs.getString("LogoUrl"));
                emp.setWebsite(rs.getString("Website"));

                return new JobDetailDTO(job, cat, emp);
            }
        } catch (Exception e) {
            System.out.println("Error getJobById: " + e.getMessage());
        }
        return null;
    }
    
    public List<JobDetailDTO> getJobsByEmployerId(int employerId) {
        List<JobDetailDTO> list = new ArrayList<>();
        String sql = """
                     SELECT j.*, c.CategoryName 
                     FROM Job_Post j 
                     JOIN Category c ON j.CategoryID = c.CategoryID 
                     WHERE j.EmployerID = ?
                     ORDER BY j.CreatedAt DESC
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, employerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setSalary(rs.getInt("Salary"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setStatus(rs.getInt("Status"));
                job.setCreatedAt(rs.getTimestamp("CreatedAt"));

                Category cat = new Category();
                cat.setCategoryName(rs.getString("CategoryName"));
                cat.setCategoryId(rs.getInt("CategoryID"));

                list.add(new JobDetailDTO(job, cat, null)); 
            }
        } catch (Exception e) {
            System.out.println("Error getJobsByEmployerId: " + e.getMessage());
        }
        return list;
    }

    public boolean insertJob(Job_Post job) {
        String sql = """
                     INSERT INTO Job_Post (EmployerID, CategoryID, Title, Description, Salary, StartTime, EndTime, City, Ward, DetailAddress, Status)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, job.getEmployerId());
            st.setInt(2, job.getCategoryId());
            st.setString(3, job.getTitle());
            st.setString(4, job.getDescription());
            st.setInt(5, job.getSalary());
            st.setTime(6, job.getStartTime());
            st.setTime(7, job.getEndTime());
            st.setString(8, job.getCity());
            st.setString(9, job.getWard());
            st.setString(10, job.getDetailAddress());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error insertJob: " + e.getMessage());
        }
        return false;
    }

    public boolean updateJob(Job_Post job) {
        String sql = """
                     UPDATE Job_Post 
                     SET CategoryID=?, Title=?, Description=?, Salary=?, 
                         StartTime=?, EndTime=?, City=?, Ward=?, DetailAddress=?, 
                         Status=0 
                     WHERE JobID=? AND EmployerID=?
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, job.getCategoryId());
            st.setString(2, job.getTitle());
            st.setString(3, job.getDescription());
            st.setInt(4, job.getSalary());
            st.setTime(5, job.getStartTime());
            st.setTime(6, job.getEndTime());
            st.setString(7, job.getCity());
            st.setString(8, job.getWard());
            st.setString(9, job.getDetailAddress());
            
            // Điều kiện WHERE
            st.setInt(10, job.getJobId());
            st.setInt(11, job.getEmployerId()); // Check bảo mật: chỉ chủ sở hữu mới sửa được
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateJob: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateJobStatus(int jobId, int employerId, int status) {
         String sql = "UPDATE Job_Post SET Status = ? WHERE JobID = ? AND EmployerID = ?";
         try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, jobId);
            st.setInt(3, employerId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateJobStatus: " + e.getMessage());
        }
        return false;
    }
    
    public List<JobDetailDTO> getPendingJobs() {
        List<JobDetailDTO> list = new ArrayList<>();
        String sql = """
                     SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress 
                     FROM Job_Post j 
                     JOIN Category c ON j.CategoryID = c.CategoryID 
                     JOIN Employer_Profile e ON j.EmployerID = e.EmployerID 
                     WHERE j.Status = 0
                     ORDER BY j.CreatedAt ASC
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Job_Post job = new Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setDescription(rs.getString("Description")); 
                job.setSalary(rs.getInt("Salary"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setCity(rs.getString("City"));               
                job.setWard(rs.getString("Ward"));               
                job.setDetailAddress(rs.getString("DetailAddress")); 
                job.setCreatedAt(rs.getTimestamp("CreatedAt"));
                job.setStatus(rs.getInt("Status"));

                Category cat = new Category();
                cat.setCategoryName(rs.getString("CategoryName"));

                Employer_Profile emp = new Employer_Profile();
                emp.setBusinessName(rs.getString("BusinessName"));

                list.add(new JobDetailDTO(job, cat, emp));
            }
        } catch (Exception e) {
            System.out.println("Error getPendingJobs: " + e.getMessage());
        }
        return list;
    }

    public boolean updateJobStatusByAdmin(int jobId, int status) {
        String sql = "UPDATE Job_Post SET Status = ? WHERE JobID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, jobId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateJobStatusByAdmin: " + e.getMessage());
        }
        return false;
    }
    
    // =====================================================================
    // HÀM THỐNG KÊ CHO ADMIN DASHBOARD 
    // =====================================================================
    public int countAllJobs() {
        String sql = "SELECT COUNT(JobID) FROM Job_Post";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }

    public List<StatDTO> getJobStatsByCategory() {
        List<StatDTO> list = new ArrayList<>();
        String sql = """
                     SELECT c.CategoryName, COUNT(j.JobID) AS Total
                     FROM Category c
                     LEFT JOIN Job_Post j ON c.CategoryID = j.CategoryID
                     GROUP BY c.CategoryName
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new StatDTO(rs.getString("CategoryName"), rs.getInt("Total")));
            }
        } catch (Exception e) {}
        return list;
    }
    
    public int countPendingJobs() {
        String sql = "SELECT COUNT(JobID) FROM Job_Post WHERE Status = 0";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }
    
    public List<UserActivityDTO> getEmployerActivities() {
        List<UserActivityDTO> list = new ArrayList<>();
        String sql = """
                     SELECT e.EmployerID, e.BusinessName, e.Phone, 
                            COUNT(DISTINCT j.JobID) as TotalJobs, 
                            COUNT(DISTINCT CASE WHEN a.Status = 1 THEN a.ApplicationID ELSE NULL END) as ActiveEmployees 
                     FROM Employer_Profile e 
                     JOIN Job_Post j ON e.EmployerID = j.EmployerID 
                     LEFT JOIN Application a ON j.JobID = a.JobID 
                     GROUP BY e.EmployerID, e.BusinessName, e.Phone 
                     ORDER BY TotalJobs DESC
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserActivityDTO dto = new UserActivityDTO();
                dto.setUserId(rs.getInt("EmployerID"));
                dto.setUserName(rs.getString("BusinessName"));
                dto.setContactInfo(rs.getString("Phone"));
                dto.setTotalCount(rs.getInt("TotalJobs"));
                dto.setActiveEmployeesCount(rs.getInt("ActiveEmployees"));
                
                // Lấy chi tiết bài đăng
                List<String> details = new ArrayList<>();
                String sql2 = "SELECT Title, Status FROM Job_Post WHERE EmployerID = ?";
                PreparedStatement ps2 = connection.prepareStatement(sql2);
                ps2.setInt(1, dto.getUserId());
                ResultSet rs2 = ps2.executeQuery();
                while(rs2.next()) {
                    int st = rs2.getInt("Status");
                    String stStr = (st == 1) ? "Đã duyệt" : ((st == 0) ? "Chờ duyệt" : "Từ chối/Ẩn");
                    details.add(rs2.getString("Title") + " [" + stStr + "]");
                }
                dto.setDetails(details);

                // Lấy danh sách Review đánh giá Doanh nghiệp này
                List<String> reviews = new ArrayList<>();
                String sqlRev = "SELECT Rating, Comment FROM Employer_Review WHERE EmployerID = ?";
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
            System.out.println("Error getEmployerActivities: " + e.getMessage());
        }
        return list;
    }
    public List<JobDetailDTO> getAdminJobsByStatus(int status) {
        List<JobDetailDTO> list = new ArrayList<>();
        String sql = "SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress " +
                     "FROM Job_Post j " +
                     "JOIN Category c ON j.CategoryID = c.CategoryID " +
                     "JOIN Employer_Profile e ON j.EmployerID = e.EmployerID " +
                     "WHERE j.Status = ? " +
                     "ORDER BY j.CreatedAt DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                models.Job_Post job = new models.Job_Post();
                job.setJobId(rs.getInt("JobID"));
                job.setTitle(rs.getString("Title"));
                job.setDescription(rs.getString("Description")); 
                job.setSalary(rs.getInt("Salary"));
                job.setStartTime(rs.getTime("StartTime"));
                job.setEndTime(rs.getTime("EndTime"));
                job.setCity(rs.getString("City"));               
                job.setWard(rs.getString("Ward"));               
                job.setDetailAddress(rs.getString("DetailAddress")); 
                job.setCreatedAt(rs.getTimestamp("CreatedAt"));
                job.setStatus(rs.getInt("Status"));

                models.Category cat = new models.Category();
                cat.setCategoryName(rs.getString("CategoryName"));

                models.Employer_Profile emp = new models.Employer_Profile();
                emp.setBusinessName(rs.getString("BusinessName"));

                list.add(new JobDetailDTO(job, cat, emp));
            }
        } catch (Exception e) {}
        return list;
    }
}
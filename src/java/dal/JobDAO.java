package dal;

import models.Category;
import models.Employer_Profile;
import models.Job_Post;
import viewmodels.JobDetailDTO; 

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class JobDAO extends DBContext {

    // =====================================================================
    // HÀM TIỆN ÍCH: CHUẨN HÓA CHUỖI THỜI GIAN
    // =====================================================================
    private String safeFormatTime(String timeStr) {
        if (timeStr == null || timeStr.trim().isEmpty()) return null;
        try {
            String st = timeStr.trim();
            if (st.length() == 5) {
                st += ":00"; 
            }
            java.sql.Time.valueOf(st); 
            return st;
        } catch (Exception e) {
            return null;
        }
    }

    public int getTotalJobs() {
        String sql = """
                     SELECT COUNT(*) 
                     FROM Job_Post 
                     WHERE Status = 1
                     """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
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
                     WHERE j.Status = 1 
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
            e.printStackTrace();
        }
        return list;
    }

    public int countSearchJobs(String categoryId, String city, String ward, String startTime, String endTime) {
        StringBuilder sql = new StringBuilder("""
                                             SELECT COUNT(*) 
                                             FROM Job_Post 
                                             WHERE Status = 1
                                             """);
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            try {
                sql.append(" AND CategoryID = ? ");
                params.add(Integer.parseInt(categoryId.trim()));
            } catch (Exception e) {}
        }
        
        if (city != null && !city.trim().isEmpty()) {
            sql.append(" AND City LIKE ? ");
            params.add("%" + city.trim() + "%");
        }
        
        if (ward != null && !ward.trim().isEmpty()) {
            sql.append(" AND Ward LIKE ? ");
            params.add("%" + ward.trim() + "%");
        }
        
        // --- LOGIC XỬ LÝ LỌC THỜI GIAN THÔNG MINH ---
        String pStartTime = safeFormatTime(startTime);
        String pEndTime = safeFormatTime(endTime);

        if (pStartTime != null && pEndTime != null) {
            // Nếu người dùng tìm kiếm ca trong ngày (VD: 19:00 -> 22:00)
            if (pStartTime.compareTo(pEndTime) <= 0) {
                sql.append(" AND StartTime <= EndTime "); // Loại bỏ triệt để các ca qua đêm (như 22:00 -> 06:00)
                sql.append(" AND StartTime >= CAST(? AS TIME) ");
                sql.append(" AND EndTime <= CAST(? AS TIME) ");
                params.add(pStartTime);
                params.add(pEndTime);
            } 
            // Nếu người dùng cố tình tìm ca rảnh qua đêm (VD: 22:00 -> 06:00)
            else {
                sql.append(" AND (StartTime >= CAST(? AS TIME) OR StartTime <= CAST(? AS TIME)) ");
                sql.append(" AND (EndTime >= CAST(? AS TIME) OR EndTime <= CAST(? AS TIME)) ");
                params.add(pStartTime);
                params.add(pEndTime);
                params.add(pStartTime);
                params.add(pEndTime);
            }
        } else if (pStartTime != null) {
            sql.append(" AND StartTime >= CAST(? AS TIME) ");
            params.add(pStartTime);
        } else if (pEndTime != null) {
            sql.append(" AND EndTime <= CAST(? AS TIME) ");
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
            e.printStackTrace();
        }
        return 0;
    }

    // =====================================================================
    // HÀM LẤY DANH SÁCH (CÓ LỌC)
    // =====================================================================
    public List<JobDetailDTO> searchJobs(String categoryId, String city, String ward, String startTime, String endTime, int pageIndex, int pageSize) {
        List<JobDetailDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                                             SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress 
                                             FROM Job_Post j 
                                             JOIN Category c ON j.CategoryID = c.CategoryID 
                                             JOIN Employer_Profile e ON j.EmployerID = e.EmployerID 
                                             WHERE j.Status = 1
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
        
        // --- LOGIC XỬ LÝ LỌC THỜI GIAN THÔNG MINH ---
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
            e.printStackTrace();
        }
        return list;
    }

    public JobDetailDTO getJobById(int id) {
        String sql = """
                     SELECT j.*, c.CategoryName, e.* FROM Job_Post j 
                     JOIN Category c ON j.CategoryID = c.CategoryID 
                     JOIN Employer_Profile e ON j.EmployerID = e.EmployerID 
                     WHERE j.JobID = ?
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
                emp.setAddress(rs.getString("Address"));
                emp.setDescription(rs.getString("Description"));
                emp.setAverageRating(rs.getDouble("AverageRating"));

                return new JobDetailDTO(job, cat, emp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
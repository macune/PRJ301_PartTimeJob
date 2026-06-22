package dal;

import models.Category;
import models.Employer_Profile;
import models.Job_Post;
import viewmodels.JobDetailViewModel;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class JobDAO extends DBContext {

    public int getTotalJobs() {
        String sql = "SELECT COUNT(*) FROM Job_Post WHERE Status = 1";
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

    public List<JobDetailViewModel> getAllJobs(int pageIndex, int pageSize) {
        List<JobDetailViewModel> list = new ArrayList<>();
        String sql = "SELECT j.*, c.CategoryName, e.BusinessName, e.LogoUrl, e.Address AS EmployerAddress " +
                     "FROM Job_Post j " +
                     "JOIN Category c ON j.CategoryID = c.CategoryID " +
                     "JOIN Employer_Profile e ON j.EmployerID = e.EmployerID " +
                     "WHERE j.Status = 1 " +
                     "ORDER BY j.CreatedAt DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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

                list.add(new JobDetailViewModel(job, cat, emp));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public JobDetailViewModel getJobById(int id) {
        String sql = "SELECT j.*, c.CategoryName, e.* " +
                     "FROM Job_Post j " +
                     "JOIN Category c ON j.CategoryID = c.CategoryID " +
                     "JOIN Employer_Profile e ON j.EmployerID = e.EmployerID " +
                     "WHERE j.JobID = ?";
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

                return new JobDetailViewModel(job, cat, emp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
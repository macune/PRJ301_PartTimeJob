package models;

import java.sql.Time;
import java.sql.Timestamp;

public class Job_Post {
    private int jobId;
    private int employerId;
    private int categoryId;
    private String title;
    private String description;
    private int salary;
    private Time startTime;
    private Time endTime;
    private String city;
    private String ward;
    private String detailAddress;
    private int status;
    private Timestamp createdAt;

    public Job_Post() {
    }

    public Job_Post(int jobId, int employerId, int categoryId, String title, String description, int salary, Time startTime, Time endTime, String city, String ward, String detailAddress, int status, Timestamp createdAt) {
        this.jobId = jobId;
        this.employerId = employerId;
        this.categoryId = categoryId;
        this.title = title;
        this.description = description;
        this.salary = salary;
        this.startTime = startTime;
        this.endTime = endTime;
        this.city = city;
        this.ward = ward;
        this.detailAddress = detailAddress;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }
    public int getEmployerId() { return employerId; }
    public void setEmployerId(int employerId) { this.employerId = employerId; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getSalary() { return salary; }
    public void setSalary(int salary) { this.salary = salary; }
    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }
    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }
    public String getDetailAddress() { return detailAddress; }
    public void setDetailAddress(String detailAddress) { this.detailAddress = detailAddress; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
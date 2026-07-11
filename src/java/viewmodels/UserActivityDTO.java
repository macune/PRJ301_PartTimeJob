package viewmodels;

import java.util.List;

public class UserActivityDTO {
    private int userId;
    private String userName;
    private String contactInfo;
    private int totalCount;
    private int activeEmployeesCount; 
    private List<String> details; 
    private List<String> reviews; // BIẾN MỚI: Chứa danh sách các đánh giá

    public UserActivityDTO() {}

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    
    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    
    public int getActiveEmployeesCount() { return activeEmployeesCount; }
    public void setActiveEmployeesCount(int activeEmployeesCount) { this.activeEmployeesCount = activeEmployeesCount; }
    
    public List<String> getDetails() { return details; }
    public void setDetails(List<String> details) { this.details = details; }

    // GETTER & SETTER CHO REVIEWS
    public List<String> getReviews() { return reviews; }
    public void setReviews(List<String> reviews) { this.reviews = reviews; }
}
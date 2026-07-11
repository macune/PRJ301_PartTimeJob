package viewmodels;

import java.util.List;

public class UserActivityDTO {
    private int userId;
    private String userName;
    private String contactInfo;
    private int totalCount;
    private int activeEmployeesCount; // Biến mới: Chứa số sinh viên đang làm việc
    private List<String> details; 

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
}
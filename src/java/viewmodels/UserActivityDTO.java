package viewmodels;

import java.util.List;

public class UserActivityDTO {
    private int userId;
    private String userName;
    private String contactInfo;
    private int totalCount;
    private List<String> details; // Chứa danh sách các công việc chi tiết

    public UserActivityDTO() {}

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    public List<String> getDetails() { return details; }
    public void setDetails(List<String> details) { this.details = details; }
}
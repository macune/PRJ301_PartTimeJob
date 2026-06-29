package models;

public class Student_Profile {
    private int studentID;
    private String fullName;
    private String avatarUrl;
    private String contactEmail;
    private String phone;
    private String address;
    private String university;
    private String introduction;
    private String experience;
    private double averageRating;

    public Student_Profile() {}

    public Student_Profile(int studentID, String fullName, String avatarUrl, String contactEmail, String phone, String address, String university, String introduction, String experience, double averageRating) {
        this.studentID = studentID;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
        this.contactEmail = contactEmail;
        this.phone = phone;
        this.address = address;
        this.university = university;
        this.introduction = introduction;
        this.experience = experience;
        this.averageRating = averageRating;
    }

    public int getStudentId() { return studentID; }
    public void setStudentId(int studentID) { this.studentID = studentID; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }
    public String getIntroduction() { return introduction; }
    public void setIntroduction(String introduction) { this.introduction = introduction; }
    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }
    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
}
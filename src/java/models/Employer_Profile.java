package models;

public class Employer_Profile {
    private int employerId;
    private String businessName;
    private String logoUrl;
    private String website;
    private String phone;
    private String contactEmail;
    private String address;
    private String description;
    private double averageRating;

    public Employer_Profile() {}

    public Employer_Profile(int employerId, String businessName, String logoUrl, String website, String phone, String contactEmail, String address, String description, double averageRating) {
        this.employerId = employerId;
        this.businessName = businessName;
        this.logoUrl = logoUrl;
        this.website = website;
        this.phone = phone;
        this.contactEmail = contactEmail;
        this.address = address;
        this.description = description;
        this.averageRating = averageRating;
    }

    public int getEmployerId() { return employerId; }
    public void setEmployerId(int employerId) { this.employerId = employerId; }
    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }
    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }
    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
}
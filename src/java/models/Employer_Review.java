package models;

import java.sql.Timestamp;

public class Employer_Review {
    private int employerReviewId;
    private int applicationId; // THAY ĐỔI: Sử dụng ApplicationID
    private int studentId;
    private int employerId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public Employer_Review() {
    }

    public Employer_Review(int employerReviewId, int applicationId, int studentId, int employerId, int rating, String comment, Timestamp createdAt) {
        this.employerReviewId = employerReviewId;
        this.applicationId = applicationId;
        this.studentId = studentId;
        this.employerId = employerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getEmployerReviewId() {
        return employerReviewId;
    }

    public void setEmployerReviewId(int employerReviewId) {
        this.employerReviewId = employerReviewId;
    }

    // GETTER SETTER MỚI
    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getEmployerId() {
        return employerId;
    }

    public void setEmployerId(int employerId) {
        this.employerId = employerId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
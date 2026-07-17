package models;

import java.sql.Timestamp;

public class Student_Review {
    private int studentReviewId;
    private int applicationId; // THAY ĐỔI: Sử dụng ApplicationID
    private int employerId;
    private int studentId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public Student_Review() {
    }

    public Student_Review(int studentReviewId, int applicationId, int employerId, int studentId, int rating, String comment, Timestamp createdAt) {
        this.studentReviewId = studentReviewId;
        this.applicationId = applicationId;
        this.employerId = employerId;
        this.studentId = studentId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getStudentReviewId() {
        return studentReviewId;
    }

    public void setStudentReviewId(int studentReviewId) {
        this.studentReviewId = studentReviewId;
    }

    // GETTER SETTER MỚI
    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public int getEmployerId() {
        return employerId;
    }

    public void setEmployerId(int employerId) {
        this.employerId = employerId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
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
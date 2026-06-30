package viewmodels;

import java.sql.Timestamp;

public class ReviewDTO {
    private String reviewerName;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public ReviewDTO() {}

    public ReviewDTO(String reviewerName, int rating, String comment, Timestamp createdAt) {
        this.reviewerName = reviewerName;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
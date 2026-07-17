package viewmodels;

import java.util.List;
import models.Application;
import models.Student_Profile;
import models.Job_Post;
import models.Employer_Profile;

public class ApplicationDTO {
    private Application application;
    private Student_Profile student;
    private Job_Post job; 
    private Employer_Profile employer; // Bổ sung thêm Employer
    private List<ReviewDTO> reviews;
    private boolean isReviewed;
    private int reviewRating;
    private String reviewComment;

    public ApplicationDTO() {}

    public ApplicationDTO(Application application, Student_Profile student) {
        this.application = application;
        this.student = student;
    }

    public ApplicationDTO(Application application, Student_Profile student, Job_Post job) {
        this.application = application;
        this.student = student;
        this.job = job;
    }
    
    public ApplicationDTO(Application application, Job_Post job, Employer_Profile employer) {
        this.application = application;
        this.job = job;
        this.employer = employer;
    }

    public Application getApplication() { return application; }
    public void setApplication(Application application) { this.application = application; }
    public Student_Profile getStudent() { return student; }
    public void setStudent(Student_Profile student) { this.student = student; }
    public Job_Post getJob() { return job; }
    public void setJob(Job_Post job) { this.job = job; }
    public Employer_Profile getEmployer() { return employer; }
    public void setEmployer(Employer_Profile employer) { this.employer = employer; }
    public List<ReviewDTO> getReviews() {return reviews;}
    public void setReviews(List<ReviewDTO> reviews) {this.reviews = reviews;}
    public boolean getIsReviewed() { return isReviewed; }
    public void setIsReviewed(boolean isReviewed) { this.isReviewed = isReviewed; }
    public int getReviewRating() {return reviewRating;}
    public void setReviewRating(int reviewRating) {this.reviewRating = reviewRating;}
    public String getReviewComment() {return reviewComment;}
    public void setReviewComment(String reviewComment) {this.reviewComment = reviewComment;}
}

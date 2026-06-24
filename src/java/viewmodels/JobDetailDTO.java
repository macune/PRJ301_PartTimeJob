package viewmodels;

import models.Category;
import models.Employer_Profile;
import models.Job_Post;

public class JobDetailDTO {
    private Job_Post job;
    private Category category;
    private Employer_Profile employer;

    public JobDetailDTO(Job_Post job, Category category, Employer_Profile employer) {
        this.job = job;
        this.category = category;
        this.employer = employer;
    }

    public Job_Post getJob() { return job; }
    public void setJob(Job_Post job) { this.job = job; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public Employer_Profile getEmployer() { return employer; }
    public void setEmployer(Employer_Profile employer) { this.employer = employer; }
}
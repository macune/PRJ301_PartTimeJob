package viewmodels;

import models.Application;
import models.Student_Profile;
import models.Job_Post;

public class ApplicationDTO {
    private Application application;
    private Student_Profile student;
    private Job_Post job; // Bổ sung thêm Job để hiện tên công việc

    public ApplicationDTO(Application application, Student_Profile student) {
        this.application = application;
        this.student = student;
    }

    // Constructor mới có thêm Job_Post
    public ApplicationDTO(Application application, Student_Profile student, Job_Post job) {
        this.application = application;
        this.student = student;
        this.job = job;
    }

    public Application getApplication() { return application; }
    public void setApplication(Application application) { this.application = application; }
    public Student_Profile getStudent() { return student; }
    public void setStudent(Student_Profile student) { this.student = student; }
    public Job_Post getJob() { return job; }
    public void setJob(Job_Post job) { this.job = job; }
}
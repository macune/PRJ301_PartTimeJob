package viewmodels;

import models.Application;
import models.Student_Profile;

public class ApplicationDTO {
    private Application application;
    private Student_Profile student;

    public ApplicationDTO(Application application, Student_Profile student) {
        this.application = application;
        this.student = student;
    }

    public Application getApplication() { return application; }
    public void setApplication(Application application) { this.application = application; }
    public Student_Profile getStudent() { return student; }
    public void setStudent(Student_Profile student) { this.student = student; }
}
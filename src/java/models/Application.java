/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.util.Date;

public class Application {

    private int applicationID;
    private int studentID;
    private int jobID;
    private int desiredSalary;
    private String message;
    private int status;         // 0=Pending, 1=Accepted, 2=Rejected
    private String employerNote;
    private Date appliedAt;

    // -------- Constructors --------
    public Application() {}

    public Application(int applicationID, int studentID, int jobID,
            int desiredSalary, String message, int status,
            String employerNote, Date appliedAt) {
        this.applicationID = applicationID;
        this.studentID     = studentID;
        this.jobID         = jobID;
        this.desiredSalary = desiredSalary;
        this.message       = message;
        this.status        = status;
        this.employerNote  = employerNote;
        this.appliedAt     = appliedAt;
    }

    // -------- Getters & Setters --------
    public int getApplicationID() { return applicationID; }
    public void setApplicationID(int applicationID) { this.applicationID = applicationID; }

    public int getStudentID() { return studentID; }
    public void setStudentID(int studentID) { this.studentID = studentID; }

    public int getJobID() { return jobID; }
    public void setJobID(int jobID) { this.jobID = jobID; }

    public int getDesiredSalary() { return desiredSalary; }
    public void setDesiredSalary(int desiredSalary) { this.desiredSalary = desiredSalary; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getEmployerNote() { return employerNote; }
    public void setEmployerNote(String employerNote) { this.employerNote = employerNote; }

    public Date getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Date appliedAt) { this.appliedAt = appliedAt; }

    /** Tiện ích: trả về label text cho Status */
    public String getStatusLabel() {
        switch (status) {
            case 0: return "Đang chờ";
            case 1: return "Chấp nhận";
            case 2: return "Từ chối";
            default: return "Không xác định";
        }
    }

    @Override
    public String toString() {
        return "Application{applicationID=" + applicationID
                + ", studentID=" + studentID
                + ", jobID=" + jobID
                + ", status=" + status + "}";
    }
}

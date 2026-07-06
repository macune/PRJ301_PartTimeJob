/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.util.Date;

/**
 * Model ánh xạ bảng Saved_Job
 * @author PRJ301
 */
public class SavedJob {

    private int savedID;
    private int studentID;
    private int jobID;
    private Date savedAt;

    // -------- Constructors --------
    public SavedJob() {}

    public SavedJob(int savedID, int studentID, int jobID, Date savedAt) {
        this.savedID   = savedID;
        this.studentID = studentID;
        this.jobID     = jobID;
        this.savedAt   = savedAt;
    }

    // -------- Getters & Setters --------
    public int getSavedID() { return savedID; }
    public void setSavedID(int savedID) { this.savedID = savedID; }

    public int getStudentID() { return studentID; }
    public void setStudentID(int studentID) { this.studentID = studentID; }

    public int getJobID() { return jobID; }
    public void setJobID(int jobID) { this.jobID = jobID; }

    public Date getSavedAt() { return savedAt; }
    public void setSavedAt(Date savedAt) { this.savedAt = savedAt; }

    @Override
    public String toString() {
        return "SavedJob{savedID=" + savedID
                + ", studentID=" + studentID
                + ", jobID=" + jobID + "}";
    }
}

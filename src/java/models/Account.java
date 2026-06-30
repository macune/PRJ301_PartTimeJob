package models;

import java.util.Date;

public class Account {
    private int accountId;
    private String username;
    private String email;
    private String password;
    private int role;   
    private int status; 
    private Date createdAt;
    private int isDeleted; 

    public Account() {}

    public Account(int accountId, String username, String email, String password,
                   int role, int status, Date createdAt, int isDeleted) {
        this.accountId = accountId;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
        this.isDeleted = isDeleted;
    }

    public int getAccountId() { return accountId; }
    public void setAccountId(int accountId) { this.accountId = accountId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }
    
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public int getIsDeleted() { return isDeleted; }
    public void setIsDeleted(int isDeleted) { this.isDeleted = isDeleted; }
}
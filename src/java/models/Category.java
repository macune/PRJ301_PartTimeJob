package models;

public class Category {
    private int categoryId;
    private String categoryName;
    private int status;

    public Category() {}

    public Category(int categoryId, String categoryName, int status) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.status = status;
    }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}
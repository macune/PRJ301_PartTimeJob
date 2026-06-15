CREATE DATABASE PartTimeJobsDB

USE PartTimeJobsDB

-- ==========================================
-- NHÓM 1: TÀI KHOẢN & HỒ SƠ
-- ==========================================

-- 1. Bảng Account (Tài khoản)
CREATE TABLE Account (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role INT NOT NULL, -- 1: Admin, 2: Student, 3: Employer
    Status INT DEFAULT 1 -- 1: Active, 0: Banned
);
GO

-- 2. Bảng Student_Profile (Hồ sơ Sinh viên)
CREATE TABLE Student_Profile (
    StudentID INT PRIMARY KEY FOREIGN KEY REFERENCES Account(AccountID),
    FullName NVARCHAR(100) NOT NULL,
    AvatarUrl VARCHAR(MAX),
    ContactEmail VARCHAR(100),
    Phone VARCHAR(20),
    Address NVARCHAR(255),
    University NVARCHAR(100),
    Introduction NVARCHAR(MAX),
    Experience NVARCHAR(MAX),
    AverageRating FLOAT DEFAULT 0 -- Điểm đánh giá trung bình
);
GO

-- 3. Bảng Employer_Profile (Hồ sơ Nhà tuyển dụng)
CREATE TABLE Employer_Profile (
    EmployerID INT PRIMARY KEY FOREIGN KEY REFERENCES Account(AccountID),
    BusinessName NVARCHAR(255) NOT NULL,
    LogoUrl VARCHAR(MAX),
    Website VARCHAR(255),
    Phone VARCHAR(20),
    ContactEmail VARCHAR(100),
    Address NVARCHAR(255),
    Description NVARCHAR(MAX),
    AverageRating FLOAT DEFAULT 0 -- Điểm đánh giá trung bình
);
GO

-- ==========================================
-- NHÓM 2: VIỆC LÀM & DANH MỤC
-- ==========================================

-- 4. Bảng Category (Danh mục ngành nghề)
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Status INT DEFAULT 1 -- 1: Active, 0: Hidden
);
GO

-- 5. Bảng Job_Post (Bài đăng tuyển dụng)
CREATE TABLE Job_Post (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Salary NVARCHAR(100),
    WorkingTime NVARCHAR(255),
    WorkingLocation NVARCHAR(255),
    Status INT DEFAULT 0, -- 0: Pending, 1: Approved, 2: Rejected, 3: Closed
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- ==========================================
-- NHÓM 3: TƯƠNG TÁC & ĐÁNH GIÁ
-- ==========================================

-- 6. Bảng Application (Đơn ứng tuyển)
CREATE TABLE Application (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Student_Profile(StudentID),
    JobID INT FOREIGN KEY REFERENCES Job_Post(JobID),
    Message NVARCHAR(MAX), -- Lời nhắn/Lịch rảnh của sinh viên
    Status INT DEFAULT 0, -- 0: Pending, 1: Accepted, 2: Rejected
    EmployerNote NVARCHAR(MAX), -- Phản hồi từ chủ quán
    AppliedAt DATETIME DEFAULT GETDATE()
);
GO

-- 7. Bảng Saved_Job (Việc làm đã lưu)
CREATE TABLE Saved_Job (
    SavedID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Student_Profile(StudentID),
    JobID INT FOREIGN KEY REFERENCES Job_Post(JobID),
    SavedAt DATETIME DEFAULT GETDATE()
);
GO

-- 8. Bảng Student_Review (Cửa hàng đánh giá Sinh viên)
CREATE TABLE Student_Review (
    StudentReviewID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    StudentID INT FOREIGN KEY REFERENCES Student_Profile(StudentID),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 9. Bảng Employer_Review (Sinh viên đánh giá Cửa hàng)
CREATE TABLE Employer_Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Student_Profile(StudentID),
    EmployerID INT FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- ==========================================
-- NHÓM 4: TRIGGER TỰ ĐỘNG TÍNH ĐIỂM
-- ==========================================

-- Trigger 1: Tính điểm cho Employer
CREATE TRIGGER trg_UpdateEmployerRating
ON Employer_Review
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Employer_Profile
    SET AverageRating = ISNULL((
        SELECT ROUND(AVG(CAST(Rating AS FLOAT)), 1)
        FROM Employer_Review
        WHERE Employer_Review.EmployerID = Employer_Profile.EmployerID
    ), 0)
    WHERE EmployerID IN (SELECT EmployerID FROM inserted UNION SELECT EmployerID FROM deleted);
END;
GO

-- Trigger 2: Tính điểm cho Student
CREATE TRIGGER trg_UpdateStudentRating
ON Student_Review
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Student_Profile
    SET AverageRating = ISNULL((
        SELECT ROUND(AVG(CAST(Rating AS FLOAT)), 1)
        FROM Student_Review
        WHERE Student_Review.StudentID = Student_Profile.StudentID
    ), 0)
    WHERE StudentID IN (SELECT StudentID FROM inserted UNION SELECT StudentID FROM deleted);
END;
GO
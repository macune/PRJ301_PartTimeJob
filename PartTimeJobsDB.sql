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
    Role INT NOT NULL CHECK (Role IN (1, 2, 3)), -- 1: Admin, 2: Student, 3: Employer
    Status INT DEFAULT 1 CHECK (Status IN (0, 1)), -- 1: Active, 0: Banned
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. Bảng Student_Profile (Hồ sơ Sinh viên)
CREATE TABLE Student_Profile (
    StudentID INT PRIMARY KEY FOREIGN KEY REFERENCES Account(AccountID),
    FullName NVARCHAR(100) NOT NULL,
    AvatarUrl VARCHAR(MAX),
    ContactEmail VARCHAR(100),
    Phone VARCHAR(20) CHECK (Phone NOT LIKE '%[^0-9+]%'),
    Address NVARCHAR(255),
    University NVARCHAR(100),
    Introduction NVARCHAR(MAX),
    Experience NVARCHAR(MAX),
    AverageRating FLOAT DEFAULT 0 CHECK (AverageRating >= 0 AND AverageRating <= 5)
);
GO

-- 3. Bảng Employer_Profile (Hồ sơ Nhà tuyển dụng)
CREATE TABLE Employer_Profile (
    EmployerID INT PRIMARY KEY FOREIGN KEY REFERENCES Account(AccountID),
    BusinessName NVARCHAR(255) NOT NULL,
    LogoUrl VARCHAR(MAX),
    Website VARCHAR(255),
    Phone VARCHAR(20) CHECK (Phone NOT LIKE '%[^0-9+]%'),
    ContactEmail VARCHAR(100),
    Address NVARCHAR(255),
    Description NVARCHAR(MAX),
    AverageRating FLOAT DEFAULT 0 CHECK (AverageRating >= 0 AND AverageRating <= 5)
);
GO

-- ==========================================
-- NHÓM 2: VIỆC LÀM & DANH MỤC
-- ==========================================

-- 4. Bảng Category (Danh mục ngành nghề)
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) UNIQUE NOT NULL, -- Không được trùng tên danh mục
    Status INT DEFAULT 1 CHECK (Status IN (0, 1))
);
GO

-- 5. Bảng Job_Post (Bài đăng tuyển dụng)
CREATE TABLE Job_Post (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryID),
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Salary INT CHECK (Salary > 0), -- Mức lương phải lớn hơn 0
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    City NVARCHAR(100) NOT NULL,
    District NVARCHAR(100) NOT NULL,
    DetailAddress NVARCHAR(255) NOT NULL,
    Status INT DEFAULT 0 CHECK (Status IN (0, 1, 2, 3)), -- 0: Pending, 1: Approved, 2: Rejected, 3: Closed
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- ==========================================
-- NHÓM 3: TƯƠNG TÁC & ĐÁNH GIÁ
-- ==========================================

-- 6. Bảng Application (Đơn ứng tuyển)
CREATE TABLE Application (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    JobID INT NOT NULL FOREIGN KEY REFERENCES Job_Post(JobID),
    DesiredSalary INT CHECK (DesiredSalary > 0),
    Message NVARCHAR(MAX), 
    Status INT DEFAULT 0 CHECK (Status IN (0, 1, 2)), -- 0: Pending, 1: Accepted, 2: Rejected
    EmployerNote NVARCHAR(MAX), 
    AppliedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Job_Apply UNIQUE (StudentID, JobID) -- Chống spam nộp đơn
);
GO

-- 7. Bảng Saved_Job (Việc làm đã lưu)
CREATE TABLE Saved_Job (
    SavedID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    JobID INT NOT NULL FOREIGN KEY REFERENCES Job_Post(JobID),
    SavedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Job_Save UNIQUE (StudentID, JobID) -- Chống spam lưu việc
);
GO

-- 8. Bảng Student_Review (Cửa hàng đánh giá Sinh viên)
CREATE TABLE Student_Review (
    StudentReviewID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Employer_Student_Review UNIQUE (EmployerID, StudentID) -- 1 quán chỉ review 1 sinh viên 1 lần
);
GO

-- 9. Bảng Employer_Review (Sinh viên đánh giá Cửa hàng)
CREATE TABLE Employer_Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Employer_Review UNIQUE (StudentID, EmployerID) -- 1 SV chỉ review 1 quán 1 lần
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
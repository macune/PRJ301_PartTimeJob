CREATE DATABASE PartTimeJobsDB;
GO
USE PartTimeJobsDB;
GO

-- ==========================================
-- TẠO CẤU TRÚC BẢNG & TRIGGER
-- ==========================================
CREATE TABLE Account (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role INT NOT NULL CHECK (Role IN (1, 2, 3)), 
    Status INT DEFAULT 1 CHECK (Status IN (0, 1)), 
    CreatedAt DATETIME DEFAULT GETDATE()
);

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

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) UNIQUE NOT NULL, 
    Status INT DEFAULT 1 CHECK (Status IN (0, 1))
);

CREATE TABLE Job_Post (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryID),
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Salary INT CHECK (Salary > 0), 
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Ward NVARCHAR(100) NOT NULL,
    DetailAddress NVARCHAR(255) NOT NULL,
    Status INT DEFAULT 0 CHECK (Status IN (0, 1, 2, 3)), 
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Application (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    JobID INT NOT NULL FOREIGN KEY REFERENCES Job_Post(JobID),
    DesiredSalary INT CHECK (DesiredSalary > 0),
    Message NVARCHAR(MAX), 
    Status INT DEFAULT 0 CHECK (Status IN (0, 1, 2)), 
    EmployerNote NVARCHAR(MAX), 
    AppliedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Job_Apply UNIQUE (StudentID, JobID) 
);

CREATE TABLE Saved_Job (
    SavedID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    JobID INT NOT NULL FOREIGN KEY REFERENCES Job_Post(JobID),
    SavedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Job_Save UNIQUE (StudentID, JobID) 
);

CREATE TABLE Student_Review (
    StudentReviewID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Employer_Student_Review UNIQUE (EmployerID, StudentID) 
);

CREATE TABLE Employer_Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Employer_Review UNIQUE (StudentID, EmployerID) 
);
GO

CREATE TRIGGER trg_UpdateEmployerRating ON Employer_Review AFTER INSERT, UPDATE, DELETE AS
BEGIN
    UPDATE Employer_Profile SET AverageRating = ISNULL((SELECT ROUND(AVG(CAST(Rating AS FLOAT)), 1) FROM Employer_Review WHERE Employer_Review.EmployerID = Employer_Profile.EmployerID), 0) WHERE EmployerID IN (SELECT EmployerID FROM inserted UNION SELECT EmployerID FROM deleted);
END;
GO

CREATE TRIGGER trg_UpdateStudentRating ON Student_Review AFTER INSERT, UPDATE, DELETE AS
BEGIN
    UPDATE Student_Profile SET AverageRating = ISNULL((SELECT ROUND(AVG(CAST(Rating AS FLOAT)), 1) FROM Student_Review WHERE Student_Review.StudentID = Student_Profile.StudentID), 0) WHERE StudentID IN (SELECT StudentID FROM inserted UNION SELECT StudentID FROM deleted);
END;
GO

-- ==========================================
-- BƠM DỮ LIỆU CHÍNH (10-15 Data/Bảng)
-- ==========================================
INSERT INTO Account (Username, Email, Password, Role, Status) VALUES
('admin', 'admin@system.com', '123456', 1, 1),
('sv_tuan', 'tuan@student.com', '123456', 2, 1), 
('sv_mai', 'mai@student.com', '123456', 2, 1),
('sv_nam', 'nam@student.com', '123456', 2, 1),
('sv_huong', 'huong@student.com', '123456', 2, 1),
('sv_khanh', 'khanh@student.com', '123456', 2, 1),
('sv_linh', 'linh@student.com', '123456', 2, 1),
('sv_hoang', 'hoang@student.com', '123456', 2, 1),
('sv_duc', 'duc@student.com', '123456', 2, 1),
('sv_ngoc', 'ngoc@student.com', '123456', 2, 1),
('emp_highlands', 'tuyendung@highlands.vn', '123456', 3, 1),
('emp_mixue', 'tuyendung@mixue.vn', '123456', 3, 1),
('emp_circlek', 'hr@circlek.com.vn', '123456', 3, 1),
('emp_apollo', 'hr@apollo.edu.vn', '123456', 3, 1),
('emp_cgv', 'hr@cgv.vn', '123456', 3, 1),
('emp_winmart', 'tuyendung@winmart.vn', '123456', 3, 1),
('emp_katinat', 'hr@katinat.vn', '123456', 3, 1),
('emp_hasaki', 'tuyendung@hasaki.vn', '123456', 3, 1),
('emp_tocotoco', 'hr@tocotoco.vn', '123456', 3, 1);
GO

INSERT INTO Student_Profile (StudentID, FullName, Phone, Address, University, Introduction) VALUES
(2, N'Lê Minh Tuấn', '0901234567', N'Số 10, Phường Bách Khoa', N'Đại học Bách Khoa', N'Chăm chỉ, nhanh nhẹn, có xe máy đi lại.'),
(3, N'Trần Ngọc Mai', '0912345678', N'Số 5, Phường Dịch Vọng', N'Đại học FPT', N'Có kinh nghiệm pha chế 6 tháng, giao tiếp tốt.'),
(4, N'Lê Văn Nam', '0988777666', N'Số 12, Phường Cầu Diễn', N'Đại học Công Nghiệp', N'Sức khỏe tốt, có thể làm ca đêm.'),
(5, N'Phạm Thị Hương', '0977666555', N'Số 8, Phường Láng Thượng', N'Đại học Ngoại Thương', N'Tiếng Anh giao tiếp tốt IELTS 7.0, cẩn thận, tỉ mỉ.'),
(6, N'Đinh Quốc Khánh', '0911222333', N'Số 22, Phường Trung Liệt', N'Đại học Thủy Lợi', N'Hòa đồng, thích ứng nhanh với môi trường.'),
(7, N'Vũ Thùy Linh', '0922333444', N'Số 18, Phường Quan Hoa', N'Đại học Sư Phạm', N'Kinh nghiệm gia sư 2 năm, giọng nói chuẩn.'),
(8, N'Hoàng Việt', '0933444555', N'Số 9, Phường Mỹ Đình 1', N'Đại học Thương Mại', N'Nhiệt tình, có tinh thần trách nhiệm cao.'),
(9, N'Ngô Minh Đức', '0944555666', N'Số 15, Phường Thanh Xuân Nam', N'Đại học Khoa học Tự nhiên', N'Thành thạo tin học văn phòng, cẩn thận.'),
(10, N'Bùi Bích Ngọc', '0955666777', N'Số 3, Phường Khương Trung', N'Học viện Ngân Hàng', N'Kỹ năng tính toán nhanh, trung thực.');
GO

INSERT INTO Employer_Profile (EmployerID, BusinessName, Phone, Address, Description) VALUES
(11, N'Highlands Coffee', '0241112223', N'Tòa nhà HITC, Phường Dịch Vọng Hậu', N'Chuỗi cửa hàng cafe lớn, môi trường chuyên nghiệp.'),
(12, N'Mixue', '0249998887', N'Số 20, Phường Thanh Xuân Bắc', N'Cửa hàng trà sữa, kem tươi. Môi trường năng động, thân thiện.'),
(13, N'Circle K', '0245554443', N'Số 50, Phường Mai Dịch', N'Chuỗi cửa hàng tiện lợi phục vụ 24/7.'),
(14, N'Trung Tâm Anh Ngữ Apollo', '0248887776', N'Tòa nhà IPH, Phường Dịch Vọng Hậu', N'Hệ thống trung tâm đào tạo Tiếng Anh uy tín.'),
(15, N'Rạp chiếu phim CGV', '0241231231', N'Vincom Center, Phường Phạm Ngọc Thạch', N'Hệ thống rạp chiếu phim hiện đại nhất Việt Nam.'),
(16, N'Siêu thị WinMart', '0244564564', N'Số 10, Phường Nghĩa Tân', N'Chuỗi siêu thị bán lẻ quy mô lớn.'),
(17, N'Katinat Saigon Kafe', '0247897897', N'Số 5, Phường Lý Thái Tổ', N'Thương hiệu cà phê phong cách hiện đại.'),
(18, N'Mỹ phẩm Hasaki', '0243213213', N'Số 18, Phường Dịch Vọng', N'Hệ thống phân phối mỹ phẩm chính hãng.'),
(19, N'Trà sữa TocoToco', '0246546546', N'Số 99, Phường Cổ Nhuế 1', N'Trà sữa đậm vị thiên nhiên.');
GO

INSERT INTO Category (CategoryName, Status) VALUES
(N'Phục vụ', 1), (N'Pha chế', 1), (N'Thu ngân', 1), (N'Giao hàng', 1), 
(N'Bán hàng siêu thị', 1), (N'Gia sư', 1), (N'Lễ tân', 1), 
(N'Chăm sóc khách hàng', 1), (N'Kho bãi', 1), (N'Tư vấn viên', 1);
GO

INSERT INTO Job_Post (EmployerID, CategoryID, Title, Description, Salary, StartTime, EndTime, City, Ward, DetailAddress, Status) VALUES
(11, 1, N'Nhân viên phục vụ ca tối', N'Bưng bê, dọn bàn, hỗ trợ khách order.', 25000, '18:00:00', '22:30:00', N'Hà Nội', N'Phường Dịch Vọng Hậu', N'Tầng 1 Tòa nhà HITC', 1),
(12, 2, N'Pha chế trà sữa Mixue', N'Pha trà, luộc trân châu, dọn dẹp quầy.', 30000, '08:00:00', '12:00:00', N'Hà Nội', N'Phường Thanh Xuân Bắc', N'Ngõ 1 Khuất Duy Tiến', 1),
(11, 3, N'Thu ngân cuối tuần', N'Thanh toán tiền cho khách, xuất hóa đơn.', 27000, '09:00:00', '17:00:00', N'Hà Nội', N'Phường Bách Khoa', N'15 Tạ Quang Bửu', 0),
(13, 5, N'Nhân viên Circle K ca đêm', N'Sắp xếp hàng hóa, thanh toán, giữ vệ sinh.', 35000, '22:00:00', '06:00:00', N'Hà Nội', N'Phường Mai Dịch', N'Số 50 Hồ Tùng Mậu', 1),
(14, 6, N'Gia sư Tiếng Anh Giao Tiếp', N'Trợ giảng, kèm cặp học viên luyện nói.', 50000, '17:30:00', '19:30:00', N'Hà Nội', N'Phường Dịch Vọng Hậu', N'Tòa nhà IPH Xuân Thủy', 1),
(15, 7, N'Lễ tân rạp chiếu phim CGV', N'Bán vé, tư vấn phim và combo bắp nước.', 28000, '14:00:00', '22:00:00', N'Hà Nội', N'Phường Phạm Ngọc Thạch', N'Vincom Center', 1),
(16, 5, N'Nhân viên quầy rau củ WinMart', N'Cân đo, đóng gói rau củ, dọn dẹp quầy.', 24000, '07:00:00', '15:00:00', N'Hà Nội', N'Phường Nghĩa Tân', N'Số 10 Nghĩa Tân', 1),
(17, 2, N'Barista Katinat ca sáng', N'Pha chế theo chuẩn Katinat, dọn dẹp máy pha.', 35000, '06:30:00', '12:30:00', N'Hà Nội', N'Phường Lý Thái Tổ', N'Số 5 Lý Thái Tổ', 1),
(18, 10, N'Tư vấn viên mỹ phẩm Hasaki', N'Tư vấn da, giới thiệu sản phẩm cho khách.', 30000, '15:00:00', '21:00:00', N'Hà Nội', N'Phường Dịch Vọng', N'Số 18 Dịch Vọng', 1),
(19, 4, N'Shipper nội bộ TocoToco', N'Giao hàng bán kính 5km, xăng xe tự túc.', 22000, '10:00:00', '18:00:00', N'Hà Nội', N'Phường Cổ Nhuế 1', N'Số 99 Cổ Nhuế', 1),
(13, 9, N'Nhân viên kiểm kho Circle K', N'Kiểm đếm hàng hóa nhập xuất ca sáng.', 26000, '06:00:00', '14:00:00', N'Hà Nội', N'Phường Mai Dịch', N'Số 50 Hồ Tùng Mậu', 3),
(14, 8, N'Chăm sóc học viên Apollo', N'Gọi điện thoại cập nhật tình hình học tập.', 35000, '18:00:00', '21:00:00', N'Hà Nội', N'Phường Dịch Vọng Hậu', N'Tòa nhà IPH', 1),
(11, 1, N'Phục vụ Highlands ca gãy', N'Phục vụ bàn ca trưa đông khách.', 25000, '11:00:00', '15:00:00', N'Hà Nội', N'Phường Dịch Vọng Hậu', N'Tầng 1 Tòa nhà HITC', 1),
(15, 1, N'Soát vé phim CGV', N'Kiểm tra vé, dọn rạp sau suất chiếu.', 25000, '18:00:00', '23:30:00', N'Hà Nội', N'Phường Phạm Ngọc Thạch', N'Vincom Center', 1);
GO

INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, EmployerNote) VALUES
(2, 1, 25000, N'Em có thể làm full các tối.', 1, N'Đã nhận việc.'),
(3, 2, 30000, N'Em đã làm Mixue 6 tháng.', 0, NULL),
(4, 4, 35000, N'Em có thể thức đêm.', 1, N'Đến nhận đồng phục.'),
(5, 5, 55000, N'IELTS 7.0 ạ.', 1, N'Pass test kỹ năng.'),
(6, 6, 28000, N'Em thích môi trường rạp phim.', 0, NULL),
(7, 12, 35000, N'Em có kinh nghiệm sư phạm và telesale.', 1, N'Giọng nói rất chuẩn.'),
(8, 10, 25000, N'Em có xe số, rành đường.', 2, N'Đã tuyển đủ shipper.'),
(9, 11, 26000, N'Em cẩn thận, giỏi số liệu.', 0, NULL),
(10, 9, 30000, N'Em đam mê skincare.', 1, N'Đã phỏng vấn.'),
(2, 14, 25000, N'Em rảnh các buổi tối.', 0, NULL),
(3, 8, 35000, N'Em học Barista chuyên nghiệp rồi.', 0, NULL),
(4, 13, 25000, N'Nhà em gần HITC.', 2, N'Không phù hợp lịch.'),
(5, 12, 35000, N'Em muốn apply vị trí này.', 0, NULL),
(6, 7, 24000, N'Em rảnh sáng.', 1, N'Nhận việc tuần sau.'),
(7, 5, 50000, N'Em sinh viên Sư phạm Ngoại ngữ.', 0, NULL);
GO

INSERT INTO Saved_Job (StudentID, JobID) VALUES
(2, 2), (2, 5), (3, 1), (4, 6), (5, 5), (5, 7),
(6, 8), (6, 9), (7, 12), (7, 5), (8, 10), (8, 4),
(9, 11), (9, 3), (10, 9), (10, 6);
GO

INSERT INTO Student_Review (EmployerID, StudentID, Rating, Comment) VALUES
(11, 2, 5, N'Tuấn đi làm rất đúng giờ.'),
(12, 3, 4, N'Mai làm đồ uống chuẩn công thức.'),
(13, 4, 5, N'Nam khỏe, bốc vác kho ban đêm rất tốt.'),
(14, 5, 5, N'Hương phát âm chuẩn, học viên quý.'),
(15, 6, 5, N'Khánh thân thiện với khách hàng rạp.'),
(16, 7, 4, N'Linh cân rau quả thỉnh thoảng nhầm tem.'),
(18, 10, 5, N'Ngọc tư vấn khách chốt sale rất tốt.'),
(19, 8, 3, N'Việt đi giao hàng hay bị lạc.'),
(14, 7, 5, N'Linh gọi điện CSKH rất nhiệt tình.'),
(13, 9, 4, N'Đức kiểm kho ít sai sót.');
GO

INSERT INTO Employer_Review (StudentID, EmployerID, Rating, Comment) VALUES
(2, 11, 5, N'Môi trường cực kỳ chuyên nghiệp.'),
(3, 12, 4, N'Quán đông nhưng sếp vui tính.'),
(4, 13, 4, N'Ca đêm nhàn nhưng phải lau dọn nhiều.'),
(5, 14, 5, N'Trung tâm xịn xò, giáo trình chuẩn.'),
(6, 15, 5, N'Được xem phim miễn phí 1 vé/tháng.'),
(7, 16, 4, N'Siêu thị máy lạnh mát mẻ.'),
(10, 18, 5, N'Chiết khấu mỹ phẩm cho nhân viên cao.'),
(8, 19, 3, N'Không hỗ trợ tiền điện thoại gọi khách.'),
(7, 14, 5, N'Leader hướng dẫn kịch bản rất kỹ.'),
(9, 13, 4, N'Đồng phục đẹp, lương ổn định.');
GO
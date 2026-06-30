CREATE DATABASE PartTimeJobsDB;
GO
USE PartTimeJobsDB;
GO

-- ==========================================
-- 1. TẠO CẤU TRÚC BẢNG & TRIGGER
-- ==========================================
CREATE TABLE Account (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role INT NOT NULL CHECK (Role IN (1, 2, 3)), 
    Status INT DEFAULT 1 CHECK (Status IN (0, 1)), 
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsDeleted INT DEFAULT 0 CHECK (IsDeleted IN (0, 1))
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
-- 2. BƠM DỮ LIỆU ĐÃ CHUẨN HÓA
-- ==========================================

-- Thêm cột IsDeleted = 0 cho tất cả account
INSERT INTO Account (Username, Email, Password, Role, Status, IsDeleted) VALUES
('admin', 'admin@system.com', '123456', 1, 1, 0),
('stu_tuan', 'tuan@student.com', '123456', 2, 1, 0), 
('stu_mai', 'mai@student.com', '123456', 2, 1, 0),
('stu_nam', 'nam@student.com', '123456', 2, 1, 0),
('stu_huong', 'huong@student.com', '123456', 2, 1, 0),
('stu_khanh', 'khanh@student.com', '123456', 2, 1, 0),
('stu_linh', 'linh@student.com', '123456', 2, 1, 0),
('stu_viet', 'viet@student.com', '123456', 2, 1, 0),
('stu_duc', 'duc@student.com', '123456', 2, 1, 0),
('stu_ngoc', 'ngoc@student.com', '123456', 2, 1, 0),
('stu_huy', 'huy@student.com', '123456', 2, 1, 0),
('emp_highlands', 'tuyendung@highlands.vn', '123456', 3, 1, 0),
('emp_mixue', 'tuyendung@mixue.vn', '123456', 3, 1, 0),
('emp_circlek', 'hr@circlek.com.vn', '123456', 3, 1, 0),
('emp_apollo', 'hr@apollo.edu.vn', '123456', 3, 1, 0),
('emp_cgv', 'hr@cgv.vn', '123456', 3, 1, 0),
('emp_winmart', 'tuyendung@winmart.vn', '123456', 3, 1, 0),
('emp_katinat', 'hr@katinat.vn', '123456', 3, 1, 0),
('emp_hasaki', 'tuyendung@hasaki.vn', '123456', 3, 1, 0),
('emp_tocotoco', 'hr@tocotoco.vn', '123456', 3, 1, 0);
GO

INSERT INTO Student_Profile (StudentID, FullName, AvatarUrl, ContactEmail, Phone, Address, University, Introduction, Experience) VALUES
(2, N'Lê Minh Tuấn', NULL, 'tuan.leminh@gmail.com', '0901234567', N'Số 10, Ngõ 15, Đường Xuân Thủy, Phường Cầu Giấy, Hà Nội', N'Đại học Bách Khoa', N'Chăm chỉ, nhanh nhẹn, có xe máy.', N'1 năm làm phục vụ nhà hàng tiệc cưới.'),
(3, N'Trần Ngọc Mai', NULL, 'mai.tran@yahoo.com', '0912345678', N'Số 5, Hẻm 2A, Phố Trung Kính, Phường Yên Hòa, Hà Nội', N'Đại học FPT', N'Giao tiếp tốt, luôn đúng giờ.', N'6 tháng pha chế tại The Coffee House.'),
(4, N'Lê Văn Nam', NULL, 'nam.le@gmail.com', '0988777666', N'Nhà 12B, Ngách 1/2, Phố Kiều Mai, Phường Phú Diễn, Hà Nội', N'Đại học Công Nghiệp', N'Sức khỏe tốt, thức đêm được.', N'Chưa có kinh nghiệm, sẵn sàng học hỏi.'),
(5, N'Phạm Thị Hương', NULL, 'huong.pham@gmail.com', '0977666555', N'Phòng 302, Tòa B14, Khu tập thể Kim Liên, Phường Kim Liên, Hà Nội', N'Đại học Ngoại Thương', N'IELTS 7.0, tự tin giao tiếp.', N'1 năm trợ giảng tại Ocean Edu.'),
(6, N'Đinh Quốc Khánh', NULL, 'khanh.dinh@outlook.com', '0911222333', N'Số 22, Phố Khương Hạ, Phường Khương Đình, Hà Nội', N'Đại học Thủy Lợi', N'Hòa đồng, thích ứng nhanh.', N'3 tháng bán hàng part-time tại Circle K.'),
(7, N'Vũ Thùy Linh', NULL, 'linh.vu@gmail.com', '0922333444', N'Số 18, Đường Hoàng Quốc Việt, Phường Nghĩa Đô, Hà Nội', N'Đại học Sư Phạm', N'Kinh nghiệm gia sư, giọng chuẩn.', N'2 năm gia sư Toán cấp 2.'),
(8, N'Hoàng Việt', NULL, 'viet.hoang@icloud.com', '0933444555', N'Số 9, Ngõ 33, Đường Ngọc Đại, Phường Đại Mỗ, Hà Nội', N'Đại học Thương Mại', N'Nhiệt tình, có trách nhiệm.', N'Từng làm shipper nội thành 6 tháng.'),
(9, N'Ngô Minh Đức', NULL, 'duc.ngo@gmail.com', '0944555666', N'Số 15, Ngõ 328 Nguyễn Trãi, Phường Thanh Xuân, Hà Nội', N'Đại học KHTN', N'Thành thạo tin học văn phòng.', N'Hỗ trợ nhập liệu dữ liệu cho công ty IT 4 tháng.'),
(10, N'Bùi Bích Ngọc', NULL, 'ngoc.bui@gmail.com', '0955666777', N'Số 3, Ngõ 120, Phố Trương Định, Phường Tương Mai, Hà Nội', N'Học viện Ngân Hàng', N'Tính toán nhanh, trung thực.', N'Từng làm thu ngân tại siêu thị mini.'),
(11, N'Trần Quang Huy', NULL, 'huy.tran@gmail.com', '0966777888', N'Số 88, Ngõ Thổ Quan, Phố Tôn Đức Thắng, Phường Ô Chợ Dừa, Hà Nội', N'Đại học Mỹ Thuật', N'Sáng tạo, cẩn thận, biết thiết kế.', N'Làm part-time design banner quảng cáo.');
GO

INSERT INTO Employer_Profile (EmployerID, BusinessName, LogoUrl, Website, Phone, ContactEmail, Address, Description) VALUES
(12, N'Highlands Coffee', NULL, 'https://highlandscoffee.com.vn', '0241112223', 'hr@highlandscoffee.vn', N'Tầng 1, Tòa nhà HITC, 239 Xuân Thủy, Phường Cầu Giấy, Hà Nội', N'Chuỗi cửa hàng cafe lớn, lộ trình thăng tiến rõ ràng.'),
(13, N'Mixue', NULL, 'https://mixue.vn', '0249998887', 'tuyendung@mixue.vn', N'Số 20, Ngõ 1 Khuất Duy Tiến, Phường Thanh Xuân, Hà Nội', N'Trà sữa & kem tươi, môi trường gen Z cực kỳ năng động.'),
(14, N'Circle K', NULL, 'https://circlek.com.vn', '0245554443', 'hr@circlek.com.vn', N'Số 50, Phố Trần Cung, Phường Nghĩa Đô, Hà Nội', N'Cửa hàng tiện lợi 24/7, có phụ cấp ca đêm.'),
(15, N'Apollo English', NULL, 'https://apollo.edu.vn', '0248887776', 'tuyendung@apollo.edu.vn', N'Tầng 2, Tòa nhà IPH, 241 Xuân Thủy, Phường Yên Hòa, Hà Nội', N'Hệ thống đào tạo Tiếng Anh quốc tế.'),
(16, N'CGV Cinemas', NULL, 'https://cgv.vn', '0241231231', 'hr@cgv.vn', N'Tầng 6, Vincom Phạm Ngọc Thạch, Phường Kim Liên, Hà Nội', N'Hệ thống rạp phim, nhân viên được xem phim miễn phí.'),
(17, N'WinMart', NULL, 'https://winmart.vn', '0244564564', 'contact@winmart.vn', N'Lô 1A, Khu Ngoại Giao Đoàn, Phường Xuân Đỉnh, Hà Nội', N'Chuỗi siêu thị bán lẻ, có bảo hiểm cho NV.'),
(18, N'Katinat', NULL, 'https://katinat.vn', '0247897897', 'tuyendung@katinat.vn', N'Số 5, Phố Tràng Thi, Phường Cửa Nam, Hà Nội', N'Cà phê phong cách hiện đại, lương thưởng hấp dẫn.'),
(19, N'Hasaki', NULL, 'https://hasaki.vn', '0243213213', 'hr@hasaki.vn', N'Số 18, Phố Khâm Thiên, Phường Ô Chợ Dừa, Hà Nội', N'Phân phối mỹ phẩm chính hãng.'),
(20, N'TocoToco', NULL, 'https://tocotoco.vn', '0246546546', 'tuyendung@tocotoco.vn', N'Số 99, Phố Kẻ Vẽ, Phường Đông Ngạc, Hà Nội', N'Trà sữa đậm vị thiên nhiên.');
GO

INSERT INTO Category (CategoryName, Status) VALUES
(N'Phục vụ', 1), (N'Pha chế', 1), (N'Thu ngân', 1), (N'Giao hàng', 1), 
(N'Bán hàng siêu thị', 1), (N'Gia sư', 1), (N'Lễ tân', 1), 
(N'Chăm sóc khách hàng', 1), (N'Kho bãi', 1), (N'Tư vấn viên', 1);
GO

INSERT INTO Job_Post (EmployerID, CategoryID, Title, Description, Salary, StartTime, EndTime, City, Ward, DetailAddress, Status) VALUES
(12, 1, N'Nhân viên phục vụ ca tối', N'Bưng bê, dọn bàn, dọn dẹp vệ sinh cuối ca.', 25000, '18:00:00', '22:30:00', N'Hà Nội', N'Văn Miếu - Quốc Tử Giám', N'Số 10 Nguyễn Thái Học', 1),
(13, 2, N'Pha chế trà sữa Mixue', N'Luộc trân châu, pha trà, đón khách.', 30000, '08:00:00', '12:00:00', N'Hà Nội', N'Thanh Xuân', N'Số 20 Khuất Duy Tiến', 1), 
(12, 3, N'Thu ngân cuối tuần', N'Thanh toán, xuất hóa đơn, nộp tiền cuối ca.', 27000, '09:00:00', '17:00:00', N'Hà Nội', N'Bạch Mai', N'15 Tạ Quang Bửu', 0), 
(14, 5, N'Nhân viên Circle K ca đêm', N'Sắp xếp hàng, giữ vệ sinh, kiểm bill.', 35000, '22:00:00', '06:00:00', N'Hà Nội', N'Xuân Phương', N'Số 50 Hồ Tùng Mậu', 1),
(15, 6, N'Gia sư Tiếng Anh IELTS', N'Trợ giảng, kèm giao tiếp cho học viên.', 50000, '17:30:00', '19:30:00', N'Hà Nội', N'Cửa Nam', N'Tòa nhà X, Số 5 Lò Đúc', 1), 
(16, 7, N'Lễ tân rạp chiếu phim', N'Bán vé, tư vấn phim và combo bắp nước.', 28000, '14:00:00', '22:00:00', N'Hà Nội', N'Kim Liên', N'Tầng 6 Vincom', 1), 
(17, 5, N'Nhân viên rau củ WinMart', N'Cân đo, dọn dẹp quầy, lọc rau hỏng.', 24000, '07:00:00', '15:00:00', N'Hà Nội', N'Đông Ngạc', N'KĐT Ciputra, Xuân Đỉnh', 1), 
(18, 2, N'Barista Katinat ca sáng', N'Pha chế chuẩn công thức, vệ sinh máy pha.', 35000, '06:30:00', '12:30:00', N'Hà Nội', N'Tây Hồ', N'Số 8 Đường Thanh Niên', 1), 
(19, 10, N'Tư vấn viên Hasaki', N'Soi da, tư vấn sản phẩm phù hợp cho khách.', 30000, '15:00:00', '21:00:00', N'Hà Nội', N'Ô Chợ Dừa', N'Số 18 Khâm Thiên', 1), 
(20, 4, N'Shipper nội bộ TocoToco', N'Giao bán kính 5km, ứng tiền trước.', 22000, '10:00:00', '18:00:00', N'Hà Nội', N'Định Công', N'Số 99 Kim Giang', 1), 
(14, 9, N'Nhân viên kiểm kho', N'Kiểm đếm hàng hóa nhập vào đầu ca.', 26000, '06:00:00', '14:00:00', N'Hà Nội', N'Xuân Đỉnh', N'Kho tổng Phạm Văn Đồng', 3),
(15, 8, N'Telesale chăm sóc học viên', N'Gọi điện nhắc lịch học, tư vấn khóa mới.', 35000, '18:00:00', '21:00:00', N'Hà Nội', N'Yên Lãng', N'Số 10 Thái Hà', 1),
(12, 1, N'Phục vụ bàn Highlands trưa', N'Phục vụ ca gãy giờ nghỉ trưa dân văn phòng.', 25000, '11:00:00', '15:00:00', N'Hà Nội', N'Cầu Giấy', N'Tầng 1 HITC', 1),
(16, 1, N'Soát vé rạp phim cuối tuần', N'Kiểm tra vé, hướng dẫn ghế, dọn rạp.', 25000, '18:00:00', '23:00:00', N'Hà Nội', N'Kim Liên', N'Tầng 6 Vincom', 1),
(13, 3, N'Thu ngân Mixue', N'Đứng máy POS, in bill, trả tiền thừa.', 28000, '12:00:00', '18:00:00', N'Hà Nội', N'Thanh Xuân', N'Số 20 Khuất Duy Tiến', 1),
(18, 1, N'Phục vụ Katinat Tối', N'Bưng nước, dọn bàn, setup không gian.', 30000, '18:00:00', '23:30:00', N'Hà Nội', N'Tây Hồ', N'Số 8 Đường Thanh Niên', 1),
(20, 2, N'Pha chế TocoToco', N'Làm trà sữa, sinh tố theo công thức.', 25000, '14:00:00', '20:00:00', N'Hà Nội', N'Định Công', N'Số 99 Kim Giang', 0),
(19, 9, N'Soạn hàng kho Hasaki', N'Nhặt mỹ phẩm theo đơn Shopee/Lazada.', 26000, '08:00:00', '17:00:00', N'Hà Nội', N'Ô Chợ Dừa', N'Số 18 Khâm Thiên', 1);
GO

INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, EmployerNote) VALUES
(2, 1, 25000, N'Em có thể làm full tối, xe máy đi lại thoải mái.', 1, N'Đã nhận việc, bắt đầu ngày mai mang CCCD.'),
(3, 2, 30000, N'Em có kinh nghiệm 6 tháng pha trà sữa.', 0, NULL), 
(4, 4, 35000, N'Em sức khỏe rất tốt, thức đêm thoải mái.', 1, N'Đến siêu thị nhận đồng phục nhé.'),
(5, 5, 55000, N'IELTS 7.0 ạ, đã có KN trợ giảng.', 1, N'Pass test giảng dạy, lương khởi điểm 50k/h.'),
(6, 6, 28000, N'Em thích môi trường rạp, giao tiếp tốt.', 0, NULL),
(7, 12, 35000, N'Giọng chuẩn, không nói ngọng.', 1, N'Đi làm từ thứ 2 tuần sau.'),
(8, 10, 25000, N'Thuộc đường khu vực này.', 2, N'Cửa hàng đã tuyển đủ shipper bạn nhé.'),
(9, 11, 26000, N'Cẩn thận số liệu, dùng Excel tốt.', 0, NULL),
(10, 9, 30000, N'Đam mê skincare, hiểu biết thành phần.', 1, N'Giao tiếp cực tốt, nhận việc ngay.'),
(11, 16, 30000, N'Em làm được các tối trong tuần.', 0, NULL),
(2, 13, 25000, N'Nhà em gần HITC.', 1, N'Làm ca gãy 11h-15h em nhé.'),
(3, 15, 28000, N'Đã từng làm thu ngân máy POS.', 1, N'Mai qua test máy.'),
(4, 11, 26000, N'Sức khỏe tốt, bê vác được.', 2, N'Kho đã chuyển địa điểm.'),
(5, 12, 40000, N'Em có thể gọi điện chốt sale tốt.', 0, NULL),
(6, 14, 25000, N'Em rảnh các buổi tối cuối tuần.', 1, N'Duyệt, qua nhận áo CGV.'),
(7, 5, 50000, N'Sinh viên Sư phạm Ngoại ngữ.', 2, N'Đã chọn ứng viên khác.'),
(8, 4, 35000, N'Em làm đêm được.', 0, NULL),
(9, 18, 26000, N'Soạn hàng nhanh, cẩn thận.', 1, N'Đi làm sáng mai.'),
(10, 3, 27000, N'Học Ngân hàng, tính tiền không bao giờ sai.', 0, NULL),
(11, 8, 35000, N'Biết pha chế cơ bản.', 2, N'Yêu cầu kinh nghiệm 1 năm.'),
(2, 18, 25000, N'Xin làm kho phụ.', 0, NULL),
(3, 8, 35000, N'Kinh nghiệm 6 tháng Barista.', 1, N'Hẹn phỏng vấn chiều nay.'),
(4, 7, 24000, N'Rảnh các sáng.', 0, NULL),
(7, 6, 28000, N'Ngoại hình sáng, cao 1m65.', 0, NULL),
(11, 10, 22000, N'Có xe máy xịn.', 0, NULL); -- Thay (8,10) bằng (11,10) để tránh trùng lặp
GO

INSERT INTO Saved_Job (StudentID, JobID) VALUES
(2, 2), (2, 5), (3, 1), (4, 6), (5, 5), (5, 7),
(6, 8), (6, 9), (7, 12), (7, 5), (8, 10), (8, 4),
(9, 11), (9, 3), (10, 9), (10, 6), (11, 16), (11, 8),
(2, 13), (3, 15);
GO

INSERT INTO Student_Review (EmployerID, StudentID, Rating, Comment) VALUES
(12, 2, 5, N'Tuấn đi làm rất đúng giờ, dọn dẹp sạch sẽ.'),
(15, 2, 4, N'Giao tiếp khá, nhưng thỉnh thoảng xin về sớm.'),
(13, 3, 4, N'Mai làm đồ uống ngon nhưng hay nhầm lượng đường.'),
(14, 4, 5, N'Nam sức khỏe tốt, sắp đồ trong kho cực kỳ gọn gàng.'),
(15, 5, 5, N'Hương phát âm chuẩn, phụ huynh đánh giá rất cao.'),
(16, 6, 5, N'Khánh lúc nào cũng cười tươi với khách, rạp rất quý.'),
(14, 6, 3, N'Khánh làm ca đêm hay ngủ gật lúc không có khách.'),
(19, 10, 5, N'Ngọc tư vấn khách chốt sale đồ mỹ phẩm rất nhanh.'),
(17, 10, 4, N'Tính tiền chuẩn, nhưng cần hòa đồng hơn với team.'),
(20, 8, 3, N'Việt đi giao hàng hay bị lạc, hay mượn tiền quỹ.'),
(19, 9, 5, N'Đức nhặt hàng Shopee tốc độ ánh sáng, không sót món nào.'),
(18, 11, 4, N'Huy làm banner cho quán rất đẹp, pha chế ổn.'),
(12, 11, 5, N'Làm phục vụ rất lanh lẹ.'),
(15, 7, 5, N'Linh gọi điện CSKH rất nhiệt tình, chốt được nhiều khóa học.'),
(16, 7, 4, N'Soát vé cẩn thận nhưng hay dùng điện thoại trong ca.'),
(13, 5, 5, N'Bạn này nói tiếng Anh với khách Tây đỉnh lắm.'),
(14, 8, 4, N'Làm kho khá chịu khó.'),
(18, 3, 5, N'Kỹ năng pha chế Katinat xuất sắc, vệ sinh máy kỹ.');
GO

INSERT INTO Employer_Review (StudentID, EmployerID, Rating, Comment) VALUES
(2, 12, 5, N'Môi trường cực kỳ chuyên nghiệp, tips chia đều công bằng.'),
(11, 12, 4, N'Quản lý tốt nhưng quy định chấm công hơi khắt khe.'),
(3, 13, 4, N'Quán đông sếp thỉnh thoảng hơi gắt, nhưng bù lại có trà sữa free.'),
(5, 13, 5, N'Nhân viên toàn gen Z làm việc siêu vui.'),
(4, 14, 4, N'Ca đêm nhàn nhưng hay buồn ngủ, cần thêm phụ cấp đêm.'),
(6, 14, 3, N'Kho hàng hơi bụi bặm.'),
(5, 15, 5, N'Trung tâm xịn xò, đóng BHXH đầy đủ cho cả part-time.'),
(7, 15, 5, N'Lộ trình training rõ ràng, rất hữu ích.'),
(6, 16, 5, N'Được xem phim miễn phí 1 vé/tháng, môi trường sạch sẽ.'),
(7, 16, 4, N'Cuối tuần khách đông soát vé mỏi tay luôn.'),
(10, 19, 5, N'Được mua mỹ phẩm giá chiết khấu siêu hời.'),
(9, 19, 5, N'Kho sạch sẽ có điều hòa mát rượi.'),
(8, 20, 3, N'Không hỗ trợ tiền điện thoại gọi khách nhận hàng.'),
(10, 17, 4, N'Siêu thị mát mẻ nhưng quản lý hay trừ tiền đi muộn.'),
(3, 18, 5, N'Đồng phục Katinat siêu đẹp, máy pha cà phê xịn.'),
(11, 18, 4, N'Lương trả mùng 5 cực kỳ đúng hẹn.'),
(9, 14, 4, N'Lương cơ bản ổn, đồng phục đẹp.'),
(2, 15, 5, N'Đã từng học ở đây rồi vào làm luôn, rất tuyệt!');
GO
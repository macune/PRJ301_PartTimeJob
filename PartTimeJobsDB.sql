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
    Status INT DEFAULT 0 CHECK (Status IN (0, 1, 2, 3)), 
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
    ApplicationID INT NOT NULL FOREIGN KEY REFERENCES Application(ApplicationID),
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_StudentReview_Application UNIQUE (ApplicationID)
);

CREATE TABLE Employer_Review (
    EmployerReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID INT NOT NULL FOREIGN KEY REFERENCES Application(ApplicationID),
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Student_Profile(StudentID),
    EmployerID INT NOT NULL FOREIGN KEY REFERENCES Employer_Profile(EmployerID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_EmployerReview_Application UNIQUE (ApplicationID)
);
GO

CREATE TRIGGER trg_UpdateEmployerRating ON Student_Review AFTER INSERT, UPDATE, DELETE AS
BEGIN
    UPDATE Employer_Profile 
    SET AverageRating = ISNULL((SELECT ROUND(AVG(CAST(Rating AS FLOAT)), 1) FROM Student_Review WHERE Student_Review.EmployerID = Employer_Profile.EmployerID), 0) 
    WHERE EmployerID IN (SELECT EmployerID FROM inserted UNION SELECT EmployerID FROM deleted);
END;
GO

CREATE TRIGGER trg_UpdateStudentRating ON Employer_Review AFTER INSERT, UPDATE, DELETE AS
BEGIN
    UPDATE Student_Profile 
    SET AverageRating = ISNULL((SELECT ROUND(AVG(CAST(Rating AS FLOAT)), 1) FROM Employer_Review WHERE Employer_Review.StudentID = Student_Profile.StudentID), 0) 
    WHERE StudentID IN (SELECT StudentID FROM inserted UNION SELECT StudentID FROM deleted);
END;
GO

-- BƠM LẠI TOÀN BỘ DỮ LIỆU
INSERT INTO Account (Username, Email, Password, Role, Status, IsDeleted) VALUES
('admin', 'admin@system.com', '123456', 1, 1, 0),
('stu_tuan', 'tuan@student.com', '123456', 2, 1, 0), ('stu_mai', 'mai@student.com', '123456', 2, 1, 0),
('stu_nam', 'nam@student.com', '123456', 2, 1, 0), ('stu_huong', 'huong@student.com', '123456', 2, 1, 0),
('stu_khanh', 'khanh@student.com', '123456', 2, 1, 0), ('stu_linh', 'linh@student.com', '123456', 2, 1, 0),
('stu_viet', 'viet@student.com', '123456', 2, 1, 0), ('stu_duc', 'duc@student.com', '123456', 2, 1, 0),
('stu_ngoc', 'ngoc@student.com', '123456', 2, 1, 0), ('stu_huy', 'huy@student.com', '123456', 2, 1, 0),
('emp_highlands', 'tuyendung@highlands.vn', '123456', 3, 1, 0), ('emp_mixue', 'tuyendung@mixue.vn', '123456', 3, 1, 0),
('emp_circlek', 'hr@circlek.com.vn', '123456', 3, 1, 0), ('emp_apollo', 'hr@apollo.edu.vn', '123456', 3, 1, 0),
('emp_cgv', 'hr@cgv.vn', '123456', 3, 1, 0), ('emp_winmart', 'tuyendung@winmart.vn', '123456', 3, 1, 0),
('emp_katinat', 'hr@katinat.vn', '123456', 3, 1, 0), ('emp_hasaki', 'tuyendung@hasaki.vn', '123456', 3, 1, 0),
('emp_tocotoco', 'hr@tocotoco.vn', '123456', 3, 1, 0);

INSERT INTO Student_Profile (StudentID, FullName, AvatarUrl, ContactEmail, Phone, Address, University, Introduction, Experience) VALUES
(2, N'Lê Minh Tuấn', NULL, 'tuan.leminh@gmail.com', '0901234567', N'Số 10, Ngõ 15, Đường Xuân Thủy, Phường Cầu Giấy, Hà Nội', N'Đại học Bách Khoa', N'Chăm chỉ, nhanh nhẹn, có xe máy cá nhân đi lại thoải mái, sẵn sàng tăng ca lúc đông khách.', N'1 năm làm phục vụ nhà hàng tiệc cưới Hoàng Gia, chuyên chạy bàn tiệc lớn.'),
(3, N'Trần Ngọc Mai', NULL, 'mai.tran@yahoo.com', '0912345678', N'Số 5, Hẻm 2A, Phố Trung Kính, Phường Yên Hòa, Hà Nội', N'Đại học FPT', N'Giao tiếp cực tốt, luôn đúng giờ, chịu được áp lực cao từ khách hàng khó tính.', N'6 tháng làm nhân viên pha chế tại The Coffee House, biết đánh sữa latte cơ bản.'),
(4, N'Lê Văn Nam', NULL, 'nam.le@gmail.com', '0988777666', N'Nhà 12B, Ngách 1/2, Phố Kiều Mai, Phường Phú Diễn, Hà Nội', N'Đại học Công Nghiệp', N'Sức khỏe cực kỳ tốt, làm được ca đêm dài, không vướng bận lịch học các ca hành chính.', N'Chưa có nhiều kinh nghiệm nhưng sẵn sàng học hỏi, từng phụ vác đồ kho xưởng của gia đình.'),
(5, N'Phạm Thị Hương', NULL, 'huong.pham@gmail.com', '0977666555', N'Phòng 302, Tòa B14, Khu tập thể Kim Liên, Phường Kim Liên, Hà Nội', N'Đại học Ngoại Thương', N'IELTS 7.0, tự tin giao tiếp tiếng Anh với người nước ngoài mượt mà, kỹ năng thuyết trình tốt.', N'1 năm trợ giảng tại trung tâm tiếng Anh Ocean Edu, hay đứng lớp cùng giáo viên Tây.'),
(6, N'Đinh Quốc Khánh', NULL, 'khanh.dinh@outlook.com', '0911222333', N'Số 22, Phố Khương Hạ, Phường Khương Đình, Hà Nội', N'Đại học Thủy Lợi', N'Hòa đồng, thích ứng nhanh với môi trường làm việc nhóm quy mô đông, nắm bắt quy trình nhanh.', N'3 tháng bán hàng part-time tại chuỗi tiện lợi Circle K, thao tác quen thuộc với máy POS.'),
(7, N'Vũ Thùy Linh', NULL, 'linh.vu@gmail.com', '0922333444', N'Số 18, Đường Hoàng Quốc Việt, Phường Nghĩa Đô, Hà Nội', N'Đại học Sư Phạm', N'Kinh nghiệm gia sư nhiều năm, giọng nói chuẩn Hà Nội gốc, không nói ngọng L/N, kỹ năng sư phạm tốt.', N'2 năm gia sư Toán cấp 2 cho học sinh mất gốc tại nhà và làm ở trung tâm bồi dưỡng kiến thức.'),
(8, N'Hoàng Việt', NULL, 'viet.hoang@icloud.com', '0933444555', N'Số 9, Ngõ 33, Đường Ngọc Đại, Phường Đại Mỗ, Hà Nội', N'Đại học Thương Mại', N'Nhiệt tình, có tinh thần trách nhiệm cực kỳ cao trong công việc, đúng giờ, cẩn thận giấy tờ.', N'Từng làm shipper nội thành 6 tháng, thông thạo đường phố ngõ hẻm khu vực Thanh Xuân, Hà Đông.'),
(9, N'Ngô Minh Đức', NULL, 'duc.ngo@gmail.com', '0944555666', N'Số 15, Ngõ 328 Nguyễn Trãi, Phường Thanh Xuân, Hà Nội', N'Đại học KHTN', N'Thành thạo tin học văn phòng Word Excel, đánh máy siêu tốc 80WPM, cẩn thận số liệu.', N'Hỗ trợ nhập liệu dữ liệu hóa đơn chứng từ cho công ty IT trong 4 tháng dự án số hóa dữ liệu lớn.'),
(10, N'Bùi Bích Ngọc', NULL, 'ngoc.bui@gmail.com', '0955666777', N'Số 3, Ngõ 120, Phố Trương Định, Phường Tương Mai, Hà Nội', N'Học viện Ngân Hàng', N'Kỹ năng tính toán nhạy bén, trung thực tuyệt đối, cẩn thận chi li với sổ sách và tiền bạc lẻ.', N'Từng làm thu ngân tại siêu thị mini T-Mart 1 năm, xử lý tình huống đổi trả tiền xuất sắc, không bao giờ âm quỹ.'),
(11, N'Trần Quang Huy', NULL, 'huy.tran@gmail.com', '0966777888', N'Số 88, Ngõ Thổ Quan, Phố Tôn Đức Thắng, Phường Ô Chợ Dừa, Hà Nội', N'Đại học Mỹ Thuật', N'Sáng tạo, cẩn thận, yêu cái đẹp, biết thiết kế đồ họa 2D cơ bản bằng Photoshop, Illustrator.', N'Làm part-time design banner quảng cáo các chương trình khuyến mãi cho shop thời trang trên Shopee.');

INSERT INTO Employer_Profile (EmployerID, BusinessName, LogoUrl, Website, Phone, ContactEmail, Address, Description) VALUES
(12, N'Highlands Coffee', NULL, 'https://highlandscoffee.com.vn', '0241112223', 'hr@highlandscoffee.vn', N'Tầng 1, Tòa nhà HITC, 239 Xuân Thủy, Phường Cầu Giấy, Hà Nội', N'Chuỗi cửa hàng cafe lớn nhất nhì VN, quy trình đào tạo chuyên nghiệp, lộ trình thăng tiến rõ ràng cho sinh viên gắn bó lâu dài.'),
(13, N'Mixue', NULL, 'https://mixue.vn', '0249998887', 'tuyendung@mixue.vn', N'Số 20, Ngõ 1 Khuất Duy Tiến, Phường Thanh Xuân, Hà Nội', N'Thương hiệu trà sữa & kem tươi phủ sóng khắp nơi, môi trường gen Z siêu năng động, công việc nhẹ nhàng vừa sức học sinh sinh viên.'),
(14, N'Circle K', NULL, 'https://circlek.com.vn', '0245554443', 'hr@circlek.com.vn', N'Số 50, Phố Trần Cung, Phường Nghĩa Đô, Hà Nội', N'Cửa hàng tiện lợi phục vụ 24/7, luôn mở cửa không nghỉ, có phụ cấp cực tốt cho nhân viên đăng ký ca đêm hoặc các ngày lễ tết.'),
(15, N'Apollo English', NULL, 'https://apollo.edu.vn', '0248887776', 'tuyendung@apollo.edu.vn', N'Tầng 2, Tòa nhà IPH, 241 Xuân Thủy, Phường Yên Hòa, Hà Nội', N'Hệ thống đào tạo Tiếng Anh quốc tế chuẩn Châu Âu, môi trường học thuật văn minh, cơ hội tuyệt vời để trau dồi khả năng ngoại ngữ.'),
(16, N'CGV Cinemas', NULL, 'https://cgv.vn', '0241231231', 'hr@cgv.vn', N'Tầng 6, Vincom Phạm Ngọc Thạch, Phường Kim Liên, Hà Nội', N'Hệ thống rạp chiếu phim hiện đại, nhân viên được hưởng đặc quyền xem phim miễn phí hàng tháng, đồng phục được cấp phát cực đẹp.'),
(17, N'WinMart', NULL, 'https://winmart.vn', '0244564564', 'contact@winmart.vn', N'Lô 1A, Khu Ngoại Giao Đoàn, Phường Xuân Đỉnh, Hà Nội', N'Chuỗi siêu thị bán lẻ thuộc tập đoàn lớn, có đóng bảo hiểm y tế đầy đủ cho nhân viên ký HĐ từ 6 tháng, cam kết lương thưởng tháng 13.'),
(18, N'Katinat', NULL, 'https://katinat.vn', '0247897897', 'tuyendung@katinat.vn', N'Số 5, Phố Tràng Thi, Phường Cửa Nam, Hà Nội', N'Thương hiệu cà phê phong cách hiện đại đang lên ngôi mạnh mẽ, lượng khách đông đảo, cơ chế lương thưởng và tips hàng tháng rất hấp dẫn.'),
(19, N'Hasaki', NULL, 'https://hasaki.vn', '0243213213', 'hr@hasaki.vn', N'Số 18, Phố Khâm Thiên, Phường Ô Chợ Dừa, Hà Nội', N'Hệ thống phân phối mỹ phẩm chính hãng lớn nhất toàn quốc, môi trường làm việc nhiều phái đẹp, nhân viên được mua hàng giá chiết khấu nội bộ.'),
(20, N'TocoToco', NULL, 'https://tocotoco.vn', '0246546546', 'tuyendung@tocotoco.vn', N'Số 99, Phố Kẻ Vẽ, Phường Đông Ngạc, Hà Nội', N'Trà sữa đậm vị thiên nhiên, công thức pha chế độc quyền, quy trình công việc đơn giản dễ học cho người mới, hệ thống chi nhánh rộng khắp ngoại thành.');

INSERT INTO Category (CategoryName, Status) VALUES
(N'Phục vụ', 1), (N'Pha chế', 1), (N'Thu ngân', 1), (N'Giao hàng', 1), 
(N'Bán hàng siêu thị', 1), (N'Gia sư', 1), (N'Lễ tân', 1), 
(N'Chăm sóc khách hàng', 1), (N'Kho bãi', 1), (N'Tư vấn viên', 1);

INSERT INTO Job_Post (EmployerID, CategoryID, Title, Description, Salary, StartTime, EndTime, City, Ward, DetailAddress, Status) VALUES
-- Highlands (ID 12) -> ĐỦ 4 TRẠNG THÁI JOB
(12, 1, N'Phục vụ Highlands Ca Tối', N'Bưng bê nước tận bàn, dọn dẹp vệ sinh khu vực sảnh khi quán chốt ca. Yêu cầu ngoại hình sáng, nhanh nhẹn thao tác.', 25000, '18:00:00', '22:30:00', N'Hà Nội', N'Cầu Giấy', N'Tầng 1 HITC Xuân Thủy', 1), -- Job 1: Đã duyệt
(12, 1, N'Phục vụ Highlands Ca Trưa', N'Chạy ca gãy hỗ trợ giờ cao điểm nghỉ trưa của dân văn phòng. Áp lực khá cao, cần sự tập trung cao độ khi khách đông.', 26000, '12:30:00', '17:30:00', N'Hà Nội', N'Cầu Giấy', N'Tầng 1 HITC Xuân Thủy', 3), -- Job 2: Đã đóng
(12, 3, N'Thu ngân Highlands Ca Sáng', N'Đứng trực tiếp tại quầy order, thanh toán bill, nhận tiền mặt và quẹt thẻ, in hóa đơn VAT.', 27000, '08:00:00', '17:00:00', N'Hà Nội', N'Cầu Giấy', N'Tầng 1 HITC Xuân Thủy', 0), -- Job 3: Chờ duyệt (0 ĐƠN)
(12, 2, N'Pha chế Highlands Cuối Tuần', N'Làm Barista chuyên đứng máy Espresso, yêu cầu đã có kinh nghiệm trên 1 năm, biết latte art.', 35000, '07:00:00', '11:00:00', N'Hà Nội', N'Cầu Giấy', N'Tầng 1 HITC Xuân Thủy', 2), -- Job 4: Bị từ chối (0 ĐƠN)

-- CÁC CÔNG VIỆC CÒN LẠI DÙNG ĐỂ TẠO DATA ỨNG TUYỂN DÀY DẶN CHO SINH VIÊN
(13, 2, N'Pha chế Mixue Sáng', N'Công việc nhẹ nhàng: luộc trân châu theo giờ, pha chế các loại trà chanh, trà sữa, làm kem ốc quế phục vụ học sinh.', 30000, '07:00:00', '12:00:00', N'Hà Nội', N'Thanh Xuân', N'Số 20 Khuất Duy Tiến', 1), -- Job 5
(16, 7, N'Lễ tân rạp phim CGV Chiều', N'Bán vé tại quầy, tư vấn nhiệt tình cho khách chọn phim hay và up-sale thuyết phục mua thêm combo bắp nước để tăng doanh thu.', 28000, '13:00:00', '17:30:00', N'Hà Nội', N'Kim Liên', N'Tầng 6 Vincom', 1), -- Job 6
(17, 5, N'Nhân viên rau củ WinMart Sáng', N'Cân đo rau củ cho khách mua sắm, thường xuyên dọn dẹp quầy kệ, tinh mắt nhặt bỏ những phần rau hư hỏng hằng ngày.', 24000, '07:00:00', '12:00:00', N'Hà Nội', N'Đông Ngạc', N'KĐT Ciputra', 1), -- Job 7
(18, 2, N'Barista Katinat Sáng', N'Pha chế các dòng cà phê máy chuẩn theo công thức độc quyền của quán, vệ sinh máy pha espresso kỹ lưỡng sau mỗi ca.', 35000, '06:30:00', '12:30:00', N'Hà Nội', N'Tây Hồ', N'Số 8 Đường Thanh Niên', 1), -- Job 8
(19, 10, N'Tư vấn viên Hasaki Chiều', N'Sử dụng thành thạo máy soi da, phân tích tình trạng da mụn/nám và tư vấn bộ sản phẩm điều trị phù hợp cho khách nữ.', 30000, '13:00:00', '17:00:00', N'Hà Nội', N'Ô Chợ Dừa', N'Số 18 Khâm Thiên', 1), -- Job 9
(20, 4, N'Shipper Toco Sáng', N'Giao hàng nhanh chóng trong bán kính 5km, có trách nhiệm tự ứng tiền mặt trước cho hóa đơn dưới 500k của khách lẻ.', 22000, '08:00:00', '12:00:00', N'Hà Nội', N'Định Công', N'Số 99 Kim Giang', 1), -- Job 10
(14, 9, N'Nhân viên kho Circle K Đêm', N'Kiểm đếm chính xác số lượng hàng hóa nhập vào đầu ca đêm, lập biên bản báo cáo ngay nếu có hàng móp méo hỏng hóc từ nhà cung cấp.', 26000, '23:00:00', '06:00:00', N'Hà Nội', N'Xuân Đỉnh', N'Kho Phạm Văn Đồng', 1), -- Job 11
(15, 8, N'Telesale Apollo', N'Gọi điện nhắc lịch học định kỳ cho học sinh, tư vấn phụ huynh đăng ký khóa mới qua data có sẵn do marketing cung cấp.', 35000, '18:30:00', '21:30:00', N'Hà Nội', N'Yên Lãng', N'Số 10 Thái Hà', 1), -- Job 12
(16, 1, N'Soát vé CGV Tối', N'Kiểm tra mã vé cẩn thận, hướng dẫn khách dùng đèn pin tìm đúng số ghế trong rạp, dọn sạch rác thật nhanh sau mỗi suất chiếu.', 25000, '18:00:00', '22:00:00', N'Hà Nội', N'Kim Liên', N'Tầng 6 Vincom', 1), -- Job 13
(13, 3, N'Thu ngân Mixue Chiều', N'Đứng trực tiếp máy POS nhận order khách đông khu vực cổng trường, in bill nhanh, trả tiền thừa chính xác tuyệt đối không để âm quỹ.', 28000, '13:00:00', '18:00:00', N'Hà Nội', N'Thanh Xuân', N'Số 20 Khuất Duy Tiến', 1), -- Job 14
(15, 6, N'Gia sư IELTS Apollo', N'Trợ giảng trên lớp, hỗ trợ kèm cặp giao tiếp tiếng Anh riêng cho các học viên yếu kém cần phụ đạo thêm ngoài giờ chính.', 50000, '18:00:00', '20:00:00', N'Hà Nội', N'Cửa Nam', N'Số 5 Lò Đúc', 3), -- Job 15 (Closed)
(19, 9, N'Soạn kho Hasaki', N'Nhặt các mặt hàng mỹ phẩm theo đúng danh sách đơn hàng từ Shopee, đóng gói chống sốc gửi cho vận chuyển an toàn.', 26000, '08:00:00', '12:00:00', N'Hà Nội', N'Ô Chợ Dừa', N'Số 18 Khâm Thiên', 3), -- Job 16 (Closed)
(20, 2, N'Pha chế Toco Chiều', N'Làm trà sữa, sinh tố hoa quả tuân thủ nghiêm ngặt công thức đo lường đường đá của hệ thống, vệ sinh máy dập nắp cốc.', 25000, '13:00:00', '17:00:00', N'Hà Nội', N'Định Công', N'Số 99 Kim Giang', 1), -- Job 17
(18, 1, N'Phục vụ Katinat Tối', N'Bưng nước tận bàn cho khách tầng 2 tầng 3, dọn bàn nhanh chóng ngay khi khách rời đi, setup lại không gian trước khi đóng cửa.', 30000, '18:30:00', '23:30:00', N'Hà Nội', N'Tây Hồ', N'Số 8 Đường Thanh Niên', 1); -- Job 18

INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, EmployerNote) VALUES
-- >>> KỊCH BẢN TUẤN (ID = 2): 5 TRẠNG THÁI HOÀN HẢO KHÔNG ĐÈ LỊCH CA 0 VÀ 1
(2, 1, 26000, N'Em làm ca tối được ạ. Em từng đi bê cỗ tiệc cưới tại nhà hàng nên chạy bàn rất nhanh, không ngại vất vả dọn dẹp nhà vệ sinh cuối ngày.', 3, N'Sinh viên xin nghỉ để tập trung thời gian làm đồ án tốt nghiệp trên trường Đại Học, rất tiếc vì bạn ấy làm việc rất được việc và chăm chỉ.'), -- App 1: Đã nghỉ CÓ đánh giá (Job 1 Tối 18h-22h30)
(2, 2, 25000, N'Em có thể làm ca gãy buổi trưa vì em học xong lúc 11h sáng là rảnh rỗi. Em cam kết làm lâu dài không bỏ ngang công việc giữa chừng.', 3, N'Đã kết thúc hợp đồng thời vụ làm thêm 3 tháng dịp hè. Thanh lý hợp đồng vui vẻ hai bên, đã chi trả đủ tiền lương tháng cuối.'), -- App 2: Đã nghỉ CHƯA đánh giá (Job 2 Trưa 12h30-17h30)
(2, 5, 30000, N'Em muốn học hỏi thêm kỹ năng pha chế trà sữa. Em có xe máy tự túc đi lại làm ca sáng rất đúng giờ không lo tắc đường.', 1, N'Bạn Tuấn rất nhiệt tình và sáng dạ. Đã đào tạo xong menu cơ bản các loại trà chanh, ngày mai bắt đầu đứng quầy pha chế chính thức.'), -- App 3: Đang làm (Job 5 Sáng 07h-12h)
(2, 6, 28000, N'Em có ngoại hình sáng sủa cao ráo, từng có kinh nghiệm hướng dẫn khách hàng sự kiện, mong muốn ứng tuyển vị trí lễ tân rạp ca chiều.', 0, NULL), -- App 4: Đang chờ (Job 6 Chiều 13h-17h30) -> Không đè ca Mixue sáng.
(2, 7, 24000, N'Em là nam, sức khỏe tốt nên có thể phụ các chị bưng bê thùng rau củ, trái cây nặng vào kho siêu thị. Em rảnh ca sáng.', 2, N'Rất tiếc bộ phận này cửa hàng hiện tại đang ưu tiên tuyển nhân sự nữ nội trợ để đảm bảo sự tỉ mỉ khi phân loại lọc rau củ hỏng hóc.'), -- App 5: Từ chối (Job 7 Sáng 07h-12h) -> Có đè ca Sáng với App 3 nhưng bị Từ Chối (Status 2) nên hệ thống chấp nhận hợp lệ.

-- >>> KỊCH BẢN BÀI ĐĂNG JOB 1 (HIGHLANDS TỐI): 5 TRẠNG THÁI HOÀN HẢO
-- Đã có Tuấn (App 1) là Status 3 (Có đánh giá). Bơm thêm 4 người nữa vào Job 1:
(3, 1, 25000, N'Giọng em chuẩn Hà Nội, giao tiếp nhẹ nhàng lễ phép. Em cam kết không bao giờ đi muộn và dọn dẹp vệ sinh khu vực sảnh sạch sẽ gọn gàng cuối giờ.', 1, N'Sinh viên có thái độ làm việc cực kỳ tốt, học việc menu đồ uống nhanh. Bắt đầu nhận ca phục vụ từ chiều tối ngày mai lúc 18h nhé.'), -- App 6: Đang làm (Mai ID 3)
(4, 1, 25000, N'Nhà em ngay Cầu Giấy, đi bộ ra HITC mất có 5 phút nên làm ca tối muộn về không sợ nguy hiểm. Em rất khỏe mạnh để bưng khay nặng.', 0, NULL), -- App 7: Đang chờ (Nam ID 4)
(5, 1, 30000, N'Em từng có kinh nghiệm bưng bê nhà hàng đồ âu cao cấp. Em hy vọng quán có chế độ hỗ trợ tiền gửi xe cho nhân viên làm ca tối muộn.', 2, N'Rất tiếc, mức lương em đề xuất hơi cao so với ngân sách quỹ lương part-time phục vụ của cửa hàng chúng tôi đợt này. Hẹn em dịp khác.'), -- App 8: Từ chối (Hương ID 5)
(6, 1, 25000, N'Em tính tình hòa đồng, quen thuộc với môi trường dịch vụ F&B. Em có thể làm được thứ 7 chủ nhật full ca kể cả ngày lễ tết đông khách.', 3, N'Bạn Khánh mới làm được 2 tuần thì xin nghỉ ngang do chuyển chỗ trọ đi quá xa tận Hà Đông, đã thu hồi lại thẻ nhân viên và đồng phục quán.'), -- App 9: Đã nghỉ CHƯA đánh giá (Khánh ID 6)

-- >>> CÁC ĐƠN ỨNG TUYỂN DÀY DATA CÒN LẠI (Kiểm soát nghiêm ngặt không đè giờ Status 0 và 1)
-- Phân bổ dữ liệu rải đều các Job và các trạng thái 1, 2, 3, 0. Đảm bảo text dài chi tiết.
(3, 8, 35000, N'Em đã làm Barista được 6 tháng, thành thạo kỹ năng đánh bọt sữa và kéo latte art cơ bản các hình tim, hình lá rosetta cho đồ uống nóng.', 3, N'Mai hoàn thành tốt công việc trong suốt 6 tháng, do cần chuyển hướng thực tập đúng chuyên ngành IT nên quán đã duyệt cho nghỉ.'), -- App 10: Đã nghỉ, CÓ đánh giá (Job 8 Katinat Sáng)
(3, 9, 30000, N'Em muốn ứng tuyển làm tư vấn viên. Mặc dù chưa có kinh nghiệm soi da nhưng em cực kỳ thích học hỏi và có khả năng thuyết phục khách mua hàng.', 0, NULL), -- App 11: Đang chờ (Job 9 Hasaki Chiều)
(4, 11, 26000, N'Em là thanh niên sức khỏe cực kỳ trâu bò, có thể thức nguyên đêm kiểm đếm hàng kho mà không bị buồn ngủ hay mệt mỏi gục xuống bàn.', 1, N'Nam nhận việc khá nhanh, không ngại khó khăn bê vác các thùng sữa nặng. Đêm mai 23h đến kho gặp anh quản lý nhận đồ bảo hộ lao động.'), -- App 12: Đang làm (Job 11 Circle K Đêm)
(4, 15, 50000, N'Mặc dù em chưa thi IELTS nhưng tiếng Anh giao tiếp của em rất tự tin do hay lên Bờ Hồ nói chuyện với Tây. Mong trung tâm tạo cơ hội.', 3, N'Khả năng sư phạm của Nam khá tốt. Tuy nhiên do không sắp xếp được lịch lên lớp nên trung tâm đồng ý kết thúc hợp đồng sớm.'), -- App 13: Đã nghỉ, CÓ đánh giá (Job 15 Apollo Gia sư tối)
(5, 12, 35000, N'Em có kỹ năng thuyết phục cực tốt, kiên nhẫn gọi điện không sợ bị khách hàng từ chối hay cúp máy ngang. Giọng em rõ ràng dễ nghe.', 1, N'Bạn Hương giao tiếp rất khôn khéo qua điện thoại. Đã được duyệt vào đội telesale ca tối, nhớ lên lấy kịch bản đào tạo sản phẩm.'), -- App 14: Đang làm (Job 12 Apollo Telesale Tối 18h30-21h30)
(5, 10, 22000, N'Em rành đường khu vực Hoàng Mai, Định Công. Xe máy tự túc xăng dầu, hứa sẽ giao trà sữa tới tay khách đúng giờ không bị tan đá.', 0, NULL), -- App 15: Chờ duyệt (Job 10 Toco Sáng 08h-12h) -> Không đè ca Tối
(6, 16, 26000, N'Em cẩn thận, tỉ mỉ, cam kết nhặt hàng mỹ phẩm Shopee đúng mã vạch sản phẩm, đọc kỹ bill không để xảy ra sai sót đóng nhầm đơn hàng.', 3, N'Bạn Khánh nhặt hàng không bao giờ lỗi. Hết đợt siêu sale 11/11 kho không cần thêm nhân sự thời vụ nên đã thanh lý hợp đồng.'), -- App 16: Đã nghỉ, CÓ đánh giá (Job 16 Hasaki Kho sáng)
(6, 14, 28000, N'Em quen dùng máy POS cảm ứng, trí nhớ tốt nên nhớ thuộc lòng các công thức giảm đường giảm đá của khách. Không ngại đứng quầy lâu.', 1, N'Khánh phản xạ rất tốt với máy POS, tính tiền khách lẻ nhanh. Em làm ca chiều từ 13h, cố gắng đến sớm 10 phút để nhận bàn giao tiền lẻ quỹ.'), -- App 17: Đang làm (Job 14 Mixue Chiều)
(6, 18, 30000, N'Em có thể làm phục vụ ca tối muộn ở Katinat. Không sợ dọn dẹp nhà vệ sinh hay lau sàn nhà mệt nhọc lúc đêm khuya sau khi quán đóng cửa.', 0, NULL), -- App 18: Chờ (Job 18 Katinat Tối) -> Sáng nghỉ, Chiều làm, Tối chờ. Không đè giờ.
(7, 13, 25000, N'Em rất đam mê điện ảnh, muốn xin làm soát vé ca tối để thỉnh thoảng được ngó xem phim cọp 1 chút. Ngoại hình em ưa nhìn, vui vẻ.', 3, N'Linh làm việc khá ngoan ngoãn. Hợp đồng thời vụ Lễ 30/4 đã kết thúc tốt đẹp.'), -- App 19: Đã nghỉ, CÓ đánh giá (Job 13 CGV Tối)
(7, 6, 28000, N'Em có ngoại hình sáng, cao 1m65, giao tiếp nhẹ nhàng với khách. Đã từng làm PG sự kiện nên kỹ năng mềm xử lý khách khó tính rất tốt.', 1, N'Rất hoan nghênh em gia nhập team CGV. Em có tố chất sale bắp nước rất đỉnh. Em nhớ tới sớm 15 phút ca chiều để làm thủ tục nhận ca nhé.'), -- App 20: Đang làm (Job 6 CGV Chiều)
(7, 5, 30000, N'Em rảnh toàn bộ các buổi sáng trong tuần, mong muốn xin một chân phụ pha trà sữa ở Mixue. Tay chân em nhanh nhẹn làm việc nhóm ổn.', 0, NULL), -- App 21: Chờ (Job 5 Mixue Sáng) -> Không đè ca Chiều đang làm.
(8, 10, 22000, N'Em đi xe số Wave Alpha nên leo lề rẽ ngõ rất nhanh, thuộc lòng các tòa chung cư ở Linh Đàm. Em có sẵn 1 triệu tiền mặt để ứng đơn ngay.', 3, N'Việt giao hàng siêu nhanh, chưa bao giờ để đổ vỡ ly trà sữa của khách. Xin nghỉ do đã mua được xe máy mới và chuyển qua chạy Grab.'), -- App 22: Đã nghỉ, CÓ đánh giá (Job 10 Toco Sáng)
(8, 11, 26000, N'Em hay chơi game đêm nên quen giấc thức khuya, đảm bảo trực kho không bị gật gù hay sai lệch số lượng nhập xuất hàng hóa giá trị cao.', 0, NULL), -- App 23: Chờ (Job 11 Circle K Đêm)
(8, 17, 25000, N'Em thích pha chế đồ uống, không ngại việc vệ sinh thùng đá hay rửa cốc cuối ca. Sức khỏe cực tốt có thể xách thùng nguyên liệu đá lạnh.', 1, N'Nhận việc từ chiều nay nhé em. Chú ý học kỹ bảng công thức định lượng đường đá của TocoToco, tuyệt đối không tự ý làm sai công thức.'), -- App 24: Đang làm (Job 17 Toco Chiều) -> Sáng nghỉ, Đêm chờ, Chiều làm. Không đè lịch.
(9, 7, 24000, N'Em đi chợ cho mẹ suốt ngày từ bé nên mắt nhìn phân biệt rau củ tươi hay héo móp rất giỏi, làm việc gọn gàng không xả rác bừa bãi.', 3, N'Đức làm việc tỉ mỉ, dọn dẹp quầy rau rất sạch. Sinh viên xin nghỉ để về quê thực tập kỳ cuối.'), -- App 25: Đã nghỉ, CÓ đánh giá (Job 7 WinMart Sáng)
(9, 12, 35000, N'Em cần tìm công việc telesale ca tối để rèn luyện kỹ năng ăn nói mạnh dạn hơn, trước đây em hay bị ngại giao tiếp đám đông người lạ.', 0, NULL), -- App 26: Chờ (Job 12 Apollo Telesale Tối)
(9, 9, 30000, N'Em cực kỳ đam mê skincare da liễu, thuộc lòng công dụng của BHA, AHA, Retinol, tự tin chốt sale được mỹ phẩm đắt tiền cho các chị em.', 1, N'Đức có vốn kiến thức về da liễu thực tiễn cực kỳ tốt, tư vấn rất có tâm. Đã duyệt nhận việc ca chiều chính thức.'), -- App 27: Đang làm (Job 9 Hasaki Chiều) -> Sáng nghỉ, Tối chờ, Chiều làm. Hợp lệ tuyệt đối.
(10, 5, 30000, N'Em đã từng lắc shaker trà chanh vỉa hè nên tay to lực mạnh, không sợ bị mỏi tay khi đông khách. Chịu khó học hỏi và nghe lời quản lý ca.', 3, N'Ngọc pha chế làm kem Mixue rất đẹp mắt. Do bận học quân sự một tháng nên công ty đã đồng ý cho bạn ấy nghỉ làm.'), -- App 28: Đã nghỉ, CÓ đánh giá (Job 5 Mixue Sáng)
(10, 14, 28000, N'Em học khoa Kế Toán Ngân hàng, kỹ năng kiểm đếm tiền mặt, nhận diện tiền giả cực kỳ chuẩn xác không bao giờ lo để quán bị đền quỹ âm tiền.', 0, NULL), -- App 29: Chờ (Job 14 Mixue Chiều)
(10, 13, 25000, N'Em làm ca tối khuya rạp phim được, không ngại dọn rác bắp rang bơ khách xả ra sàn nhà sau khi hết phim. Nhà em cũng gần Vincom Phạm Ngọc Thạch.', 1, N'Hồ sơ ấn tượng, kỹ năng xử lý tình huống là điểm cộng lớn. Đi làm từ tối mai tại rạp Vincom nhé, em mặc áo trắng quần âu đen tự chuẩn bị.'), -- App 30: Đang làm (Job 13 CGV Tối) -> Sáng nghỉ, Chiều chờ, Tối làm. Không đè.
(11, 18, 30000, N'Em cực kỳ đam mê cà phê thủ công, muốn thử sức môi trường chuyên nghiệp để học hỏi kinh nghiệm làm dịch vụ chuẩn mực của hệ thống Katinat.', 3, N'Huy làm việc có tinh thần trách nhiệm cực cao, khách hàng phản hồi rất tốt. Sinh viên nghỉ do gia đình có việc bận chuyển về quê sinh sống.'), -- App 31: Đã nghỉ, CÓ đánh giá (Job 18 Katinat Tối)
(11, 8, 35000, N'Em đã từng đứng máy Espresso pha cà phê Ý, biết căn chỉnh độ xay bột cà phê và chiết xuất chuẩn thời gian. Mong anh chị xem xét tạo cơ hội.', 1, N'Rất hoan nghênh tinh thần của em. Em được duyệt làm barista ca sáng 6h30, nhớ mang tạp dề cá nhân và đến sớm setup máy móc bật nóng.'), -- App 32: Đang làm (Job 8 Katinat Sáng)
(11, 17, 25000, N'Em làm phụ pha chế ca chiều rảnh rang được, giao tiếp vui vẻ thân thiện, đã từng làm PG sự kiện nên xử lý khiếu nại khách hàng F&B cũng khá.', 0, NULL), -- App 33: Chờ (Job 17 Toco Chiều) -> Tối nghỉ, Sáng làm, Chiều chờ.
(2, 16, 26000, N'Em có thể làm kho.', 2, N'Kho xưởng ưu tiên ứng viên có chứng chỉ xe nâng.'), -- App 34 (Tuấn - Hasaki Sáng - Từ chối)
(3, 2, 26000, N'Em làm được ca gãy cực nhọc trưa.', 2, N'Quán đã tuyển đủ lượng nhân sự đăng ký làm ca gãy này.'), -- App 35 (Mai - HL Trưa - Từ chối)
(4, 6, 28000, N'Lễ tân rạp chiếu phim', 2, N'Chiều cao chưa đạt yêu cầu tối thiểu của vị trí đứng quầy sảnh chính.'), -- App 36 (Nam - CGV Chiều - Từ chối)
(5, 7, 24000, N'Cân đo rau củ chuyên nghiệp', 3, N'Sinh viên xin nghỉ để dồn sức thi cuối kỳ. Thanh toán đủ lương.'), -- App 37: Đã nghỉ, CÓ Đánh giá (Hương - WinMart Sáng)
(6, 11, 26000, N'Kiểm hàng kho đêm muộn', 2, N'Em ở quá xa so với địa điểm kho Phạm Văn Đồng.'), -- App 38 (Khánh - CircleK Đêm - Từ chối)
(7, 17, 25000, N'Pha trà sữa siêu tốc', 2, N'Chưa có chứng chỉ vệ sinh an toàn thực phẩm.'), -- App 39 (Linh - Toco Chiều - Từ chối)
(8, 1, 25000, N'Em xin một chân chạy bàn dọn dẹp', 2, N'Nhân sự ca tối đã được lấp đầy từ ngày hôm qua.'), -- App 40 (Việt - HL Tối - Từ chối)
(9, 14, 28000, N'Tính tiền lẻ không sai 1 đồng', 2, N'Hệ thống đang bảo trì không tuyển thêm.'), -- App 41 (Đức - Mixue Chiều - Từ chối)
(10, 10, 22000, N'Xe số chở hàng khỏe', 2, N'Cửa hàng chỉ ưu tiên ứng viên có thùng chở hàng sau xe.'), -- App 42 (Ngọc - Toco Sáng - Từ chối)
(11, 12, 35000, N'Telesale kiên trì không ngại mắng', 2, N'Phát âm còn hơi ngọng một số từ tiếng Anh cơ bản.'); -- App 43 (Huy - Apollo Tối - Từ chối)

INSERT INTO Saved_Job (StudentID, JobID) VALUES
(2, 5), (2, 8), (3, 1), (3, 4), (4, 6), (4, 15),
(5, 12), (5, 16), (6, 9), (6, 3), (7, 2), (7, 15),
(8, 11), (8, 13), (9, 7), (9, 16), (10, 10), (10, 14),
(11, 1), (11, 5);

INSERT INTO Student_Review (ApplicationID, EmployerID, StudentID, Rating, Comment) VALUES
(1, 12, 2, 5, N'Quản lý Highlands cực kỳ chuyên nghiệp và công tâm. Tiền tips của khách hàng được kiểm đếm và chia đều rất minh bạch, làm ca tối muộn dọn dẹp mệt nhưng bù lại khách ăn uống rất văn minh nên không bị stress tí nào.'),
(10, 18, 3, 5, N'Anh quản lý Katinat siêu tâm lý và chiều nhân viên. Đồng phục thiết kế cực xịn xò mặc đi làm rất tự tin, máy pha cà phê xịn của Ý chiết xuất espresso cực đỉnh giúp việc làm Barista rất nhàn và thích thú.'),
(13, 15, 4, 4, N'Trung tâm Apollo có giáo trình training cực kỳ bài bản và chuyên nghiệp. Lộ trình rõ ràng giúp mình học hỏi thêm nhiều về nghiệp vụ sư phạm đứng lớp. Tuy nhiên lương trả part-time so với mặt bằng chung hơi chậm.'),
(16, 19, 6, 5, N'Lần đầu tiên đi làm nhặt hàng kho mà thấy ưng ý thực sự. Kho hàng mỹ phẩm Hasaki siêu sạch sẽ, các kệ đánh số ngăn nắp, có hệ thống điều hòa tổng nên chạy đi lại nhiều nhặt đồ cũng không bị mồ hôi nhễ nhại.'),
(19, 16, 7, 4, N'Rạp phim CGV môi trường toàn các bạn sinh viên trẻ trung năng động. Cuối tuần khách xem phim bom tấn đông dọn rạp bắp nước mệt rã rời, nhưng bù lại mỗi tháng được phát voucher xem phim free là một đặc quyền siêu tuyệt vời.'),
(22, 20, 8, 5, N'Làm shipper chạy đơn nội thành cho Toco rất ổn áp, quán ngay mặt đường dễ đỗ xe lấy đồ. Anh chị quản lý quán thoải mái hay nhắc nhở shipper cẩn thận không cần phóng nhanh vượt ẩu. Tiền ship thanh toán ngay trong ngày.'),
(25, 17, 9, 4, N'Siêu thị WinMart làm việc hệ thống quy chuẩn rõ ràng, đồ bảo hộ tạp dề găng tay được cấp phát liên tục đầy đủ. Nhưng bác giám sát siêu thị đôi lúc bắt bẻ hơi gắt gao quá về vấn đề bày biện xếp hình củ quả trên kệ.'),
(28, 13, 10, 5, N'Làm ở Mixue rất là nhộn nhịp vì toàn khách học sinh nhỏ tuổi dễ thương. Nhạc quán bật vui tai bắt trend Tiktok. Học công thức pha trà chanh luộc trân châu vô cùng dễ. Tiền lương mùng 10 chuyển khoản ting ting cực chuẩn.'),
(31, 18, 11, 5, N'Katinat đúng là chân ái của sinh viên đi làm thêm F&B. Concept quán view hồ cực kỳ xịn xò, lau dọn bàn ghế trên tầng 2 mệt nhưng view đẹp mát mẻ nên rất thư giãn. Nước uống nội bộ cho nhân viên miễn phí tha hồ thử các vị.'),
(37, 17, 5, 4, N'Công việc đóng gói sơ chế rau củ trong siêu thị môi trường mát mẻ ổn định, các cô chú đồng nghiệp làm cùng bộ phận rất thương sinh viên hay nhường việc nhẹ. Trả lương ngày lễ x2 rất sòng phẳng theo luật.');


INSERT INTO Employer_Review (ApplicationID, StudentID, EmployerID, Rating, Comment) VALUES
(1, 2, 12, 5, N'Bạn Tuấn đi làm luôn đến sớm 10 phút, tác phong quần áo gọn gàng. Thái độ phục vụ bưng bê cho khách lúc nào cũng niềm nở tươi cười, tay chân dọn dẹp lau bàn ghế rất sạch sẽ không để lại vết bẩn nước hay rác.'),
(10, 3, 18, 5, N'Mai pha chế các dòng macchiato và espresso cực kỳ chuẩn vị định lượng. Đặc biệt cuối ngày em luôn tháo rời các vòi xịt vệ sinh máy móc rất kỹ lưỡng sạch sẽ. Mong có dịp được hợp tác lại với em.'),
(13, 4, 15, 4, N'Nam có sự cố gắng nỗ lực lớn trong việc truyền đạt ngữ pháp cho các bé cấp 2. Tuy nhiên đôi lúc trong lớp kỹ năng quản lý học viên nghịch ngợm ồn ào của em còn chưa được khéo léo lắm. Cần trau dồi thêm.'),
(16, 6, 19, 5, N'Khánh có trí nhớ cực kỳ tốt, nhặt hàng mỹ phẩm Shopee theo mã vạch tốc độ ánh sáng mà tỷ lệ đóng sai nhầm sản phẩm là 0% tuyệt đối. Cứ có đợt siêu sale nào kho cũng mong có Khánh ký lại hợp đồng phụ giúp.'),
(19, 7, 16, 4, N'Linh xé vé hướng dẫn số ghế cho khách bằng đèn pin rất nhiệt tình. Tốc độ vào dọn dẹp sảnh rạp sau mỗi ca chiếu cũng siêu nhanh. Điểm trừ nhỏ là đôi lúc vắng khách em hay lấy điện thoại ra nhắn tin trong giờ làm.'),
(22, 8, 20, 5, N'Việt lấy hàng và giao hàng siêu thần tốc. Cực kỳ cẩn thận chằng buộc nên chưa bao giờ để xảy ra tình trạng đổ vỡ ly trà sữa của khách. Chúc em thành công trên con đường sắp tới, quán luôn mở cửa đón em quay lại.'),
(25, 9, 17, 4, N'Đức làm việc vô cùng tỉ mỉ và nhẫn nại. Hằng ngày em dọn dẹp quầy rau củ, nhặt bỏ đồ hỏng rất có tâm, không để hàng kém chất lượng lọt tới tay khách. Tốc độ cân đo in tem nhãn dán cho khách cần rèn luyện nhanh tay hơn chút.'),
(28, 10, 13, 5, N'Bích Ngọc bóp kem ốc quế cực kỳ khéo tay và đẹp mắt đúng chuẩn quy định của hãng. Giao tiếp với các bé học sinh tiểu học vô cùng ngọt ngào dễ thương. Em hoàn thành xuất sắc hợp đồng part-time của mình.'),
(31, 11, 18, 5, N'Huy làm việc có tinh thần trách nhiệm cực cao, khách hàng thường xuyên phản hồi khen ngợi thái độ tận tâm của em khi bưng đồ lên các tầng lầu cao. Mọi ngóc ngách gầm bàn đều được em lau dọn sạch bóng không tì vết trước khi ra về.'),
(37, 5, 17, 5, N'Hương chịu khó thức khuya dậy sớm đến siêu thị làm ca 7h sáng mà không bao giờ trễ hẹn quẹt thẻ chấm công. Kỹ năng giao tiếp mời chào khách hàng dùng thử sản phẩm trái cây ăn thử cực kỳ khéo léo mang lại doanh thu tốt.');
GO
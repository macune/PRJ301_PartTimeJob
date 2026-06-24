USE PartTimeJobsDB;
GO

-- XÓA SẠCH RÁC
DELETE FROM Employer_Review;
DELETE FROM Student_Review;
DELETE FROM Saved_Job;
DELETE FROM Application;
DELETE FROM Job_Post;
DELETE FROM Category;
DELETE FROM Student_Profile;
DELETE FROM Employer_Profile;
DELETE FROM Account;
GO

-- RESET ID VỀ 0
DBCC CHECKIDENT ('Employer_Review', RESEED, 0);
DBCC CHECKIDENT ('Student_Review', RESEED, 0);
DBCC CHECKIDENT ('Saved_Job', RESEED, 0);
DBCC CHECKIDENT ('Application', RESEED, 0);
DBCC CHECKIDENT ('Job_Post', RESEED, 0);
DBCC CHECKIDENT ('Category', RESEED, 0);
DBCC CHECKIDENT ('Account', RESEED, 0);
GO

-- BƠM LẠI DỮ LIỆU CHUẨN THEO LOCATIONS.JSON
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

INSERT INTO Student_Profile (StudentID, FullName, AvatarUrl, ContactEmail, Phone, Address, University, Introduction, Experience) VALUES
(2, N'Lê Minh Tuấn', NULL, 'tuan.leminh@gmail.com', '0901234567', N'Số 10, Phường Cầu Giấy', N'Đại học Bách Khoa', N'Chăm chỉ, nhanh nhẹn, có xe máy.', N'1 năm làm phục vụ nhà hàng tiệc cưới.'),
(3, N'Trần Ngọc Mai', NULL, 'mai.tran@yahoo.com', '0912345678', N'Số 5, Phường Yên Hòa', N'Đại học FPT', N'Giao tiếp tốt.', N'6 tháng pha chế tại The Coffee House.'),
(4, N'Lê Văn Nam', NULL, 'nam.le@gmail.com', '0988777666', N'Số 12, Phường Phú Diễn', N'Đại học Công Nghiệp', N'Sức khỏe tốt, thức đêm được.', N'Chưa có kinh nghiệm, sẵn sàng học hỏi.'),
(5, N'Phạm Thị Hương', NULL, 'huong.pham@gmail.com', '0977666555', N'Số 8, Phường Kim Liên', N'Đại học Ngoại Thương', N'IELTS 7.0, tự tin giao tiếp.', N'1 năm trợ giảng tại Ocean Edu.'),
(6, N'Đinh Quốc Khánh', NULL, 'khanh.dinh@outlook.com', '0911222333', N'Số 22, Phường Khương Đình', N'Đại học Thủy Lợi', N'Hòa đồng, thích ứng nhanh.', N'3 tháng bán hàng part-time tại Circle K.'),
(7, N'Vũ Thùy Linh', NULL, 'linh.vu@gmail.com', '0922333444', N'Số 18, Phường Nghĩa Đô', N'Đại học Sư Phạm', N'Kinh nghiệm gia sư, giọng chuẩn.', N'2 năm gia sư Toán cấp 2.'),
(8, N'Hoàng Việt', NULL, 'viet.hoang@icloud.com', '0933444555', N'Số 9, Phường Đại Mỗ', N'Đại học Thương Mại', N'Nhiệt tình, có trách nhiệm.', N'Từng làm shipper nội thành 6 tháng.'),
(9, N'Ngô Minh Đức', NULL, 'duc.ngo@gmail.com', '0944555666', N'Số 15, Phường Thanh Xuân', N'Đại học KHTN', N'Thành thạo tin học văn phòng.', N'Hỗ trợ nhập liệu dữ liệu cho công ty IT 4 tháng.'),
(10, N'Bùi Bích Ngọc', NULL, 'ngoc.bui@gmail.com', '0955666777', N'Số 3, Phường Tương Mai', N'Học viện Ngân Hàng', N'Tính toán nhanh, trung thực.', N'Từng làm thu ngân tại siêu thị mini.');

INSERT INTO Employer_Profile (EmployerID, BusinessName, LogoUrl, Website, Phone, ContactEmail, Address, Description) VALUES
(11, N'Highlands Coffee', NULL, 'https://highlandscoffee.com.vn', '0241112223', 'hr@highlandscoffee.vn', N'Phường Cầu Giấy', N'Chuỗi cửa hàng cafe lớn.'),
(12, N'Mixue', NULL, 'https://mixue.vn', '0249998887', 'tuyendung@mixue.vn', N'Phường Thanh Xuân', N'Trà sữa & kem tươi.'),
(13, N'Circle K', NULL, 'https://circlek.com.vn', '0245554443', 'hr@circlek.com.vn', N'Phường Nghĩa Đô', N'Cửa hàng tiện lợi 24/7.'),
(14, N'Apollo English', NULL, 'https://apollo.edu.vn', '0248887776', 'tuyendung@apollo.edu.vn', N'Phường Yên Hòa', N'Hệ thống đào tạo Tiếng Anh.'),
(15, N'CGV Cinemas', NULL, 'https://cgv.vn', '0241231231', 'hr@cgv.vn', N'Phường Kim Liên', N'Hệ thống rạp phim.'),
(16, N'WinMart', NULL, 'https://winmart.vn', '0244564564', 'contact@winmart.vn', N'Phường Xuân Đỉnh', N'Chuỗi siêu thị bán lẻ.'),
(17, N'Katinat', NULL, 'https://katinat.vn', '0247897897', 'tuyendung@katinat.vn', N'Phường Cửa Nam', N'Cà phê phong cách hiện đại.'),
(18, N'Hasaki', NULL, 'https://hasaki.vn', '0243213213', 'hr@hasaki.vn', N'Phường Yên Hòa', N'Phân phối mỹ phẩm.'),
(19, N'TocoToco', NULL, 'https://tocotoco.vn', '0246546546', 'tuyendung@tocotoco.vn', N'Phường Đông Ngạc', N'Trà sữa đậm vị thiên nhiên.');

INSERT INTO Category (CategoryName, Status) VALUES
(N'Phục vụ', 1), (N'Pha chế', 1), (N'Thu ngân', 1), (N'Giao hàng', 1), 
(N'Bán hàng siêu thị', 1), (N'Gia sư', 1), (N'Lễ tân', 1), 
(N'Chăm sóc khách hàng', 1), (N'Kho bãi', 1), (N'Tư vấn viên', 1);

INSERT INTO Job_Post (EmployerID, CategoryID, Title, Description, Salary, StartTime, EndTime, City, Ward, DetailAddress, Status) VALUES
(11, 1, N'Nhân viên phục vụ ca tối', N'Bưng bê, dọn bàn.', 25000, '18:00:00', '22:30:00', N'Hà Nội', N'Văn Miếu - Quốc Tử Giám', N'Số 10 Nguyễn Thái Học', 1),
(12, 2, N'Pha chế trà sữa Mixue', N'Luộc trân châu, pha trà.', 30000, '08:00:00', '12:00:00', N'Hà Nội', N'Thanh Xuân', N'Ngõ 1 Khuất Duy Tiến', 1), 
(11, 3, N'Thu ngân cuối tuần', N'Thanh toán, xuất hóa đơn.', 27000, '09:00:00', '17:00:00', N'Hà Nội', N'Bạch Mai', N'15 Tạ Quang Bửu', 0), 
(13, 5, N'Nhân viên Circle K ca đêm', N'Sắp xếp hàng, giữ vệ sinh.', 35000, '22:00:00', '06:00:00', N'Hà Nội', N'Xuân Phương', N'Số 50 Hồ Tùng Mậu', 1),
(14, 6, N'Gia sư Tiếng Anh', N'Trợ giảng, kèm giao tiếp.', 50000, '17:30:00', '19:30:00', N'Hà Nội', N'Cửa Nam', N'Số 5 Lò Đúc', 1), 
(15, 7, N'Lễ tân rạp chiếu phim', N'Bán vé, tư vấn phim.', 28000, '14:00:00', '22:00:00', N'Hà Nội', N'Kim Liên', N'Số 22 Lê Thanh Nghị', 1), 
(16, 5, N'Nhân viên rau củ WinMart', N'Cân đo, dọn dẹp quầy.', 24000, '07:00:00', '15:00:00', N'Hà Nội', N'Đông Ngạc', N'Số 15 Xuân Đỉnh', 1), 
(17, 2, N'Barista Katinat ca sáng', N'Pha chế, dọn máy.', 35000, '06:30:00', '12:30:00', N'Hà Nội', N'Tây Hồ', N'Đường Thanh Niên', 1), 
(18, 10, N'Tư vấn viên Hasaki', N'Tư vấn da.', 30000, '15:00:00', '21:00:00', N'Hà Nội', N'Ô Chợ Dừa', N'Số 18 Khâm Thiên', 1), 
(19, 4, N'Shipper nội bộ TocoToco', N'Giao bán kính 5km.', 22000, '10:00:00', '18:00:00', N'Hà Nội', N'Định Công', N'Số 99 Kim Giang', 1), 
(13, 9, N'Nhân viên kiểm kho', N'Kiểm đếm hàng.', 26000, '06:00:00', '14:00:00', N'Hà Nội', N'Xuân Đỉnh', N'Số 50 Phạm Văn Đồng', 3),
(14, 8, N'Chăm sóc học viên', N'Gọi điện CSKH.', 35000, '18:00:00', '21:00:00', N'Hà Nội', N'Yên Lãng', N'Số 10 Thái Hà', 1);

INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, EmployerNote) VALUES
(2, 1, 25000, N'Em có thể làm full tối.', 1, N'Đã nhận việc, bắt đầu ngày mai.'),
(3, 2, 30000, N'Em có kinh nghiệm 6 tháng.', 0, NULL), 
(4, 4, 35000, N'Em thức đêm tốt.', 1, N'Đến siêu thị nhận đồng phục nhé.'),
(5, 5, 55000, N'IELTS 7.0 ạ.', 1, N'Pass test giảng dạy.'),
(6, 6, 28000, N'Em thích môi trường rạp.', 0, NULL),
(7, 12, 35000, N'Giọng chuẩn.', 1, N'Đi làm từ tuần sau.'),
(8, 10, 25000, N'Thuộc đường Kim Giang.', 2, N'Đã tuyển đủ shipper bạn nhé.'),
(9, 11, 26000, N'Cẩn thận số liệu.', 0, NULL),
(10, 9, 30000, N'Đam mê skincare.', 1, N'Giao tiếp cực tốt, nhận việc.');

INSERT INTO Saved_Job (StudentID, JobID) VALUES
(2, 2), (2, 5), (3, 1), (4, 6), (5, 5), (5, 7),
(6, 8), (6, 9), (7, 12), (7, 5), (8, 10), (8, 4),
(9, 11), (9, 3), (10, 9), (10, 6);

INSERT INTO Student_Review (EmployerID, StudentID, Rating, Comment) VALUES
(11, 2, 5, N'Tuấn đi làm rất đúng giờ.'),
(12, 3, 4, N'Mai làm đồ uống ngon nhưng hay nhầm đường.'),
(13, 4, 5, N'Nam sức khỏe tốt, sắp đồ gọn gàng.'),
(14, 5, 5, N'Hương phát âm chuẩn, phụ huynh khen nhiều.'),
(15, 6, 5, N'Khánh lúc nào cũng cười tươi với khách.'),
(18, 10, 5, N'Ngọc tư vấn khách chốt sale rất nhanh.');

INSERT INTO Employer_Review (StudentID, EmployerID, Rating, Comment) VALUES
(2, 11, 5, N'Môi trường cực kỳ chuyên nghiệp.'),
(3, 12, 4, N'Quán đông sếp thỉnh thoảng hơi gắt.'),
(4, 13, 4, N'Ca đêm nhàn nhưng hay buồn ngủ.'),
(5, 14, 5, N'Trung tâm xịn xò, đóng BHXH đầy đủ cho part-time.'),
(6, 15, 5, N'Được xem phim miễn phí 1 vé/tháng.'),
(10, 18, 5, N'Được mua mỹ phẩm giá chiết khấu.');
GO

PRINT N'✅ ĐÃ RESET VỀ BỘ DATA CHUẨN KHỚP VỚI LOCATIONS.JSON!';
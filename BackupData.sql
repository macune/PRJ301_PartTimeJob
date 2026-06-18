USE PartTimeJobsDB;
GO

-- ==========================================
-- 1. INSERT DỮ LIỆU TÀI KHOẢN (Account)
-- ==========================================
-- 1 Admin quyền lực, 4 Sinh viên (Đã thay tên), 4 Chủ quán/Doanh nghiệp
INSERT INTO Account (Username, Email, Password, Role, Status) VALUES
('admin', 'admin@system.com', '123456', 1, 1),
('sv_tuan', 'tuan@student.com', '123456', 2, 1), -- Đã thay bằng Tuấn
('sv_mai', 'mai@student.com', '123456', 2, 1),
('sv_nam', 'nam@student.com', '123456', 2, 1),
('sv_huong', 'huong@student.com', '123456', 2, 1),
('emp_highlands', 'tuyendung@highlands.vn', '123456', 3, 1),
('emp_mixue', 'tuyendung@mixue.vn', '123456', 3, 1),
('emp_circlek', 'hr@circlek.com.vn', '123456', 3, 1),
('emp_apollo', 'hr@apollo.edu.vn', '123456', 3, 1); -- Đổi Phúc Long thành Trung tâm Gia sư
GO

-- ==========================================
-- 2. INSERT DỮ LIỆU HỒ SƠ (Profiles)
-- ==========================================
-- Hồ sơ Sinh viên (Khớp với AccountID từ 2 đến 5)
INSERT INTO Student_Profile (StudentID, FullName, Phone, Address, University, Introduction) VALUES
(2, N'Lê Minh Tuấn', '0901234567', N'Số 10, Phường Bách Khoa', N'Đại học Bách Khoa', N'Chăm chỉ, nhanh nhẹn, có xe máy đi lại.'),
(3, N'Trần Ngọc Mai', '0912345678', N'Số 5, Phường Dịch Vọng', N'Đại học FPT', N'Có kinh nghiệm pha chế 6 tháng, giao tiếp tốt.'),
(4, N'Lê Văn Nam', '0988777666', N'Số 12, Phường Cầu Diễn', N'Đại học Công Nghiệp', N'Sức khỏe tốt, có thể làm ca đêm.'),
(5, N'Phạm Thị Hương', '0977666555', N'Số 8, Phường Láng Thượng', N'Đại học Ngoại Thương', N'Tiếng Anh giao tiếp tốt IELTS 7.0, cẩn thận, tỉ mỉ.');
GO

-- Hồ sơ Tuyển dụng (Khớp với AccountID từ 6 đến 9)
INSERT INTO Employer_Profile (EmployerID, BusinessName, Phone, Address, Description) VALUES
(6, N'Highlands Coffee', '0241112223', N'Tòa nhà HITC, Phường Dịch Vọng Hậu', N'Chuỗi cửa hàng cafe lớn, môi trường chuyên nghiệp.'),
(7, N'Mixue', '0249998887', N'Số 20, Phường Thanh Xuân Bắc', N'Cửa hàng trà sữa, kem tươi. Môi trường năng động, thân thiện.'),
(8, N'Circle K', '0245554443', N'Số 50, Phường Mai Dịch', N'Chuỗi cửa hàng tiện lợi phục vụ 24/7.'),
(9, N'Trung Tâm Anh Ngữ Apollo', '0248887776', N'Tòa nhà IPH, Phường Dịch Vọng Hậu', N'Hệ thống trung tâm đào tạo Tiếng Anh uy tín.');
GO

-- ==========================================
-- 3. INSERT DANH MỤC & VIỆC LÀM (Category & Job_Post)
-- ==========================================
INSERT INTO Category (CategoryName, Status) VALUES
(N'Phục vụ', 1),
(N'Pha chế', 1),
(N'Thu ngân', 1),
(N'Giao hàng', 1),
(N'Bán hàng siêu thị', 1),
(N'Gia sư', 1); -- Đã thay thế Bảo vệ bằng Gia sư
GO

-- Đăng 8 công việc 
INSERT INTO Job_Post (EmployerID, CategoryID, Title, Description, Salary, StartTime, EndTime, City, Ward, DetailAddress, Status) VALUES
(6, 1, N'Nhân viên phục vụ ca tối', N'Bưng bê, dọn bàn, hỗ trợ khách order.', 25000, '18:00:00', '22:30:00', N'Hà Nội', N'Phường Dịch Vọng Hậu', N'Tầng 1 Tòa nhà HITC', 1),
(7, 2, N'Pha chế trà sữa Mixue', N'Pha trà, luộc trân châu, dọn dẹp quầy.', 30000, '08:00:00', '12:00:00', N'Hà Nội', N'Phường Thanh Xuân Bắc', N'Ngõ 1 Khuất Duy Tiến', 1),
(6, 3, N'Thu ngân cuối tuần', N'Thanh toán tiền cho khách, xuất hóa đơn.', 27000, '09:00:00', '17:00:00', N'Hà Nội', N'Phường Bách Khoa', N'15 Tạ Quang Bửu', 0),
(8, 5, N'Nhân viên Circle K ca đêm', N'Sắp xếp hàng hóa, thanh toán, giữ vệ sinh cửa hàng.', 35000, '22:00:00', '06:00:00', N'Hà Nội', N'Phường Mai Dịch', N'Số 50 Hồ Tùng Mậu', 1),
(9, 6, N'Gia sư Tiếng Anh Giao Tiếp', N'Trợ giảng, kèm cặp học viên luyện nói Tiếng Anh.', 50000, '17:30:00', '19:30:00', N'Hà Nội', N'Phường Dịch Vọng Hậu', N'Tòa nhà IPH Xuân Thủy', 1), -- Công việc Gia sư 1
(8, 3, N'Thu ngân Circle K ca chiều', N'Đứng quầy thanh toán, hỗ trợ khách hàng.', 25000, '14:00:00', '22:00:00', N'Hà Nội', N'Phường Quan Hoa', N'Số 10 Nguyễn Đình Hoàn', 1),
(9, 6, N'Gia sư Toán cấp 2', N'Kèm môn Toán lớp 8, 9 theo giáo trình trung tâm.', 45000, '19:00:00', '21:00:00', N'Hà Nội', N'Phường Trung Hòa', N'Số 5 Trần Duy Hưng', 3), -- Công việc Gia sư 2 (Đã đóng)
(7, 4, N'Shipper giao trà sữa gần', N'Giao trà sữa trong bán kính 3km, có hỗ trợ tiền xăng.', 20000, '10:00:00', '15:00:00', N'Hà Nội', N'Phường Thanh Xuân Trung', N'Số 2 Nguyễn Trãi', 1);
GO

-- ==========================================
-- 4. INSERT TƯƠNG TÁC (Application & Saved_Job)
-- ==========================================
INSERT INTO Application (StudentID, JobID, DesiredSalary, Message, Status, EmployerNote) VALUES
(2, 1, 25000, N'Em có thể làm full các tối trong tuần ạ.', 1, N'Đã phỏng vấn, bắt đầu làm từ thứ 2.'), 
(3, 2, 35000, N'Em đã từng làm Mixue nên quen việc rồi ạ.', 0, NULL), 
(4, 4, 35000, N'Em là nam, sức khỏe tốt, thức đêm thoải mái ạ.', 1, N'Liên hệ nhận đồng phục nhé.'), 
(5, 5, 55000, N'Em có IELTS 7.0, tự tin giao tiếp.', 1, N'Hẹn em 3h chiều mai qua trung tâm test kỹ năng.'), -- Hương apply làm Gia sư Tiếng Anh
(2, 8, 20000, N'Em có xe máy riêng ạ.', 2, N'Quán đã tuyển đủ shipper.'), 
(3, 5, 45000, N'Em muốn thử sức với vị trí trợ giảng.', 0, NULL), 
(4, 6, 25000, N'Nhà em gần đây nên đi lại tiện ạ.', 0, NULL); 
GO

INSERT INTO Saved_Job (StudentID, JobID) VALUES
(2, 2),
(2, 5),
(3, 1),
(4, 6),
(5, 5),
(5, 7);
GO

-- ==========================================
-- 5. INSERT ĐÁNH GIÁ ĐỂ TEST TRIGGER (Reviews)
-- ==========================================
INSERT INTO Student_Review (EmployerID, StudentID, Rating, Comment) VALUES
(6, 2, 5, N'Tuấn đi làm rất đúng giờ, chăm chỉ dọn dẹp.'),
(7, 3, 4, N'Mai pha chế ngon nhưng thỉnh thoảng hay quên order của khách.'),
(8, 4, 5, N'Nam làm ca đêm rất tỉnh táo, không hay ngủ gật.'),
(9, 5, 5, N'Hương phát âm chuẩn, truyền đạt tốt, học sinh rất thích.'),
(6, 4, 3, N'Bạn Nam xin nghỉ ốm hơi nhiều trong tháng vừa rồi.');
GO

INSERT INTO Employer_Review (StudentID, EmployerID, Rating, Comment) VALUES
(2, 6, 5, N'Môi trường cực kỳ chuyên nghiệp, lương trả mùng 5 hàng tháng không bao giờ chậm.'),
(3, 7, 4, N'Quán đông khách nên hơi mệt, nhưng anh quản lý rất tâm lý.'),
(4, 8, 4, N'Làm ca đêm khá nhàn, thỉnh thoảng mới có khách nhưng lương hơi thấp.'),
(5, 9, 5, N'Trung tâm xịn xò, giáo trình chuẩn, được trau dồi kỹ năng sư phạm.'),
(2, 9, 5, N'Đã từng dự thính ở đây, rất recommend cho các bạn sinh viên khác.');
GO
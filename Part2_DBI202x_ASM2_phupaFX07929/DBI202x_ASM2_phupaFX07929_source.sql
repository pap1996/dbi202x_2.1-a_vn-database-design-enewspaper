/*2. Các bước triển khai
2.1. Khởi tạo database*/
create database assignment_2;
go

/*2.2. Tạo bảng, ràng buộc và Insert data*/
use assignment_2
go

CREATE TABLE dbo.StatusCode
(
    statusCodeID int PRIMARY KEY,
    statusDesc nvarchar(100) not null
)
go

CREATE TABLE dbo.ResourceCat
(
    resourceCatID int PRIMARY KEY,
    resourceCatName nvarchar(100) not null
)
go

CREATE TABLE dbo.ArticleCat
(
    articleCatID int PRIMARY KEY,
    articleCatDesc nvarchar(100) not null
)
go

CREATE TABLE dbo.Roles
(
    roleID int PRIMARY KEY,
    roleName nvarchar(100) not null,
	effDate datetime not null,
	inEffDate datetime not null
)
go

CREATE TABLE dbo.ActionCat
(
    actionCatID int PRIMARY KEY,
    actionCatDesc nvarchar(100) not null
)
go

CREATE TABLE dbo.AttrType
(
    attrTypeCode nvarchar(10) PRIMARY KEY,
    attrTypeDesc nvarchar(100) not null
)
go

CREATE TABLE dbo.Articles
(
    articleID int PRIMARY KEY,
    articleName ntext not null,
	articleSum ntext not null,
	articleContent ntext not null,
	statusCodeID int foreign key references StatusCode(statusCodeID),
	articleCatID int foreign key references ArticleCat(articleCatID)
)
go

CREATE TABLE dbo.Resources
(
    resourceID int primary key,
    resourceFolder nvarchar(100) not null,
	resourceCatID int foreign key references ResourceCat(resourceCatID)
);
go

CREATE TABLE dbo.Users
(
    userID nvarchar(100) primary key,
    userName nvarchar(100) not null,
	password nvarchar(100) not null,
	effDate datetime not null,
	inEffDate datetime not null
);
go

CREATE TABLE dbo.Actions
(
    actionID int primary key,
    actionDate datetime not null,
	articleID int foreign key references Articles(articleID),
	userID nvarchar(100) foreign key references Users(userID),
	actionCatID int foreign key references ActionCat(actionCatID)
);
go

CREATE TABLE dbo.ArticleHist
(
    version int NOT NULL,
    articleID int not null,
	statusDate datetime not null,
	statusCodeID int foreign key references StatusCode(statusCodeID)
	primary key (version, articleID)
);
go

CREATE TABLE dbo.ActionDetails
(
    actionID int primary key,
    attrTypeCode nvarchar(10) foreign key references AttrType(attrTypeCode),
	attrValue nvarchar(100) not null
	foreign key (actionID) references Actions(actionID)
);
go

CREATE TABLE dbo.Articles_x_Resources
(
    resourceID int NOT NULL,
    articleID int not NULL,
	primary key (resourceID, articleID),
	foreign key (resourceID) references Resources(resourceID),
	foreign key (articleID) references Articles(articleID)
);
go

CREATE TABLE dbo.Articles_x_Users
(
    articleID int NOT NULL foreign key references Articles(articleID),
    post_approve nvarchar(100) not null,
	userID nvarchar(100) not null foreign key references Users(userID),
	effDate datetime not null,
	primary key (articleID, post_approve)
);
go

CREATE TABLE dbo.Users_x_Roles
(
    roleID int NOT NULL foreign key references Roles(roleID),
    userID nvarchar(100) not NULL foreign key references Users(userID),
	effDate datetime not null,
	inEffDate datetime not null
	primary key (roleID, userID)
);
go



INSERT INTO [dbo].[StatusCode]
           ([statusCodeID]
           ,[statusDesc])
     VALUES
           (1, N'Posted'),
		   (2, N'Pending Approval'),
		   (3, N'Hidden'),
		   (4, N'Deleted')
GO

INSERT INTO [dbo].[ResourceCat]
           ([resourceCatID]
           ,[resourceCatName])
     VALUES
           (1, N'Static image'),
		   (2, N'GIF'),
		   (3, N'Audio Clip'),
		   (4, N'Video Clip'),
		   (5, N'HTML Canvas')
GO

INSERT INTO ArticleCat (articleCatID,articleCatDesc)
VALUES
    ('1', 'Technology'),
    ('2', 'Publication'),
    ('3', 'Business'),
    ('4', 'Sport'),
    ('5', 'Books'),
    ('6', 'Showbiz'),
    ('7', 'Digital Transform'),
    ('8', 'Lifestyle'),
    ('9', 'Podcast'),
    ('10', 'Laws');
GO

INSERT INTO Roles (roleID,roleName,effDate,inEffDate)
VALUES
    ('1', 'View', '1/1/2020', '12/31/9999'),
    ('2', 'Request to post', '1/1/2020', '12/31/9999'),
    ('3', 'Approve Request', '1/1/2020', '12/31/9999'),
    ('4', 'Manage User', '1/1/2020', '12/31/9999');
go

INSERT INTO ActionCat (actionCatID,actionCatDesc)
VALUES
    ('1', 'View the article'),
    ('2', 'Find and filter'),
    ('3', 'Send request to post article'),
    ('4', 'Approve to post article'),
    ('5', 'Deny the post request'),
    ('6', 'Hide the post'),
    ('7', 'Delele the post');
GO

INSERT INTO AttrType (attrTypeCode,attrTypeDesc)
VALUES
    ('SRC', 'Source link to the article'),
    ('RMK', 'Remark for approval'),
    ('RSN', 'Reason for deleting or hiding');
go

INSERT INTO Articles (articleID,articleName,articleSum,articleContent,statusCodeID,articleCatID)
VALUES
    ('1', N'Tổng thống El Salvador: Đừng nhìn giá Bitcoin, hãy tận hưởng', N'Dù khoản đầu tư vào Bitcoin đang lỗ nặng, tổng thống El Salvador vẫn nhất quyết chờ đợi đợt tăng giá tiếp theo của Bitcoin.', N'"Nayib Bukele, Tổng thống El Salvador đồng thời là người ủng hộ cuồng nhiệt tiền mã hóa, đã đề nghị người dân nước này nên bình tĩnh chờ lúc Bitcoin tăng, bất chấp đà giảm liên tục trong vài tháng gần đây. Ông cho rằng ""kiên nhẫn là điều quan trọng nhất""."', '1', '3'),
    ('2', N'Cổ phiếu nằm sàn la liệt, VN-Index rơi 37 điểm', N'Áp lực bán tháo tiếp tục xuất hiện tại các cổ phiếu ngân hàng, bất động sản, năng lượng, thép, chứng khoán, đầu cơ... khiến VN-Index chính thức mất mốc 1.200 điểm.', N'Tiếp nối những diễn biến tiêu cực của tuần trước, thị trường chứng khoán Việt Nam tiếp tục gặp áp lực bán tháo mạnh mẽ trong phiên đầu tuần. Các chỉ số sớm chìm trong sắc đỏ và càng lúc mở rộng đà rơi khi lực cầu yếu ớt.', '2', '3'),
    ('3', N'Loạt bất động sản tại TP.HCM đang được ngân hàng thanh lý', N'Hàng loạt lô đất, biệt thự giá trị tại TP.HCM đang được Sacombank, Agribank và các ngân hàng khác rao bán với giá từ vài chục tỷ cho tới vài trăm tỷ đồng.', N'Trong thời gian ngắn gần đây, các ngân hàng lớn liên tục phát đi thông báo về việc thu giữ và bán đấu giá tài sản đảm bảo của các khoản nợ xấu là bất động sản. Đáng chú ý, phần lớn bất động sản đang được rao bán đợt này tập trung ở TP.HCM, trong đó, giá khởi điểm dao động từ vài chục cho tới vài trăm tỷ đồng.', '1', '3'),
    ('4', N'Bữa trưa vỉa hè của dân văn phòng ở khu đất vàng TP.HCM', N'Nhiều quán vỉa hè xung quanh các tòa cao ốc khu vực trung tâm TP.HCM thu hút nhóm dân văn phòng bởi món ăn đa dạng và mức 35.000-50.000 đồng.', N'Hơn 11h30, Bảo, nhân viên công ty có trụ sở tại tòa nhà Sunwah (đường Nguyễn Huệ, quận 1) đi xuống mua bữa trưa ở quầy hàng rong ở góc đường Hồ Tùng Mậu giao Huỳnh Thúc Kháng, kế mặt sau tòa nhà.', '2', '3'),
    ('5', N'Chân dung bạn trai mới của Phạm Băng Băng', N'Phạm Băng Băng từng suy sụp sau khi chia tay Lý Thần. Ba năm sau cuộc tình đổ vỡ, cô hiện hạnh phúc bên doanh nhân Quách Nham Phong.', N'Phạm Băng Băng được cho là đang bí mật hẹn hò doanh nhân Quách Nham Phong. Video thân mật nơi công cộng của họ được truyền thông ghi lại và đăng tải vào ngày 18/6. Trang iFeng tiết lộ thân thế bạn trai ngôi sao Bắc Kinh lạc lối.', '3', '6'),
    ('6', N'Giả vờ yêu nhau - trò PR cũ rích của ca sĩ Việt', N'"Cách dùng chuyện yêu đương, kết hôn để PR MV đã rất cũ kỹ ở Vpop. Gần đây, nhiều ca sĩ vẫn áp dụng công thức này với mức độ ""lố"" hơn."', N'"Liên tiếp những sản phẩm âm nhạc gần đây được ca sĩ Việt quảng bá bằng chuyện tình cảm. Cách PR này được áp dụng ở Vpop từ hàng chục năm nay nhưng mức độ ngày càng nghiêm trọng. Có những ca sĩ thậm chí dùng thiệp mời hay giấy đăng ký kết hôn để ""lừa"" khán giả ""sập bẫy"" truyền thông. Cách làm đó có thể gây chú ý bước đầu nhưng về lâu dài sẽ đánh mất uy tín trong lòng khán giả. "', '4', '6'),
    ('7', N'Phong cảnh, con người miền Nam 150 năm trước qua ảnh', N'Một số địa danh, nhân vật nổi tiếng của miền Nam 150 năm trước có trong bộ sưu tập ảnh của bác sĩ Pháp J.C. Baurac.', N'Bộ sách Nam Kỳ và cư dân (tập 1 về các tỉnh miền Tây và tập 2 về các tỉnh miền Đông) của bác sĩ thuộc địa hạng nhất J.C. Baurac là bộ tư liệu đồ sộ hơn 1.100 trang với nhiều hình ảnh, dày đặc thông tin và kèm theo những đánh giá về cơ hội phát triển của xứ Nam Kỳ lúc bấy giờ.', '1', '5'),
    ('8', N'Tin buồn với người mua iPhone đời cũ', N'Khi iPhone dùng cổng Lightning bị khai tử do dự luật của EU, người mua những mẫu iPhone đời cũ, giá tốt sẽ bị ảnh hưởng.', N'Đầu tháng 6, các nhà lập pháp của Liên minh châu Âu (EU) đã thông qua thỏa thuận về dự luật bắt buộc toàn bộ smartphone bán ra tại thị trường này phải trang bị cổng kết nối USB-C để sạc pin có dây. Điều này đồng nghĩa với việc cổng Lightning trên iPhone sẽ biến mất tại châu Âu từ năm 2024.', '1', '1'),
    ('9', N'CZ uống cà phê trứng, nói về blockchain ở Hà Nội', N'Nhà sáng lập kiêm CEO của Binance có nhiều chia sẻ với Zing khi được hỏi về nhiều chủ đề nhạy cảm, như những rủi ro trong lĩnh vực blockchain.', N'Ngày 4/6, Changpeng Zhao (CZ), CEO và nhà sáng lập Binance đến quán cà phê trên đường Nguyễn Hữu Huân, Hà Nội. Ông có hẹn với một loạt nhân vật có tiếng trong ngành blockchain của Việt Nam tại đây, trong một cuộc trò chuyện ngắn sau hội thảo.', '1', '1'),
    ('10', N'Nhiều công ty công nghệ tháo chạy khỏi Trung Quốc', N'Các công ty Internet đang tính đường rút lui khỏi Trung Quốc trước sự cạnh tranh từ đối thủ nội địa, khó khăn do dịch bệnh và quy định nghiêm ngặt của chính phủ.', N'Theo SCMP, dịch vụ cho thuê căn hộ Airbnb là cái tên mới nhất tuyên bố rút lui khỏi Trung Quốc. Mảng kinh doanh máy đọc sách Kindle của Amazon cũng công bố kế hoạch ngừng hoạt động tại Trung Quốc từ ngày 30/6/2023. Với quy mô kinh tế và dân số lớn, Trung Quốc là thị trường không thể bỏ qua với các doanh nghiệp toàn cầu. Tuy nhiên, những chính sách quản lý nghiêm ngặt, sức ép cạnh tranh với công ty nội địa và sự thay đổi trong sở thích người dùng khiến nhiều hãng công nghệ lớn rút lui khỏi đất nước tỷ dân sau nhiều năm hoạt động.', '4', '7');
go

INSERT INTO Resources (resourceID,resourceFolder,resourceCatID)
VALUES
    ('1', '/res/res1.img', '1'),
    ('2', '/res/res2.mp3', '3'),
    ('3', '/res/res3.mp4', '4'),
    ('4', '/res/res1.img', '1'),
    ('5', '/res/res5.svg', '2'),
    ('6', '/res/res6.img', '1'),
    ('7', '/res/res7.img', '1'),
    ('8', '/res/res8.mp3', '3'),
    ('9', '/res/res9.img', '1'),
    ('10', '/res/res10.mp3', '3'),
    ('11', '/res/res11.img', '1'),
    ('12', '/res/res12.img', '1');
go

INSERT INTO Users (userID,userName,password,effDate,inEffDate)
VALUES
    ('user001', 'thuylien', '123456', '2020-12-12 00:00:00', '9999-12-31 00:00:00'),
    ('user002', 'huyle', '123456', '2020-12-13 00:00:00', '9999-12-31 00:00:00'),
    ('user003', 'quangthang', '123456', '2020-12-14 00:00:00', '9999-12-31 00:00:00'),
    ('user004', 'daophuong', '123456', '2020-12-15 00:00:00', '9999-12-31 00:00:00'),
    ('user005', 'dihy', '123456', '2020-12-16 00:00:00', '9999-12-31 00:00:00'),
    ('user006', 'thailinh', '123456', '2020-12-17 00:00:00', '9999-12-31 00:00:00'),
    ('user007', 'minhchau', '123456', '2020-12-18 00:00:00', '9999-12-31 00:00:00'),
    ('user008', 'tuananh', '123456', '2020-12-19 00:00:00', '9999-12-31 00:00:00'),
    ('user009', 'phucthinh', '123456', '2020-12-20 00:00:00', '9999-12-31 00:00:00'),
    ('user010', 'anhphu', '123456', '2020-12-21 00:00:00', '9999-12-31 00:00:00'),
    ('user011', 'thanhnhi', '123456', '2020-12-22 00:00:00', '9999-12-31 00:00:00');
go

INSERT INTO Actions (actionID,actionDate,articleID,userID,actionCatID)
VALUES
    ('1', '2022-06-20 06:00:00', '1', 'user001', '3'),
    ('2', '2022-06-20 06:15:00', '1', 'user001', '1'),
    ('3', '2022-06-20 11:20:00', '1', 'user010', '1'),
    ('4', '2022-06-20 12:00:00', '1', 'user010', '4'),
    ('5', '2022-06-20 16:00:00', '1', 'user002', '1'),
    ('6', '2022-06-20 00:00:00', '2', 'user002', '3'),
    ('7', '2022-06-20 11:30:00', '2', 'user010', '1'),
    ('8', '2022-06-20 11:45:00', '2', 'user011', '1'),
    ('9', '2022-06-19 06:00:00', '3', 'user003', '3'),
    ('10', '2022-06-19 06:30:00', '3', 'user003', '1'),
    ('11', '2022-06-19 10:45:00', '3', 'user010', '1'),
    ('12', '2022-06-19 11:00:00', '3', 'user010', '4'),
    ('13', '2022-06-20 00:00:00', '4', 'user004', '3'),
    ('14', '2022-06-20 12:00:00', '4', 'user004', '1'),
    ('15', '2022-06-20 12:30:00', '4', 'user010', '1'),
    ('16', '2022-06-20 05:00:00', '5', 'user005', '3'),
    ('17', '2022-06-20 05:30:00', '5', 'user005', '1'),
    ('18', '2022-06-20 12:00:00', '5', 'user011', '1'),
    ('19', '2022-06-20 12:10:00', '5', 'user011', '4'),
    ('20', '2022-06-20 16:00:00', '5', 'user011', '6'),
    ('21', '2022-06-20 00:00:00', '6', 'user006', '3'),
    ('22', '2022-06-20 00:30:00', '6', 'user006', '1'),
    ('23', '2022-06-20 05:00:00', '6', 'user010', '4'),
    ('24', '2022-06-20 06:00:00', '6', 'user002', '1'),
    ('25', '2022-06-20 08:00:00', '6', 'user010', '7'),
    ('26', '2022-06-20 07:00:00', '7', 'user007', '3'),
    ('27', '2022-06-20 11:00:00', '7', 'user011', '4'),
    ('28', '2022-06-20 12:00:00', '7', 'user003', '1'),
    ('29', '2022-06-20 13:00:00', '7', 'user004', '1'),
    ('30', '2022-06-20 05:30:00', '8', 'user001', '3'),
    ('31', '2022-06-20 11:15:00', '8', 'user010', '4'),
    ('32', '2022-06-20 12:00:00', '8', 'user004', '1'),
    ('33', '2022-06-20 13:00:00', '8', 'user007', '1'),
    ('34', '2022-06-05 04:20:00', '9', 'user008', '3'),
    ('35', '2022-06-05 13:30:00', '9', 'user010', '4'),
    ('36', '2022-06-05 13:40:00', '9', 'user005', '1'),
    ('37', '2022-06-05 13:45:00', '9', 'user004', '1'),
    ('38', '2022-06-20 04:00:00', '10', 'user009', '3'),
    ('39', '2022-06-20 06:00:00', '10', 'user011', '4'),
    ('40', '2022-06-20 09:00:00', '10', 'user005', '1'),
    ('41', '2022-06-20 09:10:00', '10', 'user004', '1'),
    ('42', '2022-06-20 10:00:00', '10', 'user011', '7');
Go

INSERT INTO ArticleHist (version,articleID,statusDate,statusCodeID)
VALUES
    ('1', '1', '2022-06-20 06:00:00', '2'),
    ('2', '1', '2022-06-20 12:00:00', '1'),
    ('1', '2', '2022-06-20 00:00:00', '2'),
    ('1', '3', '2022-06-19 06:00:00', '2'),
    ('2', '3', '2022-06-19 11:00:00', '1'),
    ('1', '4', '2022-06-20 00:00:00', '2'),
    ('1', '5', '2022-06-20 05:00:00', '2'),
    ('2', '5', '2022-06-20 12:00:00', '1'),
    ('3', '5', '2022-06-20 14:00:00', '3'),
    ('1', '6', '2022-06-20 00:00:00', '2'),
    ('2', '6', '2022-06-20 05:00:00', '1'),
    ('3', '6', '2022-06-20 15:00:00', '4'),
    ('1', '7', '2022-06-20 07:00:00', '2'),
    ('2', '7', '2022-06-20 11:00:00', '1'),
    ('1', '8', '2022-06-20 05:30:00', '2'),
    ('2', '8', '2022-06-20 11:15:00', '1'),
    ('1', '9', '2022-06-05 04:20:00', '2'),
    ('2', '9', '2022-06-05 13:30:00', '1'),
    ('1', '10', '2022-06-20 04:00:00', '2'),
    ('2', '10', '2022-06-20 06:00:00', '1'),
    ('3', '10', '2022-06-20 07:00:00', '4');
GO

INSERT INTO ActionDetails (actionID,attrTypeCode,attrValue)
VALUES
    ('2', 'SRC', 'MainPage'),
    ('3', 'SRC', 'MainPage'),
    ('4', 'RMK', 'Approved'),
    ('5', 'SRC', 'SearchPage'),
    ('7', 'SRC', 'MainPage'),
    ('8', 'SRC', 'MainPage'),
    ('10', 'SRC', 'OtherArticle'),
    ('11', 'SRC', 'MainPage'),
    ('12', 'RMK', 'Approved'),
    ('14', 'SRC', 'MainPage'),
    ('15', 'SRC', 'MainPage'),
    ('17', 'SRC', 'SearchPage'),
    ('18', 'SRC', 'SearchPage'),
    ('19', 'RMK', 'Approved'),
    ('20', 'RSN', 'Need Reviewing'),
    ('22', 'SRC', 'MainPage'),
    ('23', 'RMK', 'Approved'),
    ('24', 'SRC', 'MainPage'),
    ('25', 'RSN', 'Need Reviewing'),
    ('27', 'RMK', 'Approved'),
    ('28', 'SRC', 'SearchPage'),
    ('29', 'SRC', 'OtherArticle'),
    ('31', 'RMK', 'Approved'),
    ('32', 'SRC', 'SearchPage'),
    ('33', 'SRC', 'SearchPage'),
    ('35', 'RMK', 'Approved'),
    ('36', 'SRC', 'OtherArticle'),
    ('37', 'SRC', 'OtherArticle'),
    ('39', 'RMK', 'Approved'),
    ('40', 'SRC', 'MainPage'),
    ('41', 'SRC', 'MainPage'),
    ('42', 'RSN', 'Duplicate');
Go

INSERT INTO Articles_x_Resources (articleID,resourceID)
VALUES
    ('1', '1'),
    ('1', '2'),
    ('2', '3'),
    ('2', '4'),
    ('3', '5'),
    ('5', '6'),
    ('5', '7'),
    ('8', '8'),
    ('8', '9'),
    ('9', '10'),
    ('10', '11'),
    ('10', '12');
GO

INSERT INTO Articles_x_Users 
VALUES
    ('1', 'posted', 'user001', '2022-06-20 06:00:00'),
    ('1', 'approved', 'user010', '2022-06-20 12:00:00'),
    ('2', 'posted', 'user002', '2022-06-20 00:00:00'),
    ('3', 'posted', 'user003', '2022-06-19 06:00:00'),
    ('3', 'approved', 'user010', '2022-06-19 11:00:00'),
    ('4', 'posted', 'user004', '2022-06-20 00:00:00'),
    ('5', 'posted', 'user005', '2022-06-20 05:00:00'),
    ('5', 'approved', 'user011', '2022-06-20 12:00:00'),
    ('6', 'posted', 'user006', '2022-06-20 00:00:00'),
    ('6', 'approved', 'user010', '2022-06-20 05:00:00'),
    ('7', 'posted', 'user007', '2022-06-20 07:00:00'),
    ('7', 'approved', 'user011', '2022-06-20 11:00:00'),
    ('8', 'posted', 'user001', '2022-06-20 05:30:00'),
    ('8', 'approved', 'user010', '2022-06-20 11:15:00'),
    ('9', 'posted', 'user008', '2022-06-05 04:20:00'),
    ('9', 'approved', 'user010', '2022-06-05 13:30:00'),
    ('10', 'posted', 'user009', '2022-06-20 04:00:00'),
    ('10', 'approved', 'user011', '2022-06-20 06:00:00');
GO

INSERT INTO Users_x_Roles (roleID,userID,effDate,inEffDate)
VALUES
    ('1', 'user001', '2020-12-12 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user002', '2020-12-13 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user003', '2020-12-14 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user004', '2020-12-15 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user005', '2020-12-16 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user006', '2020-12-17 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user007', '2020-12-18 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user008', '2020-12-19 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user009', '2020-12-20 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user010', '2020-12-21 00:00:00', '9999-12-31 00:00:00'),
    ('1', 'user011', '2020-12-22 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user001', '2020-12-12 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user002', '2020-12-13 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user003', '2020-12-14 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user004', '2020-12-15 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user005', '2020-12-16 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user006', '2020-12-17 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user007', '2020-12-18 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user008', '2020-12-19 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user009', '2020-12-20 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user010', '2020-12-21 00:00:00', '9999-12-31 00:00:00'),
    ('2', 'user011', '2020-12-22 00:00:00', '9999-12-31 00:00:00'),
    ('3', 'user010', '2020-12-21 00:00:00', '9999-12-31 00:00:00'),
    ('3', 'user011', '2020-12-22 00:00:00', '9999-12-31 00:00:00'),
    ('4', 'user011', '2020-12-22 00:00:00', '9999-12-31 00:00:00');
GO


/*2.3. Tạo các Object trong database
2.3.1. Tạo trigger
- Mục đích: khi thực hiện xoá một record từ bảng Articles, thì record sẽ không bị xoá mà chuyển statusCodeID thành 4 (tương ứng deleted), đồng thời insert 1 record vào bảng ArticleHist thể hiện bài báo đã bị xoá
*/

CREATE TRIGGER TG_Delele_Article
    ON [dbo].Articles
    instead of DELETE
    AS
    BEGIN
	update [dbo].Articles
	set statusCodeID = 4
	from [dbo].Articles a1
	where a1.articleID in (select d.articleID
							from Deleted d where d.statusCodeID <> 4);

	insert into [dbo].ArticleHist
	select (select max(version) + 1 from ArticleHist sub1 where sub1.articleID = d.articleID) version
	, d.articleID
	, GETDATE()
	, 4
	from deleted d
	where d.statusCodeID <> 4
  
    END
go

select *
from Articles;
delete Articles
where articleID = 1;
select *
from Articles;
select *
from ArticleHist
go


/*2.3.2. Tạo Stored Procedure
	- Mục đích: lấy ra bài báo có số lượt xem cao nhất (tương ứng actionCatID = 1) trong khoảng thời gian được truyền vào. Đầu vào là 2 parameter kiểu date, đầu ra là câu truy vấn
*/
CREATE PROCEDURE dbo.Proc_most_viewed_article 
    @from date ,
    @to date  
AS
    SELECT top 1 a1.articleID, cast(a2.articleName as nvarchar(1000)) articleName, count(*) num_views
	from [dbo].[Actions] a1
	join [dbo].Articles a2 on a1.articleID = a2.articleID
	where actionCatID = 1
	and actionDate between @from and DATEADD(day, 1, @to)
	group by a1.articleID, cast(a2.articleName as nvarchar(1000))
	order by count(*) desc
RETURN 0 
go

exec Proc_most_viewed_article @from = '2020-01-01', @to = '2023-01-01'
go

/*2.3.3. Tạo Function
	- Mục đích: do lúc insert data dư một số dấu ngoặc kép, function này dùng để xoá bỏ các dấu ngoặc kép trong nội dung bài báo. Đầu vào là parameter kiểu ntext, đầu ra là kiểu nvarchar(max) do SQL Server không cho phép ntext làm kiểu dữ liệu đầu ra của output trong function
*/
CREATE FUNCTION [dbo].Fn_remove_quote
(
    @param ntext
)
RETURNS nvarchar(max)
AS
BEGIN

    RETURN replace(cast(@param as nvarchar(max)), N'"', N'')

END
go

select articleContent, dbo.Fn_remove_quote(articleContent)
from Articles
go

/*2.3.4. Tạo Index
	- Mục đích: tạo index trên 2 cột articleID và userID, đây là index non-cluster, non-unique
*/

CREATE INDEX IX_Action_articleID_userID
    ON dbo.Actions
    (articleID, userID);
go

/*2.3.4. Tạo Transaction
	- Mục đích: điều chỉnh các quyền của user sẽ hết hiệu lực trong vòng 2 năm kể từ ngày hiệu lực trong bảng bảng Users_x_Roles; hiệu lực của user đăng nhập sẽ hết kể từ 3 năm tính từ ngày hiệu lực trong bảng Users
 */

begin tran
	update [dbo].[Users_x_Roles]
	set inEffDate = dateadd(year, 2, effDate)
	from [dbo].[Users_x_Roles]

	update [dbo].[Users]
	set inEffDate = dateadd(year, 3, effDate)
	from [dbo].[Users]

commit tran
go

/*2.4. Thực hiện truy vấn
2.4.1. Truy vấn dữ liệu trên một bảng
- Mục đích: lấy tất cả các cột của các bài báo có thể loại là công nghệ (articleCatId = 1)
*/

select *
from Articles
where articleCatID = 1
go

/*2.4.2. Truy vấn có sử dụng Order by
- Mục đích: lấy thông tin thời gian đăng bài của các bài báo và sắp xếp theo thứ tự tăng dần theo thời gian (actionCatID = 3 tương ứng với tương tác Đăng bài)
*/

select a1.articleID, a1.articleName, a2.actionDate
from Articles a1
join Actions a2 on a1.articleID = a2.articleID and a2.actionCatID = 3
order by a2.actionDate, articleID;
go

/*2.4.3. Truy vấn sử dụng toán tử Like và các so sánh xâu ký tự
- Mục đích: lấy thông tin về các bài báo trong tiêu đề chứa chữ số
*/
select *
from Articles
where articleName like '%[0-9]%'
go

/*2.4.4. Truy vấn liên quan tới điều kiện về thời gian
- Mục đích: lấy thông tin liên quan đến các tương tác nằm trong khoảng 10 giờ đến 14 giờ hằng ngày
*/
select *
from Actions
where datepart(hour, actionDate) between 10 and 14
go

/*2.4.5. Truy vấn dữ liệu từ nhiều bảng sử dụng Inner join
- Mục đích: lấy thông tin về ngày đăng, người đăng, ngày duyệt, người duyệt (nếu đã được duyệt) của các bài báo
*/

select a1.articleID, a1.articleName, a2.effDate date_posted, a21.userName user_posted
, a3.effDate date_approved, a31.userName user_approved
from Articles a1
join Articles_x_Users a2 on a1.articleID = a2.articleID and a2.post_approve = 'posted'
join Users a21 on a2.userID = a21.userID
left join Articles_x_Users a3 on a1.articleID = a3.articleID and a3.post_approve = 'approved' 
left join Users a31 on a3.userID = a31.userID;
go


/*2.4.6. Truy vấn sử dụng Self join, Outer join
- Mục đích: lấy ID bài báo, ID tài nguyên của các bài báo có sử dụng 2 tài nguyên hoặc không có sử dụng tài nguyên nào
*/
select isnull(a1.articleID, a3.articleID) articleID, a1.resourceID
from Articles_x_Resources a1
join Articles_x_Resources a2 on a1.articleID = a2.articleID
and a1.resourceID <> a2.resourceID
full outer join Articles a3 on a1.articleID = a3.articleID
go

/*2.4.7. Truy vấn sử dụng truy vấn con
- Mục đích: lấy ID bài báo, tên bài báo và số lượng view của bài báo có số lượng view cao nhất (tương tác có actionCatID = 1 là tương tác xem bài báo)
*/
select tt.articleID, ttt.articleName, tt.num_views
from (
	select articleID, count(*) num_views
	from Actions
	where actionCatID = 1
	group by articleID) tt
	join Articles ttt on tt.articleID = ttt.articleID
	where num_views = (select max(num_views)
							from (
							select articleID, count(*) num_views
							from Actions
							where actionCatID = 1
							group by articleID) t)
go

/*2.4.8. Truy vấn sử dụng With
- Mục đích: lấy ID bài báo, tên bài báo, ngày đăng, ngày duyệt và khoảng thời gian từ lúc đăng đến khi được duyệt (tính theo giờ)
*/
with a1 as (
select a1.articleID, a1.articleName, a2.effDate date_posted, a3.effDate date_approved
from Articles a1
join Articles_x_Users a2 on a1.articleID = a2.articleID and a2.post_approve = 'posted'
join Articles_x_Users a3 on a1.articleID = a3.articleID and a3.post_approve = 'approved' 
)

select a1.*, DATEDIFF(hour, date_posted, date_approved) post2approve
from a1
go

/*2.4.9. Truy vấn thống kê sử dụng Group by và Having
- Mục đích: lấy userID, userName và số lượt xem của những user nào có số lượt xem lớn hơn 2
*/
select a1.userID, a2.userName, count(*) num_views
from Actions a1
join Users a2 on a1.userID = a2.userID
where actionCatID = 1
group by a1.userID, a2.userName
having count(*) >=2
go

/*2.4.10. Truy vấn sử dụng function (hàm) đã viết trong bước trước
- Mục đích: lấy nội dung bài báo trước và sau khi bỏ dấu ngoặc kép
*/
select  articleID, articleName, articleContent contentBefore,
dbo.Fn_remove_quote(articleContent) contentAfter
from Articles
go

use master
go
drop database getBetter
go
create database getBetter 
go
use getBetter 
go

-- Create table
create table [User](
	Id varchar(20) primary key,
	[Password] varchar(50) not null,
	Fullname nvarchar(50) not null,
	Email varchar(50) unique not null,
	[Admin] bit not null default 0,
	Active bit not null default 1
)
go

create table [Video](
	Id varchar(20) primary key,
	Title nvarchar(255) not null,
	Poster varchar(MAX) not null,
	[Views] int not null default 0,
	[Description] nvarchar(MAX) not null,
	UploadDate datetime not null,
	Active bit not null default 1
)
go

create table [History](
	Id int identity(1,1) primary key,
	UserId varchar(20) foreign key references [User](Id),
	VideoId varchar(20) foreign key references Video(Id),
	ViewedDate datetime not null default getdate(),
	IsLiked bit not null default 0,
	LikeDate datetime null
)
go

create table [share](
	Id int identity(1,1) primary key,
	UserID varchar(20) foreign key references [User](Id),
	VideoID varchar(20) foreign key references [Video](Id),
	Email varchar(50) not null,
	ShareDate datetime not null default getdate()
)
go

-- Import Data
insert into Video (Id, Title, Poster, [Views], [Description], UploadDate, Active) values 
(N'IryGw25Kgi0', N'Biết Bố Mày Là Ai Không', N'https://img.youtube.com/vi/IryGw25Kgi0/maxresdefault.jpg', 100, N'Cùng đi tìm nguồn gốc của câu nói huyền thoại: "BIẾT BỐ MÀY LÀ AI KHÔNG" | Hài Xuân Bắc, Tự Long.', getdate(), 1),
(N'Hi9eQnS7snc', N'Quan Trường - Trường Quan', N'https://img.youtube.com/vi/Hi9eQnS7snc/maxresdefault.jpg', 300, N'Phim hài dân gian | Hài Xuân Bắc, Tự Long, Trung Hiếu.', getdate(), 1),
(N'Zc1XepIV4-U', N'Cu Thóc Đi Tán Gái', N'https://img.youtube.com/vi/Zc1XepIV4-U/maxresdefault.jpg', 200, N'Phim Hài Hay Nhất | Cu Thóc, Cường Cá.', getdate(), 1)
go

insert into [User] (Id, [Password], Fullname, Email, [Admin], Active) values 
(N'KhoaDHD', N'123456', N'Đặng Hữu Đăng Khoa', N'khoadhdps14633@fpt.edu.vn', 1, 1),
(N'MaiNT', N'123456', N'Nguyễn Thị Mai', N'maint@gmail.com', 0, 1),
(N'TeoNV', N'123456', N'Nguyễn Văn Tèo', N'teonv@gmail.com', 0, 1),
(N'VanNTT', N'123456', N'Ngô Thị Thanh Vân', N'vanntt@gmail.com', 1, 1)
go

insert into History (UserId, VideoId,  ViewedDate, IsLiked, LikeDate) values 
(N'TeoNV', N'IryGw25Kgi0', getdate(), 1, getdate()),
(N'VanNTT', N'Hi9eQnS7snc', getdate(), 0, null),
(N'MaiNT', N'Zc1XepIV4-U', getdate(), 0, null),
(N'TeoNV', N'Zc1XepIV4-U', getdate(), 1, getdate())
go

insert into Share (UserID, VideoID, Email, ShareDate) values 
(N'VanNTT', N'Hi9eQnS7snc', N'maint@gmail.com', getdate()),
(N'MaiNT', N'IryGw25Kgi0', N'teonv@gmail.com', getdate())
go

-- procedure
create proc sp_TopViewNotInHistory(@size int, @userId VARCHAR(20))
as
begin
	select top (@size) * from Video v
	where v.Id not in (
		select h.VideoId from History h
		where h.UserId = @userId
	)
	order by [Views] desc
end
go

create proc sp_TopViewNotInVideoId(@size int, @videoId VARCHAR(20))
as
begin
	select top (@size) * from Video v
	where v.Id not in (@videoId)
	order by [Views] desc
end
go

create proc sp_TopRandomNotInHistory(@size int, @userId VARCHAR(20))
as
begin
	select top (@size) * from Video v
	where v.Id not in (
		select h.VideoId from History h
		where h.UserId = @userId
	)
	order by newid()
end
go

create proc sp_TopRandomNotInVideoId(@size int, @videoId VARCHAR(20))
as
begin
	select top (@size) * from Video v
	where v.Id not in (@videoId)
	order by newid()
end
go

create proc sp_selectUsersLikedVideoByVideoId(@videoId varchar(20))
as 
begin
	select u.Id, u.Fullname, u.Email, h.LikeDate
	from [User] u inner join History h on u.Id = h.UserId
		inner join Video v on h.VideoId = v.Id
	where v.Id = @videoId AND u.Active = 1 and v.Active = 1 and h.IsLiked = 1
end
CREATE DATABASE	MyBlog
GO
USE MyBlog
GO

CREATE TABLE Users(
UserID int PRIMARY KEY IDENTITY,
UserName varchar(20),
Password varchar(30),
Email varchar(30) UNIQUE,
Address nvarchar(200),
)
Go


CREATE TABLE Posts(
PostID int PRIMARY KEY IDENTITY,
Title nvarchar(200),
Content nvarchar(MAX),
Tag nvarchar(100),
Status BIT,
CreateTime DATETIME DEFAULT GETDATE(),
UpdateTime DATETIME,
UserID int FOREIGN KEY REFERENCES Users(UserID)
)
Go

CREATE TABLE Comments(
CommentID int PRIMARY KEY IDENTITY,
Content nvarchar(500),
Status BIT,
CreateTime datetime DEFAULT GETDATE(),
Author nvarchar(30),
Email varchar(50) NOT NULL,
PostID int FOREIGN KEY REFERENCES Posts(PostID)
)
Go
DROP TABLE Comments
--3
ALTER TABLE Users
ADD CONSTRAINT chk_email CHECK (Email LIKE '%@%')
GO

ALTER TABLE Comments
ADD CONSTRAINT chk_email1 CHECK (Email like '%@%')
GO

--4
CREATE UNIQUE INDEX IX_UserName ON Users(UserName)
GO

--5
INSERT INTO Users VALUES ('Tran Cong Phong', '123456', 'phong@gmail.com', 'Tren Troi'),
						 ('Tran Ma', '456789', 'Ma@gmail.com', 'Duoi Dat'),
						 ('Tran Bo', '845564', 'Bo@gmail.com', 'Chan Nui')
GO
SELECT * FROM Users
INSERT INTO Posts VALUES ('Toan Hoc', N'Hello hello akaka', 'Social', 'true' ,GETDATE(),GETDATE(),1),
						 ('Hoa Hoc', N'Videos', 'methienha', 'true' ,GETDATE(),GETDATE(),2),
						 ('Vat Ly', N'meme', 'tretrau', 'true' ,GETDATE(),GETDATE(),3)
						

GO
SELECT * FROM Posts
INSERT INTO Comments VALUES (N'Content1', 'true', GETDATE()+5, 'Jay', 'pong@gmail.com',1),
							(N'Content2', 'true', GETDATE()-4, 'Jay1','pong1@gmail.com',2),
							(N'Content3', 'true', GETDATE()-10, 'Jay2', 'pong2@gmail.com',3)
--6
SELECT * FROM Posts WHERE Tag = 'Social'
--7
SELECT * FROM Posts WHERE UserID in (SELECT UserID From Users WHERE Email='phong@gmail.com')
--8
SELECT COUNT(*) as Count FROM Comments
--9
CREATE VIEW v_NewPost AS
SELECT  TOP 2 dbo.Posts.Title, dbo.Users.UserName, dbo.Posts.CreateTime
FROM            dbo.Posts INNER JOIN
                         dbo.Users ON dbo.Posts.UserID = dbo.Users.UserID
ORDER BY dbo.Posts.CreateTime DESC
--10
CREATE Procedure sp_GetComment 
	@PostID int
AS
BEGIN
	select * from Comments where PostID = @PostID
END

GO
--11
CREATE TRIGGER tg_UpdateTime
ON Posts
AFTER  INSERT,UPDATE AS
BEGIN
   UPDATE Posts 
   SET UpdateTime = GETDATE()
   FROM Posts
   JOIN deleted ON Posts.PostID = deleted.PostID    
END

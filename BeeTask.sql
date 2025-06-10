-- ========== USERS ==========
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    AvatarUrl NVARCHAR(255) NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- ========== TASK STATUSES ==========
CREATE TABLE TaskStatuses (
    StatusId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) UNIQUE NOT NULL
);


-- Sample Statuses
INSERT INTO TaskStatuses (Name) VALUES 
(N'To Do'), 
(N'In Progress'), 
(N'Done'), 
(N'Pending'), 
(N'Review');

-- ========== LABELS ==========
CREATE TABLE Labels (
    LabelId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) UNIQUE NOT NULL,
    Color NVARCHAR(20) NULL
);

-- ========== PROJECTS ==========
CREATE TABLE Projects (
    ProjectId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Projects_Users FOREIGN KEY (CreatedBy) REFERENCES Users(UserId)
);

-- ========== PROJECT MEMBERS ==========
CREATE TABLE ProjectMembers (
    ProjectId INT NOT NULL,
    UserId INT NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    CONSTRAINT CHK_ProjectMembers_Role CHECK (Role IN ('Leader', 'Member')),
    CONSTRAINT PK_ProjectMembers PRIMARY KEY (ProjectId, UserId),
    CONSTRAINT FK_ProjectMembers_Projects FOREIGN KEY (ProjectId) REFERENCES Projects(ProjectId),
    CONSTRAINT FK_ProjectMembers_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== TEMPLATES ==========
CREATE TABLE Templates (
    TemplateId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Category NVARCHAR(100) NULL,
    ThumbnailUrl NVARCHAR(255) NULL,
    SampleData NVARCHAR(MAX) NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Templates_Users FOREIGN KEY (CreatedBy) REFERENCES Users(UserId)
);


-- ========== TEMPLATE BOARDS ==========
CREATE TABLE TemplateBoards (
    TemplateBoardId INT PRIMARY KEY IDENTITY,
    TemplateId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CONSTRAINT FK_TemplateBoards_Templates FOREIGN KEY (TemplateId) REFERENCES Templates(TemplateId)
);

-- ========== TEMPLATE TASKS ==========
CREATE TABLE TemplateTasks (
    TemplateTaskId INT PRIMARY KEY IDENTITY,
    TemplateBoardId INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Status NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_TemplateTasks_TemplateBoards FOREIGN KEY (TemplateBoardId) REFERENCES TemplateBoards(TemplateBoardId),
    CONSTRAINT CHK_TemplateTasks_Status CHECK (Status IN ('To Do', 'In Progress', 'Done', 'Pending', 'Review'))
);

-- ========== BOARDS ==========
CREATE TABLE Boards (
    BoardId INT PRIMARY KEY IDENTITY,
    ProjectId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Boards_Projects FOREIGN KEY (ProjectId) REFERENCES Projects(ProjectId)
);

-- ========== BOARD MEMBERS ==========
CREATE TABLE BoardMembers (
    BoardId INT NOT NULL,
    UserId INT NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    CONSTRAINT CHK_BoardMembers_Role CHECK (Role IN ('Leader', 'Member')),
    CONSTRAINT PK_BoardMembers PRIMARY KEY (BoardId, UserId),
    CONSTRAINT FK_BoardMembers_Boards FOREIGN KEY (BoardId) REFERENCES Boards(BoardId),
    CONSTRAINT FK_BoardMembers_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== LISTS ==========
CREATE TABLE Lists (
    ListId INT PRIMARY KEY IDENTITY,
    BoardId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Lists_Boards FOREIGN KEY (BoardId) REFERENCES Boards(BoardId)
);

-- ========== TASKS ==========
CREATE TABLE Tasks (
    TaskId INT PRIMARY KEY IDENTITY,
    BoardId INT NOT NULL,
    ListId INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    StatusId INT NOT NULL,
    DueDate DATETIME NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    CONSTRAINT FK_Tasks_Boards FOREIGN KEY (BoardId) REFERENCES Boards(BoardId),
    CONSTRAINT FK_Tasks_Lists FOREIGN KEY (ListId) REFERENCES Lists(ListId),
    CONSTRAINT FK_Tasks_TaskStatuses FOREIGN KEY (StatusId) REFERENCES TaskStatuses(StatusId),
    CONSTRAINT FK_Tasks_Users FOREIGN KEY (CreatedBy) REFERENCES Users(UserId)
);

-- =========== TASK APPROVE ============
CREATE TABLE TaskApprovals (
    ApprovalId INT PRIMARY KEY IDENTITY,
    TaskId INT NOT NULL UNIQUE,
    LeaderId INT NOT NULL,
    ApprovalStatus NVARCHAR(20) NOT NULL CHECK (ApprovalStatus IN ('Approved', 'Rejected')),
    Feedback NVARCHAR(MAX) NULL,
    ActionTime DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TaskApprovals_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId) ON DELETE CASCADE,
    CONSTRAINT FK_TaskApprovals_Users FOREIGN KEY (LeaderId) REFERENCES Users(UserId)
);

-- ========== TASK ASSIGNEES ==========
CREATE TABLE TaskAssignees (
    TaskId INT NOT NULL,
    UserId INT NOT NULL,
    CONSTRAINT PK_TaskAssignees PRIMARY KEY (TaskId, UserId),
    CONSTRAINT FK_TaskAssignees_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),
    CONSTRAINT FK_TaskAssignees_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== TASK LABELS ==========
CREATE TABLE TaskLabels (
    TaskId INT NOT NULL,
    LabelId INT NOT NULL,
    CONSTRAINT PK_TaskLabels PRIMARY KEY (TaskId, LabelId),
    CONSTRAINT FK_TaskLabels_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),
    CONSTRAINT FK_TaskLabels_Labels FOREIGN KEY (LabelId) REFERENCES Labels(LabelId)
);

-- ========== TASK ATTACHMENTS ==========
CREATE TABLE TaskAttachments (
    AttachmentId INT PRIMARY KEY IDENTITY,
    TaskId INT NOT NULL,
    FileUrl NVARCHAR(255) NULL,
    FileName NVARCHAR(100) NULL,
    FileType NVARCHAR(50) NULL,
    FileSize INT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TaskAttachments_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId)
);

-- ========== TASK COMMENTS ==========
CREATE TABLE TaskComments (
    CommentId INT PRIMARY KEY IDENTITY,
    TaskId INT NOT NULL,
    UserId INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TaskComments_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),
    CONSTRAINT FK_TaskComments_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== COMMENT MENTIONS ==========
CREATE TABLE CommentMentions (
    CommentId INT NOT NULL,
    MentionedUserId INT NOT NULL,
    CONSTRAINT PK_CommentMentions PRIMARY KEY (CommentId, MentionedUserId),
    CONSTRAINT FK_CommentMentions_TaskComments FOREIGN KEY (CommentId) REFERENCES TaskComments(CommentId),
    CONSTRAINT FK_CommentMentions_Users FOREIGN KEY (MentionedUserId) REFERENCES Users(UserId)
);

-- ========== NOTES ==========
CREATE TABLE Notes (
    NoteId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Content NVARCHAR(MAX) NULL,
    Tag NVARCHAR(50) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Notes_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== CALENDAR EVENTS ==========
CREATE TABLE CalendarEvents (
    EventId INT PRIMARY KEY IDENTITY,	
    UserId INT NOT NULL,
    TaskId INT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    ReminderTime DATETIME NULL,
    CONSTRAINT FK_CalendarEvents_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_CalendarEvents_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId)
);

-- ========== AI SCHEDULES ==========
CREATE TABLE AISchedules (
    AIScheduleId INT PRIMARY KEY IDENTITY,
    TaskId INT NOT NULL,
    SuggestedStartTime DATETIME NULL,
    SuggestedEndTime DATETIME NULL,
    ConfidenceScore FLOAT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_AISchedules_Tasks FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),
    CONSTRAINT CHK_AISchedules_Status CHECK (Status IN ('Pending', 'Accepted', 'Rejected'))
);

-- ========== NOTIFICATIONS ==========
CREATE TABLE Notifications (
    NotificationId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL,
    Message NVARCHAR(255) NOT NULL,
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== SEARCH LOGS ==========
CREATE TABLE SearchLogs (
    LogId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL,
    Keyword NVARCHAR(100) NULL,
    SearchTime DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_SearchLogs_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

-- ========== DATA INSERTS  ==========

-- USERS 
INSERT INTO Users (FullName, Email, PasswordHash, AvatarUrl) VALUES
(N'Nguyễn Văn A', 'a@gmail.com', 'hash1', 'avatar1.png'),
(N'Lê Thị B', 'b@gmail.com', 'hash2', 'avatar2.png'),
(N'Trần Văn C', 'c@gmail.com', 'hash3', 'avatar3.png'),
(N'Phạm Thị D', 'd@gmail.com', 'hash4', 'avatar4.png'),
(N'Hồ Văn E', 'e@gmail.com', 'hash5', 'avatar5.png'),
(N'Đinh Ngọc F', 'f@gmail.com', 'hash6', 'avatar6.png'),
(N'Võ Thị G', 'g@gmail.com', 'hash7', 'avatar7.png'),
(N'Bùi Văn H', 'h@gmail.com', 'hash8', 'avatar8.png'),
(N'Đặng Thị I', 'i@gmail.com', 'hash9', 'avatar9.png'),
(N'Lý Văn J', 'j@gmail.com', 'hash10', 'avatar10.png'),
(N'Vũ Thị K', 'k@gmail.com', 'hash11', 'avatar11.png'),
(N'Hoàng Văn L', 'l@gmail.com', 'hash12', 'avatar12.png'),
(N'Chu Thị M', 'm@gmail.com', 'hash13', 'avatar13.png'),
(N'Dương Văn N', 'n@gmail.com', 'hash14', 'avatar14.png');

-- LABELS 
INSERT INTO Labels (Name, Color) VALUES
(N'Medium', 'yellow'),
(N'Important', 'red'),
(N'Low', 'green'),
(N'High', 'orange'),
(N'Urgent', 'darkred'),
(N'Bug', 'crimson'),
(N'Feature', 'blue'),
(N'Testing', 'brown');

-- PROJECTS 
INSERT INTO Projects (Name, Description, CreatedBy) VALUES
(N'Website Development', N'Phát triển website công ty', 1),
(N'Mobile App', N'Ứng dụng di động cho khách hàng', 2),
(N'Marketing Campaign', N'Chiến dịch marketing Q2', 3),
(N'Database Migration', N'Di chuyển cơ sở dữ liệu', 4),
(N'AI Integration', N'Tích hợp AI vào hệ thống', 5),
(N'Security Audit', N'Kiểm tra bảo mật hệ thống', 6),
(N'UI/UX Redesign', N'Thiết kế lại giao diện', 7);

-- PROJECT MEMBERS
INSERT INTO ProjectMembers (ProjectId, UserId, Role) VALUES
(1, 1, 'Leader'), (1, 2, 'Member'), (1, 3, 'Member'),
(2, 2, 'Leader'), (2, 4, 'Member'), (2, 5, 'Member'),
(3, 3, 'Leader'), (3, 6, 'Member'), (3, 7, 'Member'),
(4, 4, 'Leader'), (4, 8, 'Member'), (4, 9, 'Member'),
(5, 5, 'Leader'), (5, 10, 'Member'), (5, 11, 'Member'),
(6, 6, 'Leader'), (6, 12, 'Member'), (6, 13, 'Member'),
(7, 7, 'Leader'), (7, 14, 'Member'), (7, 1, 'Member');

-- TEMPLATES 
INSERT INTO Templates (Name, Description, Category, ThumbnailUrl, SampleData, CreatedBy)
VALUES 
(N'Kanban Template', N'Organize tasks with visual boards', N'Project Management', N'https://www.hdwallpapers.in/download/beautiful_view_of_trees_lights_reflection_on_water_mountains_background_under_clouds_sky_hd_lock_screen-HD.jpg', N'{"boards": ["To Do", "In Progress", "Done"]}', 1),
(N'To Do Template', N'Simple task management', N'Personal', N'https://c4.wallpaperflare.com/wallpaper/654/989/292/love-image-4k-full-screen-wallpaper-preview.jpg', N'{"boards": ["To Do"]}', 1),
(N'V Model Template', N'Software development lifecycle', N'Development', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT61lS44nkvxUYAnK2yFxVjJOHjCu0-o9Uzsw&s', N'{"boards": ["Requirements", "Design", "Implementation", "Testing"]}', 1),
(N'Agile Template', N'Agile project methodology', N'Development', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQ4RS5OsphIEbQkrANKyulho5dIxIc7pCBSw&s', N'{"boards": ["Backlog", "Sprint", "Review"]}', 1),
(N'Waterfall Template', N'Sequential project phases', N'Development', N'https://thumbs.dreamstime.com/b/textured-wood-terrace-beautiful-dusky-sky-free-copy-space-use-background-backdrop-to-display-goods-new-product-41480172.jpg', N'{"boards": ["Requirements", "Design", "Build", "Test", "Deploy"]}', 1),
(N'Scrum Template', N'Sprint-based development', N'Development', N'https://img.freepik.com/free-photo/majestic-mountain-peak-tranquil-winter-landscape-generated-by-ai_188544-15662.jpg?semt=ais_items_boosted&w=740', N'{"boards": ["Sprint Backlog", "In Progress", "Done", "Retrospective"]}', 1);


-- TEMPLATE BOARDS
INSERT INTO TemplateBoards (TemplateId, Name, Description) VALUES
(1, N'Planning', N'Lập kế hoạch dự án'),
(1, N'Development', N'Phát triển sản phẩm'),
(1, N'Testing', N'Kiểm thử sản phẩm'),
(2, N'Research', N'Nghiên cứu thị trường'),
(2, N'Planning', N'Lập kế hoạch marketing'),
(2, N'Execution', N'Thực hiện chiến dịch'),
(3, N'Preparation', N'Chuẩn bị sự kiện'),
(3, N'Coordination', N'Điều phối sự kiện'),
(4, N'Research', N'Nghiên cứu sản phẩm'),
(4, N'Development', N'Phát triển sản phẩm');

-- TEMPLATE TASKS 
INSERT INTO TemplateTasks (TemplateBoardId, Title, Description, Status) VALUES
(1, N'Phân tích yêu cầu', N'Phân tích chi tiết yêu cầu dự án', 'To Do'),
(1, N'Thiết kế architecture', N'Thiết kế kiến trúc hệ thống', 'To Do'),
(2, N'Coding backend', N'Phát triển backend API', 'In Progress'),
(2, N'Coding frontend', N'Phát triển giao diện người dùng', 'In Progress'),
(3, N'Unit testing', N'Kiểm thử đơn vị', 'To Do'),
(3, N'Integration testing', N'Kiểm thử tích hợp', 'To Do'),
(4, N'Khảo sát khách hàng', N'Khảo sát nhu cầu khách hàng', 'Done'),
(4, N'Phân tích đối thủ', N'Phân tích đối thủ cạnh tranh', 'In Progress'),
(5, N'Lập kế hoạch content', N'Lập kế hoạch nội dung marketing', 'To Do'),
(5, N'Thiết kế creative', N'Thiết kế creative cho campaign', 'To Do'),
(6, N'Chạy quảng cáo', N'Thực hiện chạy quảng cáo', 'To Do'),
(6, N'Theo dõi metrics', N'Theo dõi các chỉ số hiệu quả', 'To Do'),
(7, N'Chọn địa điểm', N'Chọn địa điểm tổ chức sự kiện', 'Done'),
(7, N'Liên hệ vendors', N'Liên hệ các nhà cung cấp', 'In Progress'),
(8, N'Phân công nhiệm vụ', N'Phân công nhiệm vụ cho team', 'To Do'),
(9, N'Market research', N'Nghiên cứu thị trường cho sản phẩm', 'Done'),
(9, N'Competitor analysis', N'Phân tích đối thủ cạnh tranh', 'In Progress'),
(10, N'Feature development', N'Phát triển tính năng sản phẩm', 'In Progress');

-- BOARDS 
INSERT INTO Boards (ProjectId, Name, Description) VALUES
(1, N'Frontend Development', N'Phát triển giao diện người dùng'),
(1, N'Backend Development', N'Phát triển backend API'),
(2, N'iOS Development', N'Phát triển ứng dụng iOS'),
(2, N'Android Development', N'Phát triển ứng dụng Android'),
(3, N'Social Media', N'Marketing trên mạng xã hội'),
(3, N'Content Creation', N'Tạo nội dung marketing'),
(4, N'Data Migration', N'Di chuyển dữ liệu'),
(5, N'AI Research', N'Nghiên cứu AI'),
(6, N'Vulnerability Assessment', N'Đánh giá lỗ hổng bảo mật'),
(7, N'User Research', N'Nghiên cứu người dùng');

-- BOARD MEMBERS 
INSERT INTO BoardMembers (BoardId, UserId, Role) VALUES
(1, 1, 'Leader'), (1, 2, 'Member'), (1, 3, 'Member'),
(2, 1, 'Leader'), (2, 4, 'Member'), (2, 5, 'Member'),
(3, 2, 'Leader'), (3, 6, 'Member'), (3, 7, 'Member'),
(4, 2, 'Leader'), (4, 8, 'Member'), (4, 9, 'Member'),
(5, 3, 'Leader'), (5, 10, 'Member'), (5, 11, 'Member'),
(6, 3, 'Leader'), (6, 12, 'Member'), (6, 13, 'Member'),
(7, 4, 'Leader'), (7, 14, 'Member'), (7, 1, 'Member'),
(8, 5, 'Leader'), (8, 2, 'Member'), (8, 3, 'Member'),
(9, 6, 'Leader'), (9, 4, 'Member'), (9, 5, 'Member'),
(10, 7, 'Leader'), (10, 6, 'Member'), (10, 8, 'Member');

-- LISTS 
INSERT INTO Lists (BoardId, Name) VALUES
(1, N'To Do'), (1, N'In Progress'), (1, N'Done'),
(2, N'Backlog'), (2, N'Development'), (2, N'Testing'),
(3, N'Planning'), (3, N'Development'), (3, N'App Store'),
(4, N'Planning'), (4, N'Development'), (4, N'Play Store'),
(5, N'Content Ideas'), (5, N'In Progress'), (5, N'Published'),
(6, N'Brainstorm'), (6, N'Creation'), (6, N'Review'),
(7, N'Preparation'), (7, N'Migration'), (7, N'Validation'),
(8, N'Research'), (8, N'Development'), (8, N'Testing'),
(9, N'Assessment'), (9, N'Remediation'), (9, N'Verified'),
(10, N'Research'), (10, N'Analysis'), (10, N'Recommendations');

-- TASKS 
INSERT INTO Tasks (BoardId, ListId, Title, Description, StatusId, DueDate, CreatedBy) VALUES
(1, 1, N'Thiết kế component Button', N'Tạo component Button tái sử dụng', 1, '2025-06-15', 1),
(1, 1, N'Thiết kế component Input', N'Tạo component Input form', 1, '2025-06-20', 2),
(1, 2, N'Implement login page', N'Phát triển trang đăng nhập', 2, '2025-06-25', 1),
(1, 3, N'Homepage layout', N'Hoàn thành layout trang chủ', 3, '2025-06-10', 3),
(2, 4, N'Setup database schema', N'Thiết lập cơ sở dữ liệu', 1, '2025-07-01', 1),
(2, 5, N'User authentication API', N'API xác thực người dùng', 2, '2025-06-30', 4),
(2, 6, N'Unit tests for auth', N'Kiểm thử đơn vị cho auth', 1, '2025-07-05', 5),
(3, 7, N'iOS wireframes', N'Tạo wireframe cho iOS app', 1, '2025-06-18', 2),
(3, 8, N'Core data setup', N'Thiết lập Core Data', 2, '2025-06-22', 6),
(3, 9, N'App Store submission', N'Nộp app lên App Store', 1, '2025-07-15', 7),
(4, 10, N'Android wireframes', N'Tạo wireframe cho Android', 1, '2025-06-18', 2),
(4, 11, N'Room database setup', N'Thiết lập Room database', 2, '2025-06-22', 8),
(4, 12, N'Play Store submission', N'Nộp app lên Play Store', 1, '2025-07-15', 9),
(5, 13, N'Facebook campaign', N'Chiến dịch quảng cáo Facebook', 2, '2025-06-12', 3),
(5, 14, N'Instagram stories', N'Tạo Instagram stories', 2, '2025-06-14', 10),
(5, 15, N'LinkedIn articles', N'Viết bài cho LinkedIn', 3, '2025-06-08', 11),
(6, 16, N'Blog post ideas', N'Brainstorm ý tưởng blog', 1, '2025-06-16', 3),
(6, 17, N'Video content script', N'Viết script cho video', 2, '2025-06-20', 12),
(6, 18, N'Infographic design', N'Thiết kế infographic', 1, '2025-06-25', 13),
(7, 19, N'Data backup', N'Sao lưu dữ liệu hiện tại', 3, '2025-06-05', 4),
(7, 20, N'Schema migration', N'Di chuyển schema database', 2, '2025-06-28', 14),
(7, 21, N'Data validation', N'Kiểm tra tính toàn vẹn dữ liệu', 1, '2025-07-02', 1),
(8, 22, N'ML model research', N'Nghiên cứu mô hình ML', 2, '2025-07-10', 5),
(8, 23, N'Data preprocessing', N'Tiền xử lý dữ liệu', 2, '2025-06-25', 2),
(8, 24, N'Model training', N'Huấn luyện mô hình', 1, '2025-07-15', 3),
(9, 25, N'Security scan', N'Quét bảo mật hệ thống', 2, '2025-06-18', 6),
(9, 26, N'Vulnerability report', N'Báo cáo lỗ hổng bảo mật', 1, '2025-06-22', 4),
(9, 27, N'Security patches', N'Vá lỗi bảo mật', 1, '2025-06-25', 5),
(10, 28, N'User interviews', N'Phỏng vấn người dùng', 3, '2025-06-01', 7),
(10, 29, N'Usability testing', N'Kiểm thử khả năng sử dụng', 2, '2025-06-15', 14),
(10, 30, N'User journey mapping', N'Lập bản đồ hành trình người dùng', 1, '2025-06-18', 1),
(1, 2, N'Component library', N'Xây dựng thư viện component', 2, '2025-06-20', 9);

-- TASK ASSIGNEES
INSERT INTO TaskAssignees (TaskId, UserId) VALUES
(1, 1), (1, 2), (2, 2), (2, 3), (3, 1), (3, 4),
(4, 3), (4, 5), (5, 1), (5, 6), (6, 4), (6, 7),
(7, 5), (7, 8), (8, 2), (8, 9), (9, 6), (9, 10),
(10, 7), (10, 11), (11, 2), (11, 12), (12, 8), (12, 13),
(13, 9), (13, 14), (14, 3), (14, 1), (15, 10), (15, 2),
(16, 11), (16, 3), (17, 3), (17, 4), (18, 12), (18, 5),
(19, 13), (19, 6), (20, 4), (20, 1), (21, 14), (21, 2),
(22, 1), (22, 3), (23, 4), (23, 5), (24, 2), (24, 6),
(25, 3), (25, 7), (26, 5), (26, 8), (27, 4), (27, 9),
(28, 6), (28, 10), (29, 7), (29, 11), (30, 14), (30, 12),
(31, 1), (31, 13), (32, 9), (32, 14);

-- TASK LABELS 
INSERT INTO TaskLabels (TaskId, LabelId) VALUES
(1, 1), (1, 7), (2, 1), (2, 7), (3, 2), (3, 7),
(4, 3), (4, 7), (5, 2), (5, 6), (6, 4), (6, 6),
(7, 1), (7, 8), (8, 2), (8, 7), (9, 4), (9, 7),
(10, 1), (10, 7), (11, 2), (11, 7), (12, 4), (12, 7),
(13, 3), (13, 2), (14, 1), (14, 2), (15, 2), (15, 3),
(16, 3), (16, 2), (17, 4), (17, 2), (18, 1), (18, 2),
(19, 5), (19, 6), (20, 4), (20, 6), (21, 2), (21, 8),
(22, 3), (22, 8), (23, 4), (23, 8), (24, 5), (24, 8),
(25, 2), (25, 7), (26, 1), (26, 7), (27, 4), (27, 7),
(28, 3), (28, 7), (29, 2), (29, 7), (30, 5), (30, 7),
(31, 4), (31, 6), (32, 2), (32, 6);

-- TASK ATTACHMENTS
INSERT INTO TaskAttachments (TaskId, FileUrl, FileName, FileType, FileSize) VALUES
(1, 'https://example.com/files/button-spec.pdf', 'button-specification.pdf', 'pdf', 1024000),
(2, 'https://example.com/files/input-design.fig', 'input-design.fig', 'figma', 2048000),
(3, 'https://example.com/files/login-mockup.png', 'login-mockup.png', 'image', 512000),
(5, 'https://example.com/files/db-schema.sql', 'database-schema.sql', 'sql', 256000),
(6, 'https://example.com/files/auth-flow.pdf', 'authentication-flow.pdf', 'pdf', 1536000),
(8, 'https://example.com/files/ios-wireframe.sketch', 'ios-wireframe.sketch', 'sketch', 3072000),
(11, 'https://example.com/files/android-wireframe.xd', 'android-wireframe.xd', 'adobe-xd', 2560000),
(14, 'https://example.com/files/fb-campaign.xlsx', 'facebook-campaign-plan.xlsx', 'excel', 768000),
(15, 'https://example.com/files/insta-stories.psd', 'instagram-stories.psd', 'photoshop', 4096000),
(17, 'https://example.com/files/video-script.docx', 'video-script.docx', 'word', 128000),
(18, 'https://example.com/files/infographic.ai', 'infographic-design.ai', 'illustrator', 5120000),
(20, 'https://example.com/files/migration-plan.pdf', 'data-migration-plan.pdf', 'pdf', 2048000),
(22, 'https://example.com/files/ml-research.pdf', 'ml-model-research.pdf', 'pdf', 3584000),
(23, 'https://example.com/files/data-preprocessing.py', 'data-preprocessing.py', 'python', 64000),
(25, 'https://example.com/files/security-scan.pdf', 'security-scan-report.pdf', 'pdf', 1792000),
(28, 'https://example.com/files/user-interviews.mp4', 'user-interviews.mp4', 'video', 10240000),
(29, 'https://example.com/files/usability-test.pdf', 'usability-test-results.pdf', 'pdf', 1280000),
(1, 'https://example.com/files/button-prototype.html', 'button-prototype.html', 'html', 16000),
(3, 'https://example.com/files/login-test.js', 'login-test-cases.js', 'javascript', 32000),
(6, 'https://example.com/files/auth-test.postman', 'auth-api-tests.postman_collection.json', 'json', 128000),
(9, 'https://example.com/files/coredata-model.xcdatamodeld', 'coredata-model.xcdatamodeld', 'xcode', 64000);

-- TASK COMMENTS 
INSERT INTO TaskComments (TaskId, UserId, Content) VALUES
(1, 2, N'Đã review thiết kế, cần điều chỉnh màu sắc theo brand guideline'),
(1, 1, N'Cảm ơn feedback, sẽ update trong phiên bản tiếp theo'),
(3, 4, N'Login page đã hoàn thành 80%, cần thêm validation cho form'),
(3, 1, N'Good job! Hãy thêm error handling cho các trường hợp edge case'),
(5, 5, N'Database schema đã được approve bởi DBA team'),
(6, 4, N'API authentication đang có issue với JWT token expiration'),
(6, 1, N'Tôi sẽ check và fix issue này trong ngày hôm nay'),
(8, 6, N'iOS wireframe cần điều chỉnh layout cho iPhone SE'),
(8, 2, N'Noted, sẽ tạo responsive design cho các màn hình nhỏ'),
(11, 8, N'Android wireframe trông rất tốt, ready for development'),
(14, 10, N'Facebook campaign đã được approve budget 50 triệu'),
(14, 3, N'Tuyệt vời! Sẽ bắt đầu setup campaign ngay tuần này'),
(15, 11, N'Instagram stories design rất creative và engaging'),
(17, 12, N'Video script cần thêm call-to-action ở cuối'),
(17, 3, N'Đồng ý, sẽ thêm CTA và contact information'),
(20, 14, N'Data migration script đã được test trên staging environment'),
(20, 4, N'Kết quả test như thế nào? Có vấn đề gì không?'),
(22, 2, N'ML model research đã tìm ra 3 approaches phù hợp'),
(22, 5, N'Excellent! Hãy prepare presentation để share với team'),
(25, 2, N'Security scan phát hiện 2 medium-level vulnerabilities'),
(25, 6, N'Đã tạo tickets để fix những vulnerabilities này'),
(28, 4, N'User interviews cho insights rất valuable về UX'),
(28, 7, N'Cảm ơn, sẽ incorporate findings vào redesign'),
(32, 1, N'Component library documentation cần update'),
(32, 9, N'Sẽ update documentation tuần tới'),
(1, 3, N'Cần thêm hover states cho button component'),
(2, 4, N'Input component cần support cho different validation types'),
(5, 6, N'Database performance optimization cần được consider'),
(8, 7, N'iOS design cần follow Apple Human Interface Guidelines'),
(11, 9, N'Android design cần follow Material Design principles'),
(14, 12, N'Facebook campaign targeting cần được refined'),
(15, 13, N'Instagram stories cần thêm interactive elements'),
(20, 1, N'Data migration cần rollback plan'),
(22, 3, N'ML model cần more training data'),
(25, 4, N'Security vulnerabilities cần được prioritize');

-- COMMENT MENTIONS 
INSERT INTO CommentMentions (CommentId, MentionedUserId) VALUES
(1, 1), (3, 1), (4, 4), (6, 1), (7, 4),
(8, 2), (9, 6), (11, 3), (12, 10), (14, 3),
(16, 4), (17, 14), (19, 5), (20, 2), (22, 6),
(23, 7), (24, 4), (26, 7), (27, 2), (28, 4);

-- NOTES
INSERT INTO Notes (UserId, Title, Content, Tag) VALUES
(1, N'Meeting Notes - Sprint Planning', N'Đã thảo luận về sprint goals và task assignments. Cần focus vào performance optimization.', N'meeting'),
(2, N'Research Findings - User Behavior', N'Người dùng thường abandon form khi có quá nhiều fields. Cần simplify registration process.', N'research'),
(3, N'Marketing Ideas - Q2 Campaign', N'Tập trung vào social media marketing với video content. Budget allocation: 60% Facebook, 40% Instagram.', N'marketing'),
(4, N'Technical Debt - Database', N'Cần refactor legacy queries và optimize indexes. Estimated effort: 2 weeks.', N'technical'),
(5, N'AI Integration - Phase 1', N'Bắt đầu với recommendation system. Cần 3 months cho research và development.', N'ai'),
(6, N'Security Checklist', N'1. Update dependencies\n2. Review access controls\n3. Implement rate limiting\n4. Add monitoring', N'security'),
(7, N'Design System Update', N'Cần update color palette và typography. New brand guidelines từ marketing team.', N'design'),
(8, N'API Versioning Strategy', N'Implement semantic versioning. Maintain backward compatibility for 2 major versions.', N'api'),
(9, N'Performance Metrics - April', N'Page load time: 2.1s (target: <2s)\nAPI response time: 150ms\nUptime: 99.9%', N'metrics'),
(10, N'User Feedback Summary', N'Top requests: Dark mode, mobile app, better search functionality. High satisfaction: 4.2/5', N'feedback'),
(11, N'Competitor Analysis - Features', N'Competitor A: Strong mobile app\nCompetitor B: Better onboarding\nCompetitor C: Advanced analytics', N'analysis'),
(12, N'Team Retrospective - Sprint 12', N'What went well: Good collaboration\nWhat to improve: Code review process\nAction items: Update guidelines', N'retrospective'),
(13, N'Technology Trends - 2025', N'Key trends: AI integration, serverless architecture, edge computing, privacy-first design', N'trends'),
(14, N'Budget Planning - Q3', N'Development: $50k\nMarketing: $30k\nInfrastructure: $20k\nTotal: $100k', N'budget'),
(1, N'Daily Standup Notes', N'Yesterday: Completed login component\nToday: Working on authentication API\nBlockers: None', N'standup'),
(2, N'User Story Mapping', N'Epic: User Management\nStories: Registration, Login, Profile, Settings\nPriority: High', N'planning'),
(3, N'Content Calendar - June', N'Week 1: Product announcement\nWeek 2: Tutorial videos\nWeek 3: User testimonials\nWeek 4: Feature highlights', N'marketing'),
(4, N'Database Backup Strategy', N'Daily incremental backups\nWeekly full backups\nMonthly archive to cold storage\nTest restore quarterly', N'backup'),
(5, N'Machine Learning Pipeline', N'Data ingestion → Preprocessing → Feature engineering → Model training → Evaluation → Deployment', N'ml'),
(6, N'Incident Response Plan', N'1. Detect & Alert\n2. Assess Impact\n3. Contain Issue\n4. Resolve\n5. Post-mortem', N'incident'),
(7, N'Accessibility Audit Results', N'WCAG 2.1 AA compliance: 85%\nIssues found: 12\nHigh priority: 4\nMedium priority: 8', N'accessibility'),
(8, N'Third-party Integrations', N'Payment: Stripe\nAnalytics: Google Analytics\nEmail: SendGrid\nPush notifications: Firebase', N'integrations'),
(9, N'Server Monitoring Setup', N'CPU usage alerts > 80%\nMemory usage > 85%\nDisk space < 10%\nResponse time > 2s', N'monitoring'),
(10, N'Mobile App Requirements', N'Platform: iOS & Android\nFramework: React Native\nFeatures: Offline mode, push notifications', N'mobile'),
(11, N'SEO Optimization Plan', N'On-page: Meta tags, structured data\nOff-page: Link building, content marketing\nTechnical: Site speed, mobile-first', N'seo'),
(12, N'Data Privacy Compliance', N'GDPR compliance checklist\nData retention policies\nUser consent management\nData deletion procedures', N'privacy'),
(13, N'Testing Strategy', N'Unit tests: 80% coverage\nIntegration tests: Critical paths\nE2E tests: User journeys\nPerformance tests: Load & stress', N'testing'),
(14, N'Vendor Evaluation - Cloud Services', N'AWS: Comprehensive but expensive\nGoogle Cloud: Good AI/ML services\nAzure: Strong enterprise features', N'vendor');

-- CALENDAR EVENTS 
INSERT INTO CalendarEvents (UserId, TaskId, Title, Description, StartTime, EndTime, ReminderTime) VALUES
(1, 1, N'Design Review - Button Component', N'Review thiết kế button component với team', '2025-06-10 09:00:00', '2025-06-10 10:00:00', '2025-06-10 08:45:00'),
(2, 3, N'Login Implementation Sprint', N'Sprint để implement login functionality', '2025-06-15 10:00:00', '2025-06-15 12:00:00', '2025-06-15 09:45:00'),
(3, 14, N'Marketing Campaign Launch', N'Kickoff meeting cho Facebook campaign', '2025-06-12 14:00:00', '2025-06-12 15:30:00', '2025-06-12 13:45:00'),
(4, 20, N'Database Migration Planning', N'Planning session cho data migration', '2025-06-20 09:00:00', '2025-06-20 11:00:00', '2025-06-20 08:30:00'),
(5, 22, N'AI Research Presentation', N'Present ML model research findings', '2025-06-25 15:00:00', '2025-06-25 16:00:00', '2025-06-25 14:45:00'),
(6, 25, N'Security Assessment Review', N'Review security scan results', '2025-06-18 11:00:00', '2025-06-18 12:00:00', '2025-06-18 10:45:00'),
(7, 28, N'User Research Session', N'Conduct user interviews', '2025-06-05 14:00:00', '2025-06-05 17:00:00', '2025-06-05 13:30:00'),
(1, NULL, N'Team Daily Standup', N'Daily standup meeting', '2025-06-07 09:00:00', '2025-06-07 09:30:00', '2025-06-07 08:55:00'),
(2, NULL, N'Sprint Planning', N'Sprint planning for next iteration', '2025-06-09 10:00:00', '2025-06-09 12:00:00', '2025-06-09 09:45:00'),
(3, NULL, N'Marketing Weekly Sync', N'Weekly sync with marketing team', '2025-06-11 15:00:00', '2025-06-11 16:00:00', '2025-06-11 14:45:00'),
(4, NULL, N'Architecture Review', N'Monthly architecture review meeting', '2025-06-13 14:00:00', '2025-06-13 16:00:00', '2025-06-13 13:45:00'),
(5, NULL, N'AI Team Retrospective', N'Sprint retrospective for AI team', '2025-06-16 16:00:00', '2025-06-16 17:00:00', '2025-06-16 15:45:00'),
(6, NULL, N'Security Training', N'Security awareness training session', '2025-06-19 09:00:00', '2025-06-19 11:00:00', '2025-06-19 08:45:00'),
(7, NULL, N'Design System Workshop', N'Workshop về design system updates', '2025-06-21 10:00:00', '2025-06-21 12:00:00', '2025-06-21 09:45:00'),
(8, NULL, N'Code Review Session', N'Weekly code review session', '2025-06-23 14:00:00', '2025-06-23 15:00:00', '2025-06-23 13:45:00'),
(9, NULL, N'Product Demo', N'Demo sản phẩm cho stakeholders', '2025-06-26 15:00:00', '2025-06-26 16:30:00', '2025-06-26 14:45:00'),
(10, NULL, N'Customer Feedback Session', N'Review customer feedback và insights', '2025-06-28 11:00:00', '2025-06-28 12:00:00', '2025-06-28 10:45:00'),
(11, NULL, N'Performance Review', N'Quarterly performance review', '2025-06-30 14:00:00', '2025-06-30 15:00:00', '2025-06-30 13:45:00'),
(12, NULL, N'Innovation Brainstorm', N'Brainstorming session cho new features', '2025-07-02 10:00:00', '2025-07-02 11:30:00', '2025-07-02 09:45:00'),
(1, 6, N'API Testing Session', N'Testing authentication API', '2025-06-25 11:00:00', '2025-06-25 12:00:00', '2025-06-25 10:45:00'),
(2, 8, N'iOS Development Review', N'Review iOS app development progress', '2025-06-20 15:00:00', '2025-06-20 16:00:00', '2025-06-20 14:45:00');

-- AI SCHEDULES 
INSERT INTO AISchedules (TaskId, SuggestedStartTime, SuggestedEndTime, ConfidenceScore, Status) VALUES
(1, '2025-06-10 09:00:00', '2025-06-10 11:00:00', 0.85, 'Accepted'),
(2, '2025-06-11 14:00:00', '2025-06-11 16:00:00', 0.78, 'Pending'),
(3, '2025-06-12 10:00:00', '2025-06-12 12:00:00', 0.92, 'Accepted'),
(5, '2025-06-15 09:00:00', '2025-06-15 17:00:00', 0.88, 'Accepted'),
(6, '2025-06-16 13:00:00', '2025-06-16 15:00:00', 0.75, 'Pending'),
(8, '2025-06-18 10:00:00', '2025-06-18 12:00:00', 0.82, 'Accepted'),
(9, '2025-06-19 14:00:00', '2025-06-19 16:00:00', 0.79, 'Rejected'),
(11, '2025-06-20 09:00:00', '2025-06-20 11:00:00', 0.86, 'Accepted'),
(14, '2025-06-23 15:00:00', '2025-06-23 17:00:00', 0.91, 'Accepted'),
(15, '2025-06-24 10:00:00', '2025-06-24 12:00:00', 0.73, 'Pending'),
(17, '2025-06-25 14:00:00', '2025-06-25 16:00:00', 0.87, 'Accepted'),
(20, '2025-06-26 09:00:00', '2025-06-26 17:00:00', 0.94, 'Accepted'),
(22, '2025-06-27 13:00:00', '2025-06-27 15:00:00', 0.76, 'Pending'),
(25, '2025-06-30 10:00:00', '2025-06-30 16:00:00', 0.89, 'Accepted'),
(28, '2025-07-01 09:00:00', '2025-07-01 11:00:00', 0.81, 'Pending'),
(29, '2025-07-02 14:00:00', '2025-07-02 16:00:00', 0.83, 'Accepted'),
(30, '2025-07-03 10:00:00', '2025-07-03 12:00:00', 0.77, 'Pending'),
(32, '2025-07-04 15:00:00', '2025-07-04 17:00:00', 0.85, 'Accepted');

-- NOTIFICATIONS
INSERT INTO Notifications (UserId, Message, IsRead) VALUES
(1, N'Task "Thiết kế component Button" đã được assign cho bạn', 1),
(2, N'Bạn có comment mới trong task "Login Implementation"', 0),
(3, N'Deadline của task "Facebook campaign" sắp đến', 0),
(4, N'Task "Database Migration" đã được hoàn thành', 1),
(5, N'Bạn được mention trong comment của task "AI Research"', 0),
(6, N'Security scan đã phát hiện vulnerabilities mới', 1),
(7, N'User interview session sẽ bắt đầu trong 30 phút', 0),
(8, N'API documentation đã được update', 1),
(9, N'Bạn có meeting mới: Product Demo', 0),
(10, N'Task "Customer Feedback" cần review', 0),
(1, N'Sprint planning meeting đã được schedule', 1),
(2, N'Code review cho PR #123 đã sẵn sàng', 0),
(3, N'Marketing campaign metrics đã được update', 1),
(4, N'Database backup đã hoàn thành thành công', 1),
(5, N'ML model training đã bắt đầu', 0),
(6, N'Security patch đã được deploy', 1),
(7, N'Design system update đã được release', 0),
(8, N'API rate limit đã được tăng lên', 1),
(9, N'Performance test results đã sẵn sàng', 0),
(10, N'User feedback survey đã được gửi', 1),
(11, N'Bạn có task mới được assign: "Component Library"', 0),
(12, N'Meeting "Innovation Brainstorm" đã được reschedule', 1),
(13, N'Bug report mới đã được tạo', 0),
(14, N'Quarterly review meeting reminder', 0),
(1, N'New feature request từ client', 1),
(2, N'Server maintenance sẽ diễn ra vào cuối tuần', 0),
(3, N'Training session "React Advanced" đã được approve', 1),
(4, N'Project milestone đã được đạt', 0),
(5, N'Team lunch meeting đã được confirm', 1),
(6, N'Annual performance review sắp đến', 0),
(7, N'Deployment to production đã thành công', 1),
(8, N'Critical bug đã được fix', 0),
(9, N'Social media campaign performance tốt', 1),
(10, N'Database optimization đã hoàn thành', 1),
(11, N'AI model accuracy đã cải thiện 15%', 0);

-- SEARCH LOGS 
INSERT INTO SearchLogs (UserId, Keyword) VALUES
(1, N'button component'),
(1, N'react hooks'),
(2, N'authentication'),
(2, N'login form'),
(3, N'marketing campaign'),
(3, N'facebook ads'),
(4, N'database migration'),
(4, N'sql optimization'),
(5, N'machine learning'),
(5, N'tensorflow'),
(6, N'security vulnerability'),
(6, N'penetration testing'),
(7, N'user experience'),
(7, N'design system'),
(8, N'api documentation'),
(8, N'swagger'),
(9, N'performance testing'),
(9, N'load balancing'),
(10, N'customer feedback'),
(10, N'user survey'),
(11, N'component library'),
(11, N'storybook'),
(12, N'code review'),
(12, N'git workflow'),
(13, N'bug tracking'),
(13, N'jira'),
(14, N'project management'),
(14, N'agile methodology'),
(1, N'typescript'),
(2, N'jwt token'),
(3, N'instagram stories'),
(4, N'database backup'),
(5, N'neural networks'),
(6, N'owasp top 10'),
(7, N'accessibility');

INSERT INTO TaskApprovals (TaskId, LeaderId, ApprovalStatus, Feedback)
VALUES
(1, 2, 'Approved', N'Làm tốt, cần duy trì phong độ.'),
(2, 3, 'Rejected', N'Thiếu phần kiểm thử, bổ sung test case trước khi xác nhận.'),
(3, 2, 'Approved', N'Hoàn thành đúng tiến độ. Giao diện rõ ràng.'),
(4, 1, 'Rejected', N'Yêu cầu thêm demo prototype và hướng dẫn triển khai.'),
(5, 4, 'Approved', N'Task này được thực hiện xuất sắc. Không có điểm cần chỉnh.');

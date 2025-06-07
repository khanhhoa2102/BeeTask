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
    SampleData NVARCHAR(MAX) NULL,
    CreatedBy INT NOT NULL,
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

-- ========== DATA INSERTS ==========

-- USERS
INSERT INTO Users (FullName, Email, PasswordHash, AvatarUrl) VALUES
(N'Nguyễn Văn A', 'a@gmail.com', 'hash1', 'avatar1.png'),
(N'Lê Thị B', 'b@gmail.com', 'hash2', 'avatar2.png'),
(N'Trần Văn C', 'c@gmail.com', 'hash3', 'avatar3.png'),
(N'Phạm Thị D', 'd@gmail.com', 'hash4', 'avatar4.png'),
(N'Hồ Văn E', 'e@gmail.com', 'hash5', 'avatar5.png'),
(N'Đinh Ngọc F', 'f@gmail.com', 'hash6', 'avatar6.png');

-- LABELS
INSERT INTO Labels (Name, Color) VALUES
(N'Medium', 'yellow'),
(N'Important', 'red'),
(N'Low', 'green'),
(N'High', 'orange'),
(N'Urgent', 'darkred'),
(N'Later', 'lightgray');

-- PROJECTS
INSERT INTO Projects (Name, Description, CreatedBy) VALUES
(N'Baitap 1', N'Dự án bài tập 1', 1),
(N'Baitap 2', N'Dự án bài tập 2', 2),
(N'Baitap 3', N'Dự án bài tập 3', 3);

-- PROJECT MEMBERS
INSERT INTO ProjectMembers (ProjectId, UserId, Role) VALUES
(1, 1, 'Leader'),
(1, 2, 'Member'),
(2, 2, 'Leader'),
(3, 3, 'Leader'),
(3, 4, 'Member');

-- BOARDS
INSERT INTO Boards (ProjectId, Name, Description) VALUES
(1, N'Board A', N'Board cho dự án 1'),
(2, N'Board B', N'Board cho dự án 2'),
(3, N'Board C', N'Board cho dự án 3');

-- BOARD MEMBERS
INSERT INTO BoardMembers (BoardId, UserId, Role) VALUES
(1, 1, 'Leader'),
(1, 2, 'Member'),
(2, 2, 'Leader'),
(3, 3, 'Leader'),
(3, 4, 'Member');

-- LISTS
INSERT INTO Lists (BoardId, Name) VALUES
(1, N'To Do'),
(1, N'In Progress'),
(2, N'To Do'),
(3, N'Done');

-- TASKS
INSERT INTO Tasks (BoardId, ListId, Title, Description, StatusId, DueDate, CreatedBy) VALUES
(1, 1, N'Task 1', N'Mô tả công việc 1', 1, '2025-06-30', 1),
(1, 2, N'Task 2', N'Mô tả công việc 2', 2, '2025-07-10', 2),
(2, 3, N'Task 3', N'Mô tả công việc 3', 3, '2025-07-15', 3);

-- TASK ASSIGNEES
INSERT INTO TaskAssignees (TaskId, UserId) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 3);

-- TASK LABELS
INSERT INTO TaskLabels (TaskId, LabelId) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);

-- NOTES
INSERT INTO Notes (UserId, Title, Content, Tag) VALUES
(1, N'Note 1', N'Nội dung ghi chú 1', N'Tag1'),
(2, N'Note 2', N'Nội dung ghi chú 2', N'Tag2');

-- NOTIFICATIONS
INSERT INTO Notifications (UserId, Message) VALUES
(1, N'Bạn có một công việc mới'),
(2, N'Có thay đổi trong dự án');


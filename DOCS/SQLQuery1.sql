-- PROG6212 PART 1 SECTION C - RACEDAY SYSTEM DATABASE SCRIPT
-- Student: Michael King | Student Number: ST10474442
USE master;
GO
IF DB_ID(N'RaceDayDB') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDayDB;
END;
GO
CREATE DATABASE RaceDayDB;
GO
USE RaceDayDB;
GO

CREATE TABLE Organiser (
    OrganiserID INT IDENTITY(1,1) NOT NULL,
    OrganisationName NVARCHAR(150) NOT NULL,
    ContactName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    RegistrationDate DATE NOT NULL CONSTRAINT DF_Organiser_RegistrationDate DEFAULT (CONVERT(DATE,GETDATE())),
    CONSTRAINT PK_Organiser PRIMARY KEY (OrganiserID),
    CONSTRAINT UQ_Organiser_Email UNIQUE (Email)
);
GO

CREATE TABLE Venue (
    VenueID INT IDENTITY(1,1) NOT NULL,
    VenueName NVARCHAR(150) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Province NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    CONSTRAINT PK_Venue PRIMARY KEY (VenueID),
    CONSTRAINT CK_Venue_Capacity CHECK (Capacity > 0)
);
GO

CREATE TABLE Participant (
    ParticipantID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NVARCHAR(20) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    RegistrationDate DATE NOT NULL CONSTRAINT DF_Participant_RegistrationDate DEFAULT (CONVERT(DATE,GETDATE())),
    CONSTRAINT PK_Participant PRIMARY KEY (ParticipantID),
    CONSTRAINT UQ_Participant_Email UNIQUE (Email)
);
GO

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(120) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    MinAge INT NOT NULL,
    MaxAge INT NOT NULL,
    GenderRestriction NVARCHAR(20) NOT NULL CONSTRAINT DF_Category_GenderRestriction DEFAULT (N'Open'),
    CONSTRAINT PK_Category PRIMARY KEY (CategoryID),
    CONSTRAINT UQ_Category_Name UNIQUE (CategoryName),
    CONSTRAINT CK_Category_MinAge CHECK (MinAge >= 0),
    CONSTRAINT CK_Category_MaxAge CHECK (MaxAge >= MinAge)
);
GO

CREATE TABLE Event (
    EventID INT IDENTITY(1,1) NOT NULL,
    OrganiserID INT NOT NULL,
    VenueID INT NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    EventStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_Event_Status DEFAULT (N'Scheduled'),
    CONSTRAINT PK_Event PRIMARY KEY (EventID),
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserID) REFERENCES Organiser(OrganiserID),
    CONSTRAINT FK_Event_Venue FOREIGN KEY (VenueID) REFERENCES Venue(VenueID),
    CONSTRAINT CK_Event_Time CHECK (EndTime > StartTime)
);
GO

CREATE TABLE Enrollment (
    EnrollmentID INT IDENTITY(1,1) NOT NULL,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrollmentDate DATE NOT NULL CONSTRAINT DF_Enrollment_Date DEFAULT (CONVERT(DATE,GETDATE())),
    Status NVARCHAR(30) NOT NULL CONSTRAINT DF_Enrollment_Status DEFAULT (N'Registered'),
    BibNumber INT NOT NULL,
    PaidAmount DECIMAL(10,2) NOT NULL CONSTRAINT DF_Enrollment_PaidAmount DEFAULT (0.00),
    CONSTRAINT PK_Enrollment PRIMARY KEY (EnrollmentID),
    CONSTRAINT FK_Enrollment_Participant FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID),
    CONSTRAINT FK_Enrollment_Event FOREIGN KEY (EventID) REFERENCES Event(EventID),
    CONSTRAINT FK_Enrollment_Category FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    CONSTRAINT UQ_Enrollment_BibNumber UNIQUE (BibNumber),
    CONSTRAINT UQ_Enrollment_Participant_Event UNIQUE (ParticipantID,EventID),
    CONSTRAINT CK_Enrollment_PaidAmount CHECK (PaidAmount >= 0)
);
GO

CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) NOT NULL,
    EnrollmentID INT NOT NULL,
    PaymentDate DATE NOT NULL CONSTRAINT DF_Payment_Date DEFAULT (CONVERT(DATE,GETDATE())),
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(30) NOT NULL,
    PaymentStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_Payment_Status DEFAULT (N'Completed'),
    TransactionReference NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Payment PRIMARY KEY (PaymentID),
    CONSTRAINT FK_Payment_Enrollment FOREIGN KEY (EnrollmentID) REFERENCES Enrollment(EnrollmentID),
    CONSTRAINT UQ_Payment_Enrollment UNIQUE (EnrollmentID),
    CONSTRAINT UQ_Payment_TransactionReference UNIQUE (TransactionReference),
    CONSTRAINT CK_Payment_Amount CHECK (Amount > 0)
);
GO

CREATE TABLE Result (
    ResultID INT IDENTITY(1,1) NOT NULL,
    EnrollmentID INT NOT NULL,
    FinishTime TIME NULL,
    Position INT NULL,
    ResultStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_Result_Status DEFAULT (N'Pending'),
    CONSTRAINT PK_Result PRIMARY KEY (ResultID),
    CONSTRAINT FK_Result_Enrollment FOREIGN KEY (EnrollmentID) REFERENCES Enrollment(EnrollmentID),
    CONSTRAINT UQ_Result_Enrollment UNIQUE (EnrollmentID),
    CONSTRAINT CK_Result_Position CHECK (Position IS NULL OR Position > 0)
);
GO

INSERT INTO Organiser (OrganisationName,ContactName,Email,Phone,Address) VALUES
(N'RaceDay Events',N'Thabo Mokoena',N'thabo@raceday.co.za',N'0825550101',N'12 Market Street, Polokwane'),
(N'Active South Africa',N'Lerato Nkosi',N'lerato@active.co.za',N'0835550102',N'45 Main Road, Johannesburg');
GO

INSERT INTO Venue (VenueName,Address,City,Province,Capacity) VALUES
(N'Polokwane Sports Complex',N'123 Stadium Road',N'Polokwane',N'Limpopo',5000),
(N'Johannesburg City Stadium',N'45 Main Street',N'Johannesburg',N'Gauteng',10000),
(N'Durban Coastal Arena',N'78 Beach Road',N'Durban',N'KwaZulu-Natal',8000);
GO

INSERT INTO Participant (FirstName,LastName,DateOfBirth,Gender,Email,Phone,Address) VALUES
(N'Michael',N'King','2002-05-15',N'Male',N'michael.king@email.com',N'0715550101',N'Durban, KwaZulu-Natal'),
(N'Sipho',N'Dlamini','1998-08-20',N'Male',N'sipho.dlamini@email.com',N'0725550102',N'Polokwane, Limpopo'),
(N'Ayanda',N'Ndlovu','2001-03-12',N'Female',N'ayanda.ndlovu@email.com',N'0735550103',N'Johannesburg, Gauteng'),
(N'Zanele',N'Khumalo','1995-11-25',N'Female',N'zanele.khumalo@email.com',N'0745550104',N'Durban, KwaZulu-Natal');
GO

INSERT INTO Category (CategoryName,Description,MinAge,MaxAge,GenderRestriction) VALUES
(N'5 KM Run',N'Five kilometre running event',16,100,N'Open'),
(N'10 KM Run',N'Ten kilometre road race',18,100,N'Open'),
(N'Half Marathon',N'Twenty-one kilometre running event',18,100,N'Open'),
(N'Junior Run',N'Running category for younger participants',12,17,N'Open'),
(N'Women''s Race',N'Race category for female participants',18,100,N'Female'),
(N'Men''s Race',N'Race category for male participants',18,100,N'Male');
GO

INSERT INTO Event (OrganiserID,VenueID,EventName,Description,EventDate,StartTime,EndTime,EventStatus) VALUES
(1,1,N'Limpopo Spring Race',N'Annual running event in Polokwane','2026-09-12','07:00:00','13:00:00',N'Scheduled'),
(2,2,N'Johannesburg City Challenge',N'Major city running challenge','2026-10-03','06:30:00','14:00:00',N'Scheduled'),
(1,3,N'Durban Coastal Run',N'Coastal running event in Durban','2026-11-14','06:00:00','13:00:00',N'Scheduled');
GO

INSERT INTO Enrollment (ParticipantID,EventID,CategoryID,EnrollmentDate,Status,BibNumber,PaidAmount) VALUES
(1,1,1,'2026-08-10',N'Registered',101,150.00),
(2,1,2,'2026-08-11',N'Registered',102,250.00),
(3,2,1,'2026-08-12',N'Registered',201,150.00),
(4,2,5,'2026-08-13',N'Registered',202,200.00),
(1,3,2,'2026-08-14',N'Registered',301,250.00),
(3,3,3,'2026-08-15',N'Registered',302,350.00);
GO

INSERT INTO Payment (EnrollmentID,PaymentDate,Amount,PaymentMethod,PaymentStatus,TransactionReference) VALUES
(1,'2026-08-10',150.00,N'Card',N'Completed',N'TXN100001'),
(2,'2026-08-11',250.00,N'EFT',N'Completed',N'TXN100002'),
(3,'2026-08-12',150.00,N'Card',N'Completed',N'TXN100003'),
(4,'2026-08-13',200.00,N'EFT',N'Completed',N'TXN100004'),
(5,'2026-08-14',250.00,N'Card',N'Completed',N'TXN100005'),
(6,'2026-08-15',350.00,N'Card',N'Completed',N'TXN100006');
GO

INSERT INTO Result (EnrollmentID,FinishTime,Position,ResultStatus) VALUES
(1,'09:15:32',1,N'Finished'),
(2,'09:42:18',2,N'Finished'),
(3,'10:05:44',1,N'Finished');
GO

SELECT * FROM Organiser;
SELECT * FROM Venue;
SELECT * FROM Participant;
SELECT * FROM Category;
SELECT * FROM Event;
SELECT * FROM Enrollment;
SELECT * FROM Payment;
SELECT * FROM Result;
GO

SELECT p.FirstName + N' ' + p.LastName AS Participant,
       e.EventName,e.EventDate,v.VenueName,c.CategoryName,
       en.BibNumber,en.Status AS EnrollmentStatus,en.PaidAmount,
       pay.PaymentMethod,pay.PaymentStatus,r.FinishTime,r.Position,r.ResultStatus
FROM Enrollment AS en
INNER JOIN Participant AS p ON en.ParticipantID=p.ParticipantID
INNER JOIN Event AS e ON en.EventID=e.EventID
INNER JOIN Category AS c ON en.CategoryID=c.CategoryID
INNER JOIN Venue AS v ON e.VenueID=v.VenueID
LEFT JOIN Payment AS pay ON en.EnrollmentID=pay.EnrollmentID
LEFT JOIN Result AS r ON en.EnrollmentID=r.EnrollmentID
ORDER BY e.EventDate,en.BibNumber;
GO

SELECT COUNT(*) AS TotalOrganisers FROM Organiser;
SELECT COUNT(*) AS TotalParticipants FROM Participant;
SELECT COUNT(*) AS TotalEvents FROM Event;
SELECT COUNT(*) AS TotalCategories FROM Category;
SELECT COUNT(*) AS TotalEnrollments FROM Enrollment;
SELECT COUNT(*) AS TotalPayments FROM Payment;
SELECT COUNT(*) AS TotalResults FROM Result;
GO

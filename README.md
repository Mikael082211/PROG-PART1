1. Project Overview

The RaceDay System is a database-driven system designed to manage race events and the participants who take part in them.

The system is planned to support the management of race organisers, participants, venues, events, categories, enrolments, payments and race results.

The purpose of Part 1 is to plan the database structure and API before application development begins. This includes designing an Entity Relationship Diagram (ERD), planning the RESTful API endpoints, creating the SQL Server database and preparing the repository structure.

The planning documents provide a clear foundation for the development of the RaceDay application in the following parts of the project.

2. Objectives

The main objectives of the RaceDay System are to:

Design a properly structured relational database.
Identify the entities and relationships required by the system.
Define primary keys and foreign keys.
Establish appropriate one-to-many relationships.
Plan the RESTful API before development begins.
Create and populate the database using SQL Server.
Maintain data integrity through constraints.
Use role-based access to separate organiser and participant functionality.
Use GitHub for version control.
Use GitHub Actions to validate the project structure.

3. System Roles

The RaceDay System uses two main roles.

3.1 Organiser

The Organiser is responsible for managing the race events and administrative information within the system.

An organiser can:

Create events.
Update events.
Delete events.
Create and manage race categories.
View participant enrolments.
Manage enrolment information.
Record race results.
Update race results.
Manage event-related information.

The organiser information is stored in the Organiser entity.

3.2 Participant

The Participant is a person who registers for and takes part in RaceDay events.

A participant can:

Create an account.
Log into the system.
View and update their profile.
View available events.
View event information.
View available categories.
Enrol in events.
Cancel an enrolment.
View their race-related information.

Participant information is stored in the Participant entity.

4. Database Design

The RaceDay database uses a relational structure consisting of the following entities:

Organiser
Participant
Venue
Event
Category
Enrollment
Payment
Result

These entities represent the main information required to operate the RaceDay system.

5. Entity Relationships

The main database relationships are structured as follows:

Organiser → Event

One organiser can organise many events.

Relationship:

Organiser (1) → Event (Many)

Venue → Event

One venue can host many events.

Relationship:

Venue (1) → Event (Many)

Participant → Enrollment

One participant can have many enrolments.

Relationship:

Participant (1) → Enrollment (Many)

Event → Enrollment

One event can have many enrolments.

Relationship:

Event (1) → Enrollment (Many)

Category → Enrollment

One category can be associated with many enrolments.

Relationship:

Category (1) → Enrollment (Many)

Enrollment → Payment

An enrolment can have a payment associated with it.

Relationship:

Enrollment (1) → Payment (Many)

Enrollment → Result

An enrolment can have a race result.

Relationship:

Enrollment (1) → Result (0..1)

The result is optional because a participant may be enrolled in an event before completing the race.

6. ERD

The final Entity Relationship Diagram represents all eight entities and their relationships.

The ERD identifies:

Primary keys (PK)
Foreign keys (FK)
One-to-many relationships
Optional relationships
Entity attributes
Database structure

The final ERD is stored in the /docs folder.

ERD file:

/docs/RaceDay_ERD.png

The ERD and SQL database script have been designed to correspond with one another so that the database implementation follows the planned data model.

7. API Endpoint Plan

Before application development, a RESTful API endpoint plan was created.

The endpoint plan covers the required system functionality, including:

Authentication
User profiles
Events
Categories
Event enrolments
Results

The API follows standard HTTP methods:

Method	Purpose
GET	Retrieve information
POST	Create new information
PUT	Update existing information
DELETE	Remove information

The complete API Endpoint Plan is available in:

/docs/API_Endpoint_Plan.md

The API plan will be used as the development specification for Part 2.

8. API Security and Roles

The planned API uses role-based access control.

Public endpoints can be accessed without authentication, while protected endpoints require the user to be logged in.

Administrative operations are restricted to the Organiser role.

Participant-specific operations are restricted to the Participant role.

Examples include:

Organiser
    ├── Create Event
    ├── Update Event
    ├── Delete Event
    ├── Manage Categories
    ├── Manage Enrolments
    └── Manage Results

Participant
    ├── Manage Profile
    ├── View Events
    ├── View Categories
    ├── Enrol in Events
    └── Cancel Enrolment
9. SQL Database

The RaceDay database is designed for Microsoft SQL Server and can be created using SQL Server Management Studio (SSMS).

The SQL script contains:

CREATE DATABASE
CREATE TABLE
Primary keys
Foreign keys
NOT NULL constraints
UNIQUE constraints
DEFAULT values
Data validation constraints
Sample INSERT statements

The database is populated with realistic sample data.

The sample data includes at least:

2 Organisers
2 Participants
3 Events
Categories associated with the events
Sample enrolments
Sample payments
Sample results

The final SQL script is located at:

/docs/RaceDay_Database.sql

10. Database Integrity

Foreign key constraints are used to maintain relationships between the database entities.

For example:

Event.OrganiserID
        ↓
Organiser.OrganiserID

and:

Enrollment.ParticipantID
        ↓
Participant.ParticipantID
Enrollment.EventID
        ↓
Event.EventID
Enrollment.CategoryID
        ↓
Category.CategoryID
Payment.EnrollmentID
        ↓
Enrollment.EnrollmentID
Result.EnrollmentID
        ↓
Enrollment.EnrollmentID

These relationships help maintain referential integrity and prevent invalid related records from being inserted.


11. GitHub and Version Control

GitHub is used to manage the RaceDay project and track development progress.

Meaningful commits are used throughout the project to demonstrate the development process.

The repository follows the required minimum of 20 meaningful commits for Part 1.

Examples of meaningful commits include:

Initial project structure
Added RaceDay ERD
Updated ERD relationships
Added API endpoint planning
Added Organiser table
Added Participant table
Added Venue table
Added Event table
Added Category table
Added Enrollment table
Added Payment table
Added Result table
Added database constraints
Added sample data
Updated SQL foreign keys
Tested SQL database
Added README
Added GitHub Actions workflow
Updated documentation
Final Part 1 submission preparation

12. Testing

The SQL script should be tested on a clean SQL Server instance using SQL Server Management Studio.

Testing includes:

Creating the database.
Creating all tables.
Creating primary keys.
Creating foreign keys.
Applying constraints.
Inserting sample data.
Checking relationships.
Running SELECT queries.
Confirming that the script executes without errors.

Example validation query:

SELECT * FROM Organiser;
SELECT * FROM Participant;
SELECT * FROM Venue;
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrollment;
SELECT * FROM Payment;
SELECT * FROM Result;

These queries can be used to confirm that the database has been successfully populated.

13. Conclusion

Part 1 establishes the technical foundation for the RaceDay System before application development begins.

The ERD provides the structure of the relational database, while the SQL script implements this structure in SQL Server. The API Endpoint Plan defines how the future application will communicate with the database and separates functionality according to the Organiser and Participant roles.

GitHub and GitHub Actions provide version control and automated repository validation.

Together, these planning components provide a clear and organised foundation for developing the RaceDay RESTful API in Part 2.

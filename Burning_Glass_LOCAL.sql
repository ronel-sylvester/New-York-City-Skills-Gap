CREATE DATABASE burning_glass;
USE burning_glass;
CREATE TABLE RECORDS (
    `JobID` VARCHAR(300) NOT NULL,
    `State_ID` INT DEFAULT NULL,
    `State_Name` VARCHAR(300) DEFAULT NULL,
    `MSA_ID` VARCHAR(300) NOT NULL,
    `MSA_Name` VARCHAR(300) DEFAULT NULL,
    `County` VARCHAR(300) DEFAULT NULL,
    `Occupation_Code` VARCHAR(300) NOT NULL,
    `Occupation_Name` VARCHAR(300) DEFAULT NULL,
    `Occupation_Title` VARCHAR(300) DEFAULT NULL,
    `Degree_Level` VARCHAR(300) DEFAULT NULL,
    `Experience_Level` VARCHAR(300) DEFAULT NULL,
    `Edu_Major` VARCHAR(300) DEFAULT NULL,
    `Salary` DECIMAL(20,2) DEFAULT NULL,
    `Posting_Duration` INT DEFAULT NULL,
    `Skill_ID` VARCHAR(300) DEFAULT NULL,
    `Skill_Name` VARCHAR(300) DEFAULT NULL,
    `Skill_Type` INT DEFAULT NULL,
    `Cert_ID` VARCHAR(300) DEFAULT NULL,
    `Cert_Name` VARCHAR(300) DEFAULT NULL
    );
    
LOAD DATA LOCAL INFILE '/Users/ronel/OneDrive/Documents/College/Level/Burning_Glass/BGT.txt'
INTO TABLE RECORDS
IGNORE 2 LINES;

drop table if exists job;

SET @row_number = 0;
CREATE TABLE Job
SELECT (@row_number:=@row_number + 1) AS Main_ID,
JobID, County, Posting_Duration, Salary, 
Cert_ID, MSA_ID, Occupation_Code, Skill_ID, State_ID
FROM RECORDS;

#TITLE
Drop Table if Exists Title;
CREATE TABLE Title
(Title_ID INT(10) Auto_Increment Primary Key,
Occupation_Title VarChar(300) Not NULL);

Insert Into Title(Occupation_Title) 
Select Distinct Occupation_Title
From RECORDS;

#DEGREE
Drop Table if Exists Degree;
CREATE TABLE Degree
(Degree_ID INT(10) Auto_Increment Primary Key,
Degree_Level VarChar(300) DEFAULT NULL);

Insert Into Degree(Degree_Level) 
Select Distinct Degree_Level
From RECORDS;

#Major
Drop Table if Exists Major;
CREATE TABLE Major
(Major_ID INT(10) Auto_Increment Primary Key,
Edu_Major VarChar(300) DEFAULT NULL);

Insert Into Major(Edu_Major) 
Select Distinct Edu_Major
From RECORDS;

#County
CREATE TABLE County_Table
(County_ID INT(10) Auto_Increment Primary Key,
County VarChar(300) DEFAULT NULL);

Insert Into County_Table(County) 
Select Distinct County
From RECORDS;

#Experience
Drop Table if Exists Degree;
CREATE TABLE Experience 
(Exp_ID INT(10) Auto_Increment Primary Key,
Experience_Level VarChar(300) DEFAULT NULL);

Insert Into Experience(Experience_Level) 
Select Distinct Experience_Level
From RECORDS;

#Occupation
Create Table Occupation (Primary Key (Occupation_Code))
Select Occupation_Code, Occupation_Name
From records
Group By Occupation_Code;

#Skill
Create Table Skill (Primary Key (Skill_ID))
Select Skill_ID, Skill_Name, Skill_Type
From records
Group By Skill_ID;

Drop Table if Exists Skill;

#Certification
Create Table Certification (Primary Key (Cert_ID))
Select Cert_ID, Cert_Name
From records
Group By Cert_ID;

#MSA
Create Table MSA (Primary Key (MSA_ID))
Select MSA_ID, MSA_Name
From records
Group By MSA_ID;

#State
Create Table State (Primary Key (State_ID))
Select State_ID, State_Name
From records
Group By State_ID;


Create Table Temp
(ID int(11) not null auto_increment, Primary Key (ID))
Select JobID, State_ID, MSA_ID, Cert_ID, Occupation_Code,
Occupation_Title,

c.County_ID as County_ID,
d.Degree_ID as Degree_ID,
m.Major_ID as Major_ID,
e.Exp_ID as Experience_ID,

Salary,
Posting_Duration

From Records as r

join county_table as c
on c.County = r.County
join degree as d
on d.Degree_Level = r.Degree_Level
join major as m
on m.Edu_Major = r.Edu_Major
join experience as e
on e.Experience_Level = r.Experience_Level;

Select * From job
limit 100;

Alter Table job
Change row_names Main_ID INT;

Alter Table job
Modify JobID VARCHAR(255);

Alter Table job
Modify Occupation_Code VARCHAR(255);

Alter Table job
Modify MSA_ID VARCHAR(255);

Alter Table job
Modify Skill_ID VARCHAR(255);

Alter Table job
Modify State_ID VARCHAR(255);

Alter Table job
Modify Cert_ID VARCHAR(255);

Alter Table job
Modify State_ID VARCHAR(255);

Alter Table job
Modify State_ID VARCHAR(255);

Alter Table job
Modify State_ID VARCHAR(255);

Alter Table job
(FOREIGN KEY (PersonID) REFERENCES Persons(PersonID));


Create Table Job_Title 
Select Distinct JobID, Title_ID
From job
Where Title_ID is not NULL;

Drop Table if Exists Job_Degree;

Create Table Job_Degree 
Select Distinct JobID, Degree_ID
From job
Where Degree_ID is not NULL;

Drop Table if Exists Job_Major;

Create Table Job_Major
Select Distinct JobID, Major_ID
From job
Where Major_ID is not NULL;

Create Table Job_Exp
Select Distinct JobID, Exp_ID
From job
Where Exp_ID is not NULL;

Create Table Job_County
Select Distinct JobID, County_ID
From job
Where County_ID is not NULL;

Alter Table job
Add Constraint FK_state Foreign Key (State_ID) References state(State_ID),
Add Constraint FK_Occupation Foreign Key (Occupation_Code) References occupation(Occupation_Code),
Add Constraint FK_Counties Foreign Key (CountyID) References counties(CountyID),
Add Constraint FK_Experience Foreign Key (ExpID) References experience(ExpID),
Add Constraint FK_Title Foreign Key (TitleID) References title(TitleID);

Alter Table job_cert 
Add Constraint FK_Job_Certification Foreign Key (JobID) References job(JobID),
Add Constraint FK_Certification Foreign Key (Cert_ID) References certification(Cert_ID);

Alter Table job_degree
Add Constraint FK_Job_Degree Foreign Key (JobID) References job(JobID),
Add Constraint FK_Degree Foreign Key (DegreeID) References degree(DegreeID);

Alter Table job_major
Add Constraint FK_Job_Major Foreign Key (JobID) References job(JobID),
Add Constraint Foreign Key (MajorID) References major(MajorID);

Alter Table job_msa
Add Constraint FK_Job_MSA Foreign Key (JobID) References job(JobID),
Add Constraint FK_MSA Foreign Key (MSA_ID) References msa(MSA_ID);

Alter Table job_skill
Add Constraint FK_Job_Skill Foreign Key (JobID) References job(JobID),
Add Constraint FK_Skill Foreign Key (Skill_ID) References skill(Skill_ID);

Alter Table posting
Add Constraint FK_Job_Posting Foreign Key (JobID) References job(JobID);

Alter Table posting
ADD Main_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE job_major 
	DROP Foreign Key;

Drop Table If Exists records;
SET FOREIGN_KEY_CHECKS=1;

Alter Table job_skill
Drop Column row_names;

Select state.State_Name, (count(job.State_ID)/(select count(*) From job)*100) as Percent
From state inner join job on state.State_ID = job.State_ID
Group By State.State_Name;

Select count(Posting_Duration), 
Case
When Posting_Duration >= 3 and Posting_Duration <= 7 Then "1 week or less"
When Posting_Duration > 7 and Posting_Duration <= 30 Then "Less than 1 Month, More than 1 Week"
When Posting_Duration > 30 and Posting_Duration <= 90 Then "1-3 Months"
When Posting_Duration > 90 and Posting_Duration <= 180 Then "3-6 Months"
When Posting_Duration > 180 Then "More than 6 Months"
End as Posting_Range
From posting
Group By Posting_range;

drop table if exists state_posting;
create table State_Posting
select state.state_Name, posting.Posting_Duration
from posting 
left join job on posting.JobID = job.JobID
left join state on state.State_ID = job.State_ID;

drop table if exists Occupation_Posting_NY;
create table NY_Major
select occupation.Occupation_Name, posting.Posting_Duration, job.Salary
from posting 
left join job on posting.JobID = job.JobID
left join occupation on occupation.Occupation_Code = job.Occupation_Code
inner join job_major on job_major.JobID = job.JobID
inner join major on major.MajorID = job_major.MajorID
Where State_ID = 38 and Occupation_Name != 'NA';

create table NY_Skill
select occupation.Occupation_Name, posting.Posting_Duration, job.Salary
from posting 
left join job on posting.JobID = job.JobID
left join occupation on occupation.Occupation_Code = job.Occupation_Code
inner join job_skill on job_skill.JobID = job.JobID
inner join skill on skill.Skill_ID = job_skill.Skill_ID
Where State_ID = 38 and Occupation_Name != 'NA';


drop table if exists Occupation_Posting;
create table Occupation_Posting
select occupation.Occupation_Name, posting.Posting_Duration, job.Salary, state.State_Name
from posting 
left join job on posting.JobID = job.JobID
left join occupation on occupation.Occupation_Code = job.Occupation_Code
left join state on state.State_ID = job.State_ID
Where Occupation_Name != 'NA';

drop table if exists Everything_NY;
create table Everything_NY
select distinct occupation.Occupation_Name, posting.Posting_Duration, job.Salary, major.Edu_Major,
skill.Skill_Name, certification.Cert_Name, experience.Experience_Level
from posting 
inner join job on posting.JobID = job.JobID
inner join occupation on occupation.Occupation_Code = job.Occupation_Code
inner join job_major on job_major.JobID = job.JobID
inner join major on major.MajorID = job_major.MajorID
inner join job_skill on job_skill.JobID = job.JobID
inner join skill on skill.Skill_ID = job_skill.Skill_ID
inner join job_cert on job_cert.JobID = job.JobID
inner join certification on certification.Cert_ID = job_cert.Cert_ID
inner join experience on experience.ExpID = job.ExpID
Where Occupation_Name != 'NA' and Edu_Major != 'NA' and State_ID = 38;

select *
from (select distinct * from posting) b inner join 
(select distinct 
from job 
inner join occupation on occupation.Occupation_Code = job.Occupation_Code
inner join job_major on job_major.JobID = job.JobID
inner join major on major.MajorID = job_major.MajorID
inner join job_skill on job_skill.JobID = job.JobID
inner join skill on skill.Skill_ID = job_skill.Skill_ID
inner join job_cert on job_cert.JobID = job.JobID
inner join certification on certification.Cert_ID = job_cert.Cert_ID
inner join experience on experience.ExpID = job.ExpID
Where Occupation_Name != 'NA' and Edu_Major != 'NA' and State_ID = 38) a on a.JobID = b.JobID


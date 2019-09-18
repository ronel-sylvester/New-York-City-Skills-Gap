library(RMySQL)
library(readxl)
library(dplyr)
Burning_Glass <- dbConnect(MySQL(), 
                    db = "burning_glass", user = 'root', password = 'geico8008',
                    host = '127.0.0.1')

Records <- dbReadTable(conn = Burning_Glass, name = 'records')

posting <- Records%>%
  select(JobID, Posting_Duration)

postings <- tibble::rownames_to_column(postings, "PostingID")

Job <- Records%>%
  distinct(JobID, Occupation_Code, State_ID, 
           Occupation_Title, Salary, County, Experience_Level)

Certification <- Records%>%
  distinct(Cert_ID, Cert_Name)

MSA <- Records%>%
  distinct(MSA_ID, MSA_Name)

Skill <- Records%>%
  distinct(Skill_ID, Skill_Name, Skill_Type)

State <- Records%>%
  distinct(State_ID, State_Name)

Occupation <- Records%>%
  distinct(Occupation_Code, Occupation_Name)

Major <- Records%>%
  distinct(Edu_Major)

Major <- tibble::rownames_to_column(Major, "MajorID")

Experience <- Records%>%
  distinct(Experience_Level)

Experience <- tibble::rownames_to_column(Experience, "ExpID")

Counties <- Records%>%
  distinct(County)

Counties <- tibble::rownames_to_column(Counties, "CountyID")

Title <- Records%>%
  distinct(Occupation_Title)

Title <- tibble::rownames_to_column(Title, "TitleID")

Degree <- Records%>%
  distinct(Degree_Level)

Degree <- tibble::rownames_to_column(Degree, "DegreeID")

Job <- Job%>%
  inner_join(Title, by = "Occupation_Title")%>%
  inner_join(Experience, by = "Experience_Level")%>%
  inner_join(Counties, by = "County")%>%
  select(-Occupation_Title, -Experience_Level, -County)


  
Job_Cert <- Records%>%
  distinct(JobID, Cert_ID)

Job_Degree <- Records%>%
  distinct(JobID, Degree_Level)%>%
  inner_join(Degree, by = "Degree_Level")%>%
  select(-Degree_Level)

Job_Major <- Records%>%
  distinct(JobID, Edu_Major)%>%
  inner_join(Major, by = "Edu_Major")%>%
  select(-Edu_Major)
  
Job_Skill <- Records%>%
  distinct(JobID, Skill_ID)
  
Job_MSA <- Records%>%
  distinct(JobID, MSA_ID)
  
dbWriteTable(conn = Burning_Glass, name = 'Job', value = Job)
dbWriteTable(conn = Burning_Glass, name = 'Certification', value = Certification)
dbWriteTable(conn = Burning_Glass, name = 'Counties', value = Counties)
dbWriteTable(conn = Burning_Glass, name = 'Degree', value = Degree)
dbWriteTable(conn = Burning_Glass, name = 'Experience', value = Experience)
dbWriteTable(conn = Burning_Glass, name = 'Job_Cert', value = Job_Cert)
dbWriteTable(conn = Burning_Glass, name = 'Job_Degree', value = Job_Degree)
dbWriteTable(conn = Burning_Glass, name = 'Job_Major', value = Job_Major)
dbWriteTable(conn = Burning_Glass, name = 'Job_Skill', value = Job_Skill)
dbWriteTable(conn = Burning_Glass, name = 'Job_MSA', value = Job_MSA)
dbWriteTable(conn = Burning_Glass, name = 'Major', value = Major)
dbWriteTable(conn = Burning_Glass, name = 'MSA', value = MSA)
dbWriteTable(conn = Burning_Glass, name = 'Occupation', value = Occupation)
dbWriteTable(conn = Burning_Glass, name = 'Posting', value = posting)
dbWriteTable(conn = Burning_Glass, name = 'Skill', value = Skill)
dbWriteTable(conn = Burning_Glass, name = 'State', value = State)
dbWriteTable(conn = Burning_Glass, name = 'Title', value = Title)





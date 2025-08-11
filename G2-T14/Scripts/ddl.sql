#drop schema if exists G2T14;
create schema G2T14;
use G2T14;

create table USER (
AcctName varchar(30) not null primary key,
Name varchar(30) not null,
Password varchar(15) not null,
PrimaryTel int not null,
PrimaryTelType varchar(15) not null,
UserType char(5) not null
);

create table RU (
AcctName varchar(30) not null,
HighestEdQual varchar(20),
constraint ru_fk foreign key(AcctName) references User(AcctName)
);

create table EXTRA_CONTACT (
AcctName varchar(30) not null,
Tel int not null,
TelType varchar(15) not null,
constraint extra_contact_pk primary key(AcctName,Tel),
constraint extra_contact_fk foreign key(AcctName) references User(AcctName)
);

create table SA (
AcctName varchar(30) not null,
JobGrade varchar(5) not null,
ExtraPwd varchar(15) not null,
constraint sa_fk foreign key(AcctName) references User(AcctName)
);

create table INTEREST (
AcctName varchar(30) not null,
Category varchar(20) not null,
constraint interest_pk primary key(AcctName, Category),
constraint interest_fk foreign key(AcctName) references RU(AcctName)
);

create table VO (
VOID int not null primary key, 
Name varchar(40) not null
);

create table COURSE (
ID varchar(10) not null primary key,
Name varchar(50) not null,
Description varchar(150)
);

create table AFFILIATION (
VOID int not null,
AcctName varchar(30) not null,
DateOfAffiliation date not null,
constraint affiliation_pk primary key(VOID, AcctName),
constraint affiliation_fk1 foreign key(VOID) references VO(VOID),
constraint affiliation_fk2 foreign key(AcctName) references RU(AcctName)
);

create table VOA (
AcctName varchar(30) not null,
ApptTitle varchar(30) not null,
TokenSNo bigint not null,
VOID int not null,
constraint voa_fk1 foreign key(AcctName) references User(AcctName),
constraint voa_fk2 foreign key(VOID) references VO(VOID)
);

create table ENDORSEMENT (
Endorser varchar(30) not null,
ID varchar(10) not null,
Date date not null,
UnEndorseDate date,
UnEndorser varchar(30),
constraint endorsement_pk primary key(Endorser, ID),
constraint endorsement_fk1 foreign key(Endorser) references VOA(AcctName),
constraint endorsement_fk2 foreign key(UnEndorser) references VOA(AcctName),
constraint endorsement_fk3 foreign key(ID) references COURSE(ID)
);

 create table C_ORGANIZE (
 ID varchar(10) not null,
 VOID int not null,
 constraint c_organize_pk primary key(ID, VOID),
constraint c_organize_fk1 foreign key(ID) references COURSE(ID),
constraint c_organize_fk2 foreign key(VOID) references VO(VOID)
 );
 
 create table RUN (
 ID varchar(10) not null,
 RunID varchar(10) not null,
 StartDate date not null,
 EndDate date not null,
 NoOfHours int not null,
 constraint run_pk primary key(ID, RunID),
constraint run_fk foreign key(ID) references COURSE(ID)
 );

create table VO_PARENT (
Parent int not null,
Child int not null,
constraint vo_parent_pk primary key(Parent, Child),
constraint vo_parent_fk1 foreign key(Parent) references VO(VOID),
constraint vo_parent_fk2 foreign key(Child) references VO(VOID)
);

create table ACTIVITY (
Name varchar(100) not null,
Date date not null,
MinReqEd varchar(20),
constraint activity_pk primary key(Name, Date)
);

create table REGISTER (
VOID int not null,
AcctName varchar(30) not null,
Name varchar(100) not null,
Date date not null,
Accepted tinyint,
Completed tinyint,
NumHrs int,
constraint register_pk primary key(VOID, AcctName, Name, Date),
constraint register_fk1 foreign key(VOID,AcctName) references AFFILIATION(VOID,AcctName),
constraint register_fk2 foreign key(Name,Date) references ACTIVITY(Name,Date)
);

create table ACT_CATEGORY (
Name varchar(100) not null,
Date date not null,
Category varchar(30) not null,
constraint act_category_pk primary key(Name, Date, Category),
constraint act_category_fk1 foreign key(Name,Date) references ACTIVITY(Name,Date)
);

create table A_ORGANIZE (
VOID int not null,
Name varchar(100) not null,
Date date not null,
constraint a_organize_pk primary key(VOID, Name, Date),
constraint a_organize_fk1 foreign key(VOID) references VO(VOID),
constraint a_organize_fk2 foreign key(Name, Date) references ACTIVITY(Name, Date)
);

create table POST (
VOID int not null,
CreateDateTime datetime not null,
Startdate date not null,
Enddate date not null,
Message varchar(100) not null,
IsPublic tinyint not null,
Name varchar(100),
Date date,
constraint post_pk primary key(VOID, CreateDateTime),
constraint post_fk1 foreign key(VOID) references VO(VOID),
constraint post_fk2 foreign key(Name, Date) references ACTIVITY(Name, Date)
);

create table VISIBLE (
VOID int not null,
PostVOID int not null,
CreateDateTime datetime not null,
constraint visible_pk primary key(VOID, PostVOID, CreateDateTime),
constraint visible_fk1 foreign key(VOID) references VO(VOID),
constraint visible_fk2 foreign key(PostVOID, CreateDateTime) references POST(VOID, CreateDateTime)
);

create table AWARD (
VOID int not null,
Name varchar(30) not null,
Date date not null,
Type varchar(15) not null,
constraint award_pk primary key(VOID, Name, Date),
constraint award_fk1 foreign key(VOID) references VO(VOID)
);

create table GIVEN (
AcctName varchar(30) not null,
VOID int not null,
Name varchar(30) not null,
Date date not null,
constraint given_fk1 foreign key(AcctName) references RU(AcctName),
constraint given_fk2 foreign key(VOID, Name, Date) references AWARD(VOID, Name, Date)
);

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/user.txt' into table USER fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/ru.txt' into table RU fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/extra_contact.txt' into table EXTRA_CONTACT fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/sa.txt' into table SA fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/interest.txt' into table INTEREST fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/vo.txt' into table VO fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/course.txt' into table COURSE fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/affiliation.txt' into table AFFILIATION fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/voa.txt' into table VOA fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/endorsement.txt' into table ENDORSEMENT fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/c_organize.txt' into table C_ORGANIZE fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/run.txt' into table RUN fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/vo_parent.txt' into table VO_PARENT fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/activity.txt' into table ACTIVITY fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/register.txt' into table REGISTER fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/act_category.txt' into table ACT_CATEGORY fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/a_organize.txt' into table A_ORGANIZE fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/post.txt' into table POST fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/visible.txt' into table VISIBLE fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/award.txt' into table AWARD fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile '/Applications/MAMP/htdocs/Projects/G2-T14/Data/given.txt' into table GIVEN fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

























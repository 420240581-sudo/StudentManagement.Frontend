create DATABASE StudentManagementDb

on primary
(
	name = StudentManagementDb_data,
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\StudentManagementDb.mdf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 5MB
)
log on
(
	name = StudentManagementDb_log,
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\StudentManagementDb.ldf',
	size = 5MB,
	maxsize = 50MB,
	filegrowth = 1MB
);

create table department(
	id int identity(1,1) primary key,
	name nvarchar(50) not null,
	creationdata  datetime default getdate()
);

create table student(
	id int identity(1,1) primary key,
	name nvarchar(50) not null,
	department_id int,
	age int not null,
	email nvarchar(50) unique,
	foreign key (department_id) references department(id),
	creationdata  datetime default getdate()

)

insert into department(name) values('Computer Science')
insert into department(name) values('IT')
insert into department(name) values('HR')
insert into department(name) values('SALES')
insert into department(name) values('MARKETING')

insert into student(name, department_id, age, email) values('tony namir', 1, 20, 'tony.doe@example.com')
insert into student(name, department_id, age, email) values('marina emad', 2, 21, 'marina.doe@example.com')
insert into student(name, department_id, age, email) values('felopateer', 3, 23, 'felopateer.doe@example.com')
insert into student(name, department_id, age, email) values('Jomana emad', 4, 6, 'jomana.doe@example.com')
insert into student(name, department_id, age, email) values('John2 Doe', 5, 16, 'john2.doe@example.com')
insert into student(name, department_id, age, email) values('John3 Doe', 5, 35, 'john3.doe@example.com')
insert into student(name, department_id, age, email) values('John4 Doe', 4, 32, 'john4.doe@example.com')
insert into student(name, department_id, age, email) values('John5 Doe', 2, 25, 'john5.doe@example.com')
insert into student(name, department_id, age, email) values('John6 Doe', 1, 18, 'john6.doe@example.com')
insert into student(name, department_id, age, email) values('John7 Doe', 3, 19, 'john7.doe@example.com')
insert into student(name, department_id, age, email) values('John8 Doe', 1, 22, 'john8.doe@example.com')
insert into student(name, department_id, age, email) values('John9 Doe', 1, 22, 'john9.doe@example.com')
insert into student(name, department_id, age, email) values('John11 Doe', 1, 20, 'john11.doe@example.com')
insert into student(name, department_id, age, email) values('John12 Doe', 1, 29, 'john12.doe@example.com')
insert into student(name, department_id, age, email) values('John13 Doe', 1, 26, 'john13.doe@example.com')

select * from student


select * from student where age >17 and age < 23
order by age desc

select * from student where name like '%Doe%'


select student.name,student.email,student.age,department.name
from student inner join department
on  student.department_id= department.id
where student.name like '%marina%' or department.name like'%computer science%'

select count(student.name) as no_of_students, department.name as department from student 
inner join department 
on student.department_id=department.id
group by department.name

select count(student.name) as no_of_students,
department.name as department,
max(age) as oldest,
min(age) as youngest,
avg(age) as avgerage
from student 
inner join department on student.department_id= department.id
group by department.name


select department.name
from department
inner join student
on student.department_id=department.id
group by department.name 



update student 
set name = 'mary', age= 21 , email='mary.doe@example.com',department_id=3
where id=1


delete from student where id=6



create PROCEDURE sp_insertdepartment
    @departmentname nVARCHAR(100)
AS
BEGIN
    INSERT INTO department (name)
    VALUES (@departmentname)
	end
	go
	

	


	CREATE PROCEDURE sp_insertstudent
    @name VARCHAR(100),
    @age INT,
    @email VARCHAR(100),
    @department_id INT
AS
BEGIN

    IF NOT EXISTS
    (
        SELECT 1
        FROM department
        WHERE id = @department_id
    )
    BEGIN
        PRINT 'Department does not exist'
        RETURN
    END

    INSERT INTO student
    (
        name,
        age,
        email,
        department_id
    )
    VALUES
    (
        @name,
        @age,
        @email,
        @department_id
    )

END

CREATE PROCEDURE sp_updatestudent
    @id INT,
    @name VARCHAR(100),
    @age INT,
    @email VARCHAR(100),
    @department_id INT
AS
BEGIN

    UPDATE student
    SET
        name = @name,
        age = @age,
        email = @email,
        department_id = @id
    WHERE id = @id

END
go

CREATE PROCEDURE sp_DeleteStudent
    @StudentId INT
AS
BEGIN
    DELETE FROM student WHERE id = @StudentId;
END
GO

CREATE PROCEDURE sp_GetAllStudents
AS
BEGIN
    SELECT s.name, s.age, s.email, d.name AS department_name
    FROM student s
    JOIN department d ON s.department_id = d.id
END
GO

CREATE PROCEDURE sp_SearchStudents @SearchText nvarchar(100)
AS
BEGIN
    SELECT s.name, s.age, s.email, d.name AS department_name
    FROM student s
    JOIN department d ON s.department_id = d.id
    WHERE s.name LIKE '%' + @SearchText + '%' OR d.name LIKE '%' + @SearchText + '%'
END
GO

CREATE PROCEDURE sp_GetDepartmentStatistics
AS
BEGIN
    SELECT d.name, COUNT(s.id) AS students_count, AVG(s.age*1.0) AS avg_age,
           MAX(s.age) AS oldest_age, MIN(s.age) AS youngest_age
    FROM department d
    LEFT JOIN student s ON d.id = s.department_id
    GROUP BY d.name
END
GO

CREATE PROCEDURE sp_GetHighestAndLowestDepartments
AS
BEGIN
    WITH dept_counts AS (
        SELECT d.name, COUNT(s.id) AS students_count
        FROM department d
        LEFT JOIN student s ON d.id = s.department_id
        GROUP BY d.name
    )
    SELECT * FROM dept_counts
    WHERE students_count = (SELECT MAX(students_count) FROM dept_counts)
       OR students_count = (SELECT MIN(students_count) FROM dept_counts)
END
GO

CREATE VIEW vw_StudentDetails AS
SELECT s.id, s.name, s.age, s.email, d.name AS department_name
FROM student s
JOIN department d ON s.department_id = d.id
GO

CREATE VIEW vw_DepartmentStatistics AS
SELECT d.name, COUNT(s.id) AS students_count, AVG(s.age*1.0) AS avg_age,
       MAX(s.age) AS oldest_age, MIN(s.age) AS youngest_age
FROM department d
LEFT JOIN student s ON d.id = s.department_id
GROUP BY d.name
GO


create table Department3
(
	dept_no int primary key,
	dept_name varchar2(30),
	total_employe int,
	location varchar2(30)
);

insert into Department3 values (11,'xyz',20,'jmc');
insert into Department3 values (16,'xbc',50,'rjk');
insert into Department3 values (51,'req',25,'amr');
insert into Department3 values (14,'xsa',10,'jun');
insert into Department3 values (17,'jgf',30,'ahm');
insert into Department3 values (1,'ts',0,'goa');


create table Employe
(
	emp_id int primary key,
	emp_name varchar2(30),
	birth_date date,
	gender varchar2(20) CHECK(gender in ('Male','Female')),
	dept_no int REFERENCES Department3(dept_no),
	address varchar2(30),
	designation varchar2(30),
	salary int check (salary>0),
	experience int,
	email varchar2(50) check (email like '%@%.%')
);

insert into Employe values(108,'bella','15-Nov-2021','Female',11,'jam','manager',75500,6,'bela@gmail.com');
insert into Employe values(145,'exa','1-Oct-2001','Female',14,'rjk','cleark',20500,5,'exa@gmail.com');
insert into Employe values(134,'mihir','24-Dec-2010','Male',17,'ahm','sr',35000,3,'m@gmail.com');
insert into Employe values(240,'yash','7-Nov-2013','Male',16,'amr','hr',50000,7,'y@gmail.com');
insert into Employe values(841,'raj','15-Jan-2000','Male',51,'jun','ca',95000,12,'r@gmail.com');

	create table Project
	(
		proj_id int primary key,
		type_of_project varchar2(30),
		status varchar2(30),
		start_date date,
		emp_id int REFERENCES Employe(emp_id)
	);

 insert into Project values(1,'a','pass','10-Dec-2018',108);
 insert into Project values(2,'b','pending','2-Nov-2019',145);
 insert into Project values(3,'c','running','25-Jan-2020',134);
 insert into Project values(4,'d','pending','21-Feb-2020',240);
 insert into Project values(5,'e','running','1-Oct-2017',841);
 insert into Project values(6,'Project 6','Pending','7-JAN-2022',108);


--1. Delete the department whose total number of employees less than 1
delete from Department3 where total_employe<1; 

--2. Display the names and the designation of all female employee in descending order
select emp_name designation, gender from Employe where gender='Female' order by emp_name;

--3. Display the names of all the employees who names starts with ‘A’ ends with ‘A’.
select emp_name from Employe where emp_name like 'a%a';

--4.Find the name of employee and salary for those who had obtain minimum salary.
select emp_name,salary from Employe 
where salary=(select min(salary) from Employe);

--5. Add 10% raise in salary of all employees whose department is ‘CIVIL’.
update Employe set salary=salary+(salary*0.10)
where dept_no=(select dept_no from Department3 where dept_name='xyz');

--6. Count total number of employees of ‘MCA’ department.
select count(emp_name) from Employe where dept_no=(select dept_no from Department3 where dept_name='xyz'); 

--7. List all employees who born in the current month.
select emp_name,to_char(birth_date,'MON') from Employe
where 
to_char(birth_date,'MON')=
(select to_char(sysdate,'MON') from dual);

--8. Print the record of employee and dept table as “Employee works in department ‘CE’. 
select e.emp_name "Employe works in c",e.designation,d.dept_name 
from Employe e,Department3 d 
where e.dept_no=d.dept_no 
and e.designation='ca'; 

--9. List names of employees who are fresher’s(less than 1 year of experience)
select emp_name "Fresher<=3 year Experience" from Employe Where experience<=3;

--10. List department wise names of employees who has more than 5 years of experience.
select e.emp_name,d.dept_name from Employe e,Department3 d 
where experience<=6 
and e.dept_no=d.dept_no 
order by d.dept_name;

--11. Write a function which will display total number of projects based on status (pass status as parameter).
create or replace function total_number_of_projects(l_status varchar2)
return number
is
	c number(5);
begin
	select count(*) into c from project where status=l_status;
	return c;
end;
/

 --select total_number_of_projects('Pending') from dual;

 --12. Write a procedure that will display list of projects which is going to start today
create or replace procedure p1
is
	cursor c1
	is select proj_id,type_of_project,status from project where start_date = '10-NOV-20';
--where start_date = to_char(sysdate,'DD-MON-YY');
begin
	for r in c1 loop 
    	dbms_output.put_line(r.proj_id||'.....'||r.type_of_project||'.....' || r.status);
	end loop;
end;
/

exec p1;

--13. Write a trigger which do not allow insertion/updation/deletion into Project table if status type is ‘pending’
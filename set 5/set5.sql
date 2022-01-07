create table hostel
(
	hno number(20) primary key,
	hname varchar2(20) not null,
	haddr varchar2(20) not null,
	total_capacity number(20),
	warden varchar2(100)
);

insert into hostel values(2,'delux','jam',20,'raj');
insert into hostel values(210,'royal','jam',20,'ramesh');
insert into hostel values(10,'economy','jam',20,'mahesh');
insert into hostel values(447,'Normal','jam',20,'kahan');
insert into hostel values(21,'Super delux','jam',20,'kisan');

create table room
(
	hno number(20) REFERENCES hostel(hno),
	rno number(20) not null,
	rtype varchar2(20) not null,
	location varchar2(20) not null,
	no_of_students number(10),
	status varchar2(20),
	primary key(hno,rno)
);

insert into room values(2,10,'s','raj',6,'occupied');
insert into room values(2,1,'ds','raj',8,'vacante');
insert into room values(210,10,'ds','jam',8,'vacante');
insert into room values(210,3,'ds','jam',6,'occupied');
insert into room values(10,7,'s','ahm',10,'occupied');
insert into room values(10,5,'ds','ahm',4,'vacante');
insert into room values(21,1,'ds','jun',4,'vacante');
insert into room values(447,17,'s','amr',2,'occupied');


create table charges
(
	hno number(20) REFERENCES hostel(hno),
	rtype varchar2(10) not null, 
	charges number(10),
	primary key(hno,rtype)
);

insert into charges values(2,'ds',20000);
insert into charges values(2,'s',10000);
insert into charges values(210,'ds',30000);
insert into charges values(210,'ds',30000);
insert into charges values(10,'s',5000);
insert into charges values(10,'ds',10000);
insert into charges values(21,'ds',40000);
insert into charges values(447,'s',10000);


 create table student_s(
    sid number(20) PRIMARY KEY,
    sname VARCHAR(20) NOT NULL,
    mobile_no number(10),
    gender VARCHAR(10)CHECK(gender in('Male','Female')),
    faculty VARCHAR(10) NOT NULL,
    dept VARCHAR(10) NOT NULL,
    class VARCHAR(10) NOT NULL,
    hno number(20) REFERENCES hostel(hno),
    rno number(3)
);

insert into student_s values(101,'yash',841639312,'Male','Br','Mca','B',2,1);
insert into student_s values(154,'ers',846318832,'Male','Bj','It','A',2,1);
insert into student_s values(14,'mira',64324432,'Female','Nl','Business','A',210,10);
insert into student_s values(10,'Elexa',943732232,'Female','Nl','Business','B',210,3);
insert into student_s values(393,'raj',8445345312,'Male','Bj','Mca','B',10,7);
insert into student_s values(372,'krish',938684163,'Male','Br','It','A',10,5);
insert into student_s values(90,'minakshi',693262492,'Female','Nl','Business','B',21,1);
insert into student_s values(47,'ketan',7453213412,'Male','Bj','It','A',447,17);


create table fees(
	sid number(10) REFERENCES student_s(sid),
	fdate date,
	famount number(20)	
);

insert into fees values(101,'3-Dec-2020',20000);
insert into fees values(154,'10-Oct-2020',20000);
insert into fees values(14,'30-Sep-2020',20000);
insert into fees values(10,'18-Nov-2020',20000);
insert into fees values(393,'20-Nov-2020',20000);
insert into fees values(372,'7-Dec-2020',20000);

--1. Display the total number of rooms that are presently vacant.
select count(rno)  from room where status='vacante';

--2. Display number of students of each faculty and department wise staying in each hostel.
select dept,faculty,hname, count(*) 
from student_s , hostel  
where hostel.hno=student_s.hno 
group by faculty,dept,hname;

--3. Display hostels, which have at least one single-seated room.
select hname from hostel
where hno in(select r.hno from room r,hostel h 
where h.hno=r.hno and r.rtype='s');

--4. Display the warden name and hostel address of students of Computer Science department. 
select h.haddr,h.warden from hostel h,student_s st 
where st.dept='Business'
and h.hno=st.hno;

--5. Display those hostel details where single seated or double-seated rooms are vacant. 
select h.hname from room r,hostel h where status='vacante' 
and r.hno=h.hno and r.rtype in('s','ds');

--6. Display details of hostels occupied by medical students.
select h.hname from student_s s,hostel h,room r where r.status='occupied' 
and r.hno=h.hno and r.rno=s.rno and s.dept in('Business');

--7. Display hostels, which are totally occupied to its fullest capacity
select distinct count(h.hname) from hostel h,room r
where r.status='occupied' and h.hno=r.hno;

--8. List details about students who are staying in the double-seated rooms of Chanakya Hostel
select s.sname from student_s s,hostel h,room r
where r.rno=s.rno and h.hno=r.hno
and h.hname='economy' and r.rtype='ds';

--9. Display the total number of students staying in each room type of each hostel.

update hostel set total_capacity=1 where hno=1;

select count(sid) from student_s;

--10. Display details about students who have paid fees in the month of Nov. 2017.
select * from student_s where sid in(select sid from fees where to_char(fdate,'MM') in(11));

--11. For those hostels where total capacity is more than 300, display details of students studying in Science faculty.
select * from student_s where faculty='Bj' and hno in(select hno from hostel where total_capacity>=50);
 
--12. Display hostel details where there are at least 10 vacant rooms.
select * from hostel where hno in(select hno from room where status='vacante');

--13. Display details of students who have still not paid fees.
select * from student_s where sid not in(select sid from fees);

--14. Display those hostels where single-seated room is the costliest.
select hname,MAX(charges) from hostel h,room r,charges c
where c.hno=h.hno and h.hno = r.hno and
r.rtype='s' group by hname;

--16. Write a PL/SQL block which will count total number of student’s gender wise.
--Male Students: 999 students
--Female Students: 999 students
declare 
	TOT_M number(5);
	TOT_F number(5);
begin	
	select count(*) into TOT_M from student_s where gender ='Male';
	select count(*) into TOT_F from student_s where gender ='Female';
	dbms_output.put_line('Total Male  ' || TOT_M);
	dbms_output.put_line('Total Female  ' || TOT_F);
end;
/
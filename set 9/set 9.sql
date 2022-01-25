create table APPLICANT
(
	aid varchar2(10),
	aname varchar2(10),
	addr varchar2(20),
	abirth_dt date,
	primary key(aid)
);
--insert query--
insert into APPLICANT values('112','rajesh','Rajkot','21-OCT-1978');
insert into APPLICANT values('122','mahesh','Amreli','2-FEB-1981');
insert into APPLICANT values('A132','geeta','Junagadh','10-DEC-1998');
insert into APPLICANT values('A142','romola','canada','1-JAN-1990');
insert into APPLICANT values('A152','dominic','los angels','2-MAR-1980');
insert into APPLICANT values('A157','meggie','paris','5-Oct-1984');
-------
create table ENTRANCE_TEST
(
	etid int primary key,
	etname varchar2(10),
	max_score number(10),
	cut_score number(10)
);
--insert query---
insert into ENTRANCE_TEST values(101,'JEE',400,150);
insert into ENTRANCE_TEST values(102,'NEET',400,200);
insert into ENTRANCE_TEST values(103,'ORACLE Fm',100,30);
insert into ENTRANCE_TEST values(104,'TAT',400,200);
insert into ENTRANCE_TEST values(105,'TCS',200,50);
insert into ENTRANCE_TEST values(106,'Tew',200,50);
insert into ENTRANCE_TEST values(107,'ew',100,35);
------
create table ETEST_CENTRE
(
	etcid int primary key,
	location varchar2(10),
	incharge varchar2(10),
	capacity number(10)
);
--Insert query--
Insert into ETEST_CENTRE values(1,'jamnagar','Mukesh A',100);
Insert into ETEST_CENTRE values(2,'Rajkot','Anita S',80);
Insert into ETEST_CENTRE values(3,'Kalol','Darshan B',60);
Insert into ETEST_CENTRE values(4,'Amreli','Vina J',70);
Insert into ETEST_CENTRE values(5,'Junagadh','Aman H',50);
----
create table ETEST_DETAILS
(
	aid varchar2(10) REFERENCES APPLICANT(aid),
	etid int REFERENCES ENTRANCE_TEST(etid),
	etcid int REFERENCES ETEST_CENTRE(etcid),
	etest_dt date,
	score number(10),
	primary key(aid,etid,etcid)
);
--Insert Query--
insert into ETEST_DETAILS values('A122',102,2,'1-OCT-2010',270);
insert into ETEST_DETAILS values('A122',105,2,'5-OCT-2010',40);
insert into ETEST_DETAILS values('A112',103,2,'14-OCT-2010',170);
insert into ETEST_DETAILS values('A132',102,1,'16-OCT-2010',200);
insert into ETEST_DETAILS values('A142',103,3,'2-OCT-2010',80);
insert into ETEST_DETAILS values('A152',104,5,'4-OCT-2010',250);
insert into ETEST_DETAILS values('A112',104,4,'3-OCT-2010',290);
insert into ETEST_DETAILS values('A132',103,2,'7-OCT-2010',190);
insert into ETEST_DETAILS values('A132',106,2,'4-OCT-2010',190);
insert into ETEST_DETAILS values('A132',107,2,'5-OCT-2010',190);


insert into ETEST_DETAILS values('A152',103,3,'7-OCT-2010',80);
insert into ETEST_DETAILS values('A152',106,3,'5-OCT-2010',80);
insert into ETEST_DETAILS values('A157',101,2,'4-OCT-2010',40);

--1.1Modify the APPLICANT table so that every applicant id has an ‘A’ before its  
--value. E.g. if value is ‘1123’, it should become ‘A1123’.

Alter table applicant MODIFY check aid like ='A%';
--or
 update applicant set aid='A122' where aid='122';
--1.2 Display test center details where no tests were conducted.

select * from ETEST_CENTRE where etcid 
not in
(select a.etcid from ETEST_CENTRE a,ETEST_DETAILS b
where a.etcid=b.etcid);
 --or--
select * from ETEST_CENTRE where etcid not in (select etcid from ETEST_DETAILS);

--1-3.Display details about applicants who have the same score as that of Ajaykumar in ‘ORACLE FUNDAMENTALS’.
SELECT a.aname, et.etid, ed.score
FROM APPLICANT a,ENTRANCE_TEST et,etest_details ed
WHERE a.aid=ed.aid and
et.etid=ed.etid and
ed.score in
(
SELECT ed.score
FROM APPLICANT a,ENTRANCE_TEST et,etest_details ed
WHERE a.aid=ed.aid and
et.etid=ed.etid and
a.aname='romola'
);

--2. Display details of applicants who appeared for all tests.

select * from APPLICANT where AID in(
select DISTINCT aid from ETEST_DETAILS where aid in
(select aid from etest_details GROUP by 
aid having count(etid)=
(select count(*) from ENTRANCE_TEST)) and etid in
(select DISTINCT etid from etest_details));

--3. Display those tests where no applicant has failed.

select * from entrance_test where etid not in 
(select ed.etid from etest_details ed,entrance_test et
where ed.etid=et.etid and score<cut_score);

--4. Display details of entrance test centers which had full attendance between 1st Oct 15 and 15th Oct 16.

select * from ETEST_DETAILS where etest_dt BETWEEN TO_DATE('01/OCT/2010', 'DD/MM/YYYY')
AND TO_DATE('05/OCT/2010', 'DD/MM/YYYY');

--5.Display details of the applicants who scored more than the cut score in the tests they appeared in.
select ed.aid,ed.score 
from etest_details ed,entrance_test et 
where ed.etid=et.etid and ed.score>et.cut_score 
and ed.aid in (select aid from APPLICANT);
 

 --6.Display average and maximum score test wise of tests conducted at Mumbai.
 
select avg(score),max(score),etcid,aid from etest_details 
where etcid in(
select etcid from ETEST_CENTRE where location='Rajkot')group by etcid,aid;

--7.Display the number of applicants who have appeared for each test, test center wise.
select count(ad.aid),ec.etcid,ec.location 
from applicant ad,ETEST_CENTRE ec,etest_details ed 
where ed.aid=ad.aid and ed.etcid=ec.etcid group by ec.etcid,ec.location; 

--8. Display details about test centers where no tests have been conducted.
select * from ETEST_CENTRE where etcid not in (select etcid from ETEST_DETAILS);

--9. For tests, which have been conducted between 2-3-17 and 23-4-17, show details of 
--the tests as well as the test centre
select ed.etest_dt,ec.*,et.* from ETEST_DETAILS ed,ETEST_CENTRE ec,ENTRANCE_TEST et where ed.etest_dt BETWEEN TO_DATE('01/OCT/2010', 'DD/MM/YYYY')
 AND TO_DATE('07/OCT/2010', 'DD/MM/YYYY') and ed.etcid=ec.etcid and ed.etid=et.etid;

--10. How many applicants appeared in the ‘ORACLE FUNDAMENTALS’ test at
--Chennai in the month of February?

select ad.aname,ad.aid,ec.location,et.etid,et.etname,ed.etest_dt 
from applicant ad,ENTRANCE_TEST et,ETEST_DETAILS ed,ETEST_CENTRE ec
where et.etname='ORACLE Fm' and ec.location='Rajkot' 
and ad.aid=ed.aid and et.etid=ed.etid 
and TO_CHAR(ed.etest_dt,'MON') = 'OCT';

--11. Display details about applicants who appeared for tests in the same month as the
--month in which they were born. 

select ad.aname,ed.etest_dt 
from applicant ad,ETEST_DETAILS ed
where
ad.aid=ed.aid 
and TO_CHAR(ad.abirth_dt,'MON') = TO_CHAR(ed.etest_dt,'MON');

--12. Display the details about APPLICANTS who have scored the highest in each test,
--test centre wise.

select ed.aid,ec.location,ed.score,et.etname 
from etest_details ed,ETEST_CENTRE ec,ENTRANCE_TEST et
where ed.etcid=ec.etcid 
and et.etid=ed.etid 
and(ed.etid,ed.etcid,ed.score) in 
(select etid,etcid,max(score) from etest_details group by etid,etcid);

--13. Design a read only view, which has details about applicants and the tests that he
--has appeared for.

create view v13 as select ed.aid,et.etname from etest_details ed,entrance_test et where ed.etid=et.etid;

--14. Write a procedure which will print maximum score centre wise.

create or replace procedure max_score_center_wise
is
	cursor c1
	is select etcid, max(score) as score1 from 
	etest_details group by etcid;
begin
	dbms_output.put_line(
		rpad('Center Id',15)
		||rpad('Score',15)
	);
	for r in c1 loop
		dbms_output.put_line(
			rpad(r.etcid,15)
			||rpad(r.score1,15)
		);
	end loop;
end;
/

--15. Write a procedure which will print details of entrance test.
create or replace procedure details_ent_test
is 
	cursor c1
	is
		select c.location,a.aid,d.etest_dt,d.score
		from applicant a,ENTRANCE_TEST b,ETEST_CENTRE c,etest_details d
		where
		a.aid=d.aid and
		b.etid=d.etid and
		c.etcid=d.etcid;
begin
	dbms_output.put_line('------------------------------------------------');
	dbms_output.put_line(rpad('Location',15)
		||rpad('aid',15)
		||rpad('Test date',15)
		||rpad('Score',15));
		dbms_output.put_line('------------------------------------------------');
	for r in c1 loop
		dbms_output.put_line(rpad
		(r.location,15)||
		rpad(r.aid,15)||
		rpad(r.etest_dt,15)||
		rpad(r.score,15));
	end loop;
		dbms_output.put_line('------------------------------------------------');
end;
/

--15.Write a trigger which do not allow insertion / updation / deletion of Enterance test details on Sunday.

create or replace trigger ueue
	before insert or update or delete on entrance_test
	for each row
declare
	msg varchar2(100);
begin
	msg:='';
	if trim(to_char(sysdate,'DAY'))='MONDAY' then
		if inserting then	
			msg:='insert';
		elsif updating then
			msg:='update';
		else 
			msg:='delete';
		end if;
		RAISE_APPLICATION_ERROR(-20000,'you can not come' || msg || 'on Monday');
	end if;
end;
/





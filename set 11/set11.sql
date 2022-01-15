create table TRAIN_MASTER
(
	TRAIN_NUMBER VARCHAR2(6) PRIMARY KEY check((TRAIN_NUMBER LIKE'%DN') or (TRAIN_NUMBER Like '%UP')),
	TRAIN_NAME VARCHAR2(25) NOT NULL,
	ARRIVAL_TIME DATE NOT NULL,
	DEPARTURE_TIME DATE NOT NULL,
	NO_OF_HOURS NUMBER(5,2) NOT NULL,
	SOURCE_STATION VARCHAR2(25) NOT NULL,
	END_STATION VARCHAR2(25) NOT NULL
);

--
INSERT INTO TRAIN_MASTER VALUES ('1010UP','Mumbai-Ahemdabad Express',
(TO_DATE('2021-07-15-16.32.12','YYYY-MM-DD-HH24.MI.SS')),
(TO_DATE('2021-07-15-17.52.12','YYYY-MM-DD-HH24.MI.SS')),16,'Mumbai','Ahemdabad');

 INSERT INTO TRAIN_MASTER VALUES ('1010DN','Mumbai-Ahemdabad Express',
 (TO_DATE('2021-07-15 7.32.12 PM','YYYY-MM-DD HH.MI.SS PM')),
 (TO_DATE('2021-07-15 7.52.12 PM','YYYY-MM-DD HH.MI.SS PM')),16,'Mumbai','Ahemdabad');
 
  INSERT INTO TRAIN_MASTER VALUES ('110DN','Ahemdabad-Rajkot Express',
  (TO_DATE('2021-07-15 9.32.12 PM','YYYY-MM-DD HH.MI.SS PM')),
  (TO_DATE('2021-07-15 10.00.12 PM','YYYY-MM-DD HH.MI.SS PM')),7,'Ahemdabad','Rajkot');
--

create table PASSENGER_DETAILS
(
	TICKET_NUMBER NUMBER(5),
	TRAIN_NUMBER VARCHAR2(6) REFERENCES TRAIN_MASTER(TRAIN_NUMBER)ON DELETE CASCADE,
	SEAT_NUMBER NUMBER(2) NOT NULL,
	PASSENGER_NAME VARCHAR2(35) NOT NULL,
	AGE NUMBER(2) NOT NULL,
	GENDER CHAR(1) check (GENDER IN('M','F')),
	TRAVEL_DATE DATE,
	CLASS VARCHAR2(4) check (CLASS in('IA', 'IIA', 'IIIA', 'IC'))
);
--
insert into PASSENGER_DETAILS values(011,'1010DN',67,'mahesh',30,'M','21-Nov-2021','IC');
insert into PASSENGER_DETAILS values(189,'1010UP',7,'raj',25,'M','1-Oct-2021','IA');
insert into PASSENGER_DETAILS values(17,'1010DN',21,'Misri',20,'F','2-Dec-2021','IIA');
insert into PASSENGER_DETAILS values(80,'110DN',85,'Mira',59,'F','28-Nov-2021','IIIA');
insert into PASSENGER_DETAILS values(98,'1010UP',87,'ram',40,'M','10-Oct-2021','IA');

--
create table TRAIN_SEAT_MASTER
(
	TRAIN_NUMBER VARCHAR2(6) REFERENCES TRAIN_MASTER(TRAIN_NUMBER) ON DELETE CASCADE,
	CLASS VARCHAR2(4) check (CLASS in('IA', 'IIA', 'IIIA', 'IC')),
	TOTAL_SEATS NUMBER(2)  check (TOTAL_SEATS>= 25 AND TOTAL_SEATS<= 90)
);
insert into TRAIN_SEAT_MASTER values('1010DN','IA',60);
insert into TRAIN_SEAT_MASTER values('1010DN','IIA',60);
insert into TRAIN_SEAT_MASTER values('110DN','IIIA',90);
insert into TRAIN_SEAT_MASTER values('1010UP','IA',55);
insert into TRAIN_SEAT_MASTER values('1010UP','IA',55);

create table TRAIN_DAY_MASTER
(
	TRAIN_NUMBER VARCHAR2(6) REFERENCES TRAIN_MASTER(TRAIN_NUMBER) ON DELETE CASCADE,
	DAY VARCHAR2(3) check (DAY IN ('MON','TUE','WED','THU','FRI','SAT','SUN'))
);

insert into TRAIN_DAY_MASTER values ('1010DN','THU');
insert into TRAIN_DAY_MASTER values ('1010DN','MON');
insert into TRAIN_DAY_MASTER values ('110DN','WED');
insert into TRAIN_DAY_MASTER values ('110DN','MON');
insert into TRAIN_DAY_MASTER values ('1010UP','FRI');

--1. Give all the train nanes starting from “Bombay” and going to “Ahmedabad” on
--Tuesday and Wednesday.

select train_name,train_number from train_master where train_number in 
(select train_number from train_day_master where day ='THU' 
and train_number in (select train_number from train_day_master where day ='MON')
 and (SOURCE_STATION='Mumbai' and END_STATION='Ahemdabad'));
 
--2. List all trains which is available on Sunday
select train_name,train_number from train_master where train_number in 
(select train_number from train_day_master where day ='FRI'); 

--3. Give classwise seat availability on 10-June-2018 for train 9012DN.
select pd.class,(tsm.TOTAL_SEATS -count(pd.ticket_number))
from PASSENGER_DETAILS pd,train_seat_master tsm where tsm.train_number='1010DN' AND
tsm.train_number=pd.train_number 
group by pd.class,tsm.total_seats;
 
 
--4. List total seats classwise for train running on thrusday. 
select tsm.total_seats,tsm.class 
from TRAIN_SEAT_MASTER tsm,TRAIN_DAY_MASTER tdm 
where tsm.TRAIN_NUMBER=tdm.TRAIN_NUMBER and tdm.day ='THU';

--5. List train names which have no sleeper class.

select tm.TRAIN_NAME,pd.class from 
train_master tm,PASSENGER_DETAILS pd 
where tm.train_number=pd.train_number and pd.class not in ('sleeper class');

--6. List train number which run on Monday during 8:00: am to 1:00pm.

select tm.train_number from train_master tm,TRAIN_DAY_MASTER tdm 
where tm.train_number=tdm.train_number 
and tdm.day='MON' and (TO_CHAR(ARRIVAL_TIME,'HH')>=12 or TO_CHAR(DEPARTURE_TIME,'HH')<=20);

--7. Write a procedure which will print all train details going from Baroda to Banglore

create or replace procedure psa
is
	cursor c1
	is
	select train_number,train_name,ARRIVAL_TIME,DEPARTURE_TIME,NO_OF_HOURS,SOURCE_STATION,END_STATION 
	from
	train_master where SOURCE_STATION='Ahemdabad' and END_STATION='Rajkot';
begin
	dbms_output.put_line(rpad('-',100,'-'));
	dbms_output.put_line(
		rpad('train_number',15)
		||rpad('train_name',15)
		||rpad('ARRIVAL_TIME',15)
		||rpad('DEPARTURE_TIME',15)
		||rpad('NO_OF_HOURS',15)
		||rpad('SOURCE_STATION',15)
		||rpad('END_STATION',15)
	);
	dbms_output.put_line('Train Details');
	for r in c1 loop
		dbms_output.put_line(upper(
			rpad(r.train_number,15)||
			rpad(r.train_name,15)||
			rpad(r.ARRIVAL_TIME,15)||
			rpad(r.DEPARTURE_TIME,15)||
			rpad(r.NO_OF_HOURS,15)||
			rpad(r.SOURCE_STATION,15)||
			rpad(r.END_STATION,15))
		);
	end loop;
	dbms_output.put_line(rpad('-',100,'-'));
end;
/

--8. Write a function which will print arrival time and departure time for a given train. (pass train no as a parameter)
create or replace function ta(tno train_master.train_number%type)
return varchar2
is
	tt varchar2(10);
	ats varchar2(10); 
	dt varchar2(20);
begin
	select ARRIVAL_TIME,DEPARTURE_TIME,train_number into ats,dt,tt from train_master where train_number=tno;
return('arrival time : '||ats||' destination time : '||dt ||' train number : '||tt);
end;
/
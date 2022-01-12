create table Screen
(
	screen_id varchar2(10) check(screen_id like 's%'),
	location varchar2(2) check(location in('FF','SF','TF')),
	seating_cap number(5) not null,
	primary key(screen_id)
);

--Screen
insert into Screen values('s1','FF',30);
insert into Screen values('s2','SF',50);
insert into Screen values('s3','TF',70);
insert into Screen values('s4','SF',60);
insert into Screen values('s5','TF',80);
insert into Screen values('s6','SF',70);

create table Movie
(
	movie_id number(10) primary key,
	movie_name varchar2(20) unique,
	date_of_release date
);

--Movie
insert into Movie values(1,'FandF saga','21-Dec-2023');
insert into Movie values(2,'KGF 2','2-Dec-2021');
insert into Movie values(3,'Ironman Return','3-Mar-2025');
insert into Movie values(4,'sherlock home return','2-jan-2022');
insert into Movie values(5,'Hell Vs Predise','12-March-2023');
insert into Movie values(6,'Star Wars III','18-Feb-2005');

create table Curent
(
	screen_id varchar2(10) REFERENCES Screen(screen_id),
	movie_id number(10) REFERENCES Movie(movie_id),
	date_of_arrival date,
	date_of_closure date
);
--Curent
insert into Curent values('s1',1,'21-Dec-2023','1-Jan-2024');
insert into Curent values('s2',2,'2-Dec-2021','1-Jan-2021');
insert into Curent values('s3',3,'3-Mar-2025','3-Apr-2025');
insert into Curent values('s4',4,'2-jan-2022','2-Feb-2022');
insert into Curent values('s5',5,'12-March-2023','12-Apr-2023');


--1. Get the name of movie which has run the longest in the multiplex so far.
select * from Movie where movie_id=(select movie_id from 
(select movie_id,(date_of_closure-date_of_arrival) 
as a
from Curent   
order by a desc)
where rownum=1);

--2. Get the average duration of a movie on screen number ‘S4’.
select avg(date_of_closure-date_of_arrival) from Curent where screen_id='s4';
--or--
select max(date_of_closure-date_of_arrival) 
from Curent where screen_id =(select screen_id 
from Screen where screen_id='s4');

--3. Get the details of movie that closed on date 24-november-2004.
select * from Movie where movie_id in(select movie_id from Curent where date_of_closure='1-Jan-2021');

--4. Movie ‘star wars III ‘was released in the 7th week of 2005. Find out the date of its release considering that a movie releases only on Friday
select * from Movie
where
TO_CHAR(date_of_release,'IW')=7 AND
TO_CHAR(date_of_release, 'YYYY')=2005 AND trim(
TO_CHAR(date_of_release,'DAY'))='FRIDAY';

--5. Get the full outer join of the relations screen and current.
select s.* from Curent rc
 FULL OUTER JOIN Screen s 
 ON s.screen_id=rc.screen_id;

 --6. Write a PL/SQL function which will count total number of day’s horror movie last longer.

create or replace function display_movie_days
return number
is
	tot number(5);
begin
	select (date_of_closure-date_of_arrival)into tot from curent where movie_id=(select movie_id from movie where movie_name='F saga');
return(tot);
end;
/

--7. Write a PL/SQL procedure that will display movie which is going to release today.
create or replace procedure p1
is
	cursor c1	
	is
	select movie_id,movie_name,date_of_release from movie where date_of_release='21-Dec-2023';	
begin
	for r in c1 loop
		dbms_output.put_line('movie Id-------Movie Name-------Date Of Release');
		dbms_output.put_line(
		Rpad(r.movie_id,15)
		||Rpad(r.movie_name,15)
		||Rpad(r.date_of_release,15));
		dbms_output.put_line('------------------------------------------------');
	end loop;
end;
/
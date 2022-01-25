create table category
(
	cat_code int primary key,
	catdesc varchar2(20) check (catdesc in('deluxe','superdeluxe','superfast','normal'))
);

insert into category values(101,'deluxe');
insert into category values(021,'superdeluxe');
insert into category values(135,'normal');
insert into category values(161,'deluxe');
insert into category values(152,'superfast');
insert into category values(178,'normal');

create table routemaster
(
	routeno int primary key,
	origin varchar2(20),
	destination varchar2(20),
	fare number(10) not null,
	distance number(20),
	capacity number(20) check (capacity>0 and capacity<=60),
	day date,
	cat_code int REFERENCES category(cat_code),	
	check (destination != origin)
);

insert into routemaster values(501,'raj','jam',100,90,40,'4-Dec-2021',178);
insert into routemaster values(552,'ahk','raj',1000,400,60,'2-Dec-2021',021);
insert into routemaster values(51,'mum','jamu',4000,1000,40,'1-Dec-2021',101);
insert into routemaster values(5,'mum','jamu',4000,1000,40,'1-Dec-2021',101);
insert into routemaster values(405,'goa','sur',500,250,60,'3-Dec-2021',161);
insert into routemaster values(123,'amr','jam',140,360,40,'5-Dec-2021',152);
insert into routemaster values(127,'amr','jam',140,360,90,'5-Dec-2021',152);

create table ticketheader
(
	ticketno int primary key,
	dateofissue date,
	dateodtravel date,
	boardplace varchar2(20),
	routeno int REFERENCES routemaster(routeno)
);

insert into ticketheader values(4520,'1-NOV-2021','4-Dec-2021','raj-jam',501);
insert into ticketheader values(3520,'2-Dec-2021','6-Dec-2021','ahk-raj',552);
insert into ticketheader values(520,'10-OCT-2021','3-Dec-2021','mum-jamu',51);
insert into ticketheader values(50,'10-NOV-2021','3-DEC-2021','mum-jamu',51);
insert into ticketheader values(420,'7-OCT-2021','3-Dec-2021','goa-sur',405);
insert into ticketheader values(894,'9-OCT-2021','5-Dec-2021','raj-jam',123);

create table ticket_details
(
	ticketno int REFERENCES ticketheader(ticketno),
	name varchar2(20),
	sex varchar2(20),
	age number(10),
	fare number(10)
);	
	
 insert into ticket_details values(894,'raju','Male',30,1000);
 insert into ticket_details values(894,'bheem','Male',10,1000);
 insert into ticket_details values(3520,'bheem','Male',40,500);
 insert into ticket_details values(520,'jagu-bander','Male',35,700);
 insert into ticket_details values(50,'bander','Male',30,700);
 insert into ticket_details values(420,'kalia','Male',50,856);
 insert into ticket_details values(4520,'dholu-bholu','Male',45,412);

 --1. Display the total number of people traveled on each ticket group by ticket no 23.
 select count(name),name from ticket_details where ticketno=894 group by name;
 
 --2. Give the total collection of fare for each route.
 select sum(t.fare),r.routeno from ticket_details t, routemaster r,ticketheader th
 where r.routeno=th.routeno AND
 th.ticketno=t.ticketno group by r.routeno;
 
 --3.Give the number of months between issue date and travel date of each ticket issued.
 select ticketno,TO_CHAR(dateodtravel,'MM')-TO_CHAR(dateofissue,'MM') as Gape from ticketheader;
 
 --4.Count number of person boarding from the same place and same route.
 
select th.boardplace,th.routeno,COUNT(td.ticketno) from ticketheader th,ticket_details td 
where th.ticketno=td.ticketno group by th.boardplace,th.routeno HAVING count(td.ticketno)>1;

--5. Display count of person who has traveled in each category.
select count(td.ticketno),c.catdesc from ticket_details td,category c,routemaster r,ticketheader th 
where c.cat_code=r.cat_code and r.routeno = th.routeno and th.ticketno=td.ticketno group by catdesc;

--6. Write a trigger which allow to insert or update the bus capacity only greater than zero and less than 60.

create or replace trigger uue
	before insert or update or delete on routemaster
	for each row
declare
	msg varchar2(100);
begin
	msg:='';
	if :new.capacity < 0 or :new.capacity > 60 then
		if inserting then	
			msg:='insert';
		elsif updating then
			msg:='update';
		end if;
		RAISE_APPLICATION_ERROR(-20000,'you can not come' || msg || 'on Monday');
	end if;
end;
/

--7. Write a Procedure which will print tour details, a driver is going to take it. ( pass route_no as parameter)
create or replace procedure print_tour_details(rno routemaster.routeno%type)
is
	cursor c1
	is
	select routemaster.routeno,origin,destination,dateodtravel,day,capacity
	from
	routemaster,ticketheader
	where
	routemaster.routeno=ticketheader.routeno and
	routemaster.routeno=rno;
begin
	dbms_output.put_line('route no :' || rno || 'vehicle no : 786');
	dbms_output.put_line(rpad('-',75,'-'));
	dbms_output.put_line(
		rpad('origin',15)
		||rpad('destination',15)
		||rpad('dateoftravel',15)
		||rpad('day',15)
		||rpad('capacity',15)
	);
	dbms_output.put_line('transport details');
	for r in c1 loop
		dbms_output.put_line(
			rpad(r.origin,15)||
			rpad(r.destination,15)||
			rpad(r.dateodtravel,15)||
			rpad(r.day,15)||
			rpad(r.capacity,15)
		);
	end loop;
	dbms_output.put_line(rpad('-',75,'-'));
end;
/

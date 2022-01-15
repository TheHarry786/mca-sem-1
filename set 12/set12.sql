create table CUSTOMERR(
cid number primary key,
fname varchar2(20),
lname varchar2(20),
city varchar2(20),
country varchar2(20),
phone number(10)
);

insert into customerr values(12,'harsh','pandya','amreli','gujarat',8483938442);
insert into customerr values(1,'meet','nanda','mumbai','maharstra',9936371892);
insert into customerr values(14,'priyank','sorthiya','los angels','us',7483919035);
insert into customerr values(10,'yash','adesara','jmanagar','gujarat',8463947295);
insert into customerr values(19,'hardik','maru','jamnagar','gujarat',9462544854);


create table ODR(
oid number primary key,
oDate date,
oNumber number(10),
cid number REFERENCES CUSTOMERR(cid),
oTotalAmount number(20)
);

insert into odr values(10,'21-Dec-2021',78912,1,10000);
insert into odr values(12,'31-Dec-2021',78924,1,10000);
insert into odr values(11,'22-Dec-2021',78920,10,10000);
insert into odr values(14,'23-Dec-2021',78920,10,1000);
insert into odr values(1,'27-Dec-2021',79821,14,4000);
insert into odr values(15,'24-Dec-2021',79821,14,7000);
insert into odr values(74,'24-Dec-2021',79821,14,8000);
insert into odr values(101,'25-Dec-2021',78129,10,4000);
insert into odr values(17,'26-Dec-2021',78022,19,8000);
insert into odr values(7,'24-Dec-2021',78423,12,9000);

--1. List the number of customers in each country. Only include countries with more than
--100 customers.

select count(fname),country from customerr group by country having count(fname)>=2; 

--2. List the number of customers in each country, except China, sorted high to low.
--Only include countries with 5 or more customers.
select count(fname),country from customerr group by country having count(fname)>=2 and country not in('us');  


--3. List all customers with average orders between Rs.5000 and Rs.6500.
select fname from customerr where cid in (select cid from odr group by cid having avg(oTotalAmount)
BETWEEN 5000 and 10000); 

--5. Create a function to return customer with maximum orders.


create or replace function gcmo
return varchar2
is
    cname varchar2(200);
begin
    select fname||' '||lname into cname from customerr
    where cid=(select cid from (select cid(count(cid)) as x from odr group by cid order by x desc)where rownum=1);
    --ODR 
   -- group by cid having count(cid)=
    --(select max(count(cid)) from odr group by cid));
    return cname;
end;
/

declare
    ans varchar2(200);
begin
    ans:=gcmo;
    dbms_output.put_line('Customer having maximum order is :' || ans);
end;
/

create or replace function gmo
return SYS_REFCURSOR
is
    name SYS_REFCURSOR;
begin
    open name
    for
        select fname,lname from customerr
        where cid in (select cid from 
        ODR 
        group by cid having count(cid)=
        (select max(count(cid)) from odr group by cid));
    return name;
end;
/

declare
    ans varchar2(200);
begin
    ans:=gmo;
    dbms_output.put_line('Customer having maximum order is :' || ans);
end;
/

--6. Create a procedure to display month names of dates of ORDER table. The month names should be unique.
create or replace procedure mnor
is  
    cursor c1
    is select distinct upper(to_char(odate,'month'))as mname from odr;
begin
    dbms_output.put_line('------------');
    dbms_output.put_line('Month Name');
    dbms_output.put_line('------------');
    for r in c1 loop
        dbms_output.put_line(r.mname);
    end loop;
    dbms_output.put_line('------------');
end;
/


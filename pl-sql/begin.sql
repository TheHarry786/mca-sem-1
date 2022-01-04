----mimp
set serveroutput on;

--1
begin
dbms_output.put_line('a');
end;
/
--2
declare
 a number(3);
begin
    a:=10; 
    dbms_output.put_line('a :' || a);
end;
/
--3
declare
 a number(3);
begin
    a:=&a; 
    dbms_output.put_line('a :' || a);
end;
/
--4
declare 
    a number(3);
    b number(3);
    c number(3);
begin
    a:=10;
    b:=20;
    c:=a+b;
    dbms_output.put_line('c :' ||c);
end;
/

--1 procedure

create or replace procedure p1(a number,b number)
is
c number(5);
begin
    c:=a+b;
    dbms_output.put_line('c :' ||c);
end;
/
--execute
exec p1(10,20);

--2 function
create or replace function f1(a number,b number)
return number
is
c number(5);
begin
    c:=a+b;
    return c;
end;
/
--execute
select f1(1,5) from dual;

--
begin 
 dbms_output.put_line(f1(10,20));
end;
/

select name from user_source;

select text from user_source where name='p1' and type
='procedure' order by line;

--delete function/procedure
drop procedure p1;
drop function f1();
---
declare
 a varchar2(10);
 b varchar2(10);
begin
    a:='&a'; 
    b:='&b';
    dbms_output.put_line('full name is:' || a || b);
end;
/
---
create or replace procedure p1(a varchar2,b varchar2)
is
begin

    dbms_output.put_line('full name :' || a ||b);
end;
/
---
create or replace function f1(a varchar2,b varchar2)
return varchar2
is
begin
    return (a ||b);
end;
/
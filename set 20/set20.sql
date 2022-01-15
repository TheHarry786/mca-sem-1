--1. Find out the names of all the tables, views and constraints associated with current tables in the system.

select * from tab;
select object_name from user_objects
where object_type='TABLE' or object_type='VIEW';

select object_name from user_objects where object_type='VIEW';

---constraints associated with current tables
select * from user_cons_columns where table_name = 'dept';

--2. Write a query to add 15 days to the current date.
select sysdate+15 from dual;

--3. Write a query to Add and subtract 5 months from the current month.

select add_months(sysdate,+5) from dual;

--4. Find out the ASCII equivalent of character ‘M’.

select ascii('M') from dual;

--5. Find out the character equivalent of ASCII 67, 65 and 84.

select chr(67), chr(65), chr(84) from dual;

--6. Write a query to find the last day of the month.

select last_day(sysdate) from dual;

--7. Find out how many days are left in the current month.

select last_day(sysdate) - sysdate "Day left" from dual;

--8. Write a query to calculate the Date difference between current date and 20/05/2015.

select sysdate-to_date('20/05/2015','dd-mm-yyyy') from dual;

select (sysdate-to_date('20/05/2015','dd-mm-yyyy'))/365 from dual;


--9. Write a query to Calculate the number of months between current date and 03/03/2016.

select months_between(sysdate,to_date('03/03/2016','dd/mm/yyyy'))"Months" from dual;

--10. Find out the second occurrence of ‘or’ from third position in the string ‘corporate floor.
--select instr('<targeted string>','<serach-string>','<starting-position>','<string-occurrence>' from dual)
select instr('corporate floor','or',1,2) from dual;

--11. Find out log to the base 3 of 81.

select log(3,81) "Log base 3 of 81" from dual;
--12. Convert the string ‘gujarat technological university’ so that first character of each work is in capital.

select initcap('gujarat technological university') from dual;
select upper('gujarat technological university ') from dual;
select Lower(upper('gujarat technological university ')) from dual;

--13. Convert the string ‘jack and jue’ Into ‘black and blue’.

select replace('jack and jue','j','bl') "changes done" from dual;

--14. Round off the date 27-July-2016 to the current year.

select round(to_date('27-july-2016'),'year')"current year" from dual;

--15. Find out the user name and user id off currently logged on user.

select username from v$SESSION;
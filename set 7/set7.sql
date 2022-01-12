create table Customer
(
	cno int primary key,
	cust_name varchar2(30),
	cust_phone number(10),
	location varchar2(30),
	gender varchar2(10) check(gender in ('male','female'))
);
--isnert 
insert into Customer values(1,'Harshit',737393338,'jamnagar','male');
insert into Customer values(2,'mahek',828837372,'junagadh','female');
insert into Customer values(3,'kenil',737833338,'rajkot','male');
insert into Customer values(4,'mira',997833338,'amreli','female');


create table Item
(
	itemno int primary key,
	itemname varchar2(20),
	color varchar2(20),
	weight number(10),
	expire_date date,
	price number(10),
	shop_name varchar2(20)
);
--insert
insert into Item values(101,'cookie','green',10,'21-Dec-2021',200,'raju_shop');
insert into Item values(113,'Biscuit','red',30,'1-Jan-2022',100,'mohan_skop');
insert into Item values(105,'bread','green',20,'2-Feb-2022',400,'Mira_shop');
insert into Item values(10,'egg','red',50,'1-Feb-2022',800,'kira_shop');
insert into Item values(11,'grapes','green',20,'30-Dec-2021',100,'aira_shop');
insert into Item values(1,'potato','green',10,'12-Dec-2021',100,'a_shop');


create table Cust_item
(
	cno int REFERENCES Customer(cno),
	itemno int REFERENCES Item(itemno),
	quantity_purchased varchar2(20),
	date_purchased date
);

--insert
insert into Cust_item values(1,105,9,'1-Dec-2021');
insert into Cust_item values(1,101,7,'6-Dec-2021');
insert into Cust_item values(2,105,5,'29-Nov-2021');
insert into Cust_item values(1,113,4,'3-Dec-2021');
insert into Cust_item values(3,101,7,'5-Dec-2021');
insert into Cust_item values(2,101,8,'30-Nov-2021');

--1. Delete the items whose price is more than 50000.
delete from Item where price>400; 

--2. Find the names of the customer who is located in same location as that of other customer
select location,count(*) from Customer 
group by location having count(*)>=2;

--3. Display the names of items which is black, white & brown in color.
select itemname,color from Item 
where color in('red','green');

--4. Display the names of all the items whose names lies between ‘p’ and‘s’.
select itemname from Item where itemname 
BETWEEN 'a' and 'h';

--5. Find the item which is having less weight.
select * from item where weight 
in(select min(weight) from item); 

--6. Add one month more to those items whose item no =40
update item set expire_date=add_months(expire_date,1) 
where itemno = 1;

--7. Count total number of items which is going to expire in next month
select count(itemno) from item where 
to_char(expire_date,'MON') = (select 
to_char(add_months(sysdate,1),'MON') from dual);

--8. List all customers whose phone number starts with ‘99’.
select * from Customer where cust_phone like '99%';

--9. Display total value (qty*price) for all items.
select ci.quantity_purchased,i.price, 
(quantity_purchased*i.price) 
as total from Cust_item ci,item i where i.itemno=ci.itemno;

--10. List customer details who has purchased maximum number of items 
select * from Customer where cno in
(select cno from Cust_item group by cno having count(cno)=
(select max(ic) from (select cno,count(cno)
as ic from Cust_item group by cno))); 

--short query.
select * from (select cno,count(cno) as ic from Cust_item group by cno order by cno)
where rownum=1;

--11. Display total price item wise.
select i.itemname,ci.cno,ci.quantity_purchased,i.price, 
(quantity_purchased*i.price)as total 
from Cust_item ci,item i 
where i.itemno=ci.itemno 
order by i.price;

--12. List name of items, customer details and qty purchased.
select i.itemname,c.cust_name,ci.quantity_purchased 
from customer c,item i,Cust_item ci 
where c.cno = ci.cno 
and i.itemno = ci.itemno;

--13.Write a PL/SQL procedure which will display records in the following format
declare
	cursor c1
	is
	select i.itemno,i.itemname,i.expire_date,i.price,ci.quantity_purchased,i.shop_name,i.price*ci.quantity_purchased as amt 
	from item i, Cust_item ci
	where
	i.itemno=ci.itemno and
	shop_name='Mira_shop';
	dt date;
	sp_name varchar2(20);
	tot_amt number(10);
begin
	sp_name:='Mira_shop';
	tot_amt:=0;
	select sysdate into dt from dual;
	dbms_output.put_line('------------------------');
	dbms_output.put_line('Today date: '||dt||'Shop Name :'||sp_name);
	dbms_output.put_line('------------------------');

	for r in c1 loop
		dbms_output.put_line(Rpad(to_char(r.itemno),5)
		||Rpad(r.itemname,15)
		||lpad(to_char(r.expire_date),12)
		||lpad(to_char(r.price),8)
		||lpad(to_char(r.quantity_purchased),8)
		||lpad(to_char(r.amt),8));
		tot_amt:=tot_amt+r.amt;
	end loop;
	dbms_output.put_line('------------------------');
	dbms_output.put_line('Grand Total Rs:'||tot_amt);
	dbms_output.put_line('------------------------');
end;
/

------for procedure:-
create or replace procedure p1
is
	cursor c1
	is
	select i.itemno,i.itemname,i.expire_date,i.price,ci.quantity_purchased,i.shop_name,i.price*ci.quantity_purchased as amt 
	from item i, Cust_item ci
	where
	i.itemno=ci.itemno and
	shop_name='Mira_shop';
	dt date;
	sp_name varchar2(20);
	tot_amt number(10);
begin
	sp_name:='Mira_shop';
	tot_amt:=0;
	select sysdate into dt from dual;
	dbms_output.put_line('------------------------------------------------');
	dbms_output.put_line('Today date: '||dt||'     Shop Name :'||sp_name);
	dbms_output.put_line('------------------------------------------------');

	for r in c1 loop
		dbms_output.put_line(Rpad(to_char(r.itemno),5)
		||Rpad(r.itemname,15)
		||lpad(to_char(r.expire_date),12)
		||lpad(to_char(r.price),8)
		||lpad(to_char(r.quantity_purchased),8)
		||lpad(to_char(r.amt),8));
		tot_amt:=tot_amt+r.amt;
	end loop;
	dbms_output.put_line('------------------------------------------------');
	dbms_output.put_line('            Grand Total Rs:             '||tot_amt);
	dbms_output.put_line('------------------------------------------------');
end;
/

--14. Write a trigger which do not allow insertion / updation / deletion of Item details on Sunday.

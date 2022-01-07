create table hospital
(
	dno number(10) primary key,
	dname varchar2(30),
	specialization varchar2(30),
	clinic_addr varchar2(30)
);

insert into hospital values(1,'dr.raju','Cardiologist','rajkot');
insert into hospital values(2,'dr.misra','Ophthalmologist','jamnagar');
insert into hospital values(3,'dr.kalani','Neurologist','mumbai');
insert into hospital values(4,'dr.mehta','Gynecologist','junagadh');
insert into hospital values(5,'dr.shah','Dentist','amreli');

create table medicine
(
	mno number(10) primary key,
	mname varchar2(30),
	type varchar2(30),
	content varchar2(30),
	manufacture varchar2(30)
);

insert into medicine values(101,'painkiller','tylenol','Not Below 18','rajkot');
insert into medicine values(11,'covid-19','remdesivr','Not Below 18','gandhinagar');
insert into medicine values(102,'crocin','pain relief','Not Below 12','amreli');
insert into medicine values(103,'metacin','fever','Not Below 15','jamnagar');
insert into medicine values(104,'anacin','migraine','Not Below 14','junagadh');

create table disease
(
	disease_name varchar2(30) primary key,
	symptom1 varchar2(30),
	symptom2 varchar2(30),
	symptom3 varchar2(30)
);
insert into disease values('cholera','vomiting','diarrhea','dehydration');
insert into disease values('tyfod','fever','cuff','stumak_pro');
insert into disease values('mucormycosis','cough','headache','fever');
insert into disease values('psoriasis','redness','scaly_skin','tiredness');
insert into disease values('covid','breath_pro','fever','cuff');

create table treatment
(
	tno number(10) primary key,
	dno number(10) REFERENCES hospital(dno),
	disease_name varchar2(30) REFERENCES disease(disease_name),
	mno number(10) REFERENCES medicine(mno),
	dosage number(30),
	avg_cure_time number(10)
);

insert into treatment values(101,1,'covid',11,200,1);
insert into treatment(tno,dno,disease_name,mno,dosage,avg_cure_time)values(102,2,'cholera',102,200,2);
insert into treatment(tno,dno,disease_name,mno,dosage,avg_cure_time)values(103,3,'tyfod',103,300,3);
insert into treatment(tno,dno,disease_name,mno,dosage,avg_cure_time)values(104,4,'mucormycosis',101,400,4);
insert into treatment(tno,dno,disease_name,mno,dosage,avg_cure_time)values(105,5,'psoriasis',104,500,5);

--1. Display records of each table in ascending order.
select * from hospital order by dname;
select * from medicine order by mname;
select * from disease order by disease_name;
select * from treatment order by tno;

--2. Count total number of doctors which has not given any treatment.
select count(dno),dname from hospital where dno not in(select dno from treatment) group by dname;

--3. Display all Chennai doctors who treat cancer.
select dname,clinic_addr,specialization 
from hospital 
where clinic_addr='jamnagar' 
and dno 
in(select dno from treatment where disease_name='cholera');

--4. Remove disease “polio” from disease table as well as treatment table.
delete from treatment where disease_name = 'psoriasis';
delete from disease where disease_name = 'psoriasis';

--5. Delete all those treatment related to liver of Dr.Shah.
delete from treatment where dno in(select dno from hospital where dname='dr.shah');

--6. Create index on dno, Disease name in the treatment table.
create index index_dno_dname on treatment(dno,disease_name);
--after that pass this;
set autotrace on;
select * from treatment;

--7. Display details of doctors who treat migraines.
select * from hospital where dno in(select dno from treatment where disease_name='covid');

--8. What is the maximum dosage of “penicillin” prescribe by the doctor for the treatment of any disease?
select max(dosage) from treatment where mno in (select mno from medicine where mname='crocin');

--9. Display total number of disease treated by every doctor
select d.dname,count(t.disease_name) 
from hospital d, treatment t 
where d.dno = t.dno group by dname; 

--10. Which doctor have no treatment for “depression”?
select dno,dname from hospital where dno not in(select dno from treatment where disease_name='mucormycosis');

--12. Write a PL/SQL block to print the following report ( Symptoms wise print total
--number of medicine given )
declare
	cursor c1
	is
	select A.mno as medicine, count(b.symptom1) as Symptom1,
	count(b.symptom2) as Symptom2, count (b.symptom3) as Symptom3,
	count(b.symptom1)+count(b.symptom2)+count(b.symptom3) as Total from treatment a, disease b where
	a.disease_name = b.disease_name
	group by a.mno;
begin	
	dbms_output.put_line('------------------------');

	dbms_output.put_line(Rpad('Dieaese Name',15)
	||Rpad('Symptom1',15)
	||Rpad('Symptom2',15)
	||Rpad('Symptom3',15)
	||Rpad('Total',15));

	dbms_output.put_line('------------------------');
	for r in c1 loop 
		dbms_output.put_line(Rpad(r.medicine,15)
		||Rpad(r.symptom1,15)
		||Rpad(r.symptom2,15)
		||Rpad(r.symptom3,15)
		||Rpad(r.Total,15));
	end loop;
	dbms_output.put_line('------------------------');
end;
/
create table stack21(f1 date);
 insert into stack21 values (TO_DATE('2017-05-30-16.47.32','YYYY-MM-DD-HH24.MI.SS'));
 
 select f1,
 TO_CHAR(f1,'YYYY-MM-DD'),TO_CHAR(f1,'HH24.MI.SS') from stack21;
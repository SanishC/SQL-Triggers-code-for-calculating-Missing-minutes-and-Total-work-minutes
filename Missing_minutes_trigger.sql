CREATE DEFINER=`root`@`localhost` TRIGGER `employee_attn_records_BEFORE_INSERT` BEFORE INSERT ON `employee_attn_records` FOR EACH ROW BEGIN

Declare Attn_count int default 0 ;
select count(concat(empid,Worked_date)) into Attn_count from emp_attn_details 
where empid=new.emp_id and Worked_date=date(new.Punch_datetime);
if new.In_out='In' and Attn_count=0 then
insert into emp_attn_details set
empid=new.emp_id,
Worked_date=new.Punch_datetime,
Last_punchin=new.punch_datetime;
else if new.In_out='In' then
 update emp_attn_details set Last_Punchin=new.Punch_datetime,
Missing_minutes=Missing_minutes+timestampdiff(minute,last_punchout,new.punch_datetime),
Current_status=new.In_out
where empid=new.emp_id and Worked_date=date(new.Punch_datetime);
end if;
end if;

END
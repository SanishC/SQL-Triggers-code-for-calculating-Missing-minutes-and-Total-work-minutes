CREATE DEFINER=`root`@`localhost` TRIGGER `employee_attn_records_AFTER_INSERT` AFTER INSERT ON `employee_attn_records` FOR EACH ROW BEGIN
if new.In_out='Out' then
update emp_attn_details set
Last_punchout=new.punch_datetime,
worked_minutes=worked_minutes+timestampdiff(minute,last_punchin,last_punchout),
Current_status=new.In_out
where date(Last_Punchin) = date(new.punch_datetime) and empid=new.emp_id;
end if;

END
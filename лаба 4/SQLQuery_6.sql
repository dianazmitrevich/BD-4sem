use UNIVER
select PULPIT.PULPIT_NAME [�������],  ISNULL(TEACHER.TEACHER_NAME, '***') [�������������]
	from TEACHER left outer join PULPIT
	on TEACHER.PULPIT = PULPIT.PULPIT
order by PULPIT.PULPIT_NAME;

select PULPIT.PULPIT_NAME [�������],  ISNULL(TEACHER.TEACHER_NAME, '***') [�������������]
	from PULPIT right outer join TEACHER
	on TEACHER.PULPIT = PULPIT.PULPIT
order by PULPIT.PULPIT_NAME;
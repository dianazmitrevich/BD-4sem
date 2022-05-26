-- 1
use UNIVER
set nocount on
if  exists (select * from SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.Table_1'))
	drop table Table_1;

DECLARE @rows int
SET IMPLICIT_TRANSACTIONS ON
CREATE table Table_1(
	X int
); 
	INSERT INTO Table_1 VALUES
		(1),(2),(3);
	SET @rows = (SELECT COUNT(*) FROM Table_1);
	print N'Количество строк в таблице Table_1: ' + cast(@rows as varchar(10));
	if @rows < 5 commit;
	else rollback;
SET IMPLICIT_TRANSACTIONS OFF;

if exists (select * from  SYS.OBJECTS where OBJECT_ID = object_id(N'DBO.Table_1'))
	print 'Таблица Table_1 есть'; 
else print 'Таблицы Table_1 нет';

--DROP table Table_1

-- 2
use UNIVER
BEGIN try
	BEGIN TRANSACTION
		DELETE SUBJECT WHERE SUBJECT LIKE 'test%';
		INSERT INTO SUBJECT VALUES('test1', 'test1', 'ИСиТ'), ('test2', 'test2', 'ИСиТ');
	commit transaction;
END try
BEGIN catch
	print N'Ошибка: ' + cast(error_number() as varchar(10))
	print N'Строка: ' + cast(error_line() as varchar(10))
	print N'Сообщение: ' + error_message();
	if @@TRANCOUNT > 0
		rollback TRANSACTION;
END catch;

-- 3
use UNIVER
set nocount on
DECLARE @point varchar(32);
BEGIN try
	BEGIN TRANSACTION
		DELETE SUBJECT WHERE SUBJECT LIKE 'test%';
		SET @point = 'p1'; SAVE TRANSACTION @point;
		INSERT INTO SUBJECT VALUES('test1', 'test1', 'ИСиТ');
		SET @point = 'p2'; SAVE TRANSACTION @point;
		INSERT INTO SUBJECT VALUES('test2', 'test2', 'ИСиТ');
	commit TRANSACTION;
END try
BEGIN catch
	print N'Ошибка: ' + cast(error_number() as varchar(10))
	print N'Строка: ' + cast(error_line() as varchar(10))
	print N'Сообщение: ' + error_message();
	if @@TRANCOUNT > 0
		BEGIN
			print N'Контрольная точка: ' + @point;
			rollback TRANSACTION @point;
			commit TRANSACTION;
		END;
END catch;

-- 4
use UNIVER
set transaction isolation level read uncommitted
begin transaction 
select count(*) from AUDITORIUM
commit transaction;

begin tran
delete from AUDITORIUM where AUDITORIUM='301-1'
select count(*) from AUDITORIUM 
rollback tran

select count(*) from AUDITORIUM

-- 5
use UNIVER;
SET nocount on;
set transaction isolation level read committed
begin transaction
select count(*) from AUDITORIUM
commit transaction;

begin tran
delete from AUDITORIUM where AUDITORIUM='301-1'
select count(*) from AUDITORIUM
rollback tran

select count(*) from AUDITORIUM

-- 6
use UNIVER;
SET nocount on;

set transaction isolation level repeatable read
begin tran
select count(*) from AUDITORIUM

begin tran
delete from AUDITORIUM where AUDITORIUM='301-1'
commit tran
-- rollback tran

select count(*) from AUDITORIUM

commit tran

-- 7
use UNIVER;
SET nocount on;
set transaction isolation level serializable
begin transaction
delete STUDENT where IDSTUDENT=1000;
insert STUDENT values(1,'студент','26/05/2022', null, null, null);
update STUDENT set IDGROUP=9 where NAME='студент';
select * from STUDENT where IDGROUP=12;
commit;

set transaction isolation level read committed
begin transaction
delete STUDENT where NAME='студент';
insert STUDENT values(2,'другой студент','26/05/2022', null, null, null);
update STUDENT set IDGROUP=9 where NAME='другой студент';
select * from STUDENT where IDGROUP=9;
commit

select * from STUDENT where IDGROUP=12;

-- 8
BEGIN TRANSACTION
INSERT INTO AUDITORIUM
VALUES ('0-0', 'ЛБ-К', 120, '0-0')
SELECT * FROM AUDITORIUM

-- DELETE AUDITORIUM WHERE AUDITORIUM='0-0'

BEGIN TRANSACTION
UPDATE AUDITORIUM
SET AUDITORIUM_CAPACITY = 90
WHERE [AUDITORIUM_NAME] LIKE '0-0'
SELECT * FROM AUDITORIUM
-- ROLLBACK TRANSACTION

COMMIT TRANSACTION
SELECT * FROM AUDITORIUM
-- 1
use UNIVER;
set nocount on;

GO
CREATE PROCEDURE PSUBJECT AS
BEGIN
	DECLARE @count int;
	SELECT * FROM dbo.SUBJECT;
	SET @count = (SELECT COUNT(*) FROM SUBJECT);

	RETURN @count;
END;

DECLARE @c int;
EXEC @c = PSUBJECT;
PRINT 'количество строк: ' + CAST(@c as varchar(5));

-- 2
GO
use UNIVER;
set nocount on;

DECLARE @k int, @r int, @param varchar(20);
EXEC @k = PSUBJECT @param = 'ИСиТ', @cout = @r output;
PRINT 'количество строк: ' + CAST(@k as varchar(5));

-- 3
use UNIVER; -- drop procedure PSUBJECT_1

GO
CREATE procedure PSUBJECT_1 @param varchar(20) AS
BEGIN
	DECLARE @count int;
	SET @count = (SELECT COUNT(*) FROM SUBJECT WHERE SUBJECT.PULPIT = @param);
	PRINT 'параметры: @p = ' + @param + ' @c = ' + CAST(@count as varchar(5));

	SELECT * FROM dbo.SUBJECT WHERE SUBJECT.PULPIT = @param;
END;

-- drop table #SUBJECT
CREATE TABLE #SUBJECT (
	SUBJ varchar(10) NOT NULL,
	SUBJ_NAME varchar(100),
	PULP varchar(10) NOT NULL
);

INSERT #SUBJECT EXEC PSUBJECT_1 @param = 'ИСиТ';
SELECT * FROM #SUBJECT;
GO

-- 4
use UNIVER;
SET nocount on;

GO
CREATE procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10) AS
BEGIN
	BEGIN try
		INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
			values(@a, @n, @c, @t);
		RETURN 1;
	END try
	BEGIN catch
		print 'Error number: ' + cast(ERROR_NUMBER() as varchar(6));
		print 'Error message: ' + ERROR_MESSAGE();
		print 'Error line: ' + cast(ERROR_LINE()as varchar(8));
		if ERROR_PROCEDURE() is not null
			print 'Error procedure: ' + ERROR_PROCEDURE();
		print 'Error secerity: ' + cast(ERROR_SEVERITY()as varchar(6));
		print 'Error state: ' + cast(ERROR_STATE()as varchar(8));
		RETURN -1;
	END CATCH
END;

DECLARE @paud int = 0;
EXEC @paud = PAUDITORIUM_INSERT @a='999-1',@n='999-1',@c='99',@t='ЛК-К';
-- DELETE AUDITORIUM where AUDITORIUM_NAME='999-1';
GO

-- 5
use UNIVER;
SET nocount on;

GO
CREATE procedure SUBJECT_REPORT @pulpit varchar(20) AS
BEGIN
	BEGIN try
		if not exists (select * from SUBJECT where SUBJECT.PULPIT = @pulpit)
			RAISERROR('ошибка в параметрах', 11, 1);
		else
			BEGIN
				DECLARE pulpit_subjects CURSOR LOCAL FOR
					SELECT SUBJECT.SUBJECT
					FROM SUBJECT
					WHERE SUBJECT.PULPIT = @pulpit;

				DECLARE @subject char(30), @subjects char(500) ='', @count int = 0;

				OPEN pulpit_subjects;
				FETCH pulpit_subjects into @subject;
				PRINT 'ИСиТ:';
				WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @subjects = RTRIM(@subject) +', ' +  @subjects;
						FETCH pulpit_subjects into @subject;
						SET @count = @count + 1;
					END;
					PRINT @subjects;
				CLOSE pulpit_subjects;
				RETURN @count;
			END
	END try
	BEGIN catch
		print 'ошибка в параметрах.'
		if ERROR_PROCEDURE() is not null
			print 'ошибка:' + error_procedure();
		return -1;
	END catch;
END;

DECLARE @res_rep int;
exec @res_rep = SUBJECT_REPORT @pulpit = 'ИСиТ';
print 'количество: ' + cast(@res_rep as varchar(3));
GO

-- 6
use UNIVER;
SET nocount on;

GO
CREATE procedure PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50) AS
BEGIN
	BEGIN try
		set transaction isolation level SERIALIZABLE;
		begin transaction
			INSERT into AUDITORIUM_TYPE (AUDITORIUM_TYPE,AUDITORIUM_TYPENAME)
				values(@t, @tn);
			EXEC PAUDITORIUM_INSERT @a=@a, @n=@n, @c=@c, @t=@t;
		commit transaction;
		return  1;
	END try
	BEGIN catch
		print 'Error number: ' + cast(ERROR_NUMBER() as varchar(6));
		print 'Error message: ' + ERROR_MESSAGE();
		print 'Error line: ' + cast(ERROR_LINE()as varchar(8));
		if ERROR_PROCEDURE() is not null
			print 'Error procedure: ' + ERROR_PROCEDURE();
		print 'Error secerity: ' + cast(ERROR_SEVERITY()as varchar(6));
		print 'Error state: ' + cast(ERROR_STATE()as varchar(8));
		RETURN -1;
	END catch
END;
GO

DECLARE @paud int = 0;
EXEC @paud = PAUDITORIUM_INSERTX @a='999-1', @n='999-1', @c='90', @t='ЛД-К', @tn ='тест';
use UNIVER

-- 1
DECLARE
	@char char(1) = 'd',
	@vchar varchar(7) = 'varchar',
	@time time = '12:00:00',
	@date datetime = getdate(),
	@int int,
	@sint smallint,
	@tint tinyint,
	@num numeric(12, 5);
SET	@sint = (SELECT COUNT(*) FROM STUDENT);

SELECT
	@date [@datetime],
	@time [@time],
	@sint [@sint],
	@num [@num];
PRINT 'char = ' + CAST(@char AS varchar(10));
PRINT 'vchar = ' + CAST(@vchar AS varchar(10));
PRINT 'tint = ' + CAST(@tint AS varchar(10));

-- 2
DECLARE
	@capacity int = (SELECT SUM(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM),
	@averageCapacity float(3),
	@lessThanAverage int,
	@total int;
IF @capacity > 200
	BEGIN
		SELECT
			@averageCapacity = (SELECT CAST(AVG(AUDITORIUM.AUDITORIUM_CAPACITY) AS float(3)) FROM AUDITORIUM),
			@total = (SELECT COUNT(*) FROM AUDITORIUM);
		SET @lessThanAverage = (
			SELECT COUNT(*)
			FROM AUDITORIUM
			WHERE AUDITORIUM.AUDITORIUM_CAPACITY < @averageCapacity);
		SELECT
			@capacity [Общая вместимость],
			@averageCapacity [Средняя вместимость],
			@total [Количество],
			@lessThanAverage [Меньше средней],
			CAST((100.0 * @lessThanAverage / @total) AS float(3)) [Процент]
	END
ELSE
	BEGIN
		PRINT 'Общая вместимость: ' + CAST(@capacity AS varchar(10));
	END

-- 3
PRINT '@@ROWCOUNT = ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '@@VERSION = ' + CAST(@@VERSION AS varchar(10));
PRINT '@@SPID = ' + CAST(@@SPID AS varchar(10));
PRINT '@@ERROR = ' + CAST(@@ERROR AS varchar(10));
PRINT '@@SERVERNAME = ' + CAST(@@SERVERNAME AS varchar(10));
PRINT '@@TRANCOUNT = ' + CAST(@@TRANCOUNT AS varchar(10));
PRINT '@@FETCH_STATUS = ' + CAST(@@FETCH_STATUS AS varchar(10));
PRINT '@@NESTLEVEL = ' + CAST(@@NESTLEVEL AS varchar(10));

-- 4
DECLARE @x int = 1, @t int = 10, @z float;
IF (@t > @x) SET @z = POWER(SIN(@t), 2);
ELSE IF (@t < @x) SET @z = 4 * (@t + @x);
ELSE SET @z = 1 - EXP(@x - 2);
PRINT 'x = ' + CAST(@x AS varchar(10));
PRINT 't = ' + CAST(@t AS varchar(10));
PRINT 'z = ' + CAST(@z AS varchar(10));

DECLARE @FIO varchar(50) = 'Макейчик Татьяна Леонидовна';
SET @FIO = (
	SELECT
		SUBSTRING(@FIO, 1, CHARINDEX(' ', @FIO)) +
		SUBSTRING(@FIO, CHARINDEX(' ', @FIO) + 1, 1) + '.' +
		SUBSTRING(@FIO, CHARINDEX(' ', @FIO, CHARINDEX(' ', @FIO) + 1) + 1, 1) + '.'
);
PRINT 'Инициалы: ' + @FIO;

DECLARE @nextMonth int = MONTH(GETDATE()) + 1;
SELECT 
	STUDENT.NAME,
	STUDENT.BDAY
FROM STUDENT
WHERE MONTH(STUDENT.BDAY) = @nextMonth;

SELECT DISTINCT
	PROGRESS.SUBJECT,
	PROGRESS.PDATE,
	DATENAME(DW, PROGRESS.PDATE) [День недели]
FROM PROGRESS
WHERE PROGRESS.SUBJECT = 'СУБД';

-- 5
DECLARE @aStudents int = (
	SELECT COUNT(*)
	FROM STUDENT
	WHERE STUDENT.NAME LIKE 'А%'
);
IF(@aStudents < 5)
	BEGIN
		PRINT 'Количество студентов с фамилией на А меньше 5';
	END
ELSE
	BEGIN
		SELECT STUDENT.IDSTUDENT, STUDENT.NAME
		FROM STUDENT
		WHERE STUDENT.NAME LIKE 'А%';
	END

-- 6
SELECT *
FROM (
	SELECT
		CASE
			WHEN (PROGRESS.NOTE IN (9, 10)) THEN 'Супер'
			WHEN (PROGRESS.NOTE IN (7, 8)) THEN 'Хорошо'
			WHEN (PROGRESS.NOTE IN (5, 6)) THEN 'Не очень'
			ELSE 'Плохо'
		END [Оценка],
		COUNT(*) [Количество]
	FROM PROGRESS
	GROUP BY CASE
			WHEN (PROGRESS.NOTE IN (9, 10)) THEN 'Супер'
			WHEN (PROGRESS.NOTE IN (7, 8)) THEN 'Хорошо'
			WHEN (PROGRESS.NOTE IN (5, 6)) THEN 'Не очень'
			ELSE 'Плохо'
	END
) AS T;

-- 7
CREATE TABLE #TEST (
	ID int NOT NULL,
	STRING varchar(50),
);
DECLARE @index int = 0;
WHILE (@index < 10)
	BEGIN
		INSERT #TEST(ID, STRING) VALUES
			(@index, CAST(@index + MONTH(GETDATE()) AS varchar(50)));
		SET @index = @index + 1;
	END
SELECT *
FROM #TEST;

--DROP TABLE #TEST

-- 8
DECLARE @a int = 0
	PRINT @a + 1
	PRINT @a + 2
	RETURN
	PRINT @a + 3

-- 9
BEGIN TRY
	UPDATE AUDITORIUM SET AUDITORIUM.AUDITORIUM_CAPACITY = 'ZERO' WHERE AUDITORIUM.AUDITORIUM_TYPE = 'ЛК'
	SELECT * FROM AUDITORIUM
END TRY
BEGIN CATCH
	PRINT 'ERROR_NUMBER = ' + CAST(ERROR_NUMBER() AS varchar(10))
	PRINT 'ERROR_MESSAGE = ' + ERROR_MESSAGE()
	PRINT 'ERROR_LINE = ' + CAST(ERROR_LINE() AS varchar(10))
	PRINT 'ERROR_PROCEDURE = ' + CAST(ERROR_PROCEDURE() AS varchar(10))
	PRINT 'ERROR_SEVERITY = ' + CAST(ERROR_SEVERITY() AS varchar(10))
	PRINT 'ERROR_STATE = ' + CAST(ERROR_STATE() AS varchar(10))
END CATCH
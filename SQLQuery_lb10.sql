-- 1
use UNIVER
GO
DECLARE isit CURSOR FOR
	SELECT SUBJECT.SUBJECT
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ';

DECLARE @subject char(30), @subjects char(500) ='';

OPEN isit;
FETCH isit INTO @subject;
PRINT 'Список дисциплин:';
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH isit into @subject;
	END;
PRINT @subjects;
CLOSE isit;

-- 2
use UNIVER
GO
DECLARE isit_local CURSOR LOCAL FOR
	SELECT SUBJECT.SUBJECT
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ';

PRINT 'Список дисциплин (локальный):';
DECLARE @subject char(30), @subjects char(500) ='';
OPEN isit_local;
FETCH isit_local into @subject;

WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH isit_local into @subject;
	END;
	PRINT @subjects;
CLOSE isit_local;

use UNIVER;
GO
DECLARE isit_global CURSOR GLOBAL FOR
	SELECT SUBJECT.SUBJECT
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ';

PRINT 'Список дисциплин (глобальный):';
DECLARE @subject char(30), @subjects char(500) ='';
OPEN isit_global;
FETCH isit_global into @subject;

WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH isit_global into @subject;
	END;
	PRINT @subjects;
CLOSE isit_global;
DEALLOCATE isit_global;

-- 3
use UNIVER
GO
DECLARE isit_static CURSOR LOCAL STATIC FOR
	SELECT SUBJECT.SUBJECT
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ';

DECLARE @subject char(30), @subjects char(500) ='';
OPEN isit_static;
INSERT INTO SUBJECT VALUES('тест', 'тест', 'ИСиТ');
FETCH isit_static into @subject;
PRINT 'Список дисциплин (статический):';
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH isit_static into @subject;
	END;
	PRINT @subjects;
CLOSE isit_static;

DELETE SUBJECT WHERE SUBJECT_NAME = 'тест';

use UNIVER
GO
DECLARE isit_dynamic CURSOR LOCAL DYNAMIC FOR
	SELECT SUBJECT.SUBJECT
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ';

DECLARE @subject char(30), @subjects char(500) ='';

OPEN isit_dynamic;
INSERT INTO SUBJECT VALUES('тест', 'тест', 'ИСиТ');

FETCH isit_dynamic into @subject;
PRINT 'Список дисциплин (динамический):';
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH isit_dynamic into @subject;
	END;
	PRINT @subjects;
CLOSE isit_dynamic;

DELETE SUBJECT WHERE SUBJECT = 'тест';

-- 4
use UNIVER
GO
DECLARE isit_scroll CURSOR LOCAL DYNAMIC SCROLL FOR
	SELECT
		ROW_NUMBER() over (order by SUBJECT),
		SUBJECT.SUBJECT
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ';
DECLARE @subject char(30), @row int = 0;
OPEN isit_scroll;

FETCH isit_scroll INTO @row, @subject;
PRINT 'Следующая строка: ' + CAST(@row as varchar(4)) + ', ' + RTRIM(@subject);

FETCH LAST FROM isit_scroll INTO @row, @subject;
PRINT 'Последняя строка: ' + CAST(@row as varchar(4)) + ', ' + RTRIM(@subject);

FETCH RELATIVE -1 FROM isit_scroll INTO @row, @subject;
PRINT 'Предыдущая строка с конца: ' + CAST(@row as varchar(4)) + ', ' + RTRIM(@subject);

FETCH ABSOLUTE 3 FROM isit_scroll INTO @row, @subject;
PRINT 'Третья строка: ' + CAST(@row as varchar(4)) + ', ' + RTRIM(@subject);

FETCH ABSOLUTE -3 FROM isit_scroll INTO @row, @subject;
PRINT 'Третья строка с конца: ' + CAST(@row as varchar(4)) + ', ' + RTRIM(@subject);

-- 5
use UNIVER
GO
INSERT INTO SUBJECT VALUES('тест_1', 'тест_1', 'ИСиТ');
INSERT INTO SUBJECT VALUES('тест_2', 'тест_2', 'ИСиТ');
INSERT INTO SUBJECT VALUES('тест_3', 'тест_3', 'ИСиТ');
DECLARE isit_currentof CURSOR GLOBAL DYNAMIC FOR
	SELECT *
	FROM SUBJECT
	WHERE SUBJECT.PULPIT = 'ИСиТ' AND SUBJECT LIKE 'тест_%'
	FOR UPDATE

-- DELETE SUBJECT WHERE SUBJECT_NAME = 'тест_1';
-- DELETE SUBJECT WHERE SUBJECT_NAME = 'тест_2';
-- DELETE SUBJECT WHERE SUBJECT_NAME = 'тест_3';

DECLARE @subject varchar(30), @subject_name varchar(30), @pulpit varchar(30);
OPEN isit_currentof;
FETCH isit_currentof INTO @subject, @subject_name, @pulpit;
PRINT '1)' + @subject + ' ' + @subject_name + ' ' + @pulpit;
DELETE SUBJECT WHERE CURRENT OF isit_currentof;

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @subject + ' ' + @subject_name + ' ' + @pulpit;
		FETCH isit_currentof INTO @subject, @subject_name, @pulpit;
	END;
CLOSE isit_currentof;
DEALLOCATE isit_currentof;

-- 6
use UNIVER
GO
DECLARE @id varchar(10), @name varchar(100), @subject varchar(50), @note varchar(2);
DECLARE progress CURSOR LOCAL DYNAMIC FOR
	SELECT STUDENT.IDSTUDENT, STUDENT.NAME, PROGRESS.SUBJECT, PROGRESS.NOTE
	FROM PROGRESS INNER JOIN STUDENT ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	FOR UPDATE;

OPEN progress
FETCH progress into @id, @name, @subject, @note;
IF(@note < 4)
	BEGIN
		DELETE PROGRESS WHERE CURRENT OF progress;
	END;
WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH progress into @id, @name, @subject, @note;
		PRINT @id + ' - ' + @name + ' - '+ RTRIM(@subject) + ' - ' + @note ;
		IF(@note < 4)
			BEGIN
				DELETE PROGRESS WHERE CURRENT OF progress;
			END;
	END;
CLOSE progress;

PRINT '------';

OPEN progress;
FETCH progress into @id, @name, @subject, @note;
IF (@note IN (5, 6))
	UPDATE PROGRESS SET NOTE += 3 WHERE CURRENT OF progress;

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		FETCH progress into @id, @name, @subject, @note;
		PRINT @id + ' - ' + @name + ' - '+ RTRIM(@subject) + ' - ' + @note ;
	END;
CLOSE progress;
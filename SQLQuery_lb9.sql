use UNIVER

-- 1
EXEC SP_HELPINDEX 'AUDITORIUM';
EXEC SP_HELPINDEX 'AUDITORIUM_TYPE';
EXEC SP_HELPINDEX 'FACULTY';
EXEC SP_HELPINDEX 'GROUPS';
EXEC SP_HELPINDEX 'PROFESSION';
EXEC SP_HELPINDEX 'PULPIT';
EXEC SP_HELPINDEX 'STUDENT';
EXEC SP_HELPINDEX 'SUBJECT';
EXEC SP_HELPINDEX 'TEACHER';

GO
CREATE TABLE #TASK_1 (
	ID int,
    NUM varchar(100)
);

SET nocount on;
DECLARE @i int = 0;
WHILE (@i < 1000)
	BEGIN
		INSERT INTO #TASK_1(ID, NUM) VALUES(@i, 1000 * RAND());
		SET @i = @i + 1;
	END;

-- DROP TABLE #TASK_1

SELECT *
FROM #TASK_1
WHERE ID BETWEEN 150 AND 250
ORDER BY ID;

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE clustered index ##TASK_1CL on #TASK_1(ID asc);

SELECT *
FROM #TASK_1
WHERE ID BETWEEN 150 AND 250
ORDER BY ID;

-- 2
GO
CREATE TABLE #TASK_2 (
	ID int,
	NUM int
);

-- DROP TABLE #TASK_2

SET nocount on;
DECLARE @i int = 0;
WHILE (@i < 10000)
	BEGIN
		INSERT INTO #TASK_2(ID, NUM) VALUES(@i + 1, 1000 * RAND());
		SET @i = @i + 1;
	END;

SELECT COUNT(*) [Количество_строк] FROM #TASK_2;

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE clustered index #EXAMPLE_2_CL on #TASK_2(ID asc, NUM);

SELECT *
FROM #TASK_2
WHERE NUM BETWEEN 100 AND 200
ORDER BY ID;

-- 3
GO
CREATE TABLE #TASK_3 (
	ID int,
	NUM int
);

-- DROP TABLE #TASK_3

SET nocount on;
DECLARE @i int = 0;
WHILE (@i < 10000)
	BEGIN
		INSERT INTO #TASK_3(ID, NUM) VALUES(@i + 1, 1000 * RAND());
		SET @i = @i + 1;
	END;

SELECT NUM from #TASK_3 where ID between 1 and 100;

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE INDEX #TASK_3CL on #TASK_3(ID) INCLUDE (NUM);

SELECT *
FROM #TASK_3
WHERE NUM = 999 
ORDER BY ID;

-- 4
GO
CREATE TABLE #TASK_4 (
	ID int,
	NUM int
);

-- DROP TABLE #TASK_4

SET nocount on;
DECLARE @i int = 0;
WHILE (@i < 10000)
	BEGIN
		INSERT INTO #TASK_4(ID, NUM) VALUES(@i + 1, 1000 * RAND());
		SET @i = @i + 1;
	END;

CREATE INDEX #EX_WHERE ON #TASK_4(NUM) WHERE NUM >= 1 AND NUM <= 100;

SELECT NUM FROM #TASK_4 WHERE NUM BETWEEN 400 AND 450;
SELECT NUM FROM #TASK_4 WHERE NUM >= 100 AND NUM <= 200;
SELECT NUM FROM #TASK_4 WHERE NUM = 999;

-- 5
GO
CREATE TABLE #TASK_5 (
	ID int,
	NUM int
);

-- DROP TABLE #TASK_5

SET nocount on;
DECLARE @i int = 0;
WHILE (@i < 10000)
	BEGIN
		INSERT INTO #TASK_5(ID, NUM) VALUES(@i + 1, 1000 * RAND());
		SET @i = @i + 1;
	END;

SELECT * FROM #TASK_5 where ID between 100 and 120 order by ID;

CREATE INDEX #EX_ID ON #TASK_5(ID);

SELECT a.index_id, name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'#TASK_5'),
NULL, NULL, NULL, NULL) AS a
INNER JOIN sys.indexes AS b
ON a.object_id = b.object_id AND a.index_id = b.index_id
			WHERE name IS NOT NULL;

ALTER INDEX #EX_ID on #TASK_5 reorganize;
ALTER INDEX #EX_ID on #TASK_5 rebuild with (online = off);

-- 6
GO
CREATE TABLE #TASK_6 (
	ID int,
	NUM int
);

-- DROP TABLE #TASK_6

SET nocount on;
DECLARE @i int = 0;
WHILE (@i < 10000)
	BEGIN
		INSERT INTO #TASK_5(ID, NUM) VALUES(@i + 1, 1000 * RAND());
		SET @i = @i + 1;
	END;

CREATE index #EX_TKEY on #TASK_6(NUM) with (fillfactor = 65);

INSERT top(50) percent INTO #TASK_6(NUM)
	SELECT NUM  FROM #TASK_6;

SELECT a.index_id, name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(N'#TASK_6'),
NULL, NULL, NULL, NULL) AS a
INNER JOIN sys.indexes AS b
ON a.object_id = b.object_id AND a.index_id = b.index_id;
USE [UNIVER]
GO

/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 03.06.2022 11:38:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PSUBJECT] @param varchar(20), @cout int output AS
BEGIN
	DECLARE @count int;
	SELECT * FROM dbo.SUBJECT WHERE SUBJECT.PULPIT = @param;
	SET @count = (SELECT COUNT(*) FROM SUBJECT WHERE SUBJECT.PULPIT = @param);

	RETURN @count;
END;


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RefreshAllViews] AS

-- This sp will refresh all views in the catalog. 
--     It enumerates all views, and runs sp_refreshview for each of them

DECLARE abc CURSOR FOR
     SELECT TABLE_NAME AS ViewName
     FROM INFORMATION_SCHEMA.VIEWS
OPEN abc

DECLARE @ViewName varchar(128)

-- Build select string
DECLARE @SQLString nvarchar(2048)

FETCH NEXT FROM abc 
INTO @ViewName
WHILE @@FETCH_STATUS = 0 
BEGIN
    SET @SQLString = 'EXECUTE sp_RefreshView '+@ViewName
    PRINT @SQLString
    EXECUTE sp_ExecuteSQL @SQLString

    FETCH NEXT FROM abc
    INTO @ViewName
END
CLOSE abc
DEALLOCATE abc
GO
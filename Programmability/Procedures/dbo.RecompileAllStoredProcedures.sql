SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RecompileAllStoredProcedures] AS

DECLARE abc CURSOR FOR
     SELECT ROUTINE_NAME
     FROM INFORMATION_SCHEMA.routines
    WHERE ROUTINE_TYPE = 'PROCEDURE'
OPEN abc

DECLARE @RoutineName varchar(128)

-- Build select string once 
DECLARE @SQLString nvarchar(2048)

FETCH NEXT FROM abc 
INTO @RoutineName
WHILE @@FETCH_STATUS = 0 
BEGIN
    SET @SQLString = 'EXECUTE sp_recompile '+@RoutineName
    PRINT @SQLString
    EXECUTE sp_ExecuteSQL @SQLString

    FETCH NEXT FROM abc
    INTO @RoutineName
END
CLOSE abc
DEALLOCATE abc
GO
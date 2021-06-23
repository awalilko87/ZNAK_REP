SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYS_USERGROUPS_Update](
    @GroupID nvarchar(20) OUT,
    @GroupName nvarchar(100),
    @Module nvarchar(30)
)
WITH ENCRYPTION
AS

DECLARE @Typ nvarchar(50)
SET @Typ = 'PE'

IF @GroupID is null
    SET @GroupID = NewID()
IF @GroupID =''
    SET @GroupID = NewID()

IF LEN(@GroupID) > 20
	SELECT @GroupID = LEFT(@GroupID, 20)
	
IF NOT EXISTS (SELECT * FROM SYGroups WHERE [GroupID] = @GroupID)
BEGIN
    INSERT INTO SYGroups([GroupID], [GroupName], [Module], Typ, Typ2) 
    VALUES (@GroupID, @GroupName, @Module, @Typ, UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@GroupID+'VISION'+@Typ))))
END
ELSE
BEGIN
    UPDATE SYGroups 
    SET [GroupName] = @GroupName,[Module] = @Module
    WHERE [GroupID] = @GroupID
END
GO
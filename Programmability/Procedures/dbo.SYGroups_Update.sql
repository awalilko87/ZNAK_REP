SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYGroups_Update](
    @GroupID nvarchar(20) OUT,
    @GroupName nvarchar(100),
    @Typ nvarchar(50),
    @Typ2 nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @GroupID is null
    SET @GroupID = NewID()
IF @GroupID =''
    SET @GroupID = NewID()

IF LEN(@GroupID)>20
	SELECT @GroupID = LEFT(@GroupID, 20)
	
IF NOT EXISTS (SELECT * FROM SYGroups WHERE GroupID = @GroupID)
BEGIN
    INSERT INTO SYGroups(
        GroupID, GroupName, Typ, Typ2) 
    VALUES (
       Upper(@GroupID), @GroupName, @Typ, @Typ2)
END
ELSE
BEGIN
    UPDATE SYGroups SET
        GroupName = @GroupName,
				Typ = @Typ,
				Typ2 = @Typ2
        WHERE GroupID = @GroupID
END 
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_Update](
    @GroupID nvarchar(20) OUT,
    @ParentID nvarchar(50) = null,
    @GroupDesc nvarchar(300) = null
)
WITH ENCRYPTION
AS

IF @GroupID is null
    SET @GroupID = NewID()
IF @GroupID =''
    SET @GroupID = NewID()

IF NOT EXISTS (SELECT * FROM VS_FormGroups WHERE GroupID = @GroupID)
BEGIN
    INSERT INTO VS_FormGroups(
        GroupID, ParentID, GroupDesc)
    VALUES (
        @GroupID, @ParentID, @GroupDesc)
END
ELSE
BEGIN
    UPDATE VS_FormGroups SET
        ParentID = @ParentID, GroupDesc = @GroupDesc
        WHERE GroupID = @GroupID
END
GO
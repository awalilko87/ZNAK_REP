SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_GetByParentID](
    @ParentID nvarchar(50)
)
WITH ENCRYPTION
AS

    SELECT
        GroupID, ParentID, GroupDesc 
    FROM VS_FormGroups
         WHERE ParentID LIKE @ParentID
	ORDER BY GroupID
GO
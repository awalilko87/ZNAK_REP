SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_Search](
    @GroupID nvarchar(20),
    @ParentID nvarchar(50) = null,
    @GroupDesc nvarchar(300) = null
)
WITH ENCRYPTION
AS

    SELECT
        GroupID, ParentID, GroupDesc
    FROM VS_FormGroups
            /* WHERE ParentID = @ParentID AND GroupDesc = @GroupDesc*/
GO
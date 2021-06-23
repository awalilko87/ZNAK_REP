SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_GetByID](
    @GroupID nvarchar(20) = '%'
)
WITH ENCRYPTION
AS

    SELECT
        GroupID, ParentID, GroupDesc
    FROM VS_FormGroups
         WHERE GroupID LIKE @GroupID
GO
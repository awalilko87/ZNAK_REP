SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_Remove](
    @GroupID nvarchar(20)
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_FormGroups
            WHERE GroupID = @GroupID
GO
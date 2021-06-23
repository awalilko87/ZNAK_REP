SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYGroups_Search](
    @GroupID nvarchar(20),
    @GroupName nvarchar(100),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT GroupID, GroupName, Typ, Typ2 
    FROM SYGroups
GO
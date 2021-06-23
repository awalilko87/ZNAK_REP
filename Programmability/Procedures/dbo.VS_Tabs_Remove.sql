SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_Remove](
    @MenuID nvarchar(50),
    @TabName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
    DELETE
        FROM VS_Tabs
            WHERE MenuID = @MenuID AND TabName = @TabName
GO
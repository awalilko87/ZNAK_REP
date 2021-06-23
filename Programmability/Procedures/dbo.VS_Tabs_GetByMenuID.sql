SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_GetByMenuID](
    @MenuID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
        Visible, TabOrder, TabType, NoUsed 
    FROM VS_Tabs
    WHERE MenuID LIKE @MenuID
    ORDER BY TabOrder
GO
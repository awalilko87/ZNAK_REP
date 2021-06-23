SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_GetVisible](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
        Visible, TabOrder, TabType, NoUsed /*, _USERID_ */ 
    FROM VS_Tabs
    WHERE Visible = 1 AND ISNULL(NoUsed, 0) = 0 AND TabName <> ''
	ORDER BY MenuID, TabOrder
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_GetSorted](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
        Visible, TabOrder, TabType, NoUsed /*, _USERID_ */ 
    FROM VS_Tabs
    ORDER BY MenuID, TabOrder
GO
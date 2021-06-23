SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_Search](
    @MenuID nvarchar(50),
    @TabName nvarchar(50),
    @MenuKey nvarchar(50),
    @TabCaption nvarchar(50),
    @FormID nvarchar(500),
    @Parameters nvarchar(500),
    @TabTooltip nvarchar(max),
    @Visible int,
    @TabOrder int,
    @TabType nvarchar(4),
    @NoUsed bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
        Visible, TabOrder, TabType, NoUsed /*, _USERID_ */ 
    FROM VS_Tabs
GO
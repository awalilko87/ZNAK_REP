SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_Update](
    @MenuID nvarchar(50) OUT,
    @TabName nvarchar(50) OUT,
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

IF @MenuID is null
    SET @MenuID = NewID()
IF @MenuID =''
    SET @MenuID = NewID()

IF NOT EXISTS (SELECT * FROM VS_Tabs WHERE MenuID = @MenuID AND TabName = @TabName)
BEGIN
    INSERT INTO VS_Tabs(
        MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
        Visible, TabOrder, TabType, NoUsed)
    VALUES (
        @MenuID, @TabName, @MenuKey, @TabCaption, @FormID, @Parameters, @TabTooltip,
        @Visible, @TabOrder, @TabType, @NoUsed)
END
ELSE
BEGIN
    UPDATE VS_Tabs 
    SET
        MenuKey = @MenuKey, TabCaption = @TabCaption, FormID = @FormID, TabTooltip = @TabTooltip, Visible = @Visible, 
        TabOrder = @TabOrder, Parameters = @Parameters,
        TabType = @TabType, NoUsed = @NoUsed 
    WHERE 
        MenuID = @MenuID AND TabName = @TabName
END
GO
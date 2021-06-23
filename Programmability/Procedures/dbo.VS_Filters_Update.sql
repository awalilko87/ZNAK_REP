SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Filters_Update](
    @FormID nvarchar(50) OUT,
    @TableName nvarchar(250),
    @GroupID nvarchar(20) OUT,
    @UserID nvarchar(30) OUT,
    @IsPrivate bit,
    @SqlWhere nvarchar(max),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FormID is null
    SET @FormID = NewID()
IF @FormID =''
    SET @FormID = NewID()
IF @GroupID is null
    SET @GroupID = NewID()
IF @GroupID =''
    SET @GroupID = NewID()
IF @UserID is null
    SET @UserID = ''

IF NOT EXISTS (SELECT * FROM VS_Filters WHERE FormID = @FormID AND GroupID = @GroupID AND UserID = @UserID)
BEGIN
    INSERT INTO VS_Filters(
        FormID, TableName, GroupID, UserID, IsPrivate,
        SqlWhere /*, _USERID_ */ )
    VALUES (
        @FormID, @TableName, @GroupID, @UserID, @IsPrivate,
        @SqlWhere /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_Filters SET
        TableName = @TableName, IsPrivate = @IsPrivate, SqlWhere = @SqlWhere /* , _USERID_ = @_USERID_ */ 
        WHERE FormID = @FormID AND GroupID = @GroupID AND UserID = @UserID
END
GO
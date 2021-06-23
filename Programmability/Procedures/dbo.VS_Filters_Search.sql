SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Filters_Search](
    @FormID nvarchar(50),
    @TableName nvarchar(250),
    @GroupID nvarchar(20),
    @UserID nvarchar(30),
    @IsPrivate bit,
    @SqlWhere nvarchar(max),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, TableName, GroupID, UserID, IsPrivate,
        SqlWhere /*, _USERID_ */ 
    FROM VS_Filters
            /* WHERE TableName = @TableName AND IsPrivate = @IsPrivate AND SqlWhere = @SqlWhere /*  AND _USERID_ = @_USERID_ */ */
GO
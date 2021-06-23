SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reporttables_Update](
    @TableName nvarchar(50) OUT,
    @FieldName nvarchar(50) OUT,
    @Description nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FieldName is null
    SET @FieldName = NewID()
IF @FieldName =''
    SET @FieldName = NewID()
IF @TableName is null
    SET @TableName = NewID()
IF @TableName =''
    SET @TableName = NewID()

IF NOT EXISTS (SELECT * FROM VS_Reporttables WHERE FieldName = @FieldName AND TableName = @TableName)
BEGIN
    INSERT INTO VS_Reporttables(
        TableName, FieldName, Description /*, _USERID_ */ )
    VALUES (
        @TableName, @FieldName, @Description /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_Reporttables SET
        Description = @Description /* , _USERID_ = @_USERID_ */ 
        WHERE FieldName = @FieldName AND TableName = @TableName
END
GO
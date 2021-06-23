SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLDV_Update](
    @DocID nvarchar(50) OUT,
    @FieldName nvarchar(50) OUT,
    @FieldValue nvarchar(50) OUT,
    @Display nvarchar(50),
    @Remarks nvarchar(100),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @DocID is null
    SET @DocID = NewID()
IF @DocID =''
    SET @DocID = NewID()
IF @FieldName is null
    SET @FieldName = NewID()
IF @FieldName =''
    SET @FieldName = NewID()
IF @FieldValue is null
    SET @FieldValue = NewID()
IF @FieldValue =''
    SET @FieldValue = NewID()

IF NOT EXISTS (SELECT * FROM SYDocListSQLDV WHERE DocID = @DocID AND FieldName = @FieldName AND FieldValue = @FieldValue)
BEGIN
    INSERT INTO SYDocListSQLDV(
        DocID, FieldName, FieldValue, Display, Remarks /*, _USERID_ */ )
    VALUES (
        @DocID, @FieldName, @FieldValue, @Display, @Remarks /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYDocListSQLDV SET
        Display = @Display, Remarks = @Remarks /* , _USERID_ = @_USERID_ */ 
        WHERE DocID = @DocID AND FieldName = @FieldName AND FieldValue = @FieldValue
END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Langs_Update](
    @LangID nvarchar(10) OUT,
    @LangName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @LangID is null
    SET @LangID = NewID()
IF @LangID =''
    SET @LangID = NewID()

IF NOT EXISTS (SELECT * FROM VS_Langs WHERE LangID = @LangID)
BEGIN
    INSERT INTO VS_Langs(
        LangID, LangName /*, _USERID_ */ )
    VALUES (
        @LangID, @LangName /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_Langs SET
        LangName = @LangName /* , _USERID_ = @_USERID_ */ 
        WHERE LangID = @LangID
END
GO
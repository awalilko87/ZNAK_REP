SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_GetByObjectIDForUser](
    @UserID nvarchar(30),
    @ObjectID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

--select @UserID = usr_code from r5users WHERE usr_group = @UserID

SELECT @UserID = UserID FROM dbo.SYUsers WHERE UserID = @UserID

    SELECT
        UserID, FormID, FieldID, Rights,
        Cond, rReadOnly, rVisible, rRequire /*, _USERID_ */ 
    FROM  VS_Rights
        WHERE UserID = @UserID AND FormID = @ObjectID
GO
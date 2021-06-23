SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_Remove](
    @Cond nvarchar(100),
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @UserID nvarchar(30),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_Rights
            WHERE Cond = @Cond AND FieldID = @FieldID AND FormID = @FormID AND UserID = @UserID
GO
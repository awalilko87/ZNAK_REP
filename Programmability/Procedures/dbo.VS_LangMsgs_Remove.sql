SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_Remove](
    @ControlID nvarchar(50),
    @LangID nvarchar(10),
    @ObjectID nvarchar(150),
    @ObjectType nvarchar(20),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_LangMsgs
            WHERE ControlID = @ControlID AND LangID = @LangID AND ObjectID = @ObjectID AND ObjectType = @ObjectType
GO
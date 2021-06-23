SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_GetCustomMsg](
	@LangID nvarchar(10) = '%',
    @ObjectID nvarchar(150) = '%',
    @ObjectType nvarchar(20) = '%',
	@Message nvarchar(4000) = '%' OUT,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        @Message = Caption
    FROM VS_LangMsgs
         WHERE [LangID] = @LangID AND ObjectID = @ObjectID AND ObjectType = @ObjectType
GO
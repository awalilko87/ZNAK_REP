SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_CheckDefTrans](
    @LangID nvarchar(50)
)
WITH ENCRYPTION
AS
	IF (SELECT COUNT(*) FROM VS_LangMsgs WHERE [LangID] = @LangID AND ObjectType = 'MSG') < 130
		SELECT 1
	ELSE
		SELECT 0
GO
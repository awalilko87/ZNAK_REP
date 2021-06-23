SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_CreateOtherMsgs](
	@LangID nvarchar(10),
	@ObjectID nvarchar(150),
	@Caption nvarchar(4000)
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE [LangID] = @LangID AND [ObjectID] = @ObjectID AND [ControlID] = '' AND [ObjectType] = 'MSG')
BEGIN
	INSERT INTO VS_LangMsgs([LangID], [ObjectID], [ControlID], [ObjectType], [Caption])
	VALUES(@LangID, @ObjectID, '', 'MSG', @Caption)
END

GO
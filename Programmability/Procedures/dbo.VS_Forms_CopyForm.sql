SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_CopyForm](
    @FormID varchar(50),
    @NewFormID varchar(50),
	@GroupID nvarchar(20)) 
WITH ENCRYPTION 
AS
    --szkielet
	SET NOCOUNT ON
	DECLARE @Res int
	DECLARE @Mes varchar(255)
	DECLARE @__Procname sysname
	DECLARE @TranCnt int
 
	IF EXISTS(SELECT * FROM dbo.VS_Forms WHERE FormID=@NewFormID)
	BEGIN
		SET @Mes = 'istnieje już formatka o kodzie : ' + @NewFormID
		RAISERROR (@Mes, 16, 1)
		RETURN
	END
	 
	IF NOT EXISTS(SELECT * FROM dbo.VS_Forms WHERE FormID=@FormID)
	BEGIN
		SET @Mes = 'NIE ZNALEZIONO FORMATKI O KODZIE : ' + @FormID
		RAISERROR (@Mes, 16, 1)
		RETURN
	END
       
	DECLARE @col varchar(100), @sins varchar(8000), @s varchar(8000)
	SET @s = ''
	SET @sins = ''
	DECLARE c cursor for
	SELECT name FROM syscolumns WHERE id = Object_id(N'VS_Forms')
	OPEN c
	FETCH NEXT FROM c INTO @col
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@col = 'GroupID')
		BEGIN
			SET @sins = @sins + ', GroupID'
			SET @s = @s + ', ''' + @GroupID + ''''
		END
		ELSE IF @col<>'FormID'
		BEGIN
			SET @sins = @sins +', '+@col
			SET @s = @s + ', ' + @col
		END
		FETCH NEXT FROM c INTO @col
	END
	CLOSE c
	DEALLOCATE c
	SET @s = 'INSERT INTO dbo.VS_Forms(FormID'+@sins+') SELECT ''' + @NewFormID +'''' + @s + ' FROM dbo.VS_Forms WHERE FormID = ''' + @FormID +''''
	PRINT @s
	EXEC (@s)
	
	SET @s = ''
	DECLARE c cursor for
	SELECT name From syscolumns WHERE id = Object_id(N'VS_FormFields')
	OPEN c
	FETCH NEXT FROM c INTO @col
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @col<>'FormID'
			SET @s = @s + ', ' + @col
		FETCH NEXT FROM c INTO @col
	END
	CLOSE c
	DEALLOCATE c
	SET @s = 'INSERT INTO dbo.VS_FormFields (FormID'+ @s +') SELECT ''' + @NewFormID +'''' + @s + ' FROM dbo.VS_FormFields WHERE FormID = ''' + @FormID +''''
	PRINT @s
	EXEC (@s)

	INSERT INTO dbo.[VS_Rights] (
           [UserID]
           ,[FormID]
           ,[FieldID]
           ,[Rights]
           ,[Cond]
           ,[rReadOnly]
           ,[rVisible]
           ,[rRequire])
	SELECT 
			[UserID]
           ,@NewFormID
           ,[FieldID]
           ,[Rights]
           ,[Cond]
           ,[rReadOnly]
           ,[rVisible]
           ,[rRequire]
	FROM dbo.[VS_Rights] WHERE FormID = @FormID
	
	INSERT INTO dbo.[VS_LangMsgs] (
	  [LangID]
	  ,[ControlID]
      ,[ObjectType]
      ,[ObjectID]
      ,[Caption]
      ,[GridColCaption]
      ,[ValidateErrMessage]
      ,[CallbackMessage]
      ,[ButtonTextNew]
      ,[ButtonTextDelete]
      ,[ButtonTextSave]
      ,[AltSavePrompt]
      ,[AltRequirePrompt]
      ,[AltRecCountPrompt]
	  ,[AltPageOfCounter]
      ,[Tooltip])
	SELECT
	  [LangID]
	  ,[ControlID]
      ,[ObjectType]
      ,@NewFormID
      ,[Caption]
      ,[GridColCaption]
      ,[ValidateErrMessage]
      ,[CallbackMessage]
      ,[ButtonTextNew]
      ,[ButtonTextDelete]
      ,[ButtonTextSave]
      ,[AltSavePrompt]
      ,[AltRequirePrompt]
      ,[AltRecCountPrompt]
	  ,[AltPageOfCounter]
      ,[Tooltip]		
	FROM dbo.[VS_LangMsgs] WHERE [ObjectID] = @FormID 	
GO
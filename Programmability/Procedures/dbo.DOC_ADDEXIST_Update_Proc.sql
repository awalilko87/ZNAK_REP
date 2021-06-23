SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[DOC_ADDEXIST_Update_Proc] 
  @p_FileName nvarchar(300),
  
  @p_Entity nvarchar(4),
  @p_PK1 nvarchar(30),
  @p_PK2 nvarchar(30) = null,
  @p_PK3 nvarchar(30) = null,
  @p_copyToWo int = null,
  @p_copyToPo int = null,

  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000) output
as

-- na przykładzie tabeli EVT
-- ## elementy do dodania
  
begin
  declare @v_errorcode nvarchar(50)
  declare @v_LangID nvarchar(20)
  declare @v_evanttype nvarchar(1)  -- rodzaj zdarzenia
  declare @v_errortext nvarchar(4000)
  declare @v_date datetime
  declare @v_string nvarchar(3000)
  declare @v_module nvarchar(30)
  declare @v_errorid int
  declare @v_TYPE nvarchar(30)
  declare @v_TYPE2 nvarchar(30)
  declare @v_TYPE3 nvarchar(30)
  
  select @v_errorcode = null
  select @v_LangID = LangID from SYUsers where UserID = @p_UserID
  if @v_LangID is null
  begin
    select @v_LangID = 'EN'
  end
  select @v_module = Module from SYUsers where UserID = @p_UserID
  if @v_module is null
  begin
    select @v_module = 'ZMT'
  end

  select @v_evanttype = null
  select @v_date = getdate()
  select @v_string = null

  declare @v_code nvarchar(50)
  select @v_code = dbo.GetFilesCodeFromEntity (@p_Entity,@p_PK1,@p_PK2,@p_PK3)

  select top 1 
	 @v_TYPE = DAE_TYPE
	,@v_TYPE2 = DAE_TYPE2
	,@v_TYPE3 = DAE_TYPE3
  from dbo.DOCENTITIES(nolock) where DAE_DOCUMENT = @p_FileName and DAE_TYPE is not null

  -- czy klucze niepuste
  if @p_FileName is null and @v_code is null-- ## dopisac klucze
  begin
    select @v_errorcode = '1'
    goto errorlabel
  end


  -- insert
  begin
	if exists (select * from SYFiles (nolock) where [FileID2] = @p_FileName)
	begin
		insert into dbo.DOCENTITIES (DAE_DOCUMENT, DAE_ENTITY, DAE_CODE, DAE_COPYTOWO, DAE_COPYTOPO, DAE_MN, DAE_TYPE, DAE_TYPE2, DAE_TYPE3, DAE_CREUSER)
			values (@p_FileName, @p_Entity, @v_code, @p_copyToWo, @p_copyToPo, 0, @v_TYPE, @v_TYPE2, @v_TYPE3, @p_UserID)
	end
	else
	begin
	  select @v_errorcode = '3'
	  goto errorlabel
	end
	
  end

  return 0
  errorlabel:
    exec err_proc @v_errorcode, null, @p_UserID, @v_errortext output
    raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
end
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[DOC_UPLOAD_Update_Proc]   
  @p_FileID2 nvarchar(50),  
  @p_FileName nvarchar(300),  
  @p_Description nvarchar(250),  
  @p_DAETYPE nvarchar(30),  
  @p_DAETYPE2 nvarchar(30),  
  @p_DAETYPE3 nvarchar(30),  
  @p_Entity nvarchar(4),  
  @p_PK1 nvarchar(30),  
  @p_PK2 nvarchar(30),  
  @p_PK3 nvarchar(30),  
  
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
  declare @v_FileCode nvarchar(100)  
    
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
  
--  if @p_FileName is null  
-- select @p_FileName = [FileName] from dbo.SYFiles (nolock) where FileID2 = @p_FileID2  
    
  if @p_Description is null  
 set @p_Description = ''  
  
  
  declare @v_code nvarchar(50)  
  select @v_code = dbo.GetFilesCodeFromEntity (@p_Entity,@p_PK1,@p_PK2,@p_PK3)  
  
  -- czy klucze niepuste  
  if @v_code is null -- ## dopisac klucze  
  begin  
    select @v_errorcode = 'SYS_003'  
    goto errorlabel  
  end  
  
  if isnull(@p_FileID2,'') = ''  
  begin  
    select @v_errorcode = 'SYS_020'  
    goto errorlabel  
  end  
  
  
  -- insert  
  begin  
 if not exists (select * from SYFiles (nolock) where [FileID2] = @p_FileName) or isnull(@p_FileName,'') = ''  
 begin  
  if isnull(@p_FileName,'') = ''  
  begin  
   exec dbo.VS_GetNumber 'DOC', '', '', @v_FileCode output  
   while exists(select * from dbo.SYFiles (nolock) where [FileID2] = @v_FileCode)  
   begin  
    exec dbo.VS_GetNumber 'DOC', '', '', @v_FileCode output  
   end  
  end  
  else   
  begin  
   select @v_FileCode = @p_FileName  
  end 
  
  update SYFiles set   
    [FileID2] = @v_FileCode  
   ,[Description] = @p_Description  
   ,[TableName] = 'ZMT'  
  where FileID2 = @p_FileID2  
  
  
  declare @v_FileName nvarchar(30)
  select  @v_FileName = [FileName] from SyFiles where [FileID2] = @v_FileCode 
   
  if @@error <> 0   
  begin  
    select @v_errorcode = '3'  
    goto errorlabel  
  end  
  
  if exists (select * from SYFiles (nolock) where [FileID2] = @v_FileCode)  
  begin  
   insert into dbo.DOCENTITIES (DAE_DOCUMENT, DAE_ENTITY, DAE_TYPE, DAE_TYPE2, DAE_TYPE3, DAE_CODE, DAE_MN, DAE_CREUSER)  
    values (@v_FileCode, @p_Entity, @p_DAETYPE, @p_DAETYPE2, @p_DAETYPE3, @v_code, 0, @p_UserID) 
    
    exec DOC_UPLOAD_AUDIT @v_FileCode, @v_FileName, 'NOWY',@p_PK1, @p_UserID
     
  end  
  else  
  begin  
    select @v_errorcode = '3'  
    goto errorlabel  
  end  
  
 end  
 else  
 begin  
  select @v_errorcode = 'DOC_EXISTS'  
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
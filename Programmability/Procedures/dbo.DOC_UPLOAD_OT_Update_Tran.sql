SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[DOC_UPLOAD_OT_Update_Tran]  
  @p_FileID2 nvarchar(50),  
  @p_FileName nvarchar(300),  
  @p_Description nvarchar(250),  
  @p_DAETYPE nvarchar(30),  
  @p_DAETYPE2 nvarchar(30),  
  @p_DAETYPE3 nvarchar(30),  
  @p_Entity nvarchar(4), 
  @p_TXT01 nvarchar(30),  
  @p_PK1 nvarchar(30),  
  @p_PK2 nvarchar(30),  
  @p_PK3 nvarchar(30),  
  @p_UserID nvarchar(30), -- uzytkownik  
  @p_apperrortext nvarchar(4000) = null output  
as  
begin  
  declare @v_errorid int  
  declare @v_errortext nvarchar(4000)   
  select @v_errorid = 0  
  select @v_errortext = null  
  
  begin transaction  
    exec @v_errorid = DOC_UPLOAD_OT_Update_Proc @p_FileID2, @p_FileName, @p_Description, @p_DAETYPE, @p_DAETYPE2, @p_DAETYPE3, @p_Entity, @p_TXT01, @p_PK1, @p_PK2, @p_PK3, @p_UserID, @p_apperrortext output  
    if @v_errorid = 0  
  begin  
    commit transaction  
    return 0  
  end  
  else  
  begin  
    rollback transaction  
    return 1  
  end  
end  
  
  
  
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[err_proc] 
  @p_errorcode nvarchar(50),
  @p_syserrorcode nvarchar(4000),
  @p_UserID nvarchar(50),
  @p_apperrortext_out  nvarchar(4000) = null output,
  @p_Type nvarchar(5) = 'ERROR'
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_apperrortext nvarchar(4000)
  declare @v_LangID nvarchar(10)
  declare @v_UserGroupID nvarchar(10)
  declare @v_syserrorcode nvarchar(4000)
  
  select @v_LangID = isnull(LangID,'PL'), @v_UserGroupID = UserGroupID from dbo.SYUsers (nolock) where UserID = @p_UserID

--  if @v_UserGroupID = 'SA' 
	select @v_syserrorcode = isnull(' <i><br><b>SQL Server:</b><br>'+@p_syserrorcode+'</i>','')
--  else
--	select @v_syserrorcode = ' '

  if @p_errorcode = ''
  begin
	select @p_apperrortext_out = @p_syserrorcode
	return
  end

  if exists(select * from VS_LangMsgs where LangID = @v_LangID and ObjectID = @p_errorcode and ControlID = '' and ObjectType = 'MSG')
  begin
    if @p_Type = 'OK'
    begin
      select @p_apperrortext_out = '<span style="color: Green;">'+Caption+'<span><span style="color: Red;">'+@v_syserrorcode+'<span>' from VS_LangMsgs where LangID = @v_LangID and ObjectID = @p_errorcode and ControlID = '' and ObjectType = 'MSG'
    end
    else
    begin
      select @p_apperrortext_out = Caption from VS_LangMsgs where LangID = @v_LangID and ObjectID = @p_errorcode and ControlID = '' and ObjectType = 'MSG'
	  select @p_apperrortext_out = isnull(@p_errorcode+' - ','')+isnull(@p_apperrortext_out,'')+@v_syserrorcode
    end
  end
  else
  begin
    if @v_LangID = 'PL' or @v_LangID is null
	begin
      select @p_apperrortext_out = N'Inny błąd'+@v_syserrorcode
    end
    if @v_LangID = 'EN'
	begin
      select @p_apperrortext_out = N'Other error'+@v_syserrorcode
    end
  end
end
GO
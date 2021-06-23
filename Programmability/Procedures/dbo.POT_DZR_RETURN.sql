SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[POT_DZR_RETURN] (  
@p_POT_ID nvarchar(50)  
,@p_POT_ROWID int   
,@p_UserID nvarchar(30)  
)  
as  
begin  
  
declare @v_comment nvarchar(max)  
declare @v_UserDesc nvarchar(80)  
declare @v_poc_GroupID nvarchar(30)

select @v_poc_GroupID = POC_GROUPID from OBJTECHPROTCHECK_GU where POC_CHECKUSER = @p_UserID
select @v_UserDesc = UserName from SyUsers where UserID = @p_UserID  

   
 if exists (select 1 from dbo.OBJTECHPROTCHECK_GU (nolock) where POC_POTID = @p_POT_ROWID and POC_GROUPID = @v_poc_GroupID)  
  
  begin  

	set  @v_comment = 'Użytkownik: ' + @v_UserDesc + ' przywrócił możliwość oceny składników dla grupy: ' + @v_poc_GroupID  

   delete from dbo.OBJTECHPROTCHECK_GU where POC_POTID = @p_POT_ROWID and POC_GROUPID = @v_poc_GroupID   
  
   /*Ustawiamy znacznik na Protokole - będzie potrzebny do procedury oceny składników w przypadku powrotu do oceny*/
  
	update dbo.OBJTECHPROT
	set POT_RETURN = 1
	where POT_ROWID = @p_POT_ROWID


   /*Wrzucenie informacji o przywróceniu do oceny przez grupę*/  
  
      insert into dbo.COMMENTS        
       (        
		COM_ENTITY        
      , COM_ID        
      , COM_TEXT        
      , COM_DATE        
      , COM_USER        
       )        
       values        
       (        
		'POT'        
      , @p_POT_ID        
      , @v_comment       
      , getdate()        
      , @p_UserID        
       )    
  
  end  
end 


GO
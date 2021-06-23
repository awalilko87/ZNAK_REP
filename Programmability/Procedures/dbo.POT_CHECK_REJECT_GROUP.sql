SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[POT_CHECK_REJECT_GROUP]    
(    
@p_POTID nvarchar(50)    
,@p_pot_rowid int    
,@p_UserID nvarchar(30)    
,@p_comment nvarchar(max)    
)    
as    
begin    
    
declare @v_Group_perm nvarchar(10)    
declare @v_UserDesc nvarchar(80)    
declare @v_comment nvarchar(max)    
declare @v_perm table (PotID int, GroupID nvarchar(10), UserID nvarchar(30))    
    
select @v_UserDesc = UserName from SyUsers where UserID = @p_UserID    
    
insert into @v_perm(PotID,GroupID,UserID)    
    
select POT_ROWID, 'DZR', CHK_GU_DZR_USER from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_POTID    
union all                           
select POT_ROWID, 'IT', CHK_GU_IT_USER from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_POTID    
union all                           
select POT_ROWID, 'RKB', CHK_GU_RKB_USER from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_POTID    
union all                           
select POT_ROWID, 'UR', CHK_GU_UR_USER from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_POTID     
    
    
select @v_Group_perm = GroupID from @v_perm where UserID = @p_UserID    
    
set @v_comment = N'Powód odrzucenia możliwości akceptacji składników: ' + @p_comment    
    
    
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
      , @p_POTID            
      , @v_comment           
      , getdate()            
      , @p_UserID            
       )    
   
   /*Aktualizacja pól odrzucania możliwości*/

  if @v_Group_perm = 'DZR'
	  begin 
		   update[dbo].[OBJTECHPROT]  
		   set CHK_GU_DZR_REJ = 1 
		   where POT_ID = @p_POTID
	  end


  if @v_Group_perm = 'IT'
	  begin 
		   update[dbo].[OBJTECHPROT]  
		   set CHK_GU_IT_REJ = 1 
		   where POT_ID = @p_POTID
	  end


  if @v_Group_perm = 'RKB'
	  begin 
		   update[dbo].[OBJTECHPROT]  
		   set CHK_GU_RBK_REJ = 1 
		   where POT_ID = @p_POTID
	  end


  if @v_Group_perm = 'UR'
	  begin 
		   update[dbo].[OBJTECHPROT]  
		   set CHK_GU_UR_REJ = 1 
		   where POT_ID = @p_POTID
	  end

  
    /*Uruchamiamy procedurę wysyłki maila do realizatora w momencie wprowadzenia komentarza, przez osobę odrzucającą zlecenie*/  
  exec [dbo].[POT_CHANGE_PERSON_MAIL] @p_pot_rowid,@p_UserID, @v_Group_perm, @v_comment  
  
    
end
GO
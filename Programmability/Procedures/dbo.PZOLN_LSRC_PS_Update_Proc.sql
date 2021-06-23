SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PZOLN_LSRC_PS_Update_Proc](              
@p_FormID nvarchar(50),              
@p_ROWID int,                 
@p_PS_ACCEPT int,             
@p_PS_COMMENT nvarchar(max),            
@p_UserID nvarchar(30)              
)              
as              
begin              
 declare @v_errortext nvarchar(1000)         
 declare @OBJ int     
 declare @POT_ID int    
 declare @POL_STATUS  nvarchar(30)  
 select @OBJ = POL_OBJID     
 ,@POT_ID = POL_POTID   
 ,@POL_STATUS = POL_STATUS   
 from OBJTECHPROTLN where POL_ROWID = @p_ROWID     
          
           
 if @p_PS_ACCEPT = 0 and @p_PS_COMMENT is null          
          
  begin           
  RaisError (N'Podaj przyczynę odrzucenia  składnika',16,1)        
  return;        
  end     
    
    
  if @POL_STATUS = 'PZL_002'  
    
    begin           
   RaisError (N'Operacja niedozwolona! Nie można przyjąć składnika w statusie "Nieodebrany"',16,1)        
   return;        
  end  
    
        
               
 begin try          
             
  update dbo.OBJTECHPROTLN           
  set POL_UPDUSER = @p_UserID              
   ,POL_UPDDATE = getdate()            
   ,POL_PS_ACCEPT = @p_PS_ACCEPT            
   ,POL_PS_COMMENT = @p_PS_COMMENT              
  where POL_ROWID = @p_ROWID        
          
          
if @p_PS_ACCEPT = 1        
        
 update OBJ        
 set OBJ_STATUS  = 'OBJ_002'        
 where obj_rowid = @OBJ     
     
     
 if not exists (select 1 from OBJTECHPROTLN where POL_POTID = @POT_ID and IsNull(POL_PS_ACCEPT,0) = '0')    
 begin    
     
 update OBJTECHPROT    
 set POT_STATUS = 'PZO_005'    
 where POT_ROWID = @POT_ID    
     
 end    
     
else     
    
 begin    
 -- Wysyłamy powiadomienie mailowe do managera  o istniejących składnikach, które nie zostały zaakceptowane przez PS    
  exec dbo.OBJTECHPROTLN_Not_Acc_Proc @POT_ID    
     
 end     
                    
 end try              
 begin catch              
  set @v_errortext = error_message()              
  goto errorlabel              
 end catch              
              
 return 0              
              
errorlabel:              
 raiserror(@v_errortext, 16, 1)              
 return 1              
end 
GO
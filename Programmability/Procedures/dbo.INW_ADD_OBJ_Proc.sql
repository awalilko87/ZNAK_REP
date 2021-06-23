SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INW_ADD_OBJ_Proc]           
(          
           
 @p_FormID nvarchar(50),           
 @p_STNID nvarchar(30),            
 @p_STS nvarchar(30),               
 @p_SIA_ROWID nvarchar(30),          
 @p_SIN_ROWID int,        
 @p_SIN_CODE nvarchar(30),       
 @p_UserID nvarchar(30) -- uzytkownik          
)          
as          
begin          
          
 declare @v_errorcode nvarchar(50)          
 declare @v_syserrorcode nvarchar(4000)          
 declare @v_errortext nvarchar(4000)          
 declare @v_date datetime          
 declare @v_OBJID_MAIN int --= 0           
  , @v_OBJ_PSPID int            
  , @v_STSID int          
  , @v_ASTID int          
           
            
 --Sprawdza czy istnieje szablon           
 select @v_STSID = STS_ROWID from STENCIL (nolock) where STS_CODE = @p_STS          
 if isnull(@v_STSID,0) = 0          
 begin          
  select @v_errorcode = 'STS_002'          
  goto errorlabel          
 end         
     
     
 -- print '@v_STSID:  '  + cast(@v_STSID as nvarchar(10))     
      
 -- print '@v_STNID:  '  + cast(@p_STNID as nvarchar(10))     
      
             
 --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++          
 --+++++++++++++++++++++++++++++INSERT++++++++++++++++++++++++++++++++++++          
 --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++          
 if @v_STSID is not null and @p_STNID is not null          
 begin          
              
   BEGIN TRY          
           
    exec dbo.GenStsObj @v_STSID, NULL /*tu było psp*/, NULL, NULL, @p_STNID, @p_UserID, @v_OBJID_MAIN output       
           
                
   END TRY          
   BEGIN CATCH          
    select @v_syserrorcode = error_message()          
    select @v_errorcode = 'STS_010'          
    goto errorlabel          
   END CATCH;          
            
 end    
    
     
-- print '@v_OBJID_MAIN:  '  + cast(@v_OBJID_MAIN as nvarchar(10))       
          
          
 /*      
 kp utworzenie nowego składnika   
 if @p_SIA_ROWID is not null and @v_OBJID_MAIN is not null          
 begin          
  select @v_ASTID = SIA_ASSETID from AST_INWLN where SIA_ROWID = @p_SIA_ROWID          
         
 if @v_ASTID is not null         
  begin         
    if not exists (select * from OBJASSET where OBA_ASTID = @v_ASTID)          
    begin          
      insert into OBJASSET (OBA_OBJID, OBA_ASTID, OBA_CREDATE, OBA_CREUSER)          
      values (@v_OBJID_MAIN, @v_ASTID, getdate(), @p_UserID)          
    end          
  end         
 end       
*/
       
 declare @v_barcode nvarchar(30)      
       
 select @v_barcode =  obj_code from obj where obj_rowid = @v_OBJID_MAIN      
       
 /*Dodajemy dany składnik od razu do pozycji inwentaryzacji*/      
    insert into dbo.AST_INWLN(SIA_SINID, SIA_ASSETID, SIA_CODE, SIA_BARCODE, SIA_ORG, SIA_OLDQTY, SIA_PRICE, SIA_STATUS, SIA_NEWQTY, SIA_CREUSER, SIA_CREDATE,SIA_NOTUSED, SIA_NADWYZKA, SIA_OBJID)        
    select @p_SIN_rowid, @v_ASTID,@p_SIN_CODE,@v_barcode,'PKN', 1, 1, 'INW', 1, @p_UserID,GETDATE(),0, 1, @v_OBJID_MAIN     
            
 return 0          
          
 errorlabel:          
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext          
  raiserror (@v_errortext, 16, 1)           
  --select @p_apperrortext = @v_errortext          
  return 1          
end       
      
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_ADD_OBJ_LINES_Proc]   
(  
   
 @p_FormID nvarchar(50),  
 @p_ANOID int,  
 @p_OBJ_COUNT int = 0,  
 @p_STS_CHILD nvarchar(30),    
 @p_STS_PARENT nvarchar(30),   
  
 @p_UserID nvarchar(30), -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin  
 declare @v_errorcode nvarchar(50)  
 declare @v_syserrorcode nvarchar(4000)  
 declare @v_errortext nvarchar(4000)  
 declare @v_date datetime  
 declare   
    @v_STNID int = 0  
  , @v_ASTID int = 0  
  , @v_OBJID_MAIN int = 0  
  , @v_OBJID_CHILD int = 0  
  , @v_OBJID_CHILD_COUNT int = 0  
  , @v_STS_CHILDID int  
  , @v_STS_PARENTID int  
  , @v_STS_BLANK smallint  
   
 set @v_date = getdate()  
  
 --Ten element nie będzie wprowadzany (na liście wpisano 0)  
 if isnull(@p_OBJ_COUNT,0) = 0  
  return 0  
   
 --Sprawdza czy istnieje szablon nadrzędny  
 select @v_STS_PARENTID = STS_ROWID from [dbo].[STENCIL] (nolock) where STS_CODE = @p_STS_PARENT  
 if isnull(@v_STS_PARENTID,0) = 0  
 begin  
  select @v_errorcode = 'STS_002'  
  goto errorlabel  
 end   
  
 --Sprawdza czy istnieje szablon podrzędny  
 select @v_STS_CHILDID = STS_ROWID from [dbo].[STENCIL] (nolock) where STS_CODE = @p_STS_CHILD  
 if isnull(@v_STS_CHILDID,0) = 0 and ISNULL(@p_FormID,'') not in ('INWAST_ADD_OBJ' , 'INWAST_ADD_OBJ_MULTI') 
 begin  
  select @v_errorcode = 'STS_003'  
  goto errorlabel  
 end   
   
 --numer miejsca / stacji docelowej (dla OBJSTATION)  
 --select ANO_STNID, ANO_SIAID from [dbo].[ASTINW_NEW_OBJ] where ANO_ROWID = 20  
 select @v_STNID = ANO_STNID, @v_ASTID = ANO_ASTID from [dbo].[ASTINW_NEW_OBJ] where ANO_ROWID = @p_ANOID  
 if isnull(@v_STNID,0) = 0  
 begin   
  select @v_errorcode = 'STS_004'  
  goto errorlabel  
 end   
  
 --dodaje element nadrzędny  
 if @v_STS_PARENTID is not null  
 begin  
  --sprawdza czy istnieje zestaw/komplet nadrzędny  
  select   
   @v_OBJID_MAIN = OBJ_ROWID,  
   @v_STS_BLANK = @v_STS_BLANK  
  from OBJ (nolock)  
   join STENCIL (nolock) on STS_ROWID = OBJ_STSID   
   join SETTYPE (nolock) on STT_CODE = STS_SETTYPE  
  where   
   OBJ_ANOID = @p_ANOID   
   and OBJ_STSID = @v_STS_PARENTID   
   and STT_MAIN = 1   
   
  --jeśli nie ma zestawu (@v_OBJID_MAIN = 0), wprowadza zestaw (nie obowiązuje dla szablonów technicznych (zakładają PINPADy bez zestawu))  
  if isnull(@v_OBJID_MAIN,0) = 0 and isnull(@v_STS_BLANK ,0) = 0  
  begin     
   
   BEGIN TRY  
   
    exec dbo.GenStsObj @v_STS_PARENTID, NULL, @p_ANOID, NULL, @v_STNID, @p_UserID, @v_OBJID_MAIN output, @p_apperrortext output  
          
    update [dbo].[OBJ] set OBJ_ANOID = @p_ANOID where OBJ_PARENTID = @v_OBJID_MAIN  
         
   END TRY  
   BEGIN CATCH  
    select @v_syserrorcode = error_message()  
    select @v_errorcode = 'STS_010' -- blad kasowania  
    goto errorlabel  
   END CATCH;  
  end  
          
 end  
  
 --dodaje elementy podrzędne  
 if @v_STS_CHILDID is not null  
 begin    
    
  --zlicza ile obecnie jest podskładników w zestawie/komplecie    
  select   
   @v_OBJID_CHILD_COUNT = count (*)  
  from dbo.OBJ (nolock)  
   join dbo.STENCIL (nolock) on STS_ROWID = OBJ_STSID    
  where   
   OBJ_ANOID = @p_ANOID   
   and OBJ_STSID = @v_STS_CHILDID    
   
  --dodaje obiekty do ilości podanej na formularzu  
  while @v_OBJID_CHILD_COUNT < @p_OBJ_COUNT  
  begin  
  
   BEGIN TRY  
    --select @p_STS_CHILD = 'Check + ' + isnull(cast( @v_STS_PARENTID as nvarchar), 'nul')  
    --raiserror(@p_STS_CHILD,16,1)  
    --return   
      
    exec dbo.GenStsObj @v_STS_CHILDID, NULL, @p_ANOID, @v_OBJID_MAIN, @v_STNID, @p_UserID, @v_OBJID_CHILD output, @p_apperrortext output  
     
    update [dbo].[OBJ] set OBJ_ANOID = @p_ANOID where OBJ_PARENTID = @v_OBJID_MAIN  
      
    --zlicza ile obecnie jest podskładników w zestawie/komplecie    
    select   
     @v_OBJID_CHILD_COUNT = @v_OBJID_CHILD_COUNT + 1  
      
   END TRY  
   BEGIN CATCH  
    select @v_syserrorcode = error_message()  
    select @v_errorcode = 'STS_010' -- blad kasowania  
    goto errorlabel  
   END CATCH;  
  
  end  
   
 end  
    
 insert into OBJASSET (OBA_OBJID, OBA_ASTID, OBA_CREDATE)  
 select OBJ_ROWID, @v_ASTID, GETDATE()  
 from OBJ (nolock) where OBJ_ANOID = @p_ANOID and OBJ_ROWID not in (select OBA_OBJID from OBJASSET (nolock))  
     
 return 0  
  
 errorlabel:  
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
end  
GO
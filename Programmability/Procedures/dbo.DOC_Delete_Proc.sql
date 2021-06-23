SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[DOC_Delete_Proc]    
(    
@p_ENTITY nvarchar(4)    
,@p_FILEID2 nvarchar(50)    
,@p_OBJ_CODE nvarchar(30)    
,@p_OBJ_ORG nvarchar(30)    
,@p_UserID nvarchar(30)    
)    
as    
begin     
 if exists (select 1 from DOCENTITIES where DAE_DOCUMENT = @p_FILEID2 )    
  begin    
   declare @v_FileName nvarchar(max)   
   declare @Entity nvarchar(30)   
   
   select  @Entity  = DAE_ENTITY from DOCENTITIES where DAE_DOCUMENT = @p_FILEID2  
   select @v_FileName = [FileName] from     
   SYFILES where  FILEID2 = @p_FILEID2   
   
   
   if @Entity in ('OT11','OT21') 
   select top 1  @p_OBJ_CODE  = ROWID from VS_AUDIT where TableRowid = @p_FILEID2 and TABLENAME = 'DOCENTITIES'

      
   delete from dbo.DOCENTITIES     
   where DAE_DOCUMENT = @p_FILEID2     
  -- and DAE_ENTITY = @p_ENTITY     
   and DAE_CODE = (dbo.GetFilesCodeFromEntity(@Entity,@p_OBJ_CODE,@p_OBJ_ORG,''))    
       
   exec DOC_UPLOAD_AUDIT @p_FILEID2, @v_FIleName, 'USUNIECIE',@p_OBJ_CODE, @p_UserID    
       
  end    
end     
GO
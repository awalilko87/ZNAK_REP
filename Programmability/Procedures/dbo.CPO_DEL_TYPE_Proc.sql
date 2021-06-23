SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPO_DEL_TYPE_Proc]       
(       
 @p_potID nvarchar(30),       
 @p_key nvarchar(max),      
 @p_UserID nvarchar(30)      
)      
 as       
 begin       
       
 declare         
  @c_ROWID int,      
      
  @v_errorcode nvarchar(50),      
  @v_errortext nvarchar(4000),      
  @v_syserrorcode nvarchar(4000),      
  @p_apperrortext nvarchar(max);      
        
          
 if isnull(@p_KEY,'') = ''      
 begin      
  set @v_errorcode = 'SYS_010'      
  goto errorlabel      
 end      
      
 declare c_XLS cursor for      
 select String from dbo.VS_Split3(@p_KEY,';') where String <> ''      
        
 open c_XLS       
      
 fetch next from c_XLS       
 into @c_ROWID      
       
 while @@FETCH_STATUS = 0       
 begin      
    
 if exists (select 1 from CPO_OBJECT_STENCIL where CPT_CPOID = @p_potID and CPT_STSID = @c_ROWID)    
  begin          
		delete from  CPO_OBJECT_STENCIL where CPT_CPOID = @p_potID and CPT_STSID = @c_ROWID
  end      
         
  fetch next from c_XLS      
  into @c_ROWID      
      
 end      
      
 close c_XLS       
 deallocate c_XLS       
      
 --raiserror('Dodano %i składników',1,1,@v_COUNT)      
       
return 0      
      
errorlabel:      
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output      
 raiserror (@v_errortext, 16, 1)       
 return 1      
         
 end 
GO
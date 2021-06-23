SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPO_ADD_TYPE_Proc]     
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

declare @STS_CODE nvarchar(30) 
declare @TYP_ROWID int  
declare @TYP2_ROWID int

select @STS_CODE = STS_CODE from STENCIL where STS_ROWID = @c_ROWID

select  @TYP_ROWID = TYP_ROWID from TYP where TYP_CODE = (select STS_TYPE from STENCIL where STS_ROWID = @c_ROWID)
select  @TYP2_ROWID = TYP2_ROWID from TYP2 where TYP2_CODE = (select STS_TYPE2 from STENCIL where STS_ROWID = @c_ROWID) 
 
 if not exists (select 1 from CPO_OBJECT_STENCIL where CPT_CPOID = @p_potID and CPT_STSID = @c_ROWID)  
  begin        
	  insert into CPO_OBJECT_STENCIL(CPT_CPOID,CPT_STSID,CPT_TYPEID,CPT_TYPE2ID)  
	  values (@p_potID,@c_ROWID, @TYP_ROWID, @TYP2_ROWID)  
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
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[ZWFOT_TEMPLATEDel]
(
 @p_Key nvarchar(max),        
 @p_UserID nvarchar(30)
)as
BEGIN
	declare @c_ROWID int,        
        
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
			 if exists (select 1 from dbo.ZWFOT_TEMPLATE where OTID = @c_ROWID and USERID = @p_UserID)      
			  begin            
			  delete from  dbo.ZWFOT_TEMPLATE where OTID = @c_ROWID and USERID = @p_UserID
			  end        
           
			  fetch next from c_XLS        
			  into @c_ROWID        
        
		 end        
        
	 close c_XLS         
	 deallocate c_XLS         
        
 Raiserror('Wzorce poprawnie usunięte z listy',1,1)        
         
return 0        
        
errorlabel:        
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output        
 raiserror (@v_errortext, 16, 1)         
 return 1   


END
GO
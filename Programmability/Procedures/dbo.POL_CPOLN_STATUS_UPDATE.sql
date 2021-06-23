SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[POL_CPOLN_STATUS_UPDATE]  
(  
@p_ROWID int  
,@p_OPER_TYPE nvarchar(30)  
,@p_POT_TYPE nvarchar(30) 
,@p_POL_TOSTNID int 
,@p_UserID nvarchar(30)
,@p_apperrortext nvarchar(4000) = null output  

)  
AS   
 BEGIN   
	declare @v_errorcode nvarchar(50)  
	declare @v_syserrorcode nvarchar(4000)  
	declare @v_errortext nvarchar(4000)  
	declare @v_STATUS nvarchar(30) 
	declare @v_TOSTNID int 
  
  select @v_TOSTNID = POL_TO_STNID from dbo.OBJTECHPROTLN where POL_ROWID = @p_ROWID
   
  select  @v_STATUS = case  when @p_OPER_TYPE = 'ODSPRZEDAJ' and @p_POT_TYPE = 'OCENA' then 'POL_008'  
							when @p_OPER_TYPE = 'ODSPRZEDAJ' and @p_POT_TYPE = 'CPO'   then 'CPOLN_008'  
							when @p_OPER_TYPE = 'LIKWIDUJ' and @p_POT_TYPE = 'OCENA' then 'POL_0082'  
							when @p_OPER_TYPE = 'LIKWIDUJ' and @p_POT_TYPE = 'CPO'   then 'CPOLN_002'  
							when @p_OPER_TYPE = 'PRZENIES' and @p_POT_TYPE = 'OCENA' then 'POL_005'  
							when @p_OPER_TYPE = 'PRZENIES' and @p_POT_TYPE = 'CPO'   then 'CPOLN_005'  
					 end  
    

	if @p_OPER_TYPE = 'PRZENIES' and @v_TOSTNID IS NULL

		begin 
			select @v_syserrorcode = error_message()  
			select @v_errorcode = 'POLN_001' -- Przy operacji przenoszenia, stacja docelowa jest wymagana.  
			goto errorlabel 
		end

  if exists (select * from dbo.OBJTECHPROTLN   
        join dbo.OBJTECHPROT on POL_POTID = POT_ROWID   
        where POL_TYPE = @p_POT_TYPE and POL_POTID = @p_ROWID and POL_STATUS <> @v_STATUS)  
		   begin   
				update OBJTECHPROTLN  
				set POL_STATUS = @v_STATUS  
					,POL_TO_STNID = @p_POL_TOSTNID -- jeżeli składnik ma zostać przeniesiony musimy wskazać stację docelową
				where POL_POTID = @p_ROWID  
		   end  
  
  	return 0  
   
errorlabel:  
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
	raiserror (@v_errortext, 16, 1)   
	select @p_apperrortext = @v_errortext  
	return 1 
  
 END  
  
  
GO
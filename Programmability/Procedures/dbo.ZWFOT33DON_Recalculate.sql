SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
  
CREATE procedure [dbo].[ZWFOT33DON_Recalculate]   
 (@p_OT33ID int)  
as  
begin  
   --declare @v_ZMT_ROWID int  
   --select @v_ZMT_ROWID = OT33_ZMT_ROWID from dbo.SAPO_ZWFOT33 (nolock) where OT33_ROWID = @p_OT33ID  
     
   if (select COUNT(*) from dbo.SAPO_ZWFOT33LN (nolock) where OT33LN_OT33ID = @p_OT33ID) > 0  
   begin  
     
    --usuwanie nieaktywnych (widok SAPO_ZWFOT33DONv jest dynamiczny, tabela SAPO_ZWFOT33DON musi być aktualizowana)   
    delete from actual  
    from dbo.SAPO_ZWFOT33DON actual   
     left JOIN ZWFOT33DONv calculated on   
      --calculated.OT33DON_ANLN1 = actual.OT33DON_ANLN1 and   
      calculated.OT33DON_ANLN2 = actual.OT33DON_ANLN2 and   
      calculated.OT33DON_OT33ID = actual.OT33DON_OT33ID   
     where actual.OT33DON_OT33ID = @p_OT33ID and calculated.OT33DON_ROWID is null  
       
    declare   
     @c_LP bigint  
     , @c_ROWID int  
     , @c_ZMT_ROWID int  
     , @c_OT33ID int  
     --, @c_ANLN1 nvarchar(30)  
     --, @c_ANLN1_POSKI nvarchar(30)  
     , @c_ANLN2 nvarchar(10)  
     , @c_TXT50 nvarchar(50)  
     , @c_WARST decimal (13,2)  
     , @c_NDJARPER int  
     , @c_MTOPER nvarchar(1)  
     , @c_ANLN1_DO nvarchar(12)  
     , @c_ANLN2_DO nvarchar(4)  
     , @c_ANLKL_DO nvarchar(8)  
     , @c_KOSTL_DO nvarchar(10)  
     , @c_UZYTK_DO nvarchar(8)  
     , @c_PRAC_DO int  
     , @c_PRCNT_DO int  
     , @c_WARST_DO decimal (13,2)  
     , @c_TXT50_DO nvarchar(50)  
     , @c_NDPER_DO int  
     , @c_CHAR_DO nvarchar(50)  
     , @c_BELNR nvarchar(10)  
     , @c_ANLN1_DO_POSKI nvarchar(30)   
     , @c_ANLKL_DO_POSKI nvarchar(30)  
     , @c_KOSTL_DO_POSKI nvarchar(30)   
     , @c_UZYTK_DO_POSKI nvarchar(30)  
     , @c_OT_ROWID int  
     , @c_OT_ORG nvarchar(30)  
     , @c_OT_CODE nvarchar(50)  
     , @v_OTD_COUNT int  
  
    declare OT33_LINES cursor for   
    select  
     OT33DON_ROWID, OT33DON_ZMT_ROWID, OT33DON_OT33ID,  
     OT33DON_ANLN2, OT33DON_TXT50, OT33DON_WARST, OT33DON_NDJARPER, OT33DON_MTOPER,   
     OT33DON_ANLN1_DO, OT33DON_ANLN2_DO, OT33DON_ANLKL_DO, OT33DON_KOSTL_DO, OT33DON_UZYTK_DO,   
     OT33DON_PRAC_DO, OT33DON_PRCNT_DO, OT33DON_WARST_DO, OT33DON_TXT50_DO, OT33DON_NDPER_DO, OT33DON_CHAR_DO, OT33DON_BELNR,   
     OT33DON_ANLN1_DO_POSKI, OT33DON_ANLKL_DO_POSKI, OT33DON_KOSTL_DO_POSKI, OT33DON_UZYTK_DO_POSKI, OT_ROWID, OT_ORG, OT_CODE     
    from dbo.ZWFOT33DONv    
    where   
     OT33DON_OT33ID = @p_OT33ID  
      
    open OT33_LINES  
      
    fetch next from OT33_LINES  
    into @c_ROWID, @c_ZMT_ROWID,  @c_OT33ID,   
     @c_ANLN2, @c_TXT50, @c_WARST, @c_NDJARPER, @c_MTOPER,   
     @c_ANLN1_DO, @c_ANLN2_DO, @c_ANLKL_DO, @c_KOSTL_DO, @c_UZYTK_DO,   
     @c_PRAC_DO, @c_PRCNT_DO, @c_WARST_DO, @c_TXT50_DO, @c_NDPER_DO, @c_CHAR_DO, @c_BELNR,   
     @c_ANLN1_DO_POSKI, @c_ANLKL_DO_POSKI, @c_KOSTL_DO_POSKI, @c_UZYTK_DO_POSKI, @c_OT_ROWID, @c_OT_ORG, @c_OT_CODE  
       
    while @@FETCH_STATUS = 0  
    begin  
     if not exists (select * from dbo.SAPO_ZWFOT33DON (nolock) where OT33DON_ANLN2 = @c_ANLN2 and OT33DON_OT33ID = @p_OT33ID)  
     begin  
  
      select @v_OTD_COUNT = COUNT(*) from ZWFOTDON where OTD_OTID = @c_OT_ROWID    
  
      insert into dbo.ZWFOTDON   
      (  
       OTD_OTID, OTD_STATUS, OTD_RSTATUS, OTD_ID, OTD_ORG, OTD_CODE, OTD_TYPE, OTD_CREDATE, OTD_CREUSER, OTD_OBJID  
      )  
      select distinct  
       @c_OT_ROWID, NULL, 0, newid(), @c_OT_ORG, cast(@c_OT_CODE as nvarchar)+ '/' + cast(isnull(@v_OTD_COUNT, 0)+1 as nvarchar), NULL, getdate(), 'SA', NULL  
      from ZWFOT (nolock) where OT_ROWID = @c_OT_ROWID  
        
      declare @v_OTDID int  
      select @v_OTDID = IDENT_CURRENT('ZWFOTDON')  
  
  
      insert into dbo.SAPO_ZWFOT33DON(  
       OT33DON_ANLN2, OT33DON_TXT50, OT33DON_WARST, OT33DON_NDJARPER, OT33DON_MTOPER,   
       OT33DON_ANLN1_DO, OT33DON_ANLN2_DO, OT33DON_ANLKL_DO, OT33DON_KOSTL_DO, OT33DON_UZYTK_DO,   
       OT33DON_PRAC_DO, OT33DON_PRCNT_DO, OT33DON_WARST_DO, OT33DON_TXT50_DO, OT33DON_NDPER_DO, OT33DON_CHAR_DO,   
       OT33DON_BELNR, OT33DON_ZMT_ROWID, OT33DON_OT33ID,   
       OT33DON_ANLN1_DO_POSKI, OT33DON_ANLKL_DO_POSKI, OT33DON_KOSTL_DO_POSKI, OT33DON_UZYTK_DO_POSKI)  
      select   
       @c_ANLN2, @c_TXT50, @c_WARST, @c_NDJARPER, @c_MTOPER,   
       @c_ANLN1_DO, @c_ANLN2_DO, @c_ANLKL_DO, @c_KOSTL_DO, @c_UZYTK_DO,   
       @c_PRAC_DO, @c_PRCNT_DO, @c_WARST_DO, @c_TXT50_DO, @c_NDPER_DO, @c_CHAR_DO,   
       @c_BELNR, @v_OTDID, @c_OT33ID,   
       @c_ANLN1_DO_POSKI, @c_ANLKL_DO_POSKI, @c_KOSTL_DO_POSKI, @c_UZYTK_DO_POSKI  
     end  
     else  
     begin  

	 	 -- Jeżeli dokument miał więcej niż jedną linię ustawiamy wartość przeniesienis jko sumę wszytskich przenoszonych składników
	
      update dbo.SAPO_ZWFOT33DON set   
       OT33DON_ANLN2 = @c_ANLN2, OT33DON_TXT50 = @c_TXT50, OT33DON_WARST = @c_WARST, OT33DON_NDJARPER = @c_NDJARPER, OT33DON_MTOPER = @c_MTOPER,   
       OT33DON_ANLN1_DO = @c_ANLN1_DO, OT33DON_ANLN2_DO = @c_ANLN2_DO, OT33DON_ANLKL_DO = @c_ANLKL_DO, OT33DON_KOSTL_DO = @c_KOSTL_DO, OT33DON_UZYTK_DO = @c_UZYTK_DO,   
       OT33DON_PRAC_DO = @c_PRAC_DO, OT33DON_PRCNT_DO = @c_PRCNT_DO, OT33DON_WARST_DO = @c_WARST_DO, OT33DON_TXT50_DO = @c_TXT50_DO, OT33DON_NDPER_DO = @c_NDPER_DO, OT33DON_CHAR_DO = @c_CHAR_DO,   
       OT33DON_BELNR = @c_BELNR, OT33DON_ZMT_ROWID = @c_ZMT_ROWID, OT33DON_OT33ID = @c_OT33ID,   
       OT33DON_ANLN1_DO_POSKI = @c_ANLN1_DO_POSKI, OT33DON_ANLKL_DO_POSKI = @c_ANLKL_DO_POSKI, OT33DON_KOSTL_DO_POSKI = @c_KOSTL_DO_POSKI, OT33DON_UZYTK_DO_POSKI = @c_UZYTK_DO_POSKI  
      where OT33DON_ANLN2 = @c_ANLN2  and OT33DON_OT33ID = @p_OT33ID  
     end  
       
     fetch next from OT33_LINES  
     into @c_ROWID, @c_ZMT_ROWID,  @c_OT33ID,   
      @c_ANLN2, @c_TXT50, @c_WARST, @c_NDJARPER, @c_MTOPER,   
      @c_ANLN1_DO, @c_ANLN2_DO, @c_ANLKL_DO, @c_KOSTL_DO, @c_UZYTK_DO,   
      @c_PRAC_DO, @c_PRCNT_DO, @c_WARST_DO, @c_TXT50_DO, @c_NDPER_DO, @c_CHAR_DO, @c_BELNR,   
      @c_ANLN1_DO_POSKI, @c_ANLKL_DO_POSKI, @c_KOSTL_DO_POSKI, @c_UZYTK_DO_POSKI, @c_OT_ROWID, @c_OT_ORG, @c_OT_CODE  
    end  


          
    close OT33_LINES  
    deallocate OT33_LINES 
	 
	 	 -- Jeżeli dokument miał więcej niż jedną linię ustawiamy wartość przeniesienis jko sumę wszytskich przenoszonych składników
			declare @wartosc_all decimal(13,2)

			select @wartosc_all =  sum(obj_value) 
			from ZWFOTOBJ join OBJ on OBJ_ROWID = OTO_OBJID 
			join ZWFOTLN on OTL_OTID = OTO_OTID 
			join SAPO_ZWFOT33LN on OT33LN_ZMT_ROWID = OTL_ROWID 
			where OT33LN_OT33ID = @p_OT33ID  
			
			Print  @wartosc_all


		  update SAPO_ZWFOT33DON
		  set OT33DON_WARST_DO = @wartosc_all
		  where OT33DON_OT33ID = @p_OT33ID
		  and OT33DON_MTOPER ='x'


   end  
end      
  
GO
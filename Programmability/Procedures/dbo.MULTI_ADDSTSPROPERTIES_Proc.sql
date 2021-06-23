SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MULTI_ADDSTSPROPERTIES_Proc]  
	@p_USERID nvarchar(50),  
	@p_STSID int,  
	@p_ROWIDS nvarchar(max)  
as  
BEGIN  

	declare @c_PROID nvarchar(50)

	declare c_STS cursor for select String from dbo.VS_Split2(@p_ROWIDS,';') where String <> ''    
	
	open c_STS    
	fetch next from c_STS into @c_PROID    

	while @@FETCH_STATUS = 0    
	BEGIN  
	
		if not exists  (select ASP_ROWID from ADDSTSPROPERTIES (nolock) where ASP_STSID = @p_STSID and ASP_PROID = @c_PROID)
		begin
			insert into ADDSTSPROPERTIES (ASP_PROID, ASP_ENT, ASP_STSID, ASP_UOMID, ASP_LIST, ASP_REQUIRED)
			--select ASP_PROID, ASP_ENT, ASP_STSID, ASP_LINE, ASP_UOMID, ASP_LIST, ASP_REQUIRED from ADDSTSPROPERTIES (nolock)
			select @c_PROID, 'OBJ', @p_STSID, NULL, NULL, 'NIE'
		end

		fetch next from c_STS into @c_PROID 
		
	END  

	close c_STS
	deallocate c_STS
	
END 
GO
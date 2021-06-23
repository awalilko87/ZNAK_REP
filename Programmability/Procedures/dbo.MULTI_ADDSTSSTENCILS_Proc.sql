SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MULTI_ADDSTSSTENCILS_Proc]  
	@p_USERID nvarchar(50),  
	@p_STSID int,
	@p_ROWIDS nvarchar(max)  
as  
BEGIN  

	declare @c_CHILDID int

	declare c_CHILDS cursor for select String from dbo.VS_Split2(@p_ROWIDS,';') where String <> ''    
	
	open c_CHILDS    
	fetch next from c_CHILDS into @c_CHILDID    

	while @@FETCH_STATUS = 0    
	BEGIN  
	
		if not exists  (select STL_ROWID from STENCILLN (nolock) where STL_PARENTID = @p_STSID and STL_CHILDID = @c_CHILDID)
		begin
			insert into STENCILLN (STL_PARENTID, STL_CHILDID, STL_ORG, STL_REQUIRED, STL_ONE)
			--select STL_PARENTID, STL_CHILDID, STL_ORG, STL_REQUIRED, STL_ONE from STENCILLN (nolock)
			select STS_ROWID, @c_CHILDID, STS_ORG, 'NIE', 'NIE'
			from 
				STENCIL (nolock) 
			where 
				STS_ROWID = @p_STSID
			
		end

		fetch next from c_CHILDS into @c_CHILDID 
		
	END  

	close  c_CHILDS
	deallocate c_CHILDS
END  
GO
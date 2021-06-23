SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[STS_STRUCTURE_DISACTIVE]
(
@STS_ROWID int,
@p_UserID nvarchar(30)
)
as 

begin 
	if exists (select 1 from STENCIL where STS_ROWID = @STS_ROWID and STS_NOTUSED = 0)
	begin 
		/*dezaktywujemy szablon*/
		update dbo.STENCIL
		set STS_NOTUSED = 1
			,STS_STATUS = 'STS_002'
			,STS_UPDUSER = @p_UserID
			,STS_UPDDATE = getdate()
		where STS_ROWID = @STS_ROWID
			
		/*sprawdzamy, czy istnieją podskładniki dla tego szablonu*/
			
		if exists (select 1 from dbo.STENCILLN join dbo.STENCIL on STL_CHILDID = STS_ROWID where STL_PARENTID = @STS_ROWID)
		begin 
			/*I te również deazktywujemy*/	
			update dbo.STENCIL set 
			STS_NOTUSED = 1
			,STS_STATUS = 'STS_002'
			,STS_UPDUSER = @p_UserID
			,STS_UPDDATE = getdate()
			where STS_ROWID in (select STL_CHILDID from dbo.STENCILLN where STL_PARENTID = @STS_ROWID)
		end	
	end
end 
GO
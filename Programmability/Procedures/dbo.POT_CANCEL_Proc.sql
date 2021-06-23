SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POT_CANCEL_Proc](
@p_POTID int,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	
	declare @c_POLID int
	declare @c_OBJID int
	declare @c_STATUS nvarchar(30)
	
	declare C_POL cursor for select POL_ROWID, POL_OBJID, POL_STATUS from dbo.OBJTECHPROTLN where POL_POTID = @p_POTID and POL_STATUS in ('POL_002', 'POL_003', 'POL_005')
	open C_POL
	fetch next from C_POL into @c_POLID, @c_OBJID, @c_STATUS
	while @@fetch_status = 0
	begin
		begin try
			update dbo.OBJ set
				 OBJ_STATUS = 'OBJ_002' 
				,OBJ_UPDDATE = getdate()
				,OBJ_UPDUSER = @p_UserID
				,OBJ_TXT09 = null
			where OBJ_ROWID = @c_OBJID
			
			update dbo.OBJTECHPROTLN set
				POL_STATUS = 'POL_004'
			from dbo.OBJTECHPROT
			where POT_ROWID = POL_POTID and POT_STATUS in ('POT_001', 'POT_002')
			and POL_STATUS in (@c_STATUS, 'POL_007')
			and POL_OBJID = @c_OBJID
		end try
		begin catch
			deallocate C_POL
			set @v_errortext = 'Błąd anulowania pozycji ['+error_message()+']'
			raiserror(@v_errortext, 16, 1)
			return 1
		end catch
		
		fetch next from C_POL into @c_POLID, @c_OBJID, @c_STATUS
	end
	deallocate C_POL
	
	return 0
end
GO
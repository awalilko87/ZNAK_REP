SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[INVTSK_ADD_OBJ_XLS_Import_Save](@rowid int, @PSP nvarchar(30), @p_UserID nvarchar(30))
as 

begin 
	If exists (select 1 from  dbo.INVTSK_ADD_OBJ_XLS where rowid = @rowid  and importuser = @p_UserID)
		begin

		declare  
		 @c_ROWID int


	  declare c_XLS cursor for  
		select rowid from dbo.INVTSK_ADD_OBJ_XLS where importuser = @p_UserID order by rowid  
		open c_XLS  
		 fetch next from c_XLS into @c_ROWID 
		
		 while @@FETCH_STATUS = 0 
			 begin 
				update INVTSK_ADD_OBJ_XLS
				set c06 = @PSP
				where rowid = @rowid
				fetch next from c_XLS into @c_ROWID	

			 end 

		deallocate c_XLS	
		end


end

GO
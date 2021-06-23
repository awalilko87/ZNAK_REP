SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[MODERN_PROFILE_LN_InsUpd]
(
 @MDL_ROWID int
,@MDL_MDPID int
,@MDL_KSTCODE nvarchar(30) 
,@_USERID nvarchar(30)
)as
begin 

	if not exists (select 1 from MODERN_PROFILE_LN where MDL_ROWID = @MDL_ROWID)

		begin 
			insert into MODERN_PROFILE_LN (MDL_MDPID, MDL_KSTCODE, MDL_CREDATE, MDL_CREUSER)
			values (@MDL_MDPID, @MDL_KSTCODE,getdate(),@_UserID)
		end

	else 

		begin 
			update MODERN_PROFILE_LN
			set MDL_MDPID = @MDL_MDPID
				,MDL_KSTCODE = @MDL_KSTCODE
				,MDL_UPDDATE = getdate()
				,MDL_UPDUSER = @_USERID
			where MDL_ROWID = @MDL_ROWID
		end
end
GO
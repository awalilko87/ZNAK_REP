SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[MODERN_PROFILE_InsUpd]
(
 @MDP_ROWID int 
,@MDP_CODE nvarchar(30)
,@MDP_DESC nvarchar(80)
,@MDP_CREDATE datetime
,@MDP_CREUSER nvarchar(30)
,@MDP_UPDDATE datetime
,@MDP_UPDUSER nvarchar(30)
,@_USERID nvarchar(30)
)as
begin

if not exists (select 1 from MODERN_PROFILE where MDP_ROWID = @MDP_ROWID)

	begin

		insert into MODERN_PROFILE(MDP_CODE,MDP_DESC ,MDP_CREDATE,MDP_CREUSER)
		values (@MDP_CODE,@MDP_DESC ,@MDP_CREDATE,@MDP_CREUSER)
	end

else 
	begin 

	update MODERN_PROFILE
	set MDP_CODE = @MDP_CODE
	,MDP_DESC = @MDP_DESC
	,MDP_UPDDATE = GETDATE()
	,MDP_UPDUSER = @_USERID
	where MDP_ROWID = @MDP_ROWID

	end

end
GO
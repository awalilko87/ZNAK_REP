SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[PZOLN_LSRC_Update_Tran]
(
@p_FormID nvarchar(50),
@p_ROWID int,
@p_STATUS nvarchar(30),
@p_DATE datetime,
@p_DTX01 datetime,
@p_COM01 nvarchar(max),
@p_COM02 nvarchar(max),
@p_COM03 nvarchar(max),
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errorid int
	declare @v_errortext nvarchar(4000) 
	select @v_errorid = 0
	select @v_errortext = null

	begin transaction
	
	exec @v_errorid = [dbo].[PZOLN_LSRC_Update_Proc] 
		@p_FormID 
		, @p_ROWID 
		, @p_STATUS
		, @p_DATE
		, @p_DTX01
		, @p_COM01
		, @p_COM02
		, @p_COM03
 		, @p_UserID

	if @v_errorid = 0
	begin
		commit transaction
		return 0
	end
	else
	begin
		rollback transaction
		return 1
	end
end

GO
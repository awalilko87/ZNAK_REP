SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


 
CREATE PROCEDURE [dbo].[COSTCENTER_LSRC_Delete_Proc](
    @CCT_ROWID int = NULL,
    @p_UserID varchar(30),
    @p_apperrortext nvarchar(4000) output
    )
as
begin

	declare @v_errorcode nvarchar(50)
	, @v_syserrorcode nvarchar(4000)
	, @v_errortext nvarchar(4000)
	, @v_date datetime

	set @v_date = getdate()
	 
	if @CCT_ROWID is null  -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
	
	begin try
	
	 	delete from dbo.COSTCENTER where CCT_ROWID = @CCT_ROWID
	
	end try
	begin catch
		select @v_errorcode = 'SYS_004'
		goto errorlabel
	end catch
	return 0
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
	end


GO
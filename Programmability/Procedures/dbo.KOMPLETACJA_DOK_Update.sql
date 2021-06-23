SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[KOMPLETACJA_DOK_Update](
@p_FILE1 nvarchar(50),
@p_DESC1 nvarchar(250),
@p_FILE2 nvarchar(50),
@p_DESC2 nvarchar(250),
@p_FILE3 nvarchar(50),
@p_DESC3 nvarchar(250),
@p_UserID nvarchar(50)
)
as
begin
	declare @v_errortext nvarchar(1000)

	begin try
		begin tran

		delete from dbo.SYFiles where TableName = 'KOMPLETACJA' and FileID2 not in (@p_FILE1, @p_FILE2, @p_FILE3)

		update dbo.SYFiles set
			TableName = 'KOMPLETACJA'
			,ID = 'KOMP1'
		where FileID2 = @p_FILE1
		update dbo.SYFiles set
			TableName = 'KOMPLETACJA'
			,ID = 'KOMP2'
		where FileID2 = @p_FILE2
		update dbo.SYFiles set
			TableName = 'KOMPLETACJA'
			,ID = 'KOMP3'
		where FileID2 = @p_FILE3

		commit tran
	end try
	begin catch
		rollback tran
		set @v_errortext = error_message()
		goto errorlabel
	end catch

	return 0

errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO
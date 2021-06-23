SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_ErrorSend_Proc](
@p_OT nvarchar(4),
@p_SAPO_OTID int
)
as
begin
	declare @v_errortext nvarchar(1000)
	declare @v_SQL nvarchar(max) = ''
	declare @v_SQLparam nvarchar(max) = ''
	declare @v_OT_ID nvarchar(50)
	declare @v_OT nvarchar(30)
	declare @v_NROFTRIES tinyint
	declare @v_MAXNROFTRIES tinyint

	select @v_MAXNROFTRIES = dbo.VS_Setting('INT_SAP_MAXNROFTRIES', 0)

	set @v_SQL = 'select @v_OT_ID = OT_ID, @v_OT = OT_CODE, @v_NROFTRIES = isnull('+@p_OT+'_IF_NROFTRIES,0)
					from dbo.ZWFOT 
					inner join dbo.SAPO_ZWF'+@p_OT+' on '+@p_OT+'_ZMT_ROWID = OT_ROWID 
					where '+@p_OT+'_ROWID = @SAPO_OTID'
	set @v_SQLparam = '@v_OT_ID nvarchar(50) output, @SAPO_OTID int, @v_NROFTRIES tinyint output, @v_OT nvarchar(30) output'
	print @v_SQL
	exec sp_executesql @v_SQL, @v_SQLparam, @SAPO_OTID = @p_SAPO_OTID, @v_OT_ID = @v_OT_ID output, @v_NROFTRIES = @v_NROFTRIES output, @v_OT = @v_OT output
	print @v_NROFTRIES

	set @v_NROFTRIES = @v_NROFTRIES + 1

	if @v_NROFTRIES > @v_MAXNROFTRIES
	begin
		exec dbo.COMMENTS_Update @v_OT_ID, 'OT', 'Błąd wysyłki do SAP. Skontaktuj się z administratorem systemu.', 'SA'

		set @v_SQL = 'update dbo.SAPO_ZWF'+@p_OT+' set
						'+@p_OT+'_IF_STATUS = 9
					where '+@p_OT+'_ROWID = @SAPO_OTID'
		set @v_SQLparam = '@SAPO_OTID int'

		exec sp_executesql @v_SQL, @v_SQLparam, @SAPO_OTID = @p_SAPO_OTID

		insert into dbo.MAILBOX(MAIB_RECEIVER, MAIB_USER, MAIB_ORG, MAIB_SUBJECT, MAIB_BODY, MAIB_ISSEND, MAIB_NROFRETRY, MAIB_MAISID)
		select 'Tomasz.Chrapkowski@orlen.pl', 'TOMASZ.CHRAPKOWSKI', 'PKN', 'Błąd wysyłki dokumentu '+@p_OT+' do SAP', 'Nr dokumentu: <b>'+@v_OT+'</b><br><br>Wysyłka do SAP została zatrzymana.<br>Dokument otrzymał status Odrzucony Workflow.', 0, 0, 1

		return 1
	end
	
	set @v_SQL = 'update dbo.SAPO_ZWF'+@p_OT+' set
					'+@p_OT+'_IF_NROFTRIES = isnull('+@p_OT+'_IF_NROFTRIES,0) + 1
				where '+@p_OT+'_ROWID = @SAPO_OTID'
	set @v_SQLparam = '@SAPO_OTID int, @v_NROFTRIES tinyint output'

	exec sp_executesql @v_SQL, @v_SQLparam, @SAPO_OTID = @p_SAPO_OTID, @v_NROFTRIES = @v_NROFTRIES output


	
end
GO
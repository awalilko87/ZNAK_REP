SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[MAILSEND_Proc]
as
begin 
 declare @c_mailid int,
	@c_receiver nvarchar(200),
	@c_subject nvarchar(1000),
	@c_body nvarchar(2500),
	@c_nrofretry int,
	@c_profile nvarchar(200),
	@c_blindreceiver nvarchar(1000),
	@v_errortext nvarchar(1000)
	 
	declare mail_queue cursor for
		select 
			mailbox.ROWID, 
			MAIB_RECEIVER, 
			isnull(MAIP_SUBJECTBEGIN,'') + ' ' + MAIB_SUBJECT + ' ' + isnull(MAIP_SUBJECTEND,''), 
			isnull(MAIP_BODYBEGIN,'') + ' ' + MAIB_BODY + ' ' + isnull(MAIP_BODYEND,''), 
			MAIB_NROFRETRY,
			MAIP_NAME, 
			MAIP_BLINDCOPYRECIPIENTS			
		from dbo.mailbox 
			join dbo.mailsettings on MAIB_MAISID = mailsettings.ROWID
			join dbo.mailprofiles on MAIS_MAIPID = mailprofiles.ROWID
		where isnull(MAIB_ISSEND,0) = 0 and MAIB_NROFRETRY < 4
	open mail_queue

	fetch next from mail_queue
	into @c_mailid, @c_receiver, @c_subject, @c_body, @c_nrofretry, @c_profile, @c_blindreceiver
	
	while @@fetch_status = 0
	begin
		--EXEC msdb..sp_send_dbmail @profile_name='Profil mailowy',
		--@recipients='dstarzynski@eurotronic.net.pl; dstarzynski@eurotronic.net.pl',
		--@subject='Test message',
		--@blind_copy_recipients='dstarzynski@eurotronic.net.pl',
		----@from_address='k@lasznikow.pl',
		--@body='This is the body of the test message.
		--Congrates Database Mail Received By you Successfully.' 
		
		begin try

			EXEC msdb..sp_send_dbmail 
				@profile_name=@c_profile,
				@recipients=@c_receiver,
				@subject=@c_subject,
				@blind_copy_recipients=@c_blindreceiver, 
				@body=@c_body,
				@body_format = 'HTML' 
				  
		/*	exec [msdb].[dbo].[spSendMail] 
			   @c_receiver
			  ,@c_subject
			  ,'bgptest@copie.kghm.pl'
			  ,@c_body
			  ,'192.168.1.52'
			  ,'bgptest@copie.kghm.pl'
			  ,'testsql1'
		*/  
			UPDATE MAILBOX SET 
				 MAIB_ISSEND = 1
				,MAIB_SENDTIME = getdate()
				,MAIB_NROFRETRY = @c_nrofretry+1 
			where ROWID = @c_mailid
		end try
		begin catch
			select @v_errortext = ERROR_MESSAGE()
			update MAILBOX SET 
				 MAIB_NROFRETRY = @c_nrofretry+1
				 ,MAIB_QUERY = @v_errortext
			where ROWID = @c_mailid
		end catch
				 
		fetch next from mail_queue
		into @c_mailid, @c_receiver, @c_subject, @c_body, @c_nrofretry, @c_profile, @c_blindreceiver
	end
	
	close mail_queue
	deallocate mail_queue
end
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create proc [dbo].[SP_REQUEST_MAILSENT_PROC]
as
begin

INSERT INTO [dbo].[MAILBOX]  
           ([MAIB_RECEIVER]  
           ,[MAIB_USER]  
           ,[MAIB_ORG]  
           ,[MAIB_SUBJECT]  
           ,[MAIB_BODY]  
           ,[MAIB_ENT]  
           ,[MAIB_TYPE]  
           ,[MAIB_STATUS]  
           ,[MAIB_ISSEND]  
           ,[MAIB_SENDTIME]  
           ,[MAIB_CREATED]  
           ,[MAIB_NROFRETRY]  
           ,[MAIB_NRDOC]  
           ,[MAIB_MAISID]  
           ,[MAIB_QUERY]  
           ,[MAIB_MGTYPE]  
           ,[MAIB_DW]  
           ,[MAIB_REPORTNAME]  
           ,[MAIB_REPORTPARAMS]  
           ,[MAIB_ATTACHNAME]  
           ,[MAIB_ATTACH]  
           ,[MAIB_STATUS_IM]) 
           
    select EMAIL
			,STH_USER
			,'PKN'
			, 'Urządzenie: ' + OBJ_CODE +' - '+ OBJ_DESC  
			,'<pre>Urządzenie ' + OBJ_CODE +' - '+ OBJ_DESC  +' przebywa w serwisie ' + STN_DESC + ' 7 dni </a>  
		  
		  
		_______________________________________________  
		Wiadomość została wygenerowana automatycznie.  
		Prosimy na nią nie odpowiadać.  
		</pre>' 
		
			,'POT'
			,'OCENA'
			,NULL
			,0
			,NULL
			,GETDATE()
			,0
			, NULL  
		    , (select top 1 MAILSETTINGS.ROWID  
			from MAILSETTINGS  
			join MAILPROFILES on MAIS_MAIPID = MAILPROFILES.ROWID)  
		   , null  
		   , 'NIE'  
		   , null  
		   , null  
		   , null  
		   , null  
		   , null  
		   , null
   
		    from SP_REQUEST_MAIL_RECIPIENTS       

end



GO
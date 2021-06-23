SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




-------------------------------------------------------------------------------------------------------------------------------------
--Procedura sprawdzająca co po 3 dniach.

CREATE procedure [dbo].[STAMAIL_P3D_Proc] 
AS
BEGIN

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
           ,[MAIB_STATUS_IM]
) 
SELECT DISTINCT
			STM_EMAIL
			, STM_USERID
			, POT_ORG
			, 'Protokół: ' + POT_CODE
			,'<pre>W systemie ZMT <b>' + STM_ENTDESC + '</b>
nr: <b>' + POT_CODE + '</b> od ponad 3 dni przebywa na statusie: "' + STM_STADESC + '". 

'--<a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'Tabs3.aspx/?MID=ZMT_MOVE_' + left(STM_STATUS, 3) + '&TGR=PZO&TAB=' + left(STM_STATUS, 3) + '_RC&FID=' + left(STM_STATUS, 3) + '_RC&POTID=' + (select top 1 cast(POT_ROWID as nvarchar)))) + '">LINK</a>
+ '<a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'Tabs3.aspx/?MID=ZMT_MOVE_' + left(STM_STATUS, 3) + '&TGR=PZO&TAB=' + left(STM_STATUS, 3) + '_RC&FID=' + left(STM_STATUS, 3) + '_RC' + '&QSC=R09UT1RBQiAyOw==&DW=' + 'POT_ROWID=' + convert(varchar,POT_ROWID))) + '">LINK</a>


_______________________________________________
Wiadomość została wygenerowana automatycznie.
Prosimy na nią nie odpowiadać.
</pre>'
			, STM_ENTITY
			, POT_TYPE
			, POT_STATUS
			, 0
			, null
			, getdate()
			, 0
			, POT_CODE
			, (select top 1 MAILSETTINGS.ROWID
				from MAILSETTINGS
				join MAILPROFILES on MAIS_MAIPID = MAILPROFILES.ROWID
			)
			, null
			, 'NIE'
			, null
			, null
			, null
			, null
			, null
			, null

           from STAMAILv s
		   join OBJTECHPROT o on POT_STATUS = STM_STATUS
		   where isnull(STM_EMAIL, '') <> ''
		   and isnull(STM_P3D, 0) <> 0
		   and datediff(dd, POT_UPDDATE, getdate()) >=3
	
	

/*
     VALUES
           (<MAIB_RECEIVER, nvarchar(4000),>
           ,<MAIB_USER, nvarchar(4000),>
           ,<MAIB_ORG, nvarchar(50),>
           ,<MAIB_SUBJECT, nvarchar(500),>
           ,<MAIB_BODY, nvarchar(4000),>
           ,<MAIB_ENT, nvarchar(4),>
           ,<MAIB_TYPE, nvarchar(30),>
           ,<MAIB_STATUS, nvarchar(30),>
           ,<MAIB_ISSEND, int,>
           ,<MAIB_SENDTIME, datetime,>
           ,<MAIB_CREATED, datetime,>
           ,<MAIB_NROFRETRY, int,>
           ,<MAIB_NRDOC, nvarchar(80),>
           ,<MAIB_MAISID, int,>
           ,<MAIB_QUERY, nvarchar(max),>
           ,<MAIB_MGTYPE, nvarchar(50),>
           ,<MAIB_DW, nvarchar(500),>
           ,<MAIB_REPORTNAME, nvarchar(200),>
           ,<MAIB_REPORTPARAMS, nvarchar(200),>
           ,<MAIB_ATTACHNAME, nvarchar(200),>
           ,<MAIB_ATTACH, image,>
           ,<MAIB_STATUS_IM, nvarchar(20),>)

		   */
end
GO
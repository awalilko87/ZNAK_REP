CREATE TABLE [dbo].[STAHIST] (
  [ROWID] [int] IDENTITY,
  [STH_ENTITY] [nvarchar](30) NOT NULL,
  [STH_ID] [nvarchar](50) NOT NULL,
  [STH_DATE] [datetime] NOT NULL,
  [STH_USER] [nvarchar](30) NULL,
  [STH_OLD] [nvarchar](30) NULL,
  [STH_NEW] [nvarchar](30) NULL,
  CONSTRAINT [PK_STAHIST] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[STAHIST_mail] 
ON [dbo].[STAHIST]
AFTER
INSERT, UPDATE 
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
           ,[MAIB_STATUS_IM]) 
SELECT DISTINCT
			STM_EMAIL
			, STM_USERID
			, POT_ORG
			, 'Protokół: ' + POT_CODE
			,'<pre>W systemie ZMT <b>' + STM_ENTDESC + '</b>
nr: <b>' + POT_CODE + '</b> zmienił status na "' + STM_STADESC + '". 

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

           from inserted i
		   join STAMAILv s on STM_STATUS = STH_NEW and STH_ENTITY = STM_ENTITY
		   join OBJTECHPROT o on POT_ID = STH_ID
		   where STH_NEW <> STH_OLD
		   and isnull(STM_EMAIL, '') is not null
		   and isnull(STM_CHNG, 0) <> 0

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

EXEC sys.sp_addextendedproperty N'MS_Description', N'Encja', 'SCHEMA', N'dbo', 'TABLE', N'STAHIST', 'COLUMN', N'STH_ENTITY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'STAHIST', 'COLUMN', N'STH_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'STAHIST', 'COLUMN', N'STH_DATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Użytkownik', 'SCHEMA', N'dbo', 'TABLE', N'STAHIST', 'COLUMN', N'STH_USER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Stary status', 'SCHEMA', N'dbo', 'TABLE', N'STAHIST', 'COLUMN', N'STH_OLD'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nowy status', 'SCHEMA', N'dbo', 'TABLE', N'STAHIST', 'COLUMN', N'STH_NEW'
GO
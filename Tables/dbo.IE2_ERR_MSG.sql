CREATE TABLE [dbo].[IE2_ERR_MSG] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [OT_ROWID] [int] NOT NULL,
  [OT_TYPE] [nvarchar](5) NOT NULL,
  [TYPE] [nvarchar](30) NULL,
  [ID] [nvarchar](30) NULL,
  [NUMBER] [nvarchar](30) NULL,
  [MESSAGE] [nvarchar](max) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL DEFAULT (1),
  CONSTRAINT [PK_IE2_ERR_MSG] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPI_ErrorMessages_Insert]
on [dbo].[IE2_ERR_MSG]
after insert, update
as 
begin
 
	if CONTEXT_INFO() = cast('SAPI_ErrorMessages_Insert_Proc' as varbinary(128))
		return
		
	declare 
		  @c_ERRID int
		, @c_DateTime datetime
		, @c_OT_ROWID int
		, @c_OT_TYPE nvarchar(30)
		, @c_TYPE nvarchar(30)
		, @c_ID nvarchar(30)
		, @c_NUMBER nvarchar(30)
		, @c_MESSAGE  nvarchar(max)

	declare c_ErrorMessageInserted cursor for
	select ROWID, i_DateTime, OT_ROWID, OT_TYPE, TYPE, ID, NUMBER, MESSAGE from inserted order by OT_ROWID asc;
	--select ROWID, i_DateTime, OT_ROWID, OT_TYPE, TYPE, ID, NUMBER, MESSAGE from [IE2_ERR_MSG]

	open c_ErrorMessageInserted

	fetch next from c_ErrorMessageInserted
	into @c_ERRID, @c_DateTime, @c_OT_ROWID, @c_OT_TYPE, @c_TYPE, @c_ID, @c_NUMBER, @c_MESSAGE
	
	while @@fetch_status = 0 
	begin 
	 
		insert into dbo.ZWFOT_SAP_MESSAGES (
			OTM_OTID, 
			OTM_OTXXID, 
			OTM_DATE, 
			OTM_OT_TYPE, 
			OTM_TYPE, 
			OTM_MESSAGE,
			OTM_ERRID,
			OTM_USERID)
		select 
			OT_ROWID, 
			@c_OT_ROWID, --Integracja z SAP podaje nam np OT11_ROWID (SAPO_ZWFOT11) a nie OT_ROWID  (ZWFOT)
			@c_DateTime, 
			@c_OT_TYPE, 
			@c_TYPE, 
			@c_MESSAGE,
			@c_ERRID,
			'SAP'
 		from ZWFOT (nolock)
			 left join SAPO_ZWFOT11 (nolock) on OT11_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT11' and OT11_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT12 (nolock) on OT12_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT12' and OT12_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT21 (nolock) on OT21_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT21' and OT21_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT31 (nolock) on OT31_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT31' and OT31_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT32 (nolock) on OT32_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT32' and OT32_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT33 (nolock) on OT33_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT33' and OT33_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT42 (nolock) on OT42_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT42' and OT42_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT40 (nolock) on OT40_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT40' and OT40_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT41 (nolock) on OT41_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT41' and OT41_ZMT_ROWID = OT_ROWID
		where coalesce(OT11_ROWID, OT12_ROWID, OT21_ROWID, OT31_ROWID, OT32_ROWID, OT33_ROWID, OT40_ROWID, OT41_ROWID, OT42_ROWID) is not null
		
		--select * from ZWFOT_SAP_MESSAGES
		
		fetch next from c_ErrorMessageInserted
		into @c_ERRID, @c_DateTime, @c_OT_ROWID, @c_OT_TYPE, @c_TYPE, @c_ID, @c_NUMBER, @c_MESSAGE
	
	end

	close c_ErrorMessageInserted
	deallocate c_ErrorMessageInserted

end 
  





GO
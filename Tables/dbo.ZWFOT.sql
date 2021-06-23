CREATE TABLE [dbo].[ZWFOT] (
  [OT_ROWID] [int] IDENTITY,
  [OT_STATUS] [nvarchar](30) NULL,
  [OT_RSTATUS] [int] NULL,
  [OT_ID] [nvarchar](50) NULL CONSTRAINT [df_OT_ID] DEFAULT (newid()),
  [OT_ORG] [nvarchar](30) NULL,
  [OT_CODE] [nvarchar](30) NULL,
  [OT_TYPE] [nvarchar](30) NULL,
  [OT_CREDATE] [datetime] NULL,
  [OT_CREUSER] [nvarchar](30) NULL,
  [OT_UPDUSER] [nvarchar](30) NULL,
  [OT_UPDDATE] [datetime] NULL,
  [OT_ITSID] [int] NULL,
  [OT_PSPID] [int] NULL,
  [OT_INOID] [int] NULL,
  [OT_SRQID] [int] NULL,
  [OT_NR_PM] [nvarchar](50) NULL,
  [OT_OBSZAR] [nvarchar](10) NULL,
  [OT_COSTCODEID] [nvarchar](10) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT] PRIMARY KEY CLUSTERED ([OT_ROWID])
)
ON [PRIMARY]
GO

CREATE INDEX [OT_INOID]
  ON [dbo].[ZWFOT] ([OT_INOID])
  ON [PRIMARY]
GO

CREATE INDEX [OT_ITSID_PSPID]
  ON [dbo].[ZWFOT] ([OT_ITSID], [OT_PSPID])
  ON [PRIMARY]
GO

CREATE INDEX [OT_TYPE]
  ON [dbo].[ZWFOT] ([OT_TYPE])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[TRG_OT_CODE] 
on [dbo].[ZWFOT]
after insert 
as 
begin

	declare @c_ROWID int
	, @c_TYPE nvarchar(30)
	, @c_ENT nvarchar(5)
	, @v_CODE nvarchar(50)

	declare OT_inserted cursor for
	select OT_ROWID, OT_TYPE, right(OT_TYPE,4) from inserted order by OT_ROWID asc;

	open OT_inserted

	fetch next from OT_inserted
	into @c_ROWID, @c_TYPE, @c_ENT

	while @@fetch_status = 0 
	begin
	 
		exec GetEntCode @c_ROWID, 'ZWFOT', 'OT', @v_CODE output
		--exec GetEntCode @c_ROWID, @c_TYPE, @c_ENT, @v_CODE output
		update [dbo].[ZWFOT] set OT_CODE = @v_CODE where OT_ROWID = @c_ROWID 
			 
		
		fetch next from OT_inserted
		into @c_ROWID, @c_TYPE, @c_ENT
	end

	close OT_inserted
	deallocate OT_inserted

end 
 
GO

ALTER TABLE [dbo].[ZWFOT]
  ADD CONSTRAINT [FK_ZWFOT_INO] FOREIGN KEY ([OT_INOID]) REFERENCES [dbo].[INVTSK_NEW_OBJ] ([INO_ROWID])
GO

ALTER TABLE [dbo].[ZWFOT]
  ADD CONSTRAINT [FK_ZWFOT_ITS] FOREIGN KEY ([OT_ITSID]) REFERENCES [dbo].[INVTSK] ([ITS_ROWID])
GO

ALTER TABLE [dbo].[ZWFOT]
  ADD CONSTRAINT [FK_ZWFOT_PSP] FOREIGN KEY ([OT_PSPID]) REFERENCES [dbo].[PSP] ([PSP_ROWID])
GO
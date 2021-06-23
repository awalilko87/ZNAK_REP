CREATE TABLE [dbo].[OBJSTATION] (
  [OSA_ROWID] [int] IDENTITY,
  [OSA_OBJID] [int] NOT NULL,
  [OSA_STNID] [int] NOT NULL,
  [OSA_KL5ID] [int] NOT NULL,
  [OSA_CREDATE] [datetime] NULL CONSTRAINT [DF_OBJSTATION_CREDATE] DEFAULT (getdate()),
  [OSA_CREUSER] [nvarchar](30) NULL,
  [OSA_UPDDATE] [datetime] NULL,
  [OSA_UPDUSER] [nvarchar](30) NULL,
  CONSTRAINT [PK_OBJSTATION] PRIMARY KEY CLUSTERED ([OSA_OBJID]),
  CONSTRAINT [UQ_OBJSTATION] UNIQUE ([OSA_ROWID])
)
ON [PRIMARY]
GO

CREATE INDEX [E2IDX_OSA01]
  ON [dbo].[OBJSTATION] ([OSA_STNID], [OSA_OBJID])
  ON [PRIMARY]
GO

CREATE INDEX [OSA_STNID]
  ON [dbo].[OBJSTATION] ([OSA_STNID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[TRG_OBJ_CODE] 
on [dbo].[OBJSTATION]
after insert 
as 
begin

	declare @c_ROWID int
	, @c_OBJID int
	, @c_STNID int
	, @v_CODE nvarchar(50)
	, @v_CCDID int
	, @v_KL5ID int
	, @v_prefix nvarchar(30)

	declare OSA_inserted cursor for
	select OSA_ROWID, OSA_OBJID, OSA_STNID from inserted order by OSA_ROWID asc;
	 
	open OSA_inserted

	fetch next from OSA_inserted
	into @c_ROWID, @c_OBJID, @c_STNID

	while @@fetch_status = 0 
	begin
		if (select OBJ_CODE from dbo.OBJ where OBJ_ROWID = @c_OBJID) not like 'ZMTSP%'
		begin
			select @v_CCDID = STN_CCDID, @v_KL5ID = STN_KL5ID from dbo.STATION (nolock) where STN_ROWID = @c_STNID
			 
			--aktualizacja numeru (na podstawie numeru przypisywanej stacji paliw). Proces ten odbywa się tylko raz (technicznie: trigger after insert) (Biznesowo: zmiana stacji nie zmienia kodu obiektu)
			select @v_prefix = 'ZMTSP'+ cast(STN_CODE as nvarchar(10)) + '_' from STATION (nolock) where STN_ROWID = @c_STNID --kod w formacie 'ZMT_SP(nr stacji paliw)_(numer kolejny)
			exec dbo.VS_GetNumber @Type = 'OBJ', @Pref = @v_prefix, @Suff = '', @Number = @v_CODE output
			 
			update [dbo].[OBJ] set 
				OBJ_CODE = @v_CODE
			where OBJ_ROWID = @c_OBJID 
		end
			  		 		
		fetch next from OSA_inserted
		into  @c_ROWID, @c_OBJID, @c_STNID
	end

	close OSA_inserted
	deallocate OSA_inserted

end
GO

ALTER TABLE [dbo].[OBJSTATION]
  ADD CONSTRAINT [FK_OBJSTATION_KL5] FOREIGN KEY ([OSA_KL5ID]) REFERENCES [dbo].[KLASYFIKATOR5] ([KL5_ROWID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[OBJSTATION]
  ADD CONSTRAINT [FK_OBJSTATION_OBJ] FOREIGN KEY ([OSA_OBJID]) REFERENCES [dbo].[OBJ] ([OBJ_ROWID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[OBJSTATION]
  ADD CONSTRAINT [FK_OBJSTATION_STN] FOREIGN KEY ([OSA_STNID]) REFERENCES [dbo].[STATION] ([STN_ROWID]) ON UPDATE CASCADE
GO
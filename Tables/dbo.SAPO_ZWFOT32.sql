CREATE TABLE [dbo].[SAPO_ZWFOT32] (
  [OT32_ROWID] [int] IDENTITY,
  [OT32_BUKRS] [nvarchar](30) NULL,
  [OT32_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT32_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT32___02DE0F30] DEFAULT (0),
  [OT32_IF_SENTDATE] [datetime] NULL,
  [OT32_IF_EQUNR] [nvarchar](30) NULL,
  [OT32_IF_YEAR] [nvarchar](4) NULL,
  [OT32_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT32_OT32_IF_NROFTRIES] DEFAULT (0),
  [OT32_ZMT_ROWID] [int] NULL,
  [OT32_KROK] [nvarchar](10) NULL,
  [OT32_SAPUSER] [nvarchar](12) NULL,
  [OT32_CCD_DEFAULT] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT32] PRIMARY KEY CLUSTERED ([OT32_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create trigger [dbo].[SAPO_ZWFOT32_Status_Update] 
on [dbo].[SAPO_ZWFOT32]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT32_ROWID int, 
		@c_OT32_IF_STATUS nvarchar(50),
		@c_OT32_IF_SENTDATE datetime,
		@c_OT32_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT32_ROWID, OT32_IF_STATUS, OT32_IF_SENTDATE, OT32_IF_EQUNR from inserted order by OT32_ROWID asc;
	--select OT32_ROWID, OT32_IF_STATUS, OT32_IF_SENTDATE, OT32_IF_EQUNR from dbo.SAPO_ZWFOT32

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT32_ROWID,	@c_OT32_IF_STATUS, @c_OT32_IF_SENTDATE, @c_OT32_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT32] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT32_ZMT_ROWID]
		where OT32_ROWID = @c_OT32_ROWID
		 
		if @c_OT32_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT32_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT32_IF_STATUS = 3 and @c_OT32_IF_SENTDATE is not null and @c_OT32_IF_EQUNR is null 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT32_30', 'SAP' --Wysłany
 
		if @c_OT32_IF_STATUS = 3 and @c_OT32_IF_SENTDATE is not null and @c_OT32_IF_EQUNR is not null
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT32_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT32%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT32_ROWID,	@c_OT32_IF_STATUS, @c_OT32_IF_SENTDATE, @c_OT32_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
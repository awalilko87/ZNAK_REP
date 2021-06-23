CREATE TABLE [dbo].[SAPO_ZWFOT41] (
  [OT41_ROWID] [int] IDENTITY,
  [OT41_KROK] [int] NULL,
  [OT41_BUKRS] [nvarchar](30) NULL,
  [OT41_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT41_SAPUSER] [nvarchar](41) NULL,
  [OT41_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT41___04C657A2] DEFAULT (0),
  [OT41_IF_SENTDATE] [datetime] NULL,
  [OT41_IF_EQUNR] [nvarchar](30) NULL,
  [OT41_IF_YEAR] [nvarchar](4) NULL,
  [OT41_IF_AKCJA] [nvarchar](20) NULL,
  [OT41_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT41_OT41_IF_NROFTRIES] DEFAULT (0),
  [OT41_IF_RESPPOZ] [tinyint] NULL,
  [OT41_ZMT_ROWID] [int] NULL,
  [OT41_NR_SZKODY] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT41] PRIMARY KEY CLUSTERED ([OT41_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT41_Status_Update] 
on [dbo].[SAPO_ZWFOT41]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT41_ROWID int, 
		@c_OT41_IF_STATUS nvarchar(50),
		@c_OT41_IF_SENTDATE datetime,
		@c_OT41_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT41_ROWID, OT41_IF_STATUS, OT41_IF_SENTDATE, OT41_IF_EQUNR from inserted order by OT41_ROWID asc;
	--select OT41_ROWID, OT41_IF_STATUS, OT41_IF_SENTDATE, OT41_IF_EQUNR from dbo.SAPO_ZWFOT41

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT41_ROWID,	@c_OT41_IF_STATUS, @c_OT41_IF_SENTDATE, @c_OT41_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT41] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT41_ZMT_ROWID]
		where OT41_ROWID = @c_OT41_ROWID
		 
		if @c_OT41_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT41_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT41_IF_STATUS = 2
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT41_30', 'SAP' --Wysłany
 
		if @c_OT41_IF_STATUS = 3
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT41_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT41%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT41_ROWID,	@c_OT41_IF_STATUS, @c_OT41_IF_SENTDATE, @c_OT41_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
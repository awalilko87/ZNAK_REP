CREATE TABLE [dbo].[SAPO_ZWFOT42] (
  [OT42_ROWID] [int] IDENTITY,
  [OT42_KROK] [int] NULL,
  [OT42_BUKRS] [nvarchar](30) NULL,
  [OT42_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT42_SAPUSER] [nvarchar](42) NULL,
  [OT42_UZASADNIENIE] [nvarchar](70) NULL,
  [OT42_KOSZT] [nvarchar](15) NULL,
  [OT42_SZAC_WART_ODZYSKU] [nvarchar](15) NULL,
  [OT42_SPOSOBLIKW] [nvarchar](35) NULL,
  [OT42_PSP] [nvarchar](24) NULL,
  [OT42_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT42___05BA7BDB] DEFAULT (0),
  [OT42_IF_SENTDATE] [datetime] NULL,
  [OT42_IF_EQUNR] [nvarchar](30) NULL,
  [OT42_IF_YEAR] [nvarchar](4) NULL,
  [OT42_IF_AKCJA] [nvarchar](20) NULL,
  [OT42_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT42_OT42_IF_NROFTRIES] DEFAULT (0),
  [OT42_IF_RESPPOZ] [tinyint] NULL,
  [OT42_ZMT_ROWID] [int] NULL,
  [OT42_ROK] [int] NULL,
  [OT42_MIESIAC] [int] NULL,
  [OT42_PSP_POSKI] [nvarchar](30) NULL,
  [OT42_CZY_UCHWALA] [nvarchar](1) NULL CONSTRAINT [DF_SAPO_ZWFOT42_OT42_CZY_UCHWALA] DEFAULT (N'select ''N'''),
  [OT42_CZY_DECYZJA] [nvarchar](1) NULL CONSTRAINT [DF_SAPO_ZWFOT42_OT42_CZY_DECYZJA] DEFAULT (N'select ''N'''),
  [OT42_CZY_ZAKRES] [nvarchar](1) NULL CONSTRAINT [DF_SAPO_ZWFOT42_OT42_CZY_ZAKRES] DEFAULT (N'select ''N'''),
  [OT42_CZY_OCENA] [nvarchar](1) NULL CONSTRAINT [DF_SAPO_ZWFOT42_OT42_CZY_OCENA] DEFAULT (N'select ''N'''),
  [OT42_CZY_EKSPERTYZY] [nvarchar](1) NULL CONSTRAINT [DF_SAPO_ZWFOT42_OT42_CZY_EKSPERTYZY] DEFAULT (N'select ''N'''),
  [OT42_UCHWALA_OPIS] [nvarchar](70) NULL,
  [OT42_DECYZJA_OPIS] [nvarchar](70) NULL,
  [OT42_ZAKRES_OPIS] [nvarchar](70) NULL,
  [OT42_OCENA_OPIS] [nvarchar](70) NULL,
  [OT42_EKSPERTYZY_OPIS] [nvarchar](70) NULL,
  [OT42_NR_SZKODY] [nvarchar](30) NULL,
  [OT42_POTID] [int] NULL,
  CONSTRAINT [PK_SAPO_ZWFOT42] PRIMARY KEY CLUSTERED ([OT42_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT42_Status_Update] 
on [dbo].[SAPO_ZWFOT42]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT42_ROWID int, 
		@c_OT42_IF_STATUS nvarchar(50),
		@c_OT42_IF_SENTDATE datetime,
		@c_OT42_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT42_ROWID, OT42_IF_STATUS, OT42_IF_SENTDATE, OT42_IF_EQUNR from inserted order by OT42_ROWID asc;
	--select OT42_ROWID, OT42_IF_STATUS, OT42_IF_SENTDATE, OT42_IF_EQUNR from dbo.SAPO_ZWFOT42

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT42_ROWID,	@c_OT42_IF_STATUS, @c_OT42_IF_SENTDATE, @c_OT42_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT42] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT42_ZMT_ROWID]
		where OT42_ROWID = @c_OT42_ROWID
		 
		if @c_OT42_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT42_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT42_IF_STATUS = 2
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT42_30', 'SAP' --Wysłany
 
		if @c_OT42_IF_STATUS = 3
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT42_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT42%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT42_ROWID,	@c_OT42_IF_STATUS, @c_OT42_IF_SENTDATE, @c_OT42_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
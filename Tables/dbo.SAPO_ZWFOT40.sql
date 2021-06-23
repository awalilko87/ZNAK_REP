CREATE TABLE [dbo].[SAPO_ZWFOT40] (
  [OT40_ROWID] [int] IDENTITY,
  [OT40_KROK] [int] NULL,
  [OT40_BUKRS] [nvarchar](30) NULL,
  [OT40_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT40_SAPUSER] [nvarchar](40) NULL,
  [OT40_PL_DOC_NUM] [nvarchar](30) NULL,
  [OT40_PL_DOC_YEAR] [int] NULL,
  [OT40_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT40___03D23369] DEFAULT (0),
  [OT40_IF_SENTDATE] [datetime] NULL,
  [OT40_IF_EQUNR] [nvarchar](30) NULL,
  [OT40_IF_YEAR] [nvarchar](4) NULL,
  [OT40_IF_AKCJA] [nvarchar](20) NULL,
  [OT40_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT40_OT40_IF_NROFTRIES] DEFAULT (0),
  [OT40_IF_RESPPOZ] [tinyint] NULL,
  [OT40_ZMT_ROWID] [int] NULL,
  [OT40_NR_SZKODY] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT40] PRIMARY KEY CLUSTERED ([OT40_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT40_Status_Update] 
on [dbo].[SAPO_ZWFOT40]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT40_ROWID int, 
		@c_OT40_IF_STATUS nvarchar(50),
		@c_OT40_IF_SENTDATE datetime,
		@c_OT40_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT40_ROWID, OT40_IF_STATUS, OT40_IF_SENTDATE, OT40_IF_EQUNR from inserted order by OT40_ROWID asc;
	--select OT40_ROWID, OT40_IF_STATUS, OT40_IF_SENTDATE, OT40_IF_EQUNR from dbo.SAPO_ZWFOT40

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT40_ROWID,	@c_OT40_IF_STATUS, @c_OT40_IF_SENTDATE, @c_OT40_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT40] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT40_ZMT_ROWID]
		where OT40_ROWID = @c_OT40_ROWID
		 
		if @c_OT40_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT40_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT40_IF_STATUS = 2
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT40_30', 'SAP' --Wysłany
 
		if @c_OT40_IF_STATUS = 3
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT40_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT40%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT40_ROWID,	@c_OT40_IF_STATUS, @c_OT40_IF_SENTDATE, @c_OT40_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
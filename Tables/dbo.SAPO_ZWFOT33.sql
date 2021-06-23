CREATE TABLE [dbo].[SAPO_ZWFOT33] (
  [OT33_ROWID] [int] IDENTITY,
  [OT33_KROK] [nvarchar](10) NULL,
  [OT33_BUKRS] [nvarchar](30) NULL,
  [OT33_SAPUSER] [nvarchar](12) NULL,
  [OT33_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT33_MTOPER] [nvarchar](1) NULL,
  [OT33_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT33___16DAE63C] DEFAULT (0),
  [OT33_IF_SENTDATE] [datetime] NULL,
  [OT33_IF_EQUNR] [nvarchar](30) NULL,
  [OT33_IF_YEAR] [nvarchar](4) NULL,
  [OT33_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT33_OT33_IF_NROFTRIES] DEFAULT (0),
  [OT33_ZMT_ROWID] [int] NULL,
  [OT33_CZY_BEZ_ZM] [nvarchar](1) NULL,
  [OT33_CZY_ROZ_OKR] [nvarchar](1) NULL,
  [OT33_POTID] [int] NULL,
  [OT33_TOSTNID] [int] NULL,
  CONSTRAINT [PK_SAPO_ZWFOT33] PRIMARY KEY CLUSTERED ([OT33_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create trigger [dbo].[SAPO_ZWFOT33_Status_Update] 
on [dbo].[SAPO_ZWFOT33]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT33_ROWID int, 
		@c_OT33_IF_STATUS nvarchar(50),
		@c_OT33_IF_SENTDATE datetime,
		@c_OT33_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT33_ROWID, OT33_IF_STATUS, OT33_IF_SENTDATE, OT33_IF_EQUNR from inserted order by OT33_ROWID asc;
	--select OT33_ROWID, OT33_IF_STATUS, OT33_IF_SENTDATE, OT33_IF_EQUNR from dbo.SAPO_ZWFOT33

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT33_ROWID,	@c_OT33_IF_STATUS, @c_OT33_IF_SENTDATE, @c_OT33_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT33] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT33_ZMT_ROWID]
		where OT33_ROWID = @c_OT33_ROWID
		 
		if @c_OT33_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT33_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT33_IF_STATUS = 3 and @c_OT33_IF_SENTDATE is not null and @c_OT33_IF_EQUNR is null 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT33_30', 'SAP' --Wysłany
 
		if @c_OT33_IF_STATUS = 3 and @c_OT33_IF_SENTDATE is not null and @c_OT33_IF_EQUNR is not null
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT33_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT33%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT33_ROWID,	@c_OT33_IF_STATUS, @c_OT33_IF_SENTDATE, @c_OT33_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
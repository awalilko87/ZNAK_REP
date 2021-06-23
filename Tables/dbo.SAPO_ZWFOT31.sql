CREATE TABLE [dbo].[SAPO_ZWFOT31] (
  [OT31_ROWID] [int] IDENTITY,
  [OT31_BUKRS] [nvarchar](30) NULL,
  [OT31_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT31_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT31___01E9EAF7] DEFAULT (0),
  [OT31_IF_SENTDATE] [datetime] NULL,
  [OT31_IF_EQUNR] [nvarchar](30) NULL,
  [OT31_IF_YEAR] [nvarchar](4) NULL,
  [OT31_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT31_OT31_IF_NROFTRIES] DEFAULT (0),
  [OT31_ZMT_ROWID] [int] NULL,
  [OT31_KROK] [nvarchar](10) NULL,
  [OT31_SAPUSER] [nvarchar](12) NULL,
  [OT31_CCD_DEFAULT] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT31] PRIMARY KEY CLUSTERED ([OT31_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create trigger [dbo].[SAPO_ZWFOT31_Status_Update] 
on [dbo].[SAPO_ZWFOT31]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT31_ROWID int, 
		@c_OT31_IF_STATUS nvarchar(50),
		@c_OT31_IF_SENTDATE datetime,
		@c_OT31_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT31_ROWID, OT31_IF_STATUS, OT31_IF_SENTDATE, OT31_IF_EQUNR from inserted order by OT31_ROWID asc;
	--select OT31_ROWID, OT31_IF_STATUS, OT31_IF_SENTDATE, OT31_IF_EQUNR from dbo.SAPO_ZWFOT31

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT31_ROWID,	@c_OT31_IF_STATUS, @c_OT31_IF_SENTDATE, @c_OT31_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT31] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT31_ZMT_ROWID]
		where OT31_ROWID = @c_OT31_ROWID
		 
		if @c_OT31_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT31_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT31_IF_STATUS = 3 and @c_OT31_IF_SENTDATE is not null and @c_OT31_IF_EQUNR is null 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT31_30', 'SAP' --Wysłany
 
		if @c_OT31_IF_STATUS = 3 and @c_OT31_IF_SENTDATE is not null and @c_OT31_IF_EQUNR is not null
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT31_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT31%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT31_ROWID,	@c_OT31_IF_STATUS, @c_OT31_IF_SENTDATE, @c_OT31_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO

ALTER TABLE [dbo].[SAPO_ZWFOT31]
  ADD CONSTRAINT [ZWFOT31_COSTCODE] FOREIGN KEY ([OT31_CCD_DEFAULT]) REFERENCES [dbo].[COSTCODE] ([CCD_CODE])
GO
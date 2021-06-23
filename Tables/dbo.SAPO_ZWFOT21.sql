CREATE TABLE [dbo].[SAPO_ZWFOT21] (
  [OT21_ROWID] [int] IDENTITY,
  [OT21_BUKRS] [nvarchar](30) NULL,
  [OT21_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT21_SERNR] [nvarchar](30) NULL,
  [OT21_POSNR] [int] NULL,
  [OT21_KOSTL] [nvarchar](30) NULL,
  [OT21_GDLGRP] [nvarchar](30) NULL,
  [OT21_MUZYTK] [nvarchar](30) NULL,
  [OT21_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT21___00F5C6BE] DEFAULT (0),
  [OT21_IF_SENTDATE] [datetime] NULL,
  [OT21_IF_EQUNR] [nvarchar](30) NULL,
  [OT21_IF_YEAR] [nvarchar](4) NULL,
  [OT21_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT21_OT21_IF_NROFTRIES] DEFAULT (0),
  [OT21_ZMT_ROWID] [int] NULL,
  [OT21_SAPUSER] [nvarchar](12) NULL,
  [OT21_MUZYTKID] [int] NULL,
  [OT21_NR_FORM] [nvarchar](25) NULL,
  [OT21_TYP_DOK] [nvarchar](50) NULL,
  [OT21_POZ_FORM] [nvarchar](10) NULL,
  [OT21_NR_DOK] [nvarchar](25) NULL,
  [OT21_KWPRZEKSIEGS] [numeric](13, 2) NULL,
  [ZMT_OBJ_CODE] [nvarchar](30) NULL,
  [OT21_SERNR_POSKI] [nvarchar](30) NULL,
  [OT21_POSNR_POSKI] [nvarchar](30) NULL,
  [OT21_KOSTL_POSKI] [nvarchar](30) NULL,
  [OT21_GDLGRP_POSKI] [nvarchar](30) NULL,
  [OT21_CZY_FORM] [nvarchar](1) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT21] PRIMARY KEY CLUSTERED ([OT21_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT21_Status_Update] 
on [dbo].[SAPO_ZWFOT21]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT21_ROWID int, 
		@c_OT21_IF_STATUS nvarchar(50),
		@c_OT21_IF_SENTDATE datetime,
		@c_OT21_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT21_ROWID, OT21_IF_STATUS, OT21_IF_SENTDATE, OT21_IF_EQUNR from inserted order by OT21_ROWID asc;
	--select OT21_ROWID, OT21_IF_STATUS, OT21_IF_SENTDATE, OT21_IF_EQUNR from dbo.SAPO_ZWFOT21

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT21_ROWID,	@c_OT21_IF_STATUS, @c_OT21_IF_SENTDATE, @c_OT21_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT21] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT21_ZMT_ROWID]
		where OT21_ROWID = @c_OT21_ROWID
		 
		if @c_OT21_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT21_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT21_IF_STATUS = 3 and @c_OT21_IF_SENTDATE is not null and @c_OT21_IF_EQUNR is null 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT21_30', 'SAP' --Wysłany
 
		if @c_OT21_IF_STATUS = 3 and @c_OT21_IF_SENTDATE is not null and @c_OT21_IF_EQUNR is not null
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT21_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT21%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT21_ROWID,	@c_OT21_IF_STATUS, @c_OT21_IF_SENTDATE, @c_OT21_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
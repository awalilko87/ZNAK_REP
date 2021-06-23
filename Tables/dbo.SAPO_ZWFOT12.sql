CREATE TABLE [dbo].[SAPO_ZWFOT12] (
  [OT12_ROWID] [int] IDENTITY,
  [OT12_BUKRS] [nvarchar](30) NULL,
  [OT12_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT12_DATA_WYST] [datetime] NULL,
  [OT12_DOC_NUM] [int] NULL,
  [OT12_SERNR] [nvarchar](30) NULL,
  [OT12_POSNR] [int] NULL,
  [OT12_HERST] [nvarchar](30) NULL,
  [OT12_KOSTL] [nvarchar](30) NULL,
  [OT12_GDLGRP] [nvarchar](30) NULL,
  [OT12_MUZYTK] [nvarchar](30) NULL,
  [OT12_NR_DOW_DOST] [nvarchar](15) NULL,
  [OT12_DATA_DOST] [datetime] NULL,
  [OT12_MIES_DOST] [int] NULL,
  [OT12_ROK_DOST] [int] NULL,
  [OT12_WART_TOTAL] [numeric](30, 2) NULL,
  [OT12_PRZEW_OKRES] [int] NULL,
  [OT12_WOJEWODZTWO] [nvarchar](12) NULL,
  [OT12_ANLKL] [nvarchar](8) NULL,
  [OT12_NR_TECHNOL] [nvarchar](15) NULL,
  [OT12_IF_STATUS] [int] NULL CONSTRAINT [DF__SAPO_ZWFO__OT12___0001A285] DEFAULT (0),
  [OT12_IF_SENTDATE] [datetime] NULL,
  [OT12_IF_EQUNR] [nvarchar](30) NULL,
  [OT12_IF_YEAR] [nvarchar](4) NULL,
  [OT12_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT12_OT12_IF_NROFTRIES] DEFAULT (0),
  [OT12_ZMT_ROWID] [int] NULL,
  [OT12_SAPUSER] [nvarchar](12) NULL,
  [OT12_PODZ_USL_P] [int] NULL,
  [OT12_PODZ_USL_S] [int] NULL,
  [OT12_PODZ_USL_B] [int] NULL,
  [OT12_PODZ_USL_C] [int] NULL,
  [OT12_PODZ_USL_U] [int] NULL,
  [OT12_PODZ_USL_H] [int] NULL,
  [OT12_MUZYTKID] [int] NULL,
  [ZMT_OBJ_CODE] [nvarchar](30) NULL,
  [OT12_KROK] [nvarchar](10) NULL,
  [OT12_SERNR_POSKI] [nvarchar](30) NULL,
  [OT12_POSNR_POSKI] [nvarchar](30) NULL,
  [OT12_ANLKL_POSKI] [nvarchar](30) NULL,
  [OT12_GDLGRP_POSKI] [nvarchar](30) NULL,
  [OT12_HERST_POSKI] [nvarchar](30) NULL,
  [OT12_KOSTL_POSKI] [nvarchar](30) NULL,
  [OT12_CZY_FORM] [nvarchar](1) NULL,
  [OT12_ZZ_NR_FORM] [nvarchar](25) NULL,
  [OT12_ZZ_TYP_DOK] [nvarchar](50) NULL,
  [OT12_ZZ_POZ_FORM] [nvarchar](10) NULL,
  [OT12_ZZ_NR_DOK] [nvarchar](25) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT12] PRIMARY KEY CLUSTERED ([OT12_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT12_Status_Update] 
on [dbo].[SAPO_ZWFOT12]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT12_ROWID int, 
		@c_OT12_IF_STATUS nvarchar(50),
		@c_OT12_IF_SENTDATE datetime,
		@c_OT12_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT12_ROWID, OT12_IF_STATUS, OT12_IF_SENTDATE, OT12_IF_EQUNR from inserted order by OT12_ROWID asc;
	--select OT12_ROWID, OT12_IF_STATUS, OT12_IF_SENTDATE, OT12_IF_EQUNR from dbo.SAPO_ZWFOT12

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT12_ROWID,	@c_OT12_IF_STATUS, @c_OT12_IF_SENTDATE, @c_OT12_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT12] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT12_ZMT_ROWID]
		where OT12_ROWID = @c_OT12_ROWID
		 
		if @c_OT12_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT12_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT12_IF_STATUS = 3 and @c_OT12_IF_SENTDATE is not null and @c_OT12_IF_EQUNR is null 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT12_30', 'SAP' --Wysłany
 
		if @c_OT12_IF_STATUS = 3 and @c_OT12_IF_SENTDATE is not null and @c_OT12_IF_EQUNR is not null
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT12_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT12%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT12_ROWID,	@c_OT12_IF_STATUS, @c_OT12_IF_SENTDATE, @c_OT12_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
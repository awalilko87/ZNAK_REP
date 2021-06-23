CREATE TABLE [dbo].[SAPO_ZWFOT11] (
  [OT11_ROWID] [int] IDENTITY,
  [OT11_KROK] [nvarchar](10) NULL,
  [OT11_BUKRS] [nvarchar](30) NULL,
  [OT11_IMIE_NAZWISKO] [nvarchar](80) NULL,
  [OT11_TYP_SKLADNIKA] [nvarchar](1) NULL,
  [OT11_CZY_BUD] [nvarchar](1) NULL,
  [OT11_SERNR] [nvarchar](30) NULL,
  [OT11_POSNR] [int] NULL,
  [OT11_ANLN1_INW] [nvarchar](12) NULL,
  [OT11_ANLN1] [nvarchar](12) NULL,
  [OT11_INVNR_NAZWA] [nvarchar](50) NULL,
  [OT11_CZY_FUND] [nvarchar](1) NULL,
  [OT11_CZY_SKL_POZW] [nvarchar](1) NULL,
  [OT11_CZY_NIEMAT] [nvarchar](1) NULL,
  [OT11_HERST] [nvarchar](30) NULL,
  [OT11_LAND1] [nvarchar](3) NULL,
  [OT11_KOSTL] [nvarchar](30) NULL,
  [OT11_GDLGRP] [nvarchar](30) NULL,
  [OT11_MUZYTK] [nvarchar](30) NULL,
  [OT11_NAZWA_DOK] [nvarchar](1) NULL,
  [OT11_NUMER_DOK] [nvarchar](15) NULL,
  [OT11_DATA_DOK] [datetime] NULL,
  [OT11_WART_NAB_PLN] [numeric](30, 2) NULL,
  [OT11_PRZEW_OKRES] [int] NULL,
  [OT11_WOJEWODZTWO] [nvarchar](12) NULL,
  [OT11_BRANZA] [nvarchar](10) NULL,
  [OT11_ANLKL] [nvarchar](8) NULL,
  [OT11_CZY_BUDOWLA] [nvarchar](1) NULL,
  [OT11_IF_STATUS] [int] NULL CONSTRAINT [DF_OT11_IF_STATUS] DEFAULT (0),
  [OT11_IF_SENTDATE] [datetime] NULL,
  [OT11_IF_EQUNR] [nvarchar](30) NULL,
  [OT11_IF_YEAR] [nvarchar](4) NULL,
  [OT11_IF_NROFTRIES] [tinyint] NULL CONSTRAINT [DF_SAPO_ZWFOT11_OT11_IF_NROFTRIES] DEFAULT (0),
  [OT11_ZMT_ROWID] [int] NULL,
  [OT11_SAPUSER] [nvarchar](12) NULL,
  [OT11_MIES_DOST] [int] NULL,
  [OT11_ROK_DOST] [int] NULL,
  [ZMT_OBJ_CODE] [nvarchar](30) NULL,
  [OT11_PODZ_USL_P] [int] NULL,
  [OT11_PODZ_USL_S] [int] NULL,
  [OT11_PODZ_USL_B] [int] NULL,
  [OT11_PODZ_USL_C] [int] NULL,
  [OT11_PODZ_USL_U] [int] NULL,
  [OT11_PODZ_USL_H] [int] NULL,
  [OT11_CHAR] [nvarchar](max) NULL,
  [OT11_MUZYTKID] [int] NULL,
  [OT11_SERNR_POSKI] [nvarchar](30) NULL,
  [OT11_POSNR_POSKI] [nvarchar](30) NULL,
  [OT11_ANLKL_POSKI] [nvarchar](30) NULL,
  [OT11_ANLN1_POSKI] [nvarchar](30) NULL,
  [OT11_ANLN1_INW_POSKI] [nvarchar](30) NULL,
  [OT11_GDLGRP_POSKI] [nvarchar](30) NULL,
  [OT11_HERST_POSKI] [nvarchar](30) NULL,
  [OT11_KOSTL_POSKI] [nvarchar](30) NULL,
  [OT11_CZY_POZWOL] [nvarchar](1) NULL,
  [OT11_CZY_PLAN_POZW] [nvarchar](1) NULL,
  [OT11_CZY_WYD_POZW] [nvarchar](1) NULL,
  [OT11_WART_FUND] [numeric](30, 2) NULL,
  [ZZ_PLAN_DAT_DEC] [datetime] NULL,
  [ZZ_PLAN_DATA_ZGL] [datetime] NULL,
  [OT11_ZZ_PLAN_DAT_DEC] [datetime] NULL,
  [OT11_ZZ_PLAN_DATA_ZGL] [datetime] NULL,
  [OT11_ZZ_DATA_WYD_DEC] [datetime] NULL,
  [OT11_ZZ_DATA_UPRA_DEC] [datetime] NULL,
  [OT11_ZZ_DATA_ZGL] [datetime] NULL,
  [OT11_ZZ_DATA_UPRA_ZGL] [datetime] NULL,
  [OT11_CZY_BEZ_ZM] [nvarchar](1) NULL,
  [OT11_CZY_ROZ_OKR] [nvarchar](1) NULL CONSTRAINT [DF_OT11_CZY_ROZ_OKR] DEFAULT (0),
  [OT11_UDF01] [nvarchar](100) NULL,
  [OT11_UDF02] [nvarchar](100) NULL,
  [OT11_UDF03] [nvarchar](100) NULL,
  [OT11_UDF04] [nvarchar](100) NULL,
  [OT11_UDF05] [nvarchar](100) NULL,
  [OT11_UDF06] [nvarchar](100) NULL,
  [OT11_UDF07] [nvarchar](100) NULL,
  [OT11_UDF08] [nvarchar](100) NULL,
  [OT11_UDF09] [nvarchar](100) NULL,
  [OT11_UDF10] [nvarchar](100) NULL,
  [OT11_RECEIVE_DATE] [datetime] NULL,
  [OT11_INSTALL_DATE] [datetime] NULL,
  [OT11_INVOICE_DATE] [datetime] NULL,
  [OT11_AKT_OKR_AMORT] [nvarchar](30) NULL,
  [OT11_NETVALUE] [numeric](16, 2) NULL,
  [OT11_ACTVALUEDATE] [datetime] NULL,
  CONSTRAINT [PK_SAPO_ZWFOT11] PRIMARY KEY CLUSTERED ([OT11_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT11_Status_Update] 
on [dbo].[SAPO_ZWFOT11]
after update 
as 
begin

	declare @v_OT_ROWID int
	
	declare 
		@c_OT11_ROWID int, 
		@c_OT11_IF_STATUS nvarchar(50),
		@c_OT11_IF_SENTDATE datetime,
		@c_OT11_IF_EQUNR nvarchar(50)

	declare c_StatusInserted cursor for
	select OT11_ROWID, OT11_IF_STATUS, OT11_IF_SENTDATE, OT11_IF_EQUNR from inserted order by OT11_ROWID asc;
	--select OT11_ROWID, OT11_IF_STATUS, OT11_IF_SENTDATE, OT11_IF_EQUNR from dbo.SAPO_ZWFOT11

	open c_StatusInserted

	fetch next from c_StatusInserted
	into @c_OT11_ROWID,	@c_OT11_IF_STATUS, @c_OT11_IF_SENTDATE, @c_OT11_IF_EQUNR
		
	while @@fetch_status = 0 
	begin
	 
		select	
			@v_OT_ROWID = OT_ROWID
		FROM [dbo].[SAPO_ZWFOT11] (nolock)
			join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT11_ZMT_ROWID]
		where OT11_ROWID = @c_OT11_ROWID
		 
		if @c_OT11_IF_STATUS = 9 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT11_60', 'SAP' --Odrzucony Workflow
			
		if @c_OT11_IF_STATUS = 3 and @c_OT11_IF_SENTDATE is not null and @c_OT11_IF_EQUNR is null 
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT11_30', 'SAP' --Wysłany
 
		if @c_OT11_IF_STATUS = 3 and @c_OT11_IF_SENTDATE is not null and @c_OT11_IF_EQUNR is not null
			exec [dbo].[ZWFOT_UpdateStatus] @v_OT_ROWID, 'OT11_31', 'SAP' --Procesowany Workflow - Wystawiający

			--select * from sta where sta_code like 'OT11%'
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
				 
		fetch next from c_StatusInserted
		into @c_OT11_ROWID,	@c_OT11_IF_STATUS, @c_OT11_IF_SENTDATE, @c_OT11_IF_EQUNR
		
	end

	close c_StatusInserted
	deallocate c_StatusInserted

end
GO
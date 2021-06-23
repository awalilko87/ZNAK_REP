CREATE TABLE [dbo].[SAPO_ZWFOT21LN] (
  [OT21LN_ROWID] [int] IDENTITY,
  [OT21LN_WART_NAB_PLN] [numeric](30, 6) NULL,
  [OT21LN_DOSTAWCA] [nvarchar](80) NULL,
  [OT21LN_NR_DOW_DOSTAWY] [nvarchar](30) NULL,
  [OT21LN_DT_DOSTAWY] [datetime] NULL,
  [OT21LN_GRUPA] [nvarchar](8) NULL,
  [OT21LN_ANLN1] [nvarchar](30) NULL,
  [OT21LN_ANLN2] [nvarchar](30) NULL,
  [OT21LN_ZMT_ROWID] [int] NULL,
  [OT21LN_OT21ID] [int] NULL,
  [OT21LN_ZMT_OBJ_CODE] [nvarchar](30) NULL,
  [OT21LN_ILOSC] [int] NULL,
  [OT21LN_NZWYP] [nvarchar](50) NULL,
  [OT21LN_MUZYTK] [nvarchar](50) NULL,
  [OT21LN_NR_PRA_UZYTK] [nvarchar](50) NULL,
  [OT21LN_SKL_RUCH] [nvarchar](50) NULL,
  [OT21LN_ANLN1_POSKI] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT21LN] PRIMARY KEY CLUSTERED ([OT21LN_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT21LN_KWPRZEKSIEGS_Update] 
on [dbo].[SAPO_ZWFOT21LN]
after insert, update, delete --dla delete nie dziala teraz
as 
begin
 
	declare 
		@c_OT21LN_ROWID int, 
		@c_OT21LN_WART_NAB_PLN decimal(13,2),
		@c_OT21LN_ZMT_ROWID int,
		@c_OT21LN_OT21ID int,
		
		@v_WART_TOTAL decimal(13,2)

	declare c_LineInserted cursor for
	select OT21LN_ROWID, OT21LN_WART_NAB_PLN, OT21LN_ZMT_ROWID, OT21LN_OT21ID from inserted
	union
	select OT21LN_ROWID, OT21LN_WART_NAB_PLN, OT21LN_ZMT_ROWID, OT21LN_OT21ID from deleted
	;
	--select OT21LN_ROWID, OT21LN_WART_NAB_PLN, OT21LN_ZMT_ROWID, OT21LN_OT21ID from dbo.SAPO_ZWFOT21LN

	open c_LineInserted

	fetch next from c_LineInserted
	into @c_OT21LN_ROWID, @c_OT21LN_WART_NAB_PLN, @c_OT21LN_ZMT_ROWID, @c_OT21LN_OT21ID
	
	while @@fetch_status = 0 
	begin
	 
		select 
			@v_WART_TOTAL = sum(OT21LN_WART_NAB_PLN) 
		from [dbo].[SAPO_ZWFOT21LN] (nolock)
			join [dbo].[SAPO_ZWFOT21] (nolock) on OT21LN_OT21ID = OT21_ROWID
			join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
		where OT21_ROWID = @c_OT21LN_OT21ID and isnull(OTL_NOTUSED,0) = 0 and OT21LN_WART_NAB_PLN is not null
		 
		update [dbo].[SAPO_ZWFOT21] set OT21_KWPRZEKSIEGS = @v_WART_TOTAL	where OT21_ROWID = @c_OT21LN_OT21ID
		 
		
		fetch next from c_LineInserted
		into @c_OT21LN_ROWID, @c_OT21LN_WART_NAB_PLN, @c_OT21LN_ZMT_ROWID, @c_OT21LN_OT21ID
	
	end

	close c_LineInserted
	deallocate c_LineInserted

end 
  






GO
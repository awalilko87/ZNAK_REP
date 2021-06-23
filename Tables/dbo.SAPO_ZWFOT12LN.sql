CREATE TABLE [dbo].[SAPO_ZWFOT12LN] (
  [OT12LN_ROWID] [int] IDENTITY,
  [OT12LN_INVNR_NAZWA] [nvarchar](50) NULL,
  [OT12LN_CHAR_SKLAD] [nvarchar](255) NULL,
  [OT12LN_WART_ELEME] [numeric](30, 2) NULL,
  [OT12LN_ANLN1] [nvarchar](12) NULL,
  [OT12LN_ANLN2] [nvarchar](4) NULL,
  [OT12LN_ZMT_ROWID] [int] NULL,
  [OT12LN_OT12ID] [int] NULL,
  [OT12LN_ZMT_OBJ_CODE] [nvarchar](30) NULL,
  [OT12LN_ANLN1_POSKI] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT12LN] PRIMARY KEY CLUSTERED ([OT12LN_ROWID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[SAPO_ZWFOT12LN_WART_TOTAL_Update] 
on [dbo].[SAPO_ZWFOT12LN]
after insert, update, delete --dla delete nie dziala teraz
as 
begin
 
	declare 
		@c_OT12LN_ROWID int, 
		@c_OT12LN_WART_ELEME decimal(13,2),
		@c_OT12LN_ZMT_ROWID int,
		@c_OT12LN_OT12ID int,
		
		@v_WART_TOTAL decimal(13,2)

	declare c_LineInserted cursor for
	select OT12LN_ROWID, OT12LN_WART_ELEME, OT12LN_ZMT_ROWID, OT12LN_OT12ID from inserted
	union
	select OT12LN_ROWID, OT12LN_WART_ELEME, OT12LN_ZMT_ROWID, OT12LN_OT12ID from deleted
	;
	--select OT12LN_ROWID, OT12LN_WART_ELEME, OT12LN_ZMT_ROWID, OT12LN_OT12ID from dbo.SAPO_ZWFOT12LN

	open c_LineInserted

	fetch next from c_LineInserted
	into @c_OT12LN_ROWID, @c_OT12LN_WART_ELEME, @c_OT12LN_ZMT_ROWID, @c_OT12LN_OT12ID
	
	while @@fetch_status = 0 
	begin
	 
		select 
			@v_WART_TOTAL = sum(OT12LN_WART_ELEME) 
		from [dbo].[SAPO_ZWFOT12LN] (nolock)
			join [dbo].[SAPO_ZWFOT12] (nolock) on OT12LN_OT12ID = OT12_ROWID
		where OT12_ROWID = @c_OT12LN_OT12ID and OT12LN_WART_ELEME is not null
		 
		update [dbo].[SAPO_ZWFOT12] set OT12_WART_TOTAL = @v_WART_TOTAL	where OT12_ROWID = @c_OT12LN_OT12ID
		 
		
		fetch next from c_LineInserted
		into @c_OT12LN_ROWID, @c_OT12LN_WART_ELEME, @c_OT12LN_ZMT_ROWID, @c_OT12LN_OT12ID
	
	end

	close c_LineInserted
	deallocate c_LineInserted

end 
  





GO
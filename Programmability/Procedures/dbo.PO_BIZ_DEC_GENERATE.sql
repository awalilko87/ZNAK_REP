SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[PO_BIZ_DEC_GENERATE]
(
  @p_POTID int
, @p_UserID nvarchar(30)
)as 

begin 

if not exists (select 1 from [dbo].[PO_BIZ_DEC_HEAD] where BIZ_POTID = @p_POTID)
	begin

	declare @v_POT_CODE nvarchar(30)
	select  @v_POT_CODE = POT_CODE from [dbo].[OBJTECHPROT] where POT_ROWID = @p_POTID
	declare @BIZID int

				/********************	nagłowek decyzji biznesowej ***********************/
		insert into [dbo].[PO_BIZ_DEC_HEAD] (BIZ_CODE, BIZ_CREDATE, BIZ_CREUSER, BIZ_POTID)
			values (@v_POT_CODE, getdate(), @p_UserID,@p_POTID)
			
		select @BIZID = IDENT_CURRENT('[dbo].PO_BIZ_DEC_HEAD]')


		insert into [dbo].[PO_BIZ_DEC_ITEMS] (BII_BIZID, BII_STNID, BII_OBJID, BII_ASSET, BII_OBG, BII_STSID, BII_PRICE, BII_NETTO, BII_WART_ODSP)
		select @BIZID,POL_TO_STNID,POL_OBJID,POL_ASSET,GroupID,OBJ.OBJ_STSID,POL_PRICE,POL_NTX01,POL_WART_ODSP
		from [dbo].[OBJTECHPROTLNv] 
		join [dbo].[OBJ] (nolock) on OBJ_ROWID = POL_OBJID            
		left join dbo.OBJGROUP_RESPONv on OBG_ROWID = OBJ_GROUPID            
		where POL_POTID = @p_POTID and POL_BIZ_DEC = 1 
		 

	end

end
GO
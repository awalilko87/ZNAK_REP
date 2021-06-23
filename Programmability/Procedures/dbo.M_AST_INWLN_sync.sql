﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[M_AST_INWLN_sync]
as
 begin
	insert into AST_INWLN (
		SIA_SINID
		,SIA_ASSETID
		,SIA_CODE
		,SIA_BARCODE
		,SIA_ROWGUID
		,SIA_ORG
		,SIA_OLDQTY
		,SIA_NEWQTY
		,SIA_PRICE
		,SIA_NOTE
		,SIA_STATUS
		,SIA_RSTATUS
		,SIA_NOTUSED
		,SIA_ID
		,SIA_OBJID
		,SIA_SURPLUS
		,SIA_PDA_DATE
		,SIA_CONFIRMUSER
		,SIA_CONFIRMDATE
		,SIA_CREUSER
		,SIA_CREDATE
		) 
	select
		SIA_SINID
		,SIA_ASSETID
		,SIA_CODE
		,SIA_BARCODE
		,SIA_ROWGUID
		,SIA_ORG
		,SIA_OLDQTY
		,SIA_NEWQTY
		,SIA_PRICE
		,SIA_NOTE
		,SIA_STATUS
		,SIA_RSTATUS
		,SIA_NOTUSED
		,SIA_ID
		,SIA_OBJID
		,SIA_SURPLUS
		,SIA_PDA_DATE
		,SIA_CONFIRMUSER
		,SIA_CONFIRMDATE
		,SIA_CONFIRMUSER
		,GETDATE()
	
	from M_AST_INWLN where 
		isnull(SIA_SYNC,0) != 1
	

	update M_AST_INWLN set SIA_SYNC = 1 where isnull(SIA_SYNC,0) != 1
 end
GO
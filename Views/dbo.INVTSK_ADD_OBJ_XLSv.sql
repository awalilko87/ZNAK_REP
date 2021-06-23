SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE view [dbo].[INVTSK_ADD_OBJ_XLSv]
as
select
 rowid
,spid
,importuser
,c00
,COMMENT
,lp
,c01
,c02
,c03
,c04
,c05
,c06
,c07
,c08
,c09
,c10
,c11
,c12
,c13
,c14
,c15
,c16
,c17
,c18
,c19
,c20
,c21
,c22
,c23
,c24
,ErrorMessage
,PSP = convert(varchar,null)
,ITSCODE = convert(varchar,null)
from dbo.INVTSK_ADD_OBJ_XLS

GO
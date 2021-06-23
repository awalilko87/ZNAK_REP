SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[E2_SAP2ZMT_DocStatus_Clean]
(
@GUID nvarchar(50)
,@POZ nvarchar(5)
,@STAT_DATE	datetime
,@STAT_CODE	nvarchar(30)
,@DOC_TYPE	nvarchar(30)
,@DOC_KEY	nvarchar(30)
,@COLS	nvarchar(max)
,@VALS	nvarchar(max)	-- nie uzywane w procedurze, dodano ze wzglów zgodności ilość parametrów w WebService
)
AS
BEGIN

 Declare @Date datetime, @Statement nvarchar(max)
 DECLARE @COLS1 nvarchar(max), @COLS2 nvarchar(max)
 
/*
 If @DIC in ('KST','MPK','INW','PSP','KONTRAHENCI','ST','EQUI','KLASYFIKATOR5')
 BEGIN
	IF RIGHT(@COLS,1)=',' SELECT @COLS1=REPLACE(SubString(@COLS,1,LEN(@COLS)-1),'[','T1.[')
	ELSE SELECT @COLS1=REPLACE(SubString(@COLS,1,LEN(@COLS)-0),'[','T1.[')
	SELECT @COLS2=REPLACE(@COLS1,'T1.[','T2.[')

   SET @Statement = 
   N''
	+N' delete from dbo.IE2_'+@DIC
	+N' where ROWID in ('
	+N' select T1.ROWID'
	+N' from dbo.IE2_'+@DIC+N' T1 join dbo.IE2_'+@DIC+N' T2 '
	+N' on CHECKSUM('+@COLS1+N')=CHECKSUM('+@COLS2+N')'
	+N' and T1.ROWID>T2.ROWID'
	+N');'
   
   print @Statement
   EXEC sp_executesql @Statement;	
 
 END
*/
 
END
GO
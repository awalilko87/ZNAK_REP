SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[E2_SAP2ZMT_DocStatus]
(
@GUID nvarchar(50)
,@POZ nvarchar(5)
,@STAT_DATE	datetime
,@STAT_CODE	nvarchar(30)
,@DOC_TYPE	nvarchar(30)
,@DOC_KEY	nvarchar(30)
,@COLS	nvarchar(max)
,@VALS	nvarchar(max)
)
AS
BEGIN

 Declare @Date datetime, @Statement nvarchar(max)
 DECLARE @COLS1 nvarchar(max), @COLS2 nvarchar(max)
 select @Date=GETDATE()

 insert into dbo.IE2_DocStatus(i_DateTime, GUID, POZ, STAT_DATE, STAT_CODE, DOC_TYPE, DOC_KEY,COLS,VALS)
 select @Date, @GUID, @POZ, @STAT_DATE, @STAT_CODE, @DOC_TYPE, @DOC_KEY, @COLS, @VALS

/* 
 BEGIN
	IF RIGHT(@COLS,1)=',' SELECT @COLS1=REPLACE(SubString(@COLS,1,LEN(@COLS)-1),'[','T1.[')
	ELSE SELECT @COLS1=REPLACE(SubString(@COLS,1,LEN(@COLS)-0),'[','T1.[')
	SELECT @COLS2=REPLACE(@COLS1,'T1.[','T2.[')

	IF RIGHT(@COLS,1)=',' SELECT @COLS=@COLS+'i_DateTime'
	IF RIGHT(@VALS,1)=',' SELECT @VALS=@VALS+'#'+CONVERT(nvarchar,@Date,121)+'#'
	SELECT @VALS=REPLACE(@VALS,'#00000000#','null')
	SELECT @VALS=REPLACE(@VALS,'''','''''')
	SELECT @VALS=REPLACE(@VALS,'#','''')

   SET @Statement = 
   N' insert into dbo.IE2_'+@DIC+N'('+@COLS+N') VALUES('+@VALS+N');'

   print @Statement
   EXEC sp_executesql @Statement;	
 
 END
*/
 
END
GO
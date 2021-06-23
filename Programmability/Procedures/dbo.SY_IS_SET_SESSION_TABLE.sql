﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SY_IS_SET_SESSION_TABLE]
AS
  DECLARE @TMP_TABLE NVARCHAR(30)
  DECLARE @SQL NVARCHAR(4000)
  DECLARE @RET int

  select @TMP_TABLE = '##VS_SESSION_'+CAST(@@SPID as nvarchar(30))
  SELECT @SQL = N'SELECT @RET = CASE WHEN EXISTS (SELECT NULL FROM TEMPDB.SYS.TABLES (NOLOCK) WHERE NAME = '''+@tmp_table+''') THEN 1 ELSE 0 END'
  EXEC sp_executesql @SQL,N'@RET INT OUTPUT', @RET = @RET OUT
  RETURN @RET
GO
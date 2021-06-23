SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SY_CLEAR_SESSION_TABLE] 
AS
declare @tmp_table nvarchar(30)
DECLARE @SQL NVARCHAR(4000)

select @tmp_table = '##VS_SESSION_'+CAST(@@SPID as nvarchar(30))
SELECT @SQL = N'IF EXISTS (SELECT NULL FROM TEMPDB.SYS.TABLES (NOLOCK) WHERE NAME = '''+@tmp_table+''') DROP TABLE ' + @tmp_table

EXEC sp_executesql @SQL

GO
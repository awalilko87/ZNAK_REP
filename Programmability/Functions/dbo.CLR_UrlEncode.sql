SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CLR_UrlEncode] (@str [nvarchar](4000))
RETURNS [nvarchar](4000)
AS
EXTERNAL NAME [CLR_UrlEncode].[UserDefinedFunctions].[CLR_UrlEncode]
GO

EXEC sys.sp_addextendedproperty N'AutoDeployed', N'yes', 'SCHEMA', N'dbo', 'FUNCTION', N'CLR_UrlEncode'
GO

EXEC sys.sp_addextendedproperty N'SqlAssemblyFile', N'CLR_UrlEncode.cs', 'SCHEMA', N'dbo', 'FUNCTION', N'CLR_UrlEncode'
GO

EXEC sys.sp_addextendedproperty N'SqlAssemblyFileLine', 10, 'SCHEMA', N'dbo', 'FUNCTION', N'CLR_UrlEncode'
GO
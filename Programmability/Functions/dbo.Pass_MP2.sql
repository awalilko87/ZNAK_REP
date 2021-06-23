SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


	CREATE FUNCTION [dbo].[Pass_MP2](@sTxtin nvarchar(32) )
	returns nvarchar(32)
	WITH ENCRYPTION
	AS 
		BEGIN
			return (@sTxtin + 'MP2')
		END
GO
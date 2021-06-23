SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


	CREATE FUNCTION [dbo].[Pass_D7i](@sTxtin nvarchar(32) )
	returns nvarchar(32)
	WITH ENCRYPTION
	AS 
		BEGIN
			return (@sTxtin + 'D7i')
		END
GO
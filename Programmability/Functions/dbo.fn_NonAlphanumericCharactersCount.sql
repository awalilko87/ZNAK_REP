SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[fn_NonAlphanumericCharactersCount] (@password nvarchar(50))
RETURNS int
AS
BEGIN
	DECLARE @result int
	DECLARE @nAscii int 
	DECLARE @index int  
	DECLARE @len int  

	SET @result = 0
	SET @index = 0  
	SET @len = len( @password )  
	while @index <= @len  
	begin  
		SET @nAscii = ascii( substring( @password, @index, 1))  
		IF (@nAscii < 48) OR (@nAscii BETWEEN 58 AND 64) OR (@nAscii BETWEEN 91 AND 96) OR (@nAscii > 122)  
			SET @result = @result + 1
		SET @index = @index + 1  
	END
  RETURN @result   
END
GO
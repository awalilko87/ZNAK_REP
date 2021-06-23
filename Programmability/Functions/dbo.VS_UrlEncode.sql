SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[VS_UrlEncode](@url varchar(1024))
RETURNS varchar(3072)
AS
 BEGIN
    DECLARE @count int, @c char(1), @i int, @urlReturn varchar(3072)
    SET @count = Len(@url)
    SET @i = 1
    SET @urlReturn = ''    WHILE (@i <= @count)
     BEGIN
        SET @c = substring(@url, @i, 1)
        IF @c LIKE '[A-Za-z0-9()''*-._! ]'
         BEGIN
            SET @urlReturn = @urlReturn + @c
         END
        ELSE
         BEGIN
            SET @urlReturn = 
                   @urlReturn +
                   '%' +
                   SUBSTRING(sys.fn_varbintohexstr(CAST(@c as varbinary(max))),3,2)
         END
        SET @i = @i +1
     END
    RETURN @urlReturn
 END
GO
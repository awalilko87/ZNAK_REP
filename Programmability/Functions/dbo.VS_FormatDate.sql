SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[VS_FormatDate] (@DateTimeToFormat DATETIME, @FormatMask VARCHAR(50))
RETURNS nvarchar(100)  
  
AS  
  
BEGIN  
    DECLARE @FormattedResult nvarchar(50)  
  
    SET @FormattedResult = @FormatMask  
  
    IF (charindex('yyyy', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'yyyy', datename(YY, @DateTimeToFormat))  
  
    IF (charindex('yy', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'yy', right(datename(YY, @DateTimeToFormat), 2))  
  
    IF (charindex('MMMM', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'MMMM', datename(MM, @DateTimeToFormat))  
  
    IF (charindex('MMM', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'MMM', left(datename(MM, @DateTimeToFormat), 3))  
  
    IF (charindex('MM', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'MM', right('0' + cast(datepart(MM, @DateTimeToFormat) as nvarchar(2)), 2))  
  
    IF (charindex('M', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'M', cast(datepart(MM, @DateTimeToFormat) as nvarchar(2)))  
  
    IF (charindex('dd', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'dd', right('0' + datename(DD, @DateTimeToFormat), 2))  
  
    IF (charindex('d', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'd', datename(DD, @DateTimeToFormat))    
  
    IF (charindex('HH', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'HH', right('0' + datename(HH, @DateTimeToFormat), 2))  
  
    IF (charindex('H', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'H', datename(HH, @DateTimeToFormat))  
  
    IF (charindex('hh', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'hh',right('0' + cast((datepart(HH, @DateTimeToFormat) + 11) % 12 + 1 as nvarchar(2)), 2))  
  
    IF (charindex('h', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'h', cast((datepart(HH, @DateTimeToFormat) + 11) % 12 + 1 as nvarchar(2)))  
  
    IF (charindex('mm', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'mm', right('0' + datename(Minute, @DateTimeToFormat), 2))  
  
    IF (charindex('m', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'm', datename(Minute, @DateTimeToFormat))  
  
    IF (charindex('ss', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'ss', right('0' + datename(Second, @DateTimeToFormat), 2))  
  
    IF (charindex('s', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 's', datename(Second, @DateTimeToFormat))  
  
    IF (charindex('tt', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'tt', CASE WHEN datename(Hour, @DateTimeToFormat) < 12 THEN 'AM' ELSE 'PM' END)  
  
    IF (charindex('t', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 't', CASE WHEN datename(Hour, @DateTimeToFormat) < 12 THEN 'A' ELSE 'P' END)  
  
    IF (charindex('fff', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0) 
	   SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'fff', datename(ms, @DateTimeToFormat))  
  
    IF (charindex('zzzz', @FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)  
    BEGIN  
       -- If SQL 2008+ the line below can replace the code within this block  
       -- SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'zzzz', right(cast(SYSDATETIMEOFFSET() as nvarchar(50)), 6))  
        
       DECLARE @GmtOffset int  
       DECLARE @GmtSign nvarchar(1)  
       SET @GmtOffset = datediff(minute, getutcdate(), getdate())  
       SELECT @GmtSign = CASE WHEN @GmtOffset >= 0 THEN '+' ELSE '-' END  
     
       SET @FormattedResult = replace(@FormattedResult COLLATE SQL_Latin1_General_CP1_CS_AS, 'zzzz', CASE WHEN @GmtOffset >= 0 THEN '+' ELSE '-' END + right('0' + cast(abs(@GmtOffset) / 60 as nvarchar(5)),2) + ':' + right('0' + cast(abs(@GmtOffset % 60) as nvarchar(2)), 2))  
    END  
     
RETURN @FormattedResult  
  
-- SELECT dbo.fnc_FormatDate(getdate(), 'MM/DD/YYYY HH:mm:ss tt')  
-- SELECT dbo.fnc_FormatDate(getdate(), 'MMM DD, YYYY hh:mm:ss zzzz')  
-- SELECT dbo.fnc_FormatDate(getdate(), 'MMMM DD, YY HH:mm:ss tt')  
-- SELECT dbo.fnc_FormatDate(getdate(), 'M/D/YY H:m:s t')  
  
END 
GO
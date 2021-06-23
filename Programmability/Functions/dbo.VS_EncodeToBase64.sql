SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[VS_EncodeToBase64]
(
 @InputStrings varchar(8000)
)
RETURNS varchar(8000)
AS
BEGIN
 DECLARE  @ConvertTable varchar(128)
    ,@ReturnStrings varchar(8000)
    ,@InputBinary varbinary(8000)
    ,@InputSize int
    ,@Count  int
    ,@Before1 binary(1)
    ,@Before2 binary(1)
    ,@Before3 binary(1)
    ,@After1 int
    ,@After2 int
    ,@After3 int
    ,@After4 int


  SET @ConvertTable = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      + 'abcdefghijklmnopqrstuvwxyz'
      + '0123456789+/='

  SET @InputBinary = CAST(@InputStrings AS varbinary(8000))
  SET @InputSize = DATALENGTH(@InputBinary)
  SET @Count = 1
  SET @ReturnStrings = ''

 WHILE (0=0) BEGIN
 IF @Count > @InputSize BREAK

 SET @Before1 = SUBSTRING(@InputBinary, @Count, 1)

 IF @Count + 1 > @InputSize BEGIN
 SET @Before2 = NULL
 END
 ELSE BEGIN
 SET @Before2 = SUBSTRING(@InputBinary, @Count + 1, 1)
 END

 IF @Count + 2 > @InputSize BEGIN
 SET @Before3 = NULL
 END
 ELSE BEGIN
 SET @Before3 = SUBSTRING(@InputBinary, @Count + 2, 1)
 END

 SET @After1 = (@Before1 & 252) /  4
 SET @After2 = (@Before1 &   3) * 16 + (ISNULL(@Before2, 0x00) & 240) / 16
 SET @After3 = (@Before2 &  15) *  4 + (ISNULL(@Before3, 0x00) & 192) / 64
 SET @After4 = (ISNULL(@Before3, 0x00) &  63) *  1

 SET @ReturnStrings = @ReturnStrings
  + SUBSTRING(@ConvertTable, @After1 + 1, 1)
  + SUBSTRING(@ConvertTable, @After2 + 1, 1)
  + CASE WHEN @Before2 IS NULL AND @Before3 IS NULL
   THEN '='
   ELSE SUBSTRING(@ConvertTable, @After3 + 1, 1)
   END
  + CASE WHEN @Before3 IS NULL
   THEN '='
   ELSE SUBSTRING(@ConvertTable, @After4 + 1, 1)
   END

 SET @Count = @Count + 3
 END

 RETURN REPLACE(@ReturnStrings, '+', '$')

END
GO
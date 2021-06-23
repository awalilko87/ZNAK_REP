SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create FUNCTION [dbo].[fn_TRIMHTMLTAGS]( @sStringin nvarchar(max) ) returns nvarchar(max)
with encryption
as begin
  declare @nPos1 integer
  declare @nPos2 integer
  declare @sStringout nvarchar(max)

  set @nPos1 = 1
  set @sStringout = @sStringin

  

  set @sStringout = replace( @sStringout, char( 10 ), N'' )                       -- Remove 'enter'
  set @sStringout = replace( @sStringout, char( 13 ), N'' )                       -- Remove 'carriage return'
  set @sStringout = replace( @sStringout, char( 9 ), N'' )                        -- Remove 'tab'
  set @sStringout = replace( @sStringout, N'</div></td>', char( 9 ) )             -- Avoid extra 'enter' at the end of table cells
  set @sStringout = replace( @sStringout, N'</td>', char( 9 ) )                   -- Put a 'tab' between table cells
  set @sStringout = replace( @sStringout, N'</tr>', char( 10 ) )                  -- Start a new table row on a new line
  set @sStringout = replace( @sStringout, N'</table></div>', N'' )                -- Avoid extra 'enter' at the end of the table
  set @sStringout = replace( @sStringout, N'</p>', char( 10 ) )                   -- Start on a new line after a paragraph
  set @sStringout = replace( @sStringout, N'<ol>', char( 10 ) )                   -- Create an empty line before a list
  set @sStringout = replace( @sStringout, N'<ul>', char( 10 ) )                   -- Create an empty line before a list
  set @sStringout = replace( @sStringout, N'</ol>', char( 10 ) )                  -- Create an empty line after a list
  set @sStringout = replace( @sStringout, N'</ul>', char( 10 ) )                  -- Create an empty line after a list
  set @sStringout = replace( @sStringout, N'</div>', char( 10 ) )                 -- Start on a new line after a 'div'
  set @sStringout = replace( @sStringout, N'<br />', char( 10 ) )                 -- Start on a new line after a 'br'  
  set @sStringout = replace( @sStringout, N'<hr />', replicate( N'-', 50 ) )      -- Display a line
  set @sStringout = replace( @sStringout, N'<li>', N' * ' )                       -- Display a ' * ' before each item of a list
  set @sStringout = replace( @sStringout, N'<blockqu', char( 9 ) + N'<blockqu' )  -- Create a 'tab' as indent

  /* Trim all tags ( sub-strings starting with '<' and ending with '>' ). */
  while( 1 = 1 )
    begin
      set @nPos1 = charindex( N'<', @sStringout, @nPos1 )
      set @nPos2 = charindex( N'>', @sStringout, @nPos1 )
      if( @nPos1 = 0 or @nPos2 = 0 )
        begin
          break
        end
      set @sStringout = substring( @sStringout, 1, @nPos1 - 1 ) + substring( @sStringout, @nPos2 + 1, 32767 )
    end

  /* Replace special string '&lt;' with '<'. */
  set @sStringout = replace( @sStringout, N'&lt;', N'<' )

  /* Replace special string '&amp;' with '&'. */
  set @sStringout = replace( @sStringout, N'&amp;', N'&' )

  /* Replace special string '&nbsp;' with 'space'. */
  set @sStringout = replace( @sStringout, N'&nbsp;', N' ' )

  return @sStringout
end

GO
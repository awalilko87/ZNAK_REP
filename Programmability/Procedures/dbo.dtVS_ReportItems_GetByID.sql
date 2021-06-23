SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[dtVS_ReportItems_GetByID](
@_schema nvarchar(30) = 'DEFAULT',
@_parent nvarchar(30) = '%'
)
WITH ENCRYPTION
AS
  SELECT rowid, [schema], itemtype, name, parent, defname, value, [left], [top], width,
         height, fontfamily, fontsize, fontweight, color, backcolor, paddingtop,
         paddingbottom, paddingleft, paddingright, bordercolor, borderstyle,
         textdecoration, fontalign, borderwidth, underline, zindex
  FROM VS_ReportItems (nolock)
  WHERE [schema] LIKE @_schema AND parent LIKE @_parent
GO
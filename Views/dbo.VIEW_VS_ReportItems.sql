SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create view [dbo].[VIEW_VS_ReportItems]
as
select   
  I.rowid,  
  I.[schema],  
  I.LastUpdate,  
  I.UpdateInfo,  
  I.itemtype,  
  I.[name],  
  I.parent,  
  I.defname,  
  I.[value],  
  I.[left],  
  I.[top],  
  I.width,  
  I.height,  
  I.fontfamily,  
  I.fontsize,  
  I.fontweight,  
  I.color,  
  I.backcolor,  
  I.paddingtop,  
  I.paddingbottom,  
  I.paddingleft,  
  I.paddingright,  
  I.bordercolor,  
  I.borderstyle,  
  I.textdecoration,  
  I.fontalign,  
  I.borderwidth,  
  I.underline,  
  I.zindex,  
  I.UpdateUser,  
  I.note,  
  I.note1,  
  I.note2,  
  I.note3,
  F.FormID
    
from VS_ReportItems I(nolock)  
join VS_Forms F (nolock) on F.RdlSchemaId = I.[schema]
GO
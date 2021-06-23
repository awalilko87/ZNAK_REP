SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYS_RDL_CONF_Update](  
    @backcolor nvarchar(80) = NULL,  
    @OLD_backcolor nvarchar(80) = NULL,  
    @bordercolor nvarchar(80) = NULL,  
    @OLD_bordercolor nvarchar(80) = NULL,  
    @borderstyle nvarchar(80) = NULL,  
    @OLD_borderstyle nvarchar(80) = NULL,  
    @borderwidth nvarchar(80) = NULL,  
    @OLD_borderwidth nvarchar(80) = NULL,  
    @color nvarchar(80) = NULL,  
    @OLD_color nvarchar(80) = NULL,  
    @defname nvarchar(80) = NULL,  
    @OLD_defname nvarchar(80) = NULL,  
    @fontalign nvarchar(80) = NULL,  
    @OLD_fontalign nvarchar(80) = NULL,  
    @fontfamily nvarchar(80) = NULL,  
    @OLD_fontfamily nvarchar(80) = NULL,  
    @fontsize nvarchar(80) = NULL,  
    @OLD_fontsize nvarchar(80) = NULL,  
    @fontweight nvarchar(80) = NULL,  
    @OLD_fontweight nvarchar(80) = NULL,  
    @height nvarchar(80) = NULL,  
    @OLD_height nvarchar(80) = NULL,  
    @itemtype nvarchar(80) = NULL OUT,  
    @OLD_itemtype nvarchar(80) = NULL OUT,  
    @LastUpdate datetime = NULL,  
    @OLD_LastUpdate datetime = NULL,  
    @left nvarchar(80) = NULL,  
    @OLD_left nvarchar(80) = NULL,  
    @name nvarchar(80) = NULL OUT,  
    @OLD_name nvarchar(80) = NULL OUT,  
    @paddingbottom nvarchar(80) = NULL,  
    @OLD_paddingbottom nvarchar(80) = NULL,  
    @paddingleft nvarchar(80) = NULL,  
    @OLD_paddingleft nvarchar(80) = NULL,  
    @paddingright nvarchar(80) = NULL,  
    @OLD_paddingright nvarchar(80) = NULL,  
    @paddingtop nvarchar(80) = NULL,  
    @OLD_paddingtop nvarchar(80) = NULL,  
    @parent nvarchar(30) = NULL,  
    @OLD_parent nvarchar(30) = NULL,  
    @rowid int = NULL,  
    @OLD_rowid int = NULL,  
    @schema nvarchar(30) = NULL OUT,  
    @OLD_schema nvarchar(30) = NULL OUT,  
    @textdecoration nvarchar(80) = NULL,  
    @OLD_textdecoration nvarchar(80) = NULL,  
    @top nvarchar(80) = NULL,  
    @OLD_top nvarchar(80) = NULL,  
    @underline nvarchar(80) = NULL,  
    @OLD_underline nvarchar(80) = NULL,  
    @UpdateInfo nvarchar(255) = NULL,  
    @OLD_UpdateInfo nvarchar(255) = NULL,  
    @UpdateUser nvarchar(100) = NULL,  
    @OLD_UpdateUser nvarchar(100) = NULL,  
    @value nvarchar(512) = NULL,  
    @OLD_value nvarchar(512) = NULL,  
    @width nvarchar(80) = NULL,  
    @OLD_width nvarchar(80) = NULL,  
    @zindex nvarchar(80) = NULL,  
    @OLD_zindex nvarchar(80) = NULL,   
    @_UserID nvarchar(30),   
    @_GroupID nvarchar(20),   
    @_LangID varchar(10),
    @OLD_note nvarchar(4000) = NULL, 
    @note nvarchar(4000) = NULL
)  
AS  
BEGIN TRAN   
  
   
DECLARE @Msg nvarchar(500), @IsErr bit  
SELECT @Msg = '', @IsErr = 0   
   
begin try  
IF NOT EXISTS (SELECT * FROM VS_ReportItems WHERE [itemtype] = @itemtype AND [name] = @name AND [schema] = @schema)  
BEGIN  
INSERT INTO VS_ReportItems(  
    [backcolor], [bordercolor], [borderstyle], [borderwidth], [color], [defname], [fontalign], [fontfamily], [fontsize], [fontweight], [height], 
    [itemtype], [LastUpdate], [left], [name], [paddingbottom], [paddingleft], [paddingright], [paddingtop], [parent], [schema], [textdecoration], 
    [top], [underline], [UpdateInfo], [UpdateUser], [value], [width], [zindex]/*, [_UserID], [_GroupID], [_LangID]*/, [note])  
VALUES (  
    @backcolor, @bordercolor, @borderstyle, @borderwidth, @color, @defname, @fontalign, @fontfamily, @fontsize, @fontweight, @height, @itemtype, 
    @LastUpdate, @left, @name, @paddingbottom, @paddingleft, @paddingright, @paddingtop, @parent, @schema, @textdecoration, @top, @underline, 
    @UpdateInfo, @UpdateUser, @value, @width, @zindex/*, @_UserID, @_GroupID, @_LangID*/, @note)  
END   
ELSE   
BEGIN   
  UPDATE VS_ReportItems SET  
    [backcolor] = @backcolor, [bordercolor] = @bordercolor, [borderstyle] = @borderstyle, [borderwidth] = @borderwidth, [color] = @color, 
    [defname] = @defname, [fontalign] = @fontalign, [fontfamily] = @fontfamily, [fontsize] = @fontsize, [fontweight] = @fontweight, 
    [height] = @height, [itemtype] = @itemtype, [LastUpdate] = @LastUpdate, [left] = @left, [name] = @name, [paddingbottom] = @paddingbottom, 
    [paddingleft] = @paddingleft, [paddingright] = @paddingright, [paddingtop] = @paddingtop, [parent] = @parent, [schema] = @schema, 
    [textdecoration] = @textdecoration, [top] = @top, [underline] = @underline, [UpdateInfo] = @UpdateInfo, [UpdateUser] = @UpdateUser, 
    [value] = @value, [width] = @width, [zindex] = @zindex/*, [_UserID] = @_UserID, [_GroupID] = @_GroupID, [_LangID] = @_LangID*/, [note] = @note  
  WHERE [rowid] = @rowid  
END   
end try  
begin catch  
  select @Msg = ERROR_MESSAGE()  
  goto ERR  
end catch  
   
/* Error managment */  
IF @@TRANCOUNT>0 COMMIT TRAN  
   RETURN  
ERR:  
   IF @@TRANCOUNT>0 ROLLBACK TRAN  
      RAISERROR(@Msg, 16, 1)  

GO
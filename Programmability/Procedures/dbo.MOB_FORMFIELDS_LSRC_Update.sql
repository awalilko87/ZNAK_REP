SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[MOB_FORMFIELDS_LSRC_Update](
    @caption nvarchar(30),
    @OLD_caption nvarchar(30),
    @cvl int,
    @OLD_cvl int,
    @datatype nvarchar(30),
    @OLD_datatype nvarchar(30),
    @defaultsql nvarchar(4000),
    @OLD_defaultsql nvarchar(4000),
    @filter bit,
    @OLD_filter bit,
    @font nvarchar(30),
    @OLD_font nvarchar(30),
    @fontcolor nvarchar(30),
    @OLD_fontcolor nvarchar(30),
    @fontsize tinyint,
    @OLD_fontsize tinyint,
    @fontstyle nvarchar(30),
    @OLD_fontstyle nvarchar(30),
    @formguid  uniqueidentifier OUT,
    @OLD_formguid uniqueidentifier OUT,
    @height int,
    @OLD_height int,
    @iskey bit,
    @OLD_iskey bit,
    @ispicture bit,
    @OLD_ispicture bit,
    @isscanflag bit,
    @OLD_isscanflag bit,
    @lalignment nvarchar(30),
    @OLD_lalignment nvarchar(30),
    @left int,
    @OLD_left int,
    @lformat nvarchar(30),
    @OLD_lformat nvarchar(30),
    @lheight int,
    @OLD_lheight int,
    @listindex int,
    @OLD_listindex int,
    @lwidth int,
    @OLD_lwidth int,
    @multiline bit,
    @OLD_multiline bit,
    @name nvarchar(30) = NULL OUT,
    @OLD_name nvarchar(30) = NULL OUT,
    @orderby tinyint,
    @OLD_orderby tinyint,
    @recordindex int,
    @OLD_recordindex int,
    @required bit,
    @OLD_required bit,
    @rformat nvarchar(30),
    @OLD_rformat nvarchar(30),
    @roel bit,
    @OLD_roel bit,
    @roer bit,
    @OLD_roer bit,
    @roil bit,
    @OLD_roil bit,
    @roir bit,
    @OLD_roir bit,
    @rowguid uniqueidentifier,
    @OLD_rowguid uniqueidentifier,
    @showinputpanel bit,
    @OLD_showinputpanel bit,
    @slotype nvarchar(30),
    @OLD_slotype nvarchar(30),
    @slownik int,
    @OLD_slownik int,
    @tabname nvarchar(30),
    @OLD_tabname nvarchar(30),
    @top int,
    @OLD_top int,
    @vlist bit,
    @OLD_vlist bit,
    @vpic bit,
    @OLD_vpic bit,
    @vrecord bit,
    @OLD_vrecord bit,
    @width int,
    @OLD_width int, 
    @_UserID varchar(20), 
    @_GroupID varchar(20), 
    @_LangID varchar(10)
)
AS
BEGIN TRAN 
--IF @formguid is null
    --SET @formguid = NewID()
--IF @formguid =''
    --SET @formguid = NewID()
-- SET @formguid = @@IDENTITY
--IF @name is null
    --SET @name = NewID()
--IF @name =''
    --SET @name = NewID()
-- SET @name = @@IDENTITY
 
DECLARE @Msg nvarchar(500), @IsErr bit
SELECT @Msg = '', @IsErr = 0 
 
/* Error management */
IF @IsErr = 1
BEGIN
   SET @Msg = '<b>Komunikat bledu</b>'
   GOTO ERR
END
 
/* Generate number
IF 1=1 
  DECLARE @RC int, @Type nvarchar(50), @Pref nvarchar(50), @Suff nvarchar(50), @Number nvarchar(50), @No int
  SELECT @Type = 'DOC_TYPE', @Pref = '', @Suff='' /* + CONVERT(nvarchar(4),YEAR(@LOCAL_Date)) */
  EXECUTE @RC = [dbo].[VS_GetNumber] @Type, @Pref, @Suff, @Number OUTPUT, @No OUTPUT
  /* SET @LOCAL_Number = @Number */
  /* SET @LOCAL_No = @No */
END
*/
set @tabname = isnull(@tabname,'')

IF NOT EXISTS (SELECT * FROM MFormFields WHERE formguid = @formguid AND name = @name)
BEGIN
INSERT INTO MFormFields(
    [caption], [cvl], [datatype], [defaultsql], [filter], [font], [fontcolor], [fontsize], [fontstyle], [formguid], [height], [iskey], [ispicture], [isscanflag], [lalignment], [left], [lformat], [lheight], [listindex], [lwidth], [multiline], [name], [orderby], [recordindex], [required], [rformat], [roel], [roer], [roil], [roir], [rowguid], [showinputpanel], [slotype], [slownik], [tabname], [top], [vlist], [vpic], [vrecord], [width]/*, [_UserID], [_GroupID], [_LangID]*/
	,[filteroperator])
VALUES (
    @caption, @cvl, @datatype, @defaultsql, @filter, @font, @fontcolor, @fontsize, @fontstyle, @formguid, @height, @iskey, @ispicture, @isscanflag, @lalignment, @left, @lformat, @lheight, @listindex, @lwidth, @multiline, @name, @orderby, @recordindex, @required, @rformat, @roel, @roer, @roil, @roir, @rowguid, @showinputpanel, @slotype, @slownik, @tabname, @top, @vlist, @vpic, @vrecord, @width/*, @_UserID, @_GroupID, @_LangID*/
	,' like ''{0}%''')
END 
ELSE 
BEGIN 
UPDATE MFormFields SET
    [caption] = @caption, [cvl] = @cvl, [datatype] = @datatype, [defaultsql] = @defaultsql, [filter] = @filter, [font] = @font, [fontcolor] = @fontcolor, [fontsize] = @fontsize, [fontstyle] = @fontstyle, [formguid] = @formguid, [height] = @height, [iskey] = @iskey, [ispicture] = @ispicture, [isscanflag] = @isscanflag, [lalignment] = @lalignment, [left] = @left, [lformat] = @lformat, [lheight] = @lheight, [listindex] = @listindex, [lwidth] = @lwidth, [multiline] = @multiline, [name] = @name, [orderby] = @orderby, [recordindex] = @recordindex, [required] = @required, [rformat] = @rformat, [roel] = @roel, [roer] = @roer, [roil] = @roil, [roir] = @roir, [rowguid] = @rowguid, [showinputpanel] = @showinputpanel, [slotype] = @slotype, [slownik] = @slownik, [tabname] = @tabname, [top] = @top, [vlist] = @vlist, [vpic] = @vpic, [vrecord] = @vrecord, [width] = @width/*, [_UserID] = @_UserID, [_GroupID] = @_GroupID, [_LangID] = @_LangID*/ 
    ,[filteroperator] = ' like ''{0}%'''
    WHERE formguid = @formguid AND name = @name
END 
 
/* Error managment */
IF @@TRANCOUNT>0 COMMIT TRAN
   RETURN
ERR:
   IF @@TRANCOUNT>0 ROLLBACK TRAN
      RAISERROR(@Msg, 16, 1)

GO
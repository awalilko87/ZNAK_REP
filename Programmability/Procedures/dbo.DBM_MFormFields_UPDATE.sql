SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DBM_MFormFields_UPDATE](
    @rowguid uniqueidentifier, 
    @formguid uniqueidentifier, 
    @tabname nvarchar(30), 
    @name nvarchar(30), 
    @caption nvarchar(30), 
    @listindex int, 
    @recordindex int, 
    @top int, 
    @left int, 
    @width int, 
    @height int, 
    @vlist bit, 
    @vrecord bit, 
    @vpic bit, 
    @roer bit, 
    @roir bit, 
    @font nvarchar(30), 
    @fontcolor nvarchar(30), 
    @fontsize tinyint, 
    @fontstyle nvarchar(30), 
    @iskey bit, 
    @slownik int, 
    @lwidth int, 
    @lheight int, 
    @required bit, 
    @defaultsql nvarchar(4000), 
    @slotype nvarchar(30), 
    @cvl int, 
    @showinputpanel bit, 
    @filter bit, 
    @ispicture bit, 
    @multiline bit, 
    @isscanflag bit, 
    @lformat nvarchar(30), 
    @rformat nvarchar(30), 
    @lalignment nvarchar(30), 
    @roel bit, 
    @roil bit, 
    @datatype nvarchar(30), 
    @defaultsqledit nvarchar(4000), 
    @keyaction ntext, 
    @filteroperator nvarchar(30), 
    @orderby bit
) AS
IF NOT EXISTS (SELECT * FROM [MFormFields] WHERE [formguid] = @formguid AND [name] = @name)
    INSERT INTO [MFormFields] ([rowguid], [formguid], [tabname], [name], [caption], [listindex], [recordindex], [top], [left], [width], [height], [vlist], [vrecord], [vpic], [roer], [roir], [font], [fontcolor], [fontsize], [fontstyle], [iskey], [slownik], [lwidth], [lheight], [required], [defaultsql], [slotype], [cvl], [showinputpanel], [filter], [ispicture], [multiline], [isscanflag], [lformat], [rformat], [lalignment], [roel], [roil], [datatype], [defaultsqledit], [keyaction], [filteroperator], [orderby])
    VALUES (@rowguid, @formguid, @tabname, @name, @caption, @listindex, @recordindex, @top, @left, @width, @height, @vlist, @vrecord, @vpic, @roer, @roir, @font, @fontcolor, @fontsize, @fontstyle, @iskey, @slownik, @lwidth, @lheight, @required, @defaultsql, @slotype, @cvl, @showinputpanel, @filter, @ispicture, @multiline, @isscanflag, @lformat, @rformat, @lalignment, @roel, @roil, @datatype, @defaultsqledit, @keyaction, @filteroperator, @orderby)
ELSE
    UPDATE [MFormFields] SET [rowguid] = @rowguid, [formguid] = @formguid, [tabname] = @tabname, [name] = @name, [caption] = @caption, [listindex] = @listindex, [recordindex] = @recordindex, [top] = @top, [left] = @left, [width] = @width, [height] = @height, [vlist] = @vlist, [vrecord] = @vrecord, [vpic] = @vpic, [roer] = @roer, [roir] = @roir, [font] = @font, [fontcolor] = @fontcolor, [fontsize] = @fontsize, [fontstyle] = @fontstyle, [iskey] = @iskey, [slownik] = @slownik, [lwidth] = @lwidth, [lheight] = @lheight, [required] = @required, [defaultsql] = @defaultsql, [slotype] = @slotype, [cvl] = @cvl, [showinputpanel] = @showinputpanel, [filter] = @filter, [ispicture] = @ispicture, [multiline] = @multiline, [isscanflag] = @isscanflag, [lformat] = @lformat, [rformat] = @rformat, [lalignment] = @lalignment, [roel] = @roel, [roil] = @roil, [datatype] = @datatype, [defaultsqledit] = @defaultsqledit, [keyaction] = @keyaction, [filteroperator] = @filteroperator, [orderby] = @orderby WHERE [formguid] = @formguid AND [name] = @name
GO
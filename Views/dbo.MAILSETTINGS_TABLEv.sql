﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[MAILSETTINGS_TABLEv]  
as  
select  
 ROWID,  
 MAIE_LP = row_number() over (partition by 1 order by MAIE_FORMID),  
    MAIE_SUBJECT,  
    MAIE_HEADLINE,  
    MAIE_FOOTER,  
    MAIE_ACTIVE,  
    MAIE_RECEIVER = (select Email from SYUsersv WHERE UserID = MAIE_USERID),  
    MAIE_PROFIL,  
    MAIE_QUERYID,  
    MAIE_QUERY_DESC = (select SpyName from VS_DataSpy where DataSpyID = MAIE_QUERYID),  
    MAIE_FORMID,  
    MAIE_FORM_DESC = (select FormID +' - '+ FormDescription from dbo.VS_Forms where FormID = MAIE_FORMID),  
    MAIE_USERID,  
    MAIE_USER_DESC = (select UserName from SYUsersv WHERE UserID = MAIE_USERID),  
    MAIE_COLUMN_NAME,  
    MAIE_COLUMN_1,  
    MAIE_COLUMN_2,  
    MAIE_COLUMN_3,  
    MAIE_COLUMN_4,  
    MAIE_COLUMN_5,  
    MAIE_STYLE_1,  
    MAIE_STYLE_1_DESC = (SELECT COLUMN_NAME+ ' - ' +Caption FROM INFORMATION_SCHEMA.COLUMNS join VS_FORMFIELDS ON FieldID = COLUMN_NAME  
      WHERE COLUMN_NAME = MAIE_COLUMN_1 AND table_name = (select top 1 TableName From VS_Forms where FormID = MAIE_FORMID) AND NOTUSE = 0 AND GridColIndex > 0 AND GridColWidth > -1 AND formid = MAIE_FORMID),  
    MAIE_STYLE_2,  
    MAIE_STYLE_2_DESC = (SELECT COLUMN_NAME+ ' - ' +Caption FROM INFORMATION_SCHEMA.COLUMNS join VS_FORMFIELDS ON FieldID = COLUMN_NAME  
      WHERE COLUMN_NAME = MAIE_COLUMN_2 AND table_name = (select top 1 TableName From VS_Forms where FormID = MAIE_FORMID) AND NOTUSE = 0 AND GridColIndex > 0 AND GridColWidth > -1 AND formid = MAIE_FORMID),  
    MAIE_STYLE_3,  
    MAIE_STYLE_3_DESC = (SELECT COLUMN_NAME+ ' - ' +Caption FROM INFORMATION_SCHEMA.COLUMNS join VS_FORMFIELDS ON FieldID = COLUMN_NAME  
      WHERE COLUMN_NAME = MAIE_COLUMN_3 AND table_name = (select top 1 TableName From VS_Forms where FormID = MAIE_FORMID) AND NOTUSE = 0 AND GridColIndex > 0 AND GridColWidth > -1 AND formid = MAIE_FORMID),  
    MAIE_STYLE_4,  
    MAIE_STYLE_4_DESC = (SELECT COLUMN_NAME+ ' - ' +Caption FROM INFORMATION_SCHEMA.COLUMNS join VS_FORMFIELDS ON FieldID = COLUMN_NAME  
      WHERE COLUMN_NAME = MAIE_COLUMN_4  AND table_name = (select top 1 TableName From VS_Forms where FormID = MAIE_FORMID) AND NOTUSE = 0 AND GridColIndex > 0 AND GridColWidth > -1 AND formid = MAIE_FORMID),  
    MAIE_STYLE_5,  
    MAIE_STYLE_5_DESC = (SELECT COLUMN_NAME+ ' - ' +Caption FROM INFORMATION_SCHEMA.COLUMNS join VS_FORMFIELDS ON FieldID = COLUMN_NAME  
      WHERE COLUMN_NAME = MAIE_COLUMN_5  AND table_name = (select top 1 TableName From VS_Forms where FormID = MAIE_FORMID) AND NOTUSE = 0 AND GridColIndex > 0 AND GridColWidth > -1 AND formid = MAIE_FORMID),  
    MAIE_HEADLINE_BACKGROUND,  
    MAIE_FOOTER_BACKGROUND,  
    MAIE_HEADLINE_FONT_FACE,  
    MAIE_FOOTER_FONT_FACE,  
    MAIE_HEADLINE_FONT_SIZE,  
    MAIE_FOOTER_FONT_SIZE,  
    MAIE_HEADLINE_FONT_COLOR,  
    MAIE_FOOTER_FONT_COLOR,  
    MAIE_HEADLINE_BOLD,  
    MAIE_FOOTER_BOLD,  
    MAIE_HEADLINE_ITALICS,  
    MAIE_FOOTER_ITALICS,  
    MAIE_HEADLINE_UNDERLINE,  
    MAIE_FOOTER_UNDERLINE,  
    MAIE_HEADLINE_ALIGN,  
    MAIE_FOOTER_ALIGN,  
    MAIE_COL_1_FONT_FACE,  
    MAIE_COL_2_FONT_FACE,  
    MAIE_COL_3_FONT_FACE,  
    MAIE_COL_4_FONT_FACE,  
    MAIE_COL_5_FONT_FACE,  
    MAIE_COL_1_FONT_SIZE,  
    MAIE_COL_2_FONT_SIZE,  
    MAIE_COL_3_FONT_SIZE,  
    MAIE_COL_4_FONT_SIZE,  
    MAIE_COL_5_FONT_SIZE,  
    MAIE_COL_1_FONT_COLOR,  
    MAIE_COL_2_FONT_COLOR,  
    MAIE_COL_3_FONT_COLOR,  
    MAIE_COL_4_FONT_COLOR,  
    MAIE_COL_5_FONT_COLOR,  
    MAIE_COL_1_BOLD,  
    MAIE_COL_2_BOLD,  
    MAIE_COL_3_BOLD,  
    MAIE_COL_4_BOLD,  
    MAIE_COL_5_BOLD,  
    MAIE_COL_1_ITALICS,  
    MAIE_COL_2_ITALICS,  
    MAIE_COL_3_ITALICS,  
    MAIE_COL_4_ITALICS,  
    MAIE_COL_5_ITALICS,  
    MAIE_COL_1_UNDERLINE,  
    MAIE_COL_2_UNDERLINE,  
    MAIE_COL_3_UNDERLINE,  
    MAIE_COL_4_UNDERLINE,  
    MAIE_COL_5_UNDERLINE,  
    MAIE_COL_1_BACKGROUND,  
    MAIE_COL_2_BACKGROUND,  
    MAIE_COL_3_BACKGROUND,  
    MAIE_COL_4_BACKGROUND,  
    MAIE_COL_5_BACKGROUND,  
    MAIE_INTERVAL,  
    MAIE_GETDATE_LAST,  
    MAIE_INTERVAL_TIME,  
    MAIE_INTERVAL_DESC,  
    MAIE_LINK  
      
from MAILSETTINGS_TABLE  
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-------------------------------------------------------------------------------------------------

CREATE view [dbo].[MAILSETTINGSv]
as
SELECT [ROWID]
	  ,[MAIS_LP] = row_number() over (partition by 1 order by MAIS_ENT)
      ,[MAIS_ENT]
      ,[MAIS_TYPE]
      ,[MAIS_STATUS]
      ,[MAIS_SUBJECT]
      ,[MAIS_BODY]
      ,[MAIS_MAIPID]
      ,[MAIS_MAIP]= (select MAIP_NAME from MAILPROFILES mp where mp.ROWID = [MAILSETTINGS].[MAIS_MAIPID])
      ,[MAIS_RESPON]
      ,[MAIS_CREUSR]
      ,[MAIS_UPDUSR]
      ,[MAIS_TITLE]
      ,[MAIS_FOOTER]
      ,[MAIS_BODY_COLOUR]
      ,[MAIS_TITLE_COLOUR]
      ,[MAIS_FOOTER_COLOUR]
      ,[MAIS_DESC]
      ,[MAIS_TITLE_FONT_FACE]
      ,[MAIS_BODY_FONT_FACE]
      ,[MAIS_FOOTER_FONT_FACE]
      ,[MAIS_TITLE_FONT_SIZE]
      ,[MAIS_BODY_FONT_SIZE]
      ,[MAIS_FOOTER_FONT_SIZE]
      ,[MAIS_TITLE_BOLD]
      ,[MAIS_BODY_BOLD]
      ,[MAIS_FOOTER_BOLD]
      ,[MAIS_TITLE_ITALICS]
      ,[MAIS_BODY_ITALICS]
      ,[MAIS_FOOTER_ITALICS]
      ,[MAIS_TITLE_UNDERLINE]
      ,[MAIS_BODY_UNDERLINE]
      ,[MAIS_FOOTER_UNDERLINE]
      ,[MAIS_TITLE_ALIGN]
      ,[MAIS_BODY_ALIGN]
      ,[MAIS_FOOTER_ALIGN]
      ,[MAIS_TITLE_FONT_COLOR]
      ,[MAIS_BODY_FONT_COLOR]
      ,[MAIS_FOOTER_FONT_COLOR]
      ,[MAIS_CODE_COLOUR]
      ,[MAIS_CODE_FONT_FACE]
      ,[MAIS_CODE_FONT_SIZE]
      ,[MAIS_CODE_FONT_COLOR]
      ,[MAIS_CODE_ALIGN]
      ,[MAIS_CODE_BOLD]
      ,[MAIS_CODE_ITALICS]
      ,[MAIS_CODE_UNDERLINE]
      ,[MAIS_ACTIVE]
      ,[MAIS_ACTIVE_BANER]
      ,[MAIS_KPI_BANER_WIDTH]
	  ,[MAIS_MGTYPE]
	  ,[MAIS_REPORTNAME]
	  ,[MAIS_REPORTPARAMS]
  FROM [dbo].[MAILSETTINGS]


-------------------------------------------------------------------------------------------------
GO
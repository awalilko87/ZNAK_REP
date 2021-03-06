SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[MAILSETTINGS_LSRC_Update](
    @MAIS_BODY nvarchar(1000) = NULL, 
    @MAIS_ENT nvarchar(4) = NULL, 
    @MAIS_MAIPID int = NULL,  
    @MAIS_STATUS nvarchar(30) = NULL, 
    @MAIS_SUBJECT nvarchar(1000) = NULL, 
    @MAIS_TYPE nvarchar(30) = NULL, 
    @ROWID int = NULL OUTPUT, 
    --@MAIS_CREUSR int = NULL, 
    --@MAIS_UPDUSR int = NULL, 
    --@MAIS_RESPON int = NULL,
    @MAIS_DESC nvarchar(1000)= NULL,
    @MAIS_BODY_COLOUR nvarchar(30) = NULL,
    @MAIS_TITLE_COLOUR nvarchar(30) = NULL,
    @MAIS_FOOTER_COLOUR nvarchar(30) = NULL,
    @MAIS_TITLE nvarchar(500)= NULL,
    @MAIS_FOOTER nvarchar(500) = NULL,
    @MAIS_TITLE_FONT_FACE nvarchar(30) = NULL,
    @MAIS_BODY_FONT_FACE nvarchar(30) = NULL,
    @MAIS_FOOTER_FONT_FACE nvarchar(30) = NULL,
    @MAIS_TITLE_FONT_SIZE nvarchar(10) = NULL,
    @MAIS_BODY_FONT_SIZE nvarchar(10) = NULL,
    @MAIS_FOOTER_FONT_SIZE nvarchar(10) = NULL,
    @MAIS_TITLE_BOLD int,
    @MAIS_BODY_BOLD int,
    @MAIS_FOOTER_BOLD int,
    @MAIS_TITLE_ITALICS int,
    @MAIS_BODY_ITALICS int,
    @MAIS_FOOTER_ITALICS int,
    @MAIS_TITLE_UNDERLINE int,
    @MAIS_BODY_UNDERLINE int,
    @MAIS_FOOTER_UNDERLINE int,
    @MAIS_TITLE_ALIGN nvarchar(10),
    @MAIS_BODY_ALIGN nvarchar(10),
    @MAIS_FOOTER_ALIGN nvarchar(10),
    @MAIS_TITLE_FONT_COLOR nvarchar(30),
    @MAIS_BODY_FONT_COLOR nvarchar(30),
    @MAIS_FOOTER_FONT_COLOR nvarchar(30),
    @MAIS_CODE_COLOUR nvarchar(30),
    @MAIS_CODE_FONT_FACE nvarchar(30),
    @MAIS_CODE_FONT_SIZE nvarchar(10),
    @MAIS_CODE_FONT_COLOR nvarchar(30),
    @MAIS_CODE_ALIGN nvarchar(30),
    @MAIS_CODE_BOLD int,
    @MAIS_CODE_ITALICS int,
    @MAIS_CODE_UNDERLINE int,
    @MAIS_ACTIVE int,
    @MAIS_ACTIVE_BANER int,
    @MAIS_KPI_BANER_WIDTH int,
    --IntegrationManager
	@MAIS_MGTYPE nvarchar(10),
	@MAIS_REPORTNAME nvarchar(400),
	@MAIS_REPORTPARAMS nvarchar(200),

    @_UserID varchar(20), 
    @_GroupID varchar(10), 
    @_LangID varchar(20)
)
AS
BEGIN TRAN 
	--IF @ROWID is null
		--SET @ROWID = NewID()
	--IF @ROWID =''
		--SET @ROWID = NewID()
	-- SET @ROWID = @@IDENTITY
	 
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
	 
	IF NOT EXISTS (SELECT * FROM MAILSETTINGS WHERE ROWID = @ROWID)
	BEGIN
	INSERT INTO MAILSETTINGS(
		[MAIS_BODY], 
		--[MAIS_CREUSR], 
		[MAIS_ENT], 
		[MAIS_MAIPID], 
		--[MAIS_RESPON], 
		[MAIS_STATUS], 
		[MAIS_SUBJECT], 
		[MAIS_TYPE], 
		--[MAIS_UPDUSR],
		[MAIS_DESC],
		[MAIS_BODY_COLOUR],
		[MAIS_TITLE_COLOUR],
		[MAIS_FOOTER_COLOUR],
		[MAIS_TITLE],
		[MAIS_FOOTER],
		[MAIS_TITLE_FONT_FACE],
		[MAIS_BODY_FONT_FACE],
		[MAIS_FOOTER_FONT_FACE],
		[MAIS_TITLE_FONT_SIZE],
		[MAIS_BODY_FONT_SIZE],
		[MAIS_FOOTER_FONT_SIZE],
		[MAIS_TITLE_BOLD],
		[MAIS_BODY_BOLD],
		[MAIS_FOOTER_BOLD],
		[MAIS_TITLE_ITALICS],
		[MAIS_BODY_ITALICS],
		[MAIS_FOOTER_ITALICS],
		[MAIS_TITLE_UNDERLINE],
		[MAIS_BODY_UNDERLINE],
		[MAIS_FOOTER_UNDERLINE],
		[MAIS_TITLE_ALIGN],
		[MAIS_BODY_ALIGN],
		[MAIS_FOOTER_ALIGN],
		[MAIS_TITLE_FONT_COLOR],
		[MAIS_BODY_FONT_COLOR],
		[MAIS_FOOTER_FONT_COLOR],
		[MAIS_CODE_COLOUR],
		[MAIS_CODE_FONT_FACE],
		[MAIS_CODE_FONT_SIZE],
		[MAIS_CODE_FONT_COLOR],
		[MAIS_CODE_ALIGN],
		[MAIS_CODE_BOLD],
		[MAIS_CODE_ITALICS],
		[MAIS_CODE_UNDERLINE],
		[MAIS_ACTIVE],
		[MAIS_ACTIVE_BANER],
		[MAIS_KPI_BANER_WIDTH],
		--IntegrationManager
		[MAIS_MGTYPE],
		[MAIS_REPORTNAME],
		[MAIS_REPORTPARAMS]
		)
	VALUES (
		@MAIS_BODY, 
		--cast(@MAIS_CREUSR as int), 
		@MAIS_ENT, 
		@MAIS_MAIPID, 
		--cast(@MAIS_RESPON as int), 
		@MAIS_STATUS, 
		@MAIS_SUBJECT, 
		@MAIS_TYPE, 
		--cast(@MAIS_UPDUSR as int),
		@MAIS_DESC,
		@MAIS_BODY_COLOUR,
		@MAIS_TITLE_COLOUR,
		@MAIS_FOOTER_COLOUR,
		@MAIS_TITLE,
		@MAIS_FOOTER,
		@MAIS_TITLE_FONT_FACE,
		@MAIS_BODY_FONT_FACE,
		@MAIS_FOOTER_FONT_FACE,
		@MAIS_TITLE_FONT_SIZE,
		@MAIS_BODY_FONT_SIZE,
		@MAIS_FOOTER_FONT_SIZE,
		cast(@MAIS_TITLE_BOLD as int),
		cast(@MAIS_BODY_BOLD as int),
		cast(@MAIS_FOOTER_BOLD as int),
		cast(@MAIS_TITLE_ITALICS as int),
		cast(@MAIS_BODY_ITALICS as int),
		cast(@MAIS_FOOTER_ITALICS as int),
		cast(@MAIS_TITLE_UNDERLINE as int),
		cast(@MAIS_BODY_UNDERLINE as int),
		cast(@MAIS_FOOTER_UNDERLINE as int),
		@MAIS_TITLE_ALIGN,
		@MAIS_BODY_ALIGN,
		@MAIS_FOOTER_ALIGN,
		@MAIS_TITLE_FONT_COLOR,
		@MAIS_BODY_FONT_COLOR,
		@MAIS_FOOTER_FONT_COLOR,
		@MAIS_CODE_COLOUR,
		@MAIS_CODE_FONT_FACE,
		@MAIS_CODE_FONT_SIZE,
		@MAIS_CODE_FONT_COLOR,
		@MAIS_CODE_ALIGN,
		@MAIS_CODE_BOLD,
		@MAIS_CODE_ITALICS,
		@MAIS_CODE_UNDERLINE,
		@MAIS_ACTIVE,
		@MAIS_ACTIVE_BANER,
		@MAIS_KPI_BANER_WIDTH,
		--IntegrationManager
		@MAIS_MGTYPE,
		@MAIS_REPORTNAME,
		@MAIS_REPORTPARAMS

		)
		select @ROWID = scope_identity()
	END 
	ELSE 
	BEGIN 
	UPDATE MAILSETTINGS SET
		[MAIS_BODY] = @MAIS_BODY, 
		--[MAIS_CREUSR] = cast(@MAIS_CREUSR as int),
		[MAIS_ENT] = @MAIS_ENT, 
		[MAIS_MAIPID] = @MAIS_MAIPID, 
		--[MAIS_RESPON] = cast(@MAIS_RESPON as int), 
		[MAIS_STATUS] = @MAIS_STATUS, 
		[MAIS_SUBJECT] = @MAIS_SUBJECT, 
		[MAIS_TYPE] = @MAIS_TYPE, 
		--[MAIS_UPDUSR] = cast(@MAIS_UPDUSR as int),
		[MAIS_DESC] = @MAIS_DESC,
		[MAIS_BODY_COLOUR] = @MAIS_BODY_COLOUR,
		[MAIS_TITLE_COLOUR] = @MAIS_TITLE_COLOUR,
		[MAIS_FOOTER_COLOUR] = @MAIS_FOOTER_COLOUR,
		[MAIS_TITLE] = @MAIS_TITLE,
		[MAIS_FOOTER] = @MAIS_FOOTER,
		[MAIS_TITLE_FONT_FACE] = @MAIS_TITLE_FONT_FACE,
		[MAIS_BODY_FONT_FACE] = @MAIS_BODY_FONT_FACE,
		[MAIS_FOOTER_FONT_FACE] = @MAIS_FOOTER_FONT_FACE,
		[MAIS_TITLE_FONT_SIZE] = @MAIS_TITLE_FONT_SIZE,
		[MAIS_BODY_FONT_SIZE] = @MAIS_BODY_FONT_SIZE,
		[MAIS_FOOTER_FONT_SIZE] = @MAIS_FOOTER_FONT_SIZE,
		[MAIS_TITLE_BOLD] = cast(@MAIS_TITLE_BOLD as int),
		[MAIS_BODY_BOLD] = cast(@MAIS_BODY_BOLD as int),
		[MAIS_FOOTER_BOLD] = cast(@MAIS_FOOTER_BOLD as int),
		[MAIS_TITLE_ITALICS] = cast(@MAIS_TITLE_ITALICS as int),
		[MAIS_BODY_ITALICS] = cast(@MAIS_BODY_ITALICS as int),
		[MAIS_FOOTER_ITALICS] = cast(@MAIS_FOOTER_ITALICS as int),
		[MAIS_TITLE_UNDERLINE] = cast(@MAIS_TITLE_UNDERLINE as int),
		[MAIS_BODY_UNDERLINE] = cast(@MAIS_BODY_UNDERLINE as int),
		[MAIS_FOOTER_UNDERLINE] = cast(@MAIS_FOOTER_UNDERLINE as int),
		[MAIS_TITLE_ALIGN] = @MAIS_TITLE_ALIGN,
		[MAIS_BODY_ALIGN] = @MAIS_BODY_ALIGN,
		[MAIS_FOOTER_ALIGN] = @MAIS_FOOTER_ALIGN,
		[MAIS_TITLE_FONT_COLOR] = @MAIS_TITLE_FONT_COLOR,
		[MAIS_BODY_FONT_COLOR] = @MAIS_BODY_FONT_COLOR,
		[MAIS_FOOTER_FONT_COLOR] = @MAIS_FOOTER_FONT_COLOR,
		[MAIS_CODE_COLOUR] = @MAIS_CODE_COLOUR,
		[MAIS_CODE_FONT_FACE] = @MAIS_CODE_FONT_FACE,
		[MAIS_CODE_FONT_SIZE] = @MAIS_CODE_FONT_SIZE,
		[MAIS_CODE_FONT_COLOR] = @MAIS_CODE_FONT_COLOR,
		[MAIS_CODE_ALIGN] = @MAIS_CODE_ALIGN,
		[MAIS_CODE_BOLD] = @MAIS_CODE_BOLD,
		[MAIS_CODE_ITALICS] = @MAIS_CODE_ITALICS,
		[MAIS_CODE_UNDERLINE] = @MAIS_CODE_UNDERLINE,
		[MAIS_ACTIVE] = @MAIS_ACTIVE,
		[MAIS_ACTIVE_BANER] = @MAIS_ACTIVE_BANER,
		[MAIS_KPI_BANER_WIDTH] = @MAIS_KPI_BANER_WIDTH,
		--IntegrationManager
		[MAIS_MGTYPE] = @MAIS_MGTYPE,
		[MAIS_REPORTNAME] = @MAIS_REPORTNAME,
		[MAIS_REPORTPARAMS] = @MAIS_REPORTPARAMS
		WHERE ROWID = @ROWID
	END 
	 
/* Error managment */
IF @@TRANCOUNT>0 COMMIT TRAN
   RETURN
ERR:
   IF @@TRANCOUNT>0 ROLLBACK TRAN
      RAISERROR(@Msg, 16, 1)

GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_KPILSRC_Update](  
    @KPI_ACTIVE int = NULL,  
    @OLD_KPI_ACTIVE int = NULL,  
    @KPI_DEFIMAGE nvarchar(255) = NULL,  
    @OLD_KPI_DEFIMAGE nvarchar(255) = NULL,  
    @KPI_DESC nvarchar(80) = NULL,  
    @OLD_KPI_DESC nvarchar(80) = NULL,  
    @KPI_ID int = NULL OUT,  
    @OLD_KPI_ID int = NULL OUT,  
    @KPI_LINK nvarchar(max) = NULL,  
    @OLD_KPI_LINK nvarchar(max) = NULL,  
    @KPI_ORDER int = NULL,  
    @OLD_KPI_ORDER int = NULL,  
    @KPI_RPT nvarchar(max) = NULL,  
    @OLD_KPI_RPT nvarchar(max) = NULL,  
    @KPI_SOURCE nvarchar(max) = NULL,  
    @OLD_KPI_SOURCE nvarchar(max) = NULL,  
    @KPI_WHERE nvarchar(max) = NULL,  
    @OLD_KPI_WHERE nvarchar(max) = NULL,  
    @KPI_TYPE bit = NULL,
    @OLD_KPI_TYPE bit = NULL,
    @RPT_TYPE bit = NULL,
    @OLD_RPT_TYPE bit = NULL,
    @INBOX_TYPE bit = NULL,
    @OLD_INBOX_TYPE bit = NULL,
    @CHART_TYPE bit = NULL,
    @OLD_CHART_TYPE bit = NULL,
    @KPI_FORMID nvarchar(50) = NULL,
    @OLD_KPI_FORMID nvarchar(50) = NULL,
    @KPI_DATASPY nvarchar(100) = NULL,
    @OLD_KPI_DATASPY nvarchar(100) = NULL,
    @KPI_FONTSIZE int = NULL,
    @OLD_KPI_FONTSIZE int = NULL,
    @RSS_TYPE bit = null,
    @OLD_RSS_TYPE bit = null,
    @ROWID int = NULL,  
    @OLD_ROWID int = NULL,   
    @_UserID nvarchar(30),   
    @_GroupID nvarchar(20),   
    @_LangID varchar(10)  
)  
as  
BEGIN TRANSACTION   
BEGIN
	DECLARE @v_errorcode nvarchar(50)  
    DECLARE @v_syserrorcode nvarchar(4000)  
    DECLARE @v_errortext nvarchar(4000)  
    DECLARE @v_KPIID int  
  
	 IF((@RPT_TYPE = 1 AND (@KPI_TYPE = 1 OR @INBOX_TYPE = 1 OR @CHART_TYPE = 1 OR @RSS_TYPE = 1)) OR
       (@KPI_TYPE = 1 AND (@RPT_TYPE = 1 OR @INBOX_TYPE = 1 OR @CHART_TYPE = 1 OR @RSS_TYPE = 1)) OR
       (@INBOX_TYPE = 1 AND (@RPT_TYPE = 1 OR @KPI_TYPE = 1 OR @CHART_TYPE = 1 OR @RSS_TYPE = 1)) OR
       (@CHART_TYPE = 1 AND (@RPT_TYPE = 1 OR @KPI_TYPE = 1 OR @INBOX_TYPE = 1 OR @RSS_TYPE = 1)) OR
       (@RSS_TYPE = 1 AND (@RPT_TYPE = 1 OR @KPI_TYPE = 1 OR @INBOX_TYPE = 1 OR @CHART_TYPE = 1)))
  
	BEGIN
		rollback transaction  
		raiserror ('Należy wybrać tylko jeden typ prezentacji danych!', 16, 1)   
		return 1  
	END
	
	IF ((@RPT_TYPE = 0 AND @KPI_TYPE = 0 AND @INBOX_TYPE = 0 AND @CHART_TYPE = 0 AND @RSS_TYPE = 0))
	BEGIN
		rollback transaction  
		raiserror ('Należy wybrać typ prezentacji danych!', 16, 1)   
		return 1  
	END
	
	IF NOT EXISTS (SELECT null FROM dbo.VS_KPI (nolock) WHERE KPI_ID = @KPI_ID)  
	BEGIN  
		BEGIN TRY  
			INSERT INTO dbo.VS_KPI(  
			[KPI_ACTIVE], [KPI_DEFIMAGE], [KPI_DESC], [KPI_ID], [KPI_LINK], [KPI_ORDER], [KPI_RPT], [KPI_SOURCE], [KPI_WHERE],[KPI_TYPE], [RPT_TYPE], [INBOX_TYPE], [CHART_TYPE],
			[KPI_FORMID], [KPI_DATASPY], [KPI_FONTSIZE],[RSS_TYPE])  
			VALUES (  
			@KPI_ACTIVE, @KPI_DEFIMAGE, @KPI_DESC, @KPI_ID, @KPI_LINK, @KPI_ORDER, @KPI_RPT, @KPI_SOURCE, @KPI_WHERE, @KPI_TYPE, @RPT_TYPE, @INBOX_TYPE, @CHART_TYPE,
			@KPI_FORMID, @KPI_DATASPY, @KPI_FONTSIZE, @RSS_TYPE)  
	   
			SET @v_KPIID = null  
			SELECT @v_KPIID = ident_current('dbo.VS_KPI')  
			INSERT INTO dbo.VS_KPIRANGE (KPR_ID, KPR_KPIID, KPR_FROM, KPR_TO, KPR_IMAGE)  
			SELECT newid(), @v_KPIID, 0, 10, 'wskaznik.1.png'  
			UNION  
			SELECT newid(), @v_KPIID, 11, 25, 'wskaznik.2.png'  
			UNION  
			SELECT newid(), @v_KPIID, 26, 1000, 'wskaznik.3.png'  
		END TRY  
		BEGIN CATCH  
			SELECT @v_syserrorcode = error_message()  
			SELECT @v_errorcode = 'SYS_001'  
			goto errorlabel  
		END CATCH;   
	END   
	ELSE   
	BEGIN   
		BEGIN TRY  
			UPDATE dbo.VS_KPI   
			SET [KPI_ACTIVE] = @KPI_ACTIVE, [KPI_DEFIMAGE] = @KPI_DEFIMAGE, [KPI_DESC] = @KPI_DESC, [KPI_ID] = @KPI_ID,
			    [KPI_LINK] = @KPI_LINK, [KPI_ORDER] = @KPI_ORDER, [KPI_RPT] = @KPI_RPT, [KPI_SOURCE] = @KPI_SOURCE,
			    [KPI_WHERE] = @KPI_WHERE, [KPI_TYPE] = @KPI_TYPE, [RPT_TYPE] = @RPT_TYPE, [INBOX_TYPE] = @INBOX_TYPE,
			    [CHART_TYPE] = @CHART_TYPE, [KPI_FORMID] = @KPI_FORMID, [KPI_DATASPY] = @KPI_DATASPY, [KPI_FONTSIZE] = @KPI_FONTSIZE,
			    [RSS_TYPE] = @RSS_TYPE
			WHERE KPI_ID = @KPI_ID  
		END TRY  
		BEGIN CATCH  
			SELECT @v_syserrorcode = error_message()  
			SELECT @v_errorcode = 'SYS_002'  
			GOTO errorlabel  
		END CATCH;  
	END   
COMMIT TRANSACTION  
RETURN 0  
errorlabel:  
 rollback transaction  
    exec err_proc @v_errorcode, @v_syserrorcode, @_UserID, @v_errortext output  
 raiserror (@v_errortext, 16, 1)   
    return 1  
END
GO
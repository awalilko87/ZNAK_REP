SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_AddToolbar](
	@FormID nvarchar(50),
	@Size int = 16)
AS
DECLARE @RC int
, @FieldID nvarchar(50), @Caption nvarchar(500), @CaptionStyle nvarchar(500), @FieldName nvarchar(200), @TableName nvarchar(50)
, @IsPK bit, @ControlType nvarchar(50), @CaptionWidth int, @ControlWidth int, @NoColumn int, @NoRow int, @NoColspan int
, @Require bit, @RequireQuery nvarchar(150), @ControlSource nvarchar(4000), @ControlStyle nvarchar(4000), @Visible bit, @VisibleQuery nvarchar(150), @ReadOnly bit
, @ReadOnlyQuery nvarchar(150), @DefaultValue nvarchar(150), @DataType nvarchar(50), @DataTypeSQL nvarchar(50), @Length int, @ValidateQuery nvarchar(150)
, @TextRows int, @TextColumns int, @Tooltip nvarchar(150), @GridPk bit, @GridColIndex int, @GridColWidth int, @NotUse bit
, @AllowSort bit, @AllowFilter bit, @DisplayFieldFormat nvarchar(50), @DisplayGridFormat nvarchar(50), @ValidateErrMessage nvarchar(150)
, @GridColCaption nvarchar(50), @GridColCaptionStyle nvarchar(500), @CallbackMessage nvarchar(50), @CallbackQuery nvarchar(150), @GridAllign nvarchar(10)
, @CaptionAlign nvarchar(10), @ControlAlign nvarchar(10), @PanelGroup nvarchar(2), @FieldDesc nvarchar(150), @AllowReportParam bit, @TextTransform int
, @ControlHeight int, @InputMask nvarchar(100), @Autopostback bit, @UserID nvarchar(30), @LangID nvarchar(10)
, @RegisterInJS bit, @JSVariable nvarchar(50), @TLType int, @ExFromWhere bit, @TreePK bit, @IsFilter bit, @ACEnable bit
, @ServicePath nvarchar(100), @ServiceMethod nvarchar(100), @MinimumPrefixLength int, @CompletionSetCount int
, @ACSql nvarchar(4000), @OnChange nvarchar(150), @Is2Dir bit, @lPath nvarchar(150)

-- TODO: Set parameter values here.
SET @FieldName ='' SET @IsPK =0 SET @CaptionWidth = 0 SET @NoColspan = 0
SET @Require = 0 SET @RequireQuery = '' SET @Visible = 1 SET @VisibleQuery = '' SET @ReadOnly = 0
SET @ReadOnlyQuery = '' SET @DefaultValue = '' SET @DataType = '' SET @DataTypeSQL = '' SET @Length = 0
SET @ValidateQuery = '' SET @TextRows = 0 SET @TextColumns = 0 SET @GridPk = 0 SET @GridColIndex = 0
SET @GridColWidth = 0 SET @NotUse = 0 SET @AllowSort = 0 SET @AllowFilter = 0 SET @DisplayFieldFormat = ''
SET @DisplayGridFormat = '' SET @ValidateErrMessage = '' SET @GridColCaption = '' SET @CallbackMessage = ''
SET @CallbackQuery = '' SET @GridAllign = '' SET @CaptionAlign = '' SET @ControlAlign = '' SET @PanelGroup = '0' 
SET @AllowReportParam = 0  SET @TextTransform = 0  SET @InputMask = ''  SET @Autopostback = 0 
SET @UserID = null  SET @LangID = null  SET @RegisterInJS = 0  SET @JSVariable = ''  SET @TLType= 0 
SET @ExFromWhere = 0 SET @TreePK = 0 SET @IsFilter = 0 SET @ACEnable = 0 SET @ServicePath = ''
SET @ServiceMethod = '' SET @MinimumPrefixLength = 0 SET @CompletionSetCount = 0 SET @ACSql = ''
SET @OnChange = '' SET @Is2Dir = 0

/*ustalenie rozmiaru */
IF @Size = 0 SET @Size = 24
SET @lPath = '/Images/OfficeInfor/'

/* Inne dla kazdego przycisku */

/* Odśwież */
SET @FieldID = 'TLB_REFRESH' --nvarchar(50)
SET @Caption = @lPath + 'Document-Exchange-02.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'r'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''REFRESH''' --ntext
SET @Tooltip = 'Odśwież dane'
SET @ControlSource = 'REFRESH;'
SET @NoColumn = 1 
SET @NoRow = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir


/* NOWY */
SET @FieldID = 'TLB_ADDNEW' --nvarchar(50)
SET @Caption =  @lPath + 'Document-Add-02.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'n'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''ADDNEW''' --ntext
SET @Tooltip = 'Dodaj'
SET @ControlSource = 'ADDNEW;'
SET @NoColumn = 2 
SET @NoRow = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable, @ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir


  -- @FieldID OUTPUT  ,@FormID OUTPUT  ,@Caption  , @CaptionStyle, @FieldName  ,@TableName  ,@IsPK  ,@ControlType  ,@CaptionWidth
  --,@ControlWidth  ,@NoColumn  ,@NoRow  ,@NoColspan  ,@Require  ,@RequireQuery  ,@ControlSource  , @ControlStyle, @Visible
  --,@VisibleQuery  ,@ReadOnly  ,@ReadOnlyQuery  ,@DefaultValue  ,@DataType  ,@DataTypeSQL  ,@Length  ,@ValidateQuery
  --,@TextRows  ,@TextColumns  ,@Tooltip  ,@GridPk  ,@GridColIndex  ,@GridColWidth  ,@NotUse  ,@AllowSort  ,@AllowFilter
  --,@DisplayFieldFormat  ,@DisplayGridFormat  ,@ValidateErrMessage  ,@GridColCaption  , @GridColCaptionStyle, @CallbackMessage  ,@CallbackQuery
  --,@GridAllign  ,@CaptionAlign  ,@ControlAlign, @PanelGroup  ,@FieldDesc  ,@AllowReportParam  ,@TextTransform  ,@ControlHeight  ,@InputMask
  --,@Autopostback  ,@UserID  ,@LangID  ,@RegisterInJS  ,@JSVariable  ,@TLType  ,@ExFromWhere  ,@TreePK  ,@IsFilter
  --,@ACEnable, @MinimumPrefixLength  ,@CompletionSetCount  ,@ACSql  ,@OnChange  ,@Is2Dir

/* USUŃ */
SET @FieldID = 'TLB_DELETE' --nvarchar(50)
SET @Caption =  @lPath + 'Garbage.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight =@Size --int
SET @TableName = 'd'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''DELETE''' --ntext
SET @Tooltip = 'Usuń'
SET @ControlSource = 'DELETE;'
SET @NoColumn = 3
SET @NoRow = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir

/* ZAPISZ */
SET @FieldID = 'TLB_SAVE' --nvarchar(50)
SET @Caption =  @lPath +'Save.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 's'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''SAVE''' --ntext
SET @Tooltip = 'Zapisz'
SET @ControlSource = 'SAVE;'
SET @NoColumn = 4
SET @NoRow = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir
  
/* PRINT */
SET @FieldID = 'TLB_PRINT' --nvarchar(50)
SET @Caption =  @lPath + 'Printer.png' -- nvarchar(500)
SET @ControlType ='IMR'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'p'
SET @FieldDesc = 'Przycisk graficzny wywolujacy raport' --ntext
SET @Tooltip = 'Drukuj'
SET @ControlSource = ''
SET @NoColumn = 5
SET @NoRow = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir

/* Strzałka na koniec */
SET @FieldID = 'TLB_FIRST' --nvarchar(50)
SET @Caption =  @lPath + 'Previous.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'f'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVE_FIRST''' --ntext
SET @Tooltip = 'Pierwszy'
SET @ControlSource = 'MOVEFIRST;'
SET @NoColumn = 6
SET @NoRow = 1
SET @NotUse = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir

/* Strzałka w lewo */
SET @FieldID = 'TLB_PREV' --nvarchar(50)
SET @Caption =  @lPath + 'Previous.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'l'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVE_PREV''' --ntext
SET @Tooltip = 'Wstecz'
SET @ControlSource = 'MOVEPREV;'
SET @NoColumn = 7
SET @NoRow = 1
SET @NotUse = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount, @ACSql, @OnChange, @Is2Dir

/* Strzałka w Prawo */
SET @FieldID = 'TLB_NEXT' --nvarchar(50)
SET @Caption =  @lPath +'Next.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'p'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVE_NEXT''' --ntext
SET @Tooltip = 'Dalej'
SET @ControlSource = 'MOVENEXT;'
SET @NoColumn = 8
SET @NoRow = 1
SET @NotUse = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount,  @ACSql, @OnChange, @Is2Dir

/* Strzałka na koniec */
SET @FieldID = 'TLB_LAST' --nvarchar(50)
SET @Caption =  @lPath +'Next.png' -- nvarchar(500)
SET @ControlType ='IMC'
SET @ControlWidth = @Size
SET @ControlHeight = @Size --int
SET @TableName = 'o'
SET @FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVE_LAST''' --ntext
SET @Tooltip = 'Ostatni'
SET @ControlSource = 'MOVELAST;'
SET @NoColumn = 9
SET @NoRow = 1
SET @NotUse = 1

EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
    @ExFromWhere,@TreePK, @IsFilter, @ACEnable,	@ServicePath,@ServiceMethod,@MinimumPrefixLength,
    @CompletionSetCount,  @ACSql, @OnChange, @Is2Dir

/* Linia pod toolbarem */
--SET @FieldID = 'TLB_HR' --nvarchar(50)
--SET @Caption = '<hr />' -- nvarchar(500)
--SET @ControlType ='LBL'
--SET @ControlWidth = 0
--SET @ControlHeight = 1 --int
--SET @TableName = ''
--SET @FieldDesc = 'Linia - ozdoba' --ntext
--SET @Tooltip = ''
--SET @ControlSource = ''
--SET @NoColumn = 1
--SET @NoRow = 2
--SET @NoColspan = 5
--SET @CaptionWidth= 110
--SET @NotUse = 1

--EXECUTE @RC = [VS_FormFields_Update] @FieldID OUT, @FormID OUT, @Caption, @CaptionStyle, @FieldName, @TableName,
--    @IsPK,@ControlType,@CaptionWidth ,@ControlWidth ,@NoColumn ,@NoRow ,@NoColspan ,@Require,@RequireQuery,@ControlSource,@ControlStyle,
--    @Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,@DefaultValue,@DataType,@DataTypeSQL,@Length ,@ValidateQuery,@TextRows ,@TextColumns ,
--    @Tooltip,@GridPk,@GridColIndex ,@GridColWidth ,@NotUse,@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,
--    @GridColCaption,@GridColCaptionStyle,@CallbackMessage,@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,
--    @AllowReportParam,@TextTransform ,@ControlHeight ,@InputMask,@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType ,
--    @ExFromWhere,@TreePK, @IsFilter, @ACEnable, @ServicePath,@ServiceMethod,@MinimumPrefixLength,
--    @CompletionSetCount,  @ACSql, @OnChange, @Is2Dir

GO
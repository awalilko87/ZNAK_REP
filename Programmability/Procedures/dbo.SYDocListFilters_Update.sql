SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListFilters_Update](
    @FilterID nvarchar(50) OUT,
    @DocTypeID nvarchar(50),
    @LabelText nvarchar(100),
    @LabelWidth bigint,
    @FilterType nvarchar(50),
    @FilterWidth bigint,
    @DefaultValue nvarchar(1000),
    @FilterOrder int,
    @Visible bit,
    @Roles nvarchar(2000),
    @DataSource nvarchar(max),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FilterID is null
    SET @FilterID = NewID()
IF @FilterID =''
    SET @FilterID = NewID()

IF NOT EXISTS (SELECT * FROM SYDocListFilters WHERE FilterID = @FilterID)
BEGIN
    INSERT INTO SYDocListFilters(
        FilterID, DocTypeID, LabelText, LabelWidth, FilterType,
        FilterWidth, DefaultValue, FilterOrder, Visible, Roles,
        DataSource /*, _USERID_ */ )
    VALUES (
        @FilterID, @DocTypeID, @LabelText, @LabelWidth, @FilterType,
        @FilterWidth, @DefaultValue, @FilterOrder, @Visible, @Roles,
        @DataSource /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYDocListFilters SET
        DocTypeID = @DocTypeID, LabelText = @LabelText, LabelWidth = @LabelWidth, FilterType = @FilterType, FilterWidth = @FilterWidth,
        DefaultValue = @DefaultValue, FilterOrder = @FilterOrder, Visible = @Visible, Roles = @Roles, DataSource = @DataSource /* , _USERID_ = @_USERID_ */ 
        WHERE FilterID = @FilterID
END
GO
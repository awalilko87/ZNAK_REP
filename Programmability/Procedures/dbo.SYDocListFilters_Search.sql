SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListFilters_Search](
    @FilterID nvarchar(50),
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

    SELECT
        FilterID, DocTypeID, LabelText, LabelWidth, FilterType,
        FilterWidth, DefaultValue, FilterOrder, Visible, Roles,
        DataSource /*, _USERID_ */ 
    FROM SYDocListFilters
            /* WHERE DocTypeID = @DocTypeID AND LabelText = @LabelText AND LabelWidth = @LabelWidth AND FilterType = @FilterType AND FilterWidth = @FilterWidth AND
            DefaultValue = @DefaultValue AND FilterOrder = @FilterOrder AND Visible = @Visible AND Roles = @Roles AND DataSource = @DataSource /*  AND _USERID_ = @_USERID_ */ */
GO
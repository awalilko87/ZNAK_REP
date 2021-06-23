SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_GetByID](
    @MenuID nvarchar(50) = '%',
    @TabName nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
	WITH LANGS AS(
		SELECT 
		 LM.Caption,
		 LM.ObjectID,
		 LM.ControlID,
		 U.UserID
        FROM VS_LangMsgs LM
          JOIN SYUsers U ON LM.[LangID] = U.[LangID]
        WHERE LM.ObjectType = 'TAB' 
        AND isnull(LM.Caption,'') <> ''
	)
    SELECT
        T.MenuID, T.TabName, T.MenuKey, coalesce(LM.Caption, T.TabCaption) as TabCaption, T.FormID, T.Parameters, T.TabTooltip,
        T.Visible, T.TabOrder, T.TabType, T.NoUsed /*, _USERID_ */ 
    FROM VS_Tabs T
		left join LANGS LM ON LM.ObjectID = T.MenuID AND LM.ControlID = T.TabName AND LM.UserID = @_USERID_
    WHERE MenuID LIKE @MenuID AND TabName LIKE @TabName
GO
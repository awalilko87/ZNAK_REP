SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_KpiMessages_GetNewByUser](
    @UserID nvarchar(30),
    @GroupId nvarchar(20)
    )
WITH ENCRYPTION
AS
		SELECT * FROM (
		SELECT MessId, Mess, UserID, GroupId, CreaDate, Flag
		FROM VS_KpiMessages(NOLOCK)
		WHERE (UserID IS NOT NULL) AND (GroupId IS NOT NULL) 
			AND ((UserID IN (@UserID, '*')) OR (GroupId IN (@GroupId, '*')))
			AND Flag = 1
		UNION
			SELECT MessId, Mess, UserID, GroupId, CreaDate, Flag
			FROM VS_KpiMessages(NOLOCK)
			WHERE (UserID IS NOT NULL) AND (GroupId IS NULL) 
				AND(UserID IN (@UserID, '*'))
				AND Flag = 1
		UNION
			SELECT MessId, Mess, UserID, GroupId, CreaDate, Flag
			FROM VS_KpiMessages(NOLOCK)
			WHERE (UserID IS NULL) AND (GroupId IS NOT NULL) 
				AND (GroupId IN (@GroupId, '*'))
				AND Flag = 1
		)AA 
		ORDER BY AA.CreaDate DESC
GO
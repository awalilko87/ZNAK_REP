SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_KpiMessages_Update](
	  @MessId int, 
      @Mess nvarchar(4000), 
      @UserID nvarchar(30), 
      @GroupId nvarchar(20), 
      @CreaDate datetime,
      @Flag int
      )
WITH ENCRYPTION
AS
	IF NOT EXISTS (SELECT * FROM VS_KpiMessages(NOLOCK) WHERE MessId = @MessId)
	BEGIN
			INSERT INTO VS_KpiMessages(MessId, Mess, UserID, GroupId, CreaDate, Flag)
			VALUES(@MessId, @Mess, @UserID, @GroupId, @CreaDate, @Flag)
	END
	ELSE
	BEGIN
		UPDATE VS_KpiMessages SET Mess = @Mess, UserID = @UserID, GroupId = @GroupId, CreaDate = @CreaDate, Flag = @Flag
		WHERE MessId = @MessId
	END
GO
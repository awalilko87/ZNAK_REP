SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MRegisterDevice](@DevID NVARCHAR(255), @DevName NVARCHAR(30))
AS
BEGIN
	SET @DevName = isnull(@DevName,'PoketPC')

	IF NOT EXISTS (SELECT 1 FROM MDevices WHERE deviceid = @DevID AND code = @DevName)
	BEGIN
		INSERT INTO dbo.MDevices(deviceid, code, rowguid)
		SELECT @DevID, @DevName, newid()
	END

	IF NOT EXISTS (SELECT 1 FROM MDev2Org WHERE deviceguid in (SELECT rowguid FROM MDevices WHERE deviceid = @DevID))
	AND (SELECT COUNT(1) FROM MOrg) = 1
	BEGIN
		INSERT INTO MDev2Org (rowguid, deviceguid, orgguid)
		SELECT NEWID(), d.rowguid, o.rowguid
		FROM dbo.MDevices d
		CROSS APPLY
		(SELECT TOP 1 rowguid FROM MOrg)o
	END
END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_RdlUserLayout_Update](
    @Rowid int output,
    @FormID nvarchar(50),
    @SchemaID nvarchar(30), 
    @SchemaData xml,
    @UserID nvarchar(30) = null,
    @IsDefault bit,
    @IsLastPreset bit
)
WITH ENCRYPTION
AS

IF isnull(@FormID,'') = '' begin
    RAISERROR('@FormID NIE MOZE BYC PUSTY',16,1)
    RETURN
end
IF isnull(@SchemaID,'') = '' begin
    RAISERROR('@SchemaID NIE MOZE BYC PUSTY',16,1)
    RETURN
end


IF (isnull(@Rowid,0) = 0)
BEGIN
    IF EXISTS (select null from dbo.VS_RdlUserLayout where FormID = @FormID and UserID = @UserID and SchemaID = @SchemaID)
    BEGIN
      DECLARE @MSG NVARCHAR(30)
      IF @UserID = '%' BEGIN
        SELECT @MSG = L.Caption
		FROM VS_LangMsgs L
		WHERE L.ObjectID = 'RdlReport_SCHEMAID_EXISTS'
		AND L.LangID = 'PL'
      END ELSE BEGIN
		SELECT @MSG = L.caption 
		FROM VS_LangMsgs L
	      JOIN SY_Users U ON U.LangID = L.LangID
		WHERE L.objectid = 'RdlReport_SCHEMAID_EXISTS'
		AND U.UserID = @UserID
      END
      --select * form sy_users
      RAISERROR('%s',16,1,@MSG)
      return 1
    END

    INSERT INTO VS_RdlUserLayout( FormID, SchemaID, SchemaData, UserID, IsDefault, IsLastPreset )
    VALUES ( @FormID, @SchemaID, @SchemaData, @UserID, @IsDefault, @IsLastPreset )
    
    SELECT @Rowid = SCOPE_IDENTITY()
    
    IF @IsLastPreset = 1 BEGIN
	    UPDATE VS_RdlUserLayout set IsLastPreset = 0 WHERE FormID = @FormID AND UserID = @UserID AND Rowid <> @Rowid
	  END
END
ELSE
BEGIN
    UPDATE VS_RdlUserLayout 
    SET FormID = @FormID, 
		SchemaID = @SchemaID, 
		SchemaData = @SchemaData, 
		UserID = @UserID,
		IsDefault = @IsDefault,
		IsLastPreset = @IsLastPreset
    WHERE Rowid = @Rowid
    
    IF @IsLastPreset = 1 BEGIN
	  UPDATE VS_RdlUserLayout set IsLastPreset = 0 WHERE FormID = @FormID AND UserID = @UserID AND Rowid <> @Rowid
	END
END
GO
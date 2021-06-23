﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[ZWFOT_TEMPLATEInsUpd](  
 @_UserID nvarchar(30)  
,@OT11_ZMT_ROWID int  
,@OT11_NAME nvarchar(30)  
)  
AS  
 BEGIN   
  IF not exists (SELECT 1 FROM dbo.ZWFOT_TEMPLATE WHERE OTID = @OT11_ZMT_ROWID AND USERID = @_UserID)  
   BEGIN  
    INSERT INTO dbo.ZWFOT_TEMPLATE (USERID, OTID, [NAME])  
    VALUES (@_UserID, @OT11_ZMT_ROWID, @OT11_NAME)  
   END  
  ELSE  
   BEGIN  
    DELETE FROM dbo.ZWFOT_TEMPLATE WHERE OTID = @OT11_ZMT_ROWID AND USERID = @_UserID  
   END  
  
   RaisError('Szablon zapisany poprawnie',1,1)  
  
 END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
  
CREATE PROCEDURE [dbo].[SYS_KPI_MultiSelect](  
    @p_PAR varchar(8000) = NULL,  
    @p_Source nvarchar(30),  
    @p_Action int  
)  
AS  
BEGIN  
  
DECLARE @v_errorcode nvarchar(50)  
DECLARE @v_syserrorcode nvarchar(4000)  
DECLARE @v_errortext nvarchar(4000)  
DECLARE @v_errorid int 
DECLARE @v_KPIORDER int 
DECLARE @dataSpyID nvarchar(50)
DECLARE @newDataSpyID nvarchar(50)
DECLARE @newSpyName nvarchar(100)
    
DECLARE @cr_ID int, @cr_Key nvarchar(20), @cr_KPIID int  
  
DECLARE c CURSOR FOR  
SELECT A.ID, A.S1, B.S2 FROM   
(SELECT ind ID, String S1 FROM dbo.VS_Split2(@p_PAR,';') WHERE ind%2 = 0) A  
 INNER JOIN  
(SELECT ind+1 ID, String S2 FROM dbo.VS_Split2(@p_PAR,';') WHERE ind%2 <> 0) B  
ON A.ID = B.ID 
  
IF ISNULL(@p_PAR,'') = ''  
BEGIN  
  SELECT @v_errorcode = 'SYS_010' -- nie wybrano zadego rekordu  
  GOTO errorlabel  
END  
    
OPEN c  
FETCH NEXT FROM c INTO @cr_ID, @cr_Key, @cr_KPIID  
WHILE @@FETCH_STATUS = 0  
BEGIN  
  SELECT @v_KPIORDER = null
  SELECT @v_KPIORDER = KPI_ORDER from VS_KPI(nolock) where ROWID = @cr_KPIID
  SET @dataSpyID = (SELECT KPI_DATASPY FROM dbo.VS_KPI (nolock) WHERE ROWID = @cr_KPIID)
  BEGIN TRY  
  IF @p_Source = 'User'  
  BEGIN  
	IF @p_Action = 1  
	BEGIN   
		IF NOT EXISTS(SELECT null FROM dbo.VS_KPIUSERS (nolock) WHERE KPU_KPIID = @cr_KPIID AND KPU_USERID = @cr_Key)  
			INSERT INTO dbo.VS_KPIUSERS (KPU_KPIID, KPU_USERID, KPU_ORDER) VALUES (@cr_KPIID, @cr_Key, @v_KPIORDER)  
			
		--Dodanie DataSpy dla Usera 
		IF(@dataSpyID IS NOT NULL)
		BEGIN
			IF NOT EXISTS(SELECT null FROM dbo.VS_DataSpy (nolock) WHERE DataSpyID = @dataSpyID AND UserID = @cr_Key)
			BEGIN
				IF NOT EXISTS(SELECT null FROM dbo.VS_DataSpyUsers (nolock) WHERE DataSpyID = @dataSpyID AND UserOrGroupID = @cr_Key AND [Type] = 'U')
				BEGIN
					INSERT INTO dbo.VS_DataSpyUsers (DataSpyID, UserOrGroupID, [Type]) VALUES (@dataSpyID, @cr_Key, 'U')
				END
			END
		END
	END   
	IF @p_Action = 0  
	BEGIN  
		DELETE FROM dbo.VS_KPIUSERS WHERE KPU_KPIID = @cr_KPIID AND KPU_USERID = @cr_Key
		
		--Usunięcie DataSpy dla Usera
		IF(@dataSpyID IS NOT NULL)
		BEGIN
			IF EXISTS(SELECT null FROM dbo.VS_DataSpyUsers (nolock) WHERE DataSpyID = @dataSpyID AND UserOrGroupID = @cr_Key AND [Type] = 'U')
			BEGIN
				DELETE FROM dbo.VS_DataSpyUsers WHERE DataSpyID = @dataSpyID AND UserOrGroupID = @cr_Key AND [Type] = 'U'
			END
		END	   
	END  
 END  
 ELSE IF @p_Source = 'Group'  
 BEGIN  
	IF @p_Action = 1  
	BEGIN   
		IF NOT EXISTS (SELECT null FROM dbo.VS_KPIUSERSGROUP (nolock) WHERE KPG_KPIID = @cr_KPIID AND KPG_GROUPID = @cr_Key)  
		INSERT INTO dbo.VS_KPIUSERSGROUP (KPG_KPIID, KPG_GROUPID) VALUES (@cr_KPIID, @cr_Key)
    
		INSERT INTO dbo.VS_KPIUSERS (KPU_KPIID, KPU_USERID, KPU_ORDER) SELECT @cr_KPIID, UserID, @v_KPIORDER 
		FROM dbo.SYUsers WHERE UserGroupID = @cr_Key AND NOT EXISTS (SELECT 1 FROM dbo.VS_KPIUSERS WHERE KPU_KPIID = @cr_KPIID AND KPU_USERID = UserID)
    
		--Dodanie DataSpy dla Grupy  
		IF(@dataSpyID IS NOT NULL)
		BEGIN
			DECLARE @isGroup bit	
			DECLARE @dataSpyGroup nvarchar(20)
			DECLARE @dataSpyUserID nvarchar(30)
			
			SET @isGroup = ISNULL((SELECT IsGroup FROM dbo.VS_DataSpy (nolock) WHERE DataSpyID = @dataSpyID),0)
			SET @dataSpyUserID = ISNULL((SELECT UserID FROM dbo.VS_DataSpy (nolock) WHERE DataSpyID = @dataSpyID),'')
			SET @dataSpyGroup = ISNULL((SELECT UserGroupID FROM dbo.SYUsers (nolock) WHERE UserID = @dataSpyUserID),'')
		
			IF ((@dataSpyGroup <> @cr_Key) OR (@isGroup <> 1))
			BEGIN
				IF NOT EXISTS(SELECT null FROM dbo.VS_DataSpyUsers (nolock) WHERE DataSpyID = @dataSpyID AND UserOrGroupID = @cr_Key AND [Type] = 'G')
				BEGIN
					INSERT INTO dbo.VS_DataSpyUsers (DataSpyID, UserOrGroupID, [Type]) VALUES (@dataSpyID, @cr_Key, 'G')
				END
			END 
		END	
  END     
  IF @p_Action = 0  
  BEGIN  
    DELETE FROM dbo.VS_KPIUSERSGROUP WHERE KPG_KPIID = @cr_KPIID AND KPG_GROUPID = @cr_Key  
    DELETE FROM dbo.VS_KPIUSERS WHERE KPU_KPIID = @cr_KPIID AND KPU_USERID IN (SELECT UserID FROM dbo.SYUsers WHERE UserGroupID = @cr_Key)
    
    --Usunięcie DataSpy dla Grupy
    IF(@dataSpyID IS NOT NULL)
	BEGIN
		IF EXISTS(SELECT null FROM dbo.VS_DataSpyUsers (nolock) WHERE DataSpyID = @dataSpyID AND UserOrGroupID = @cr_Key AND [Type] = 'G')
		BEGIN
			DELETE FROM dbo.VS_DataSpyUsers WHERE DataSpyID = @dataSpyID AND UserOrGroupID = @cr_Key AND [Type] = 'G'
		END  
	END	
  END  
 END   
  
  END TRY  
  BEGIN CATCH  
    SELECT @v_syserrorcode = error_message()  
    SELECT @v_errorcode = 'SYS_001'  
    GOTO errorlabel  
  END CATCH;  
 
  FETCH NEXT from c INTO @cr_ID, @cr_Key, @cr_KPIID  
END  
CLOSE c  
DEALLOCATE c  
  
return 0  
  
errorlabel:  
    exec err_proc @v_errorcode, @v_syserrorcode, 'SA', @v_errortext output  
 raiserror (@v_errortext, 16, 1)   
    return 1  
END  
   
SET ANSI_NULLS OFF  
GO
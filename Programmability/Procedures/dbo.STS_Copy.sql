SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STS_Copy]  
(  
  @p_FormID nvarchar(50),  
  @p_ID nvarchar(50),  
  @p_ROWID int,  
  @p_CODE nvarchar(30),  
  @p_ORG nvarchar(30),  
  @p_DESC nvarchar(80),  
  @p_NOTE ntext,  
  @p_DATE datetime,  
  @p_TIME nvarchar(10),  
  @p_STATUS nvarchar(30),  
  @p_STATUS_old nvarchar(30),  
  @p_TYPE nvarchar(30),  
  @p_TYPE2 nvarchar(30),  
  @p_TYPE3 nvarchar(30),  
  @p_NOTUSED int,  
   
  @p_TXT01 nvarchar(30),  
  @p_TXT02 nvarchar(30),  
  @p_TXT03 nvarchar(30),  
  @p_TXT04 nvarchar(30),  
  @p_TXT05 nvarchar(30),  
  @p_TXT06 nvarchar(80),  
  @p_TXT07 nvarchar(80),  
  @p_TXT08 nvarchar(255),  
  @p_TXT09 nvarchar(255),  
  @p_NTX01 numeric(24,6),  
  @p_NTX02 numeric(24,6),  
  @p_NTX03 numeric(24,6),  
  @p_NTX04 numeric(24,6),  
  @p_NTX05 numeric(24,6),  
  @p_COM01 ntext,  
  @p_COM02 ntext,  
  @p_DTX01 datetime,  
  @p_DTX02 datetime,  
  @p_DTX03 datetime,  
  @p_DTX04 datetime,  
  @p_DTX05 datetime,  
     
  --- tutaj ewentualnie swoje parametry/zmienne/dane  
  @p_GROUP nvarchar(30),  
    @p_SIGNED smallint,   @p_SIGNLOC nvarchar(80),  
  @p_SETTYPE nvarchar(30),  
  @p_SAP_CHK int,  
  @p_STS_DEFAULT_KST nvarchar(30),  
  @p_ROTARY tinyint,  
  @p_PM_TOSEND tinyint,  
  ----  
  
 @p_UserID nvarchar(30) = NULL, -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin  
 declare @v_errortext nvarchar(4000)   
 declare @v_errorid int  
 declare @v_rowid int  
 declare @v_desc nvarchar(80)  
 declare @v_ID nvarchar(50)  
 set @v_errortext = null  
 set @v_desc = @p_DESC+'-kopia'  
 set @v_ID = cast(NEWID() as nvarchar(50))  
 set @v_errorid = 0  
  
 exec dbo.STS_Update_Proc  
    @p_FormID,  
    @v_ID,  
    @p_ROWID,  
    'autonumer',  
    @p_ORG,  
    @v_desc,  
    @p_NOTE,  
    @p_DATE,  
    @p_TIME,  
    @p_STATUS,  
    @p_STATUS_old,  
    @p_TYPE,  
    @p_TYPE2,  
    @p_TYPE3,  
    @p_NOTUSED,  
    @p_TXT01,  
    @p_TXT02,  
    @p_TXT03,  
    @p_TXT04,  
    @p_TXT05,  
    @p_TXT06,  
    @p_TXT07,  
    @p_TXT08,  
    @p_TXT09,  
    @p_NTX01,  
    @p_NTX02,  
    @p_NTX03,  
    @p_NTX04,  
    @p_NTX05,  
    @p_COM01,  
    @p_COM02,  
    @p_DTX01,  
    @p_DTX02,  
    @p_DTX03,  
    @p_DTX04,  
    @p_DTX05,  
    @p_GROUP,  
    @p_SIGNED,  
    @p_SIGNLOC,  
    @p_SETTYPE,  
    @p_SAP_CHK,  
    @p_STS_DEFAULT_KST,  
    @p_ROTARY,  
    0,  
    @p_UserID,  
    null  
      
   select @v_rowid = STS_ROWID from dbo.STENCIL where STS_ID = @v_ID  
   insert into ADDSTSPROPERTIES (ASP_PROID, ASP_ENT, ASP_STSID, ASP_UOMID, ASP_LIST, ASP_REQUIRED, ASP_VALUE, ASP_UPDATECOUNT, ASP_CREATED)  
   select ASP_PROID, ASP_ENT, @v_rowid, ASP_UOMID, ASP_LIST, ASP_REQUIRED, ASP_VALUE, 0, getdate()  
   from ADDSTSPROPERTIES where ASP_STSID = @p_ROWID  
     
   insert into STENCIL_PSP (PSP_CODE, STS_ROWID)  
   select PSP_CODE, @v_rowid from STENCIL_PSP where STS_ROWID = @p_ROWID  
     
   insert into [dbo].[STENCILLN] (STL_PARENTID, STL_CHILDID, STL_ORG, STL_REQUIRED, STL_ONE, STL_DEFAULT_NUMBER)  
   SELECT @v_rowid  
     ,STL_CHILDID  
     ,STL_ORG  
     ,STL_REQUIRED  
     ,STL_ONE  
     ,STL_DEFAULT_NUMBER  
      FROM [dbo].[STENCILLN] where STL_PARENTID = @p_ROWID  
end  
GO
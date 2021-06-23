SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[CPOLN_Update_Tran]
(
    @p_POTID int,
	@p_TO_STNID int,
	@p_TO_STN_DESC nvarchar(80),
    @p_OBJID int,
	@p_OBJ nvarchar(30),
    @p_OLDQTY decimal(30,6),
    @p_NEWQTY decimal(30,6),
    @p_PARTIAL int,
    @p_COM01 ntext,
    @p_COM02 ntext,
    @p_DTX01 datetime,
    @p_DTX02 datetime,
    @p_DTX03 datetime,
    @p_DTX04 datetime,
    @p_DTX05 datetime,
    @p_NTX01 numeric(24,6),
    @p_NTX02 numeric(24,6),
    @p_NTX03 numeric(24,6),
    @p_NTX04 numeric(24,6),
    @p_NTX05 numeric(24,6),
    @p_ROWID int = NULL,
    @p_OLD_ROWID int = NULL,
    @p_POL_CODE nvarchar(30) = NULL,
    @p_OLD_POL_CODE nvarchar(30) = NULL,
    @p_CREDATE datetime,
    @p_CREUSER nvarchar(30), 
    @p_DATE datetime,
    @p_DESC nvarchar(80),
    @p_ID nvarchar(50),
    @p_NOTE ntext,
    @p_NOTUSED int,
    @p_ORG nvarchar(30), 
    @p_RSTATUS int,
    @p_STATUS nvarchar(30), 
	@p_STATUS_OLD nvarchar(30),
    @p_TYPE nvarchar(30), 
    @p_TYPE2 nvarchar(30),
    @p_TYPE3 nvarchar(30),
    @p_UPDDATE datetime,
    @p_UPDUSER nvarchar(30), 
    @p_TXT01 nvarchar(30),
    @p_TXT02 nvarchar(30),
    @p_TXT03 nvarchar(30),
    @p_TXT04 nvarchar(30),
    @p_TXT05 nvarchar(30),
    @p_TXT06 nvarchar(80),
    @p_TXT07 nvarchar(80),
    @p_TXT08 nvarchar(255),
    @p_TXT09 nvarchar(255),
	@p_UserID varchar(20), 
    @p_GroupID varchar(10), 
    @p_LangID varchar(10),
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[CPOLN_Update_Proc]
    @p_POTID,
	@p_TO_STNID,
	@p_TO_STN_DESC,
    @p_OBJID,
	@p_OBJ,
    @p_OLDQTY,
    @p_NEWQTY,
    @p_PARTIAL,
    @p_COM01,
    @p_COM02,
    @p_DTX01,
    @p_DTX02,
    @p_DTX03,
    @p_DTX04,
    @p_DTX05,
    @p_NTX01,
    @p_NTX02,
    @p_NTX03,
    @p_NTX04,
    @p_NTX05,
    @p_ROWID,
    @p_OLD_ROWID,
    @p_POL_CODE,
    @p_OLD_POL_CODE,
    @p_CREDATE,
    @p_CREUSER,
    @p_DATE,
    @p_DESC,
    @p_ID,
    @p_NOTE,
    @p_NOTUSED,
    @p_ORG,
    @p_RSTATUS,
    @p_STATUS,
	@p_STATUS_OLD,
    @p_TYPE,
    @p_TYPE2,
    @p_TYPE3,
    @p_UPDDATE,
    @p_UPDUSER,
    @p_TXT01,
    @p_TXT02,
    @p_TXT03,
    @p_TXT04,
    @p_TXT05,
    @p_TXT06,
    @p_TXT07,
    @p_TXT08,
    @p_TXT09, 
    @p_UserID,
    @p_GroupID,
    @p_LangID,
    @p_apperrortext output

  if @v_errorid = 0
  begin
    commit transaction
    return 0
  end
  else
  begin
    rollback transaction
    return 1
  end
end
GO
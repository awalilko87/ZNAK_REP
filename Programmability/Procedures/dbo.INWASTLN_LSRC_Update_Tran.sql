SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
CREATE procedure [dbo].[INWASTLN_LSRC_Update_Tran]
(
    @SIA_SINID int,
    @SIA_ASTID int,
	@SIA_ASTCODE nvarchar(30),
	@SIA_ASTSUBCODE nvarchar(30),
	@SIA_BARCODE nvarchar(30),
    @SIA_OLDQTY decimal(30,6),
    @SIA_NEWQTY decimal(30,6),
    @COM01 ntext,
    @COM02 ntext,
    @DTX01 datetime,
    @DTX02 datetime,
    @DTX03 datetime,
    @DTX04 datetime,
    @DTX05 datetime,
    @NTX01 numeric(24,6),
    @NTX02 numeric(24,6),
    @NTX03 numeric(24,6),
    @NTX04 numeric(24,6),
    @NTX05 numeric(24,6),
    @ROWID int = NULL,
    @OLD_ROWID int = NULL,
    @SIA_CODE nvarchar(30) = NULL,
    @OLD_SIA_CODE nvarchar(30) = NULL,
    @SIA_CREDATE datetime,
    @SIA_CREUSER nvarchar(30), 
    @SIA_DATE datetime,
    @SIA_DESC nvarchar(80),
    @SIA_ID nvarchar(50),
    @SIA_NOTE ntext,
    @SIA_NOTUSED int,
    @SIA_ORG nvarchar(30), 
    @SIA_RSTATUS int,
    @SIA_STATUS nvarchar(30), 
    @SIA_TYPE nvarchar(30), 
    @SIA_TYPE2 nvarchar(30),
    @SIA_TYPE3 nvarchar(30),
    @SIA_UPDDATE datetime,
    @SIA_UPDUSER nvarchar(30), 
    @TXT01 nvarchar(30),
    @TXT02 nvarchar(30),
    @TXT03 nvarchar(30),
    @TXT04 nvarchar(30),
    @TXT05 nvarchar(30),
    @TXT06 nvarchar(80),
    @TXT07 nvarchar(80),
    @TXT08 nvarchar(255),
    @TXT09 nvarchar(255),
	@SIA_PRICE numeric(30,6),
    @_UserID varchar(20), 
    @_GroupID varchar(10), 
    @_LangID varchar(10),
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[INWASTLN_LSRC_Update_Proc]
    @SIA_SINID,
    @SIA_ASTID,
	@SIA_ASTCODE,
	@SIA_ASTSUBCODE,
	@SIA_BARCODE,
    @SIA_OLDQTY,
    @SIA_NEWQTY,
    @COM01,
    @COM02,
    @DTX01,
    @DTX02,
    @DTX03,
    @DTX04,
    @DTX05,
    @NTX01,
    @NTX02,
    @NTX03,
    @NTX04,
    @NTX05,
    @ROWID,
    @OLD_ROWID,
    @SIA_CODE,
    @OLD_SIA_CODE,
    @SIA_CREDATE,
    @SIA_CREUSER,
    @SIA_DATE,
    @SIA_DESC,
    @SIA_ID,
    @SIA_NOTE,
    @SIA_NOTUSED,
    @SIA_ORG,
    @SIA_RSTATUS,
    @SIA_STATUS,
    @SIA_TYPE,
    @SIA_TYPE2,
    @SIA_TYPE3,
    @SIA_UPDDATE,
    @SIA_UPDUSER,
    @TXT01,
    @TXT02,
    @TXT03,
    @TXT04,
    @TXT05,
    @TXT06,
    @TXT07,
    @TXT08,
    @TXT09,
	@SIA_PRICE,
    @_UserID,
    @_GroupID,
    @_LangID,
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
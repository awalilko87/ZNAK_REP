SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[DOC_UPLOAD_AUDIT]
(@p_FILEID2 nvarchar(50) -- identyfikator w Syfiles
,@p_FileName nvarchar(300)-- wartość parametru
,@p_evanttype nvarchar(15)
,@p_OBJCODE nvarchar(30)
,@_UserID nvarchar(30)
)
as

BEGIN

declare @v_OldValue nvarchar(max)
declare @v_NewValue nvarchar(max)
declare @v_ActualValue nvarchar(max)

select @v_ActualValue = NewValue from VS_AUDIT where FieldName = 'DOC' and TableRowID = @p_FILEID2

select @v_NewValue = case when @p_evanttype in ('NOWY', 'ZMIANA') then @p_FileName
						  when @p_evanttype  = 'USUNIECIE' then NULL end
						  

select @v_OldValue = case when @p_evanttype in ('NOWY', 'ZMIANA') then NULL
						  when @p_evanttype  = 'USUNIECIE' then @v_ActualValue end						  
						  

	INSERT INTO VS_Audit(AuditID, TableName, FieldName, UserID, OldValue,NewValue, DateWhen, Oper, TableRowID, SystemID, RowID) 
		values( NewID(),'DOCENTITIES','DOC',@_UserID,@v_OldValue,  @v_NewValue, GETDATE(),@p_evanttype, @p_FILEID2,  'ZMT', @p_OBJCODE)
	
END
GO
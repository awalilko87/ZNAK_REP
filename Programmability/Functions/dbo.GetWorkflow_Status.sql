SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetWorkflow_Status]
(
	@p_Type nvarchar(3),
	@p_ID int
)
RETURNS nvarchar(30)
AS
BEGIN
	DECLARE @type nvarchar(30)
	DECLARE @status nvarchar(50)
	
	if (@p_Type = 'MT1')
	begin
		SELECT @status = STA_DESC FROM [dbo].[SAPO_ZWFOT31]
			JOIN ZWFOT ON OT31_ZMT_ROWID = OT_ROWID
				left join STA on OT_STATUS = STA_CODE
		WHERE OT31_ROWID = @p_ID
	end
	else if (@p_Type = 'MT2')
	begin
		SELECT @status = STA_DESC FROM [dbo].[SAPO_ZWFOT32]
			JOIN ZWFOT ON OT32_ZMT_ROWID = OT_ROWID
				left join STA on OT_STATUS = STA_CODE
		WHERE OT32_ROWID = @p_ID
	end
	else if (@p_Type = 'MT3')
	begin
		SELECT @status = STA_DESC FROM [dbo].[SAPO_ZWFOT33]
			JOIN ZWFOT ON OT33_ZMT_ROWID = OT_ROWID
				left join STA on OT_STATUS = STA_CODE
		WHERE OT33_ROWID = @p_ID
	end
	else if (@p_Type = 'PL')
	begin
		SELECT @status = STA_DESC FROM [dbo].[SAPO_ZWFOT42]
			JOIN ZWFOT ON OT42_ZMT_ROWID = OT_ROWID
				left join STA on OT_STATUS = STA_CODE
		WHERE OT42_ROWID = @p_ID
	end
	else if (@p_Type = 'LTW')
	begin
		SELECT @status = STA_DESC FROM [dbo].[SAPO_ZWFOT41]
			JOIN ZWFOT ON OT41_ZMT_ROWID = OT_ROWID
				left join STA on OT_STATUS = STA_CODE
		WHERE OT41_ROWID = @p_ID
	end

	RETURN @status

END
GO
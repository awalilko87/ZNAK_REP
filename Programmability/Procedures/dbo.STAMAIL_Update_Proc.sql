SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[STAMAIL_Update_Proc](
		@p_STM_USERID nvarchar(30) OUT,
        @p_STM_STATUS nvarchar(30) OUT,
        @p_STM_ENTITY nvarchar(30) OUT,
        @p_STM_CHNG int,
        @p_STM_P3D int,
        @p_STM_UPDUSER nvarchar(30)
)
as begin
if exists (select 1 from STAMAIL where STM_USERID = @p_STM_USERID and STM_STATUS = @p_STM_STATUS and STM_ENTITY = @p_STM_ENTITY)
begin

UPDATE [dbo].[STAMAIL]
   SET [STM_USERID] = @p_STM_USERID
      ,[STM_STATUS] = @p_STM_STATUS
      ,[STM_ENTITY] = @p_STM_ENTITY
      ,[STM_CHNG] = @p_STM_CHNG
      ,[STM_P3D] = @p_STM_P3D
      ,[STM_UPDUSER] = @p_STM_UPDUSER
      ,[STM_UPDDATE] = getdate()
where STM_USERID = @p_STM_USERID
and STM_STATUS = @p_STM_STATUS
and STM_ENTITY = @p_STM_ENTITY

end
else
begin

INSERT INTO [dbo].[STAMAIL]
           ([STM_USERID]
           ,[STM_STATUS]
           ,[STM_ENTITY]
           ,[STM_CHNG]
           ,[STM_P3D]
           ,[STM_UPDUSER]
           ,[STM_UPDDATE])
     VALUES
           (
			@p_STM_USERID
			, @p_STM_STATUS
			, @p_STM_ENTITY
			, @p_STM_CHNG
			, @p_STM_P3D
			, @p_STM_UPDUSER
			, getdate()
		   )

end

end

GO
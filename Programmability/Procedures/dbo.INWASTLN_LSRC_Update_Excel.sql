SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[INWASTLN_LSRC_Update_Excel]
(
  @p_SINID int,
  @p_UserID nvarchar(30) 
)
AS
--exec [dbo].[INWLN_LSRC_Update_Excel]
BEGIN 

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_ASTID int
	declare @c_CODE nvarchar(30)
	declare @c_QTY decimal (30,6)
	declare @c_PRICE decimal (30,6)
	declare @v_ORG nvarchar(30)
	declare @v_OLDSTATUS nvarchar(30)
	declare @c_SIAID int

	select @v_ORG = SIN_ORG from ST_INW (nolock) where SIN_ROWID = @p_SINID
	
	DECLARE #astinwln_excel cursor	  
	for select 
		c02, 
		cast(replace(c08,',','.') as decimal(30,6)),
		c18
	from AST_INWLN_EXCEL where isnumeric(c08) = 1 and  importuser = @p_UserID --and spid = @@spid
	
	open #astinwln_excel
	fetch next from #astinwln_excel
	into @c_CODE, @c_QTY, @c_SIAID
	
	WHILE @@FETCH_STATUS = 0
	BEGIN 	
 		select @v_OLDSTATUS = SIA_STATUS from AST_INWLN (nolock) where SIA_ROWID = @c_SIAID

		if isnumeric(@c_QTY) = 1 
		begin
			UPDATE AST_INWLN SET 
				SIA_NEWQTY = @c_QTY,
				SIA_STATUS = 'INW',
				SIA_CONFIRMUSER = case when @v_OLDSTATUS = 'NINW' then @p_UserID else SIA_CONFIRMUSER end,
				SIA_CONFIRMDATE = case when @v_OLDSTATUS = 'NINW' then getdate() else SIA_CONFIRMDATE end
			WHERE SIA_ROWID = @c_SIAID
		end
		/*
		if isnumeric(@c_PRICE) = 1 
		begin
			UPDATE ST_INWLN SET 
				SIA_PRICE = @c_PRICE
			WHERE SIA_ASSORTID = @v_ASSORTID and SIA_PLACEID = @v_PLACEID and SIA_SINID = @p_SINID
		end
		*/
		fetch next from #astinwln_excel
		into @c_CODE, @c_QTY, @c_SIAID
	END
	
	close #astinwln_excel
	deallocate #astinwln_excel
	
	delete from AST_INWLN_EXCEL where importuser = @p_UserID --and spid = @@spid
	
	return 0
 
END

 
--CREATE TABLE [dbo].[AST_INWLN_EXCEL](
--	[rowid] [int] IDENTITY(1,1) NOT NULL,
--	[spid] [int] NOT NULL,
--	[importuser] [nvarchar](256) NULL,
--	[c01] [nvarchar](255) NULL,
--	[c02] [nvarchar](255) NULL,
--	[c03] [nvarchar](255) NULL,
--	[c04] [nvarchar](255) NULL,
--	[c05] [nvarchar](255) NULL,
--	[c06] [nvarchar](255) NULL,
--	[c07] [nvarchar](255) NULL,
--	[c08] [nvarchar](255) NULL,
--	[c09] [nvarchar](255) NULL,
--	[c10] [nvarchar](255) NULL,
--	[c11] [nvarchar](255) NULL,
--	[c12] [nvarchar](255) NULL,
--	[c13] [nvarchar](255) NULL
--) ON [PRIMARY]

--GO

--select * from AST_INWLN_EXCEL
--exec [dbo].[INWLN_LSRC_Update_Excel] @RV_ROWID

GO
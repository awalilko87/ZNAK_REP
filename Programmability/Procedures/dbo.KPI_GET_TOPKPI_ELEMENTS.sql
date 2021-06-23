SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[KPI_GET_TOPKPI_ELEMENTS](
@_UserID nvarchar(30) = null,
@_LangID nvarchar(30) = null
)
as
  SET NOCOUNT ON
  DECLARE @cr_id varchar(1000)          
  DECLARE @cr_desc varchar(1000)          
  DECLARE @cr_source varchar(1000)          
  DECLARE @cr_where varchar(1000)          
  DECLARE @cr_defimage varchar(1000)          
  DECLARE @cr_link varchar(1000)         
  DECLARE @cr_formid nvarchar(50)    
  DECLARE @cr_dataspy nvarchar(100)     
  DECLARE @cr_rpt varchar(1000)          
  DECLARE @cr_rpt_Encode varchar(1000) 
  
  DECLARE @sp_count int  
  declare @sp_link nvarchar(max) 
  DECLARE @v_org varchar(30)          
  DECLARE @v_image varchar(4000)          
  DECLARE @v_GroupID nvarchar(20)    
  DECLARE @kpi_type bit  
  DECLARE @kpu_show_when_zero bit  
  DECLARE @sp_where nvarchar(max);       
  DECLARE @sp_query nvarchar(max);        
  DECLARE @sp_SQLString nvarchar(max);          
  DECLARE @sp_ParmDefinition nvarchar(4000);         

  declare @tmp_tab table(cr_id int, 
                         cr_desc nvarchar(1000),
                         cr_link nvarchar(4000),
                         cr_defimage varchar(4000),
                         cr_count int)
  SELECT @v_org = SiteID, 
		 @v_GroupID = isnull(UserGroupID,'') 
  from dbo.SYUsers (nolock) where UserID = @_UserID  

  DECLARE cKPI CURSOR STATIC FOR          
  SELECT KPI_ID, isnull(Caption,KPI_DESC), KPI_SOURCE, KPI_WHERE, KPI_DEFIMAGE, KPI_LINK, KPI_RPT, KPI_TYPE, KPI_FORMID, KPI_DATASPY, KPU_SHOW_WHEN_ZERO         
  FROM dbo.VS_KPI (nolock)       
    LEFT JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID
    left join dbo.VS_LangMsgs(nolock) on ObjectType = 'KPI' and ControlID = convert(varchar,KPI_ID) and LangID = @_LangID
  WHERE KPU_USERID = @_UserID 
  AND KPI_ACTIVE = 1 
  AND isnull(KPU_ORDER,0) <> 0
  AND KPI_TYPE = 1     
  ORDER BY ISNULL(KPU_ORDER, 0)
  
  OPEN cKPI          
  FETCH NEXT FROM cKPI INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero             
  WHILE @@FETCH_STATUS = 0          
  BEGIN            
    IF(@cr_formid is not null AND @cr_dataspy is not null) 
    BEGIN    
      --Gdy mamy zdefiniowane DataSpy dla KPI    
      DECLARE @qs_a varchar(1), @link varchar(1000), @index TinyInt    
      SET @link = @cr_link    
      SET @index = CHARINDEX('A=', @link)    
      IF @index <> 0 BEGIN    
        SET @qs_a = (SUBSTRING (@link, @index + 2, 1))    
      END
      ELSE BEGIN    
        SET @qs_a = 0    
      END
      --print @cr_formid
      --print @cr_dataspy
      DECLARE @addWhere nvarchar(2000)    
      SET @addWhere = (SELECT AddWhere FROM dbo.VS_Forms WHERE FormID = @cr_formid)    
      SET @addWhere = replace(@addWhere, '@_UserID', ''''+@_UserID+'''')           
      SET @addWhere = replace(@addWhere, '@_ORG', ''''+@v_org+'''')           
      SET @addWhere = replace(@addWhere, '@_GroupID', ''''+@v_GroupID+'''')
      SET @addWhere = replace(@addWhere, '@_LangID', ''''+@_LangID+'''')
      SET @addWhere = replace(@addWhere, '@QS_FID', ''''+@cr_formid+'''')     
      SET @addWhere = replace(@addWhere, '@QS_A', ''''+@qs_a+'''') 

      DECLARE @output_where nvarchar(4000)    
      SET @output_where = (select [dbo].[fn_GetDataSpyWhere] (@cr_dataspy))    
      SET @output_where = replace(@output_where, '@_UserID', ''''+@_UserID+'''')           
      SET @output_where = replace(@output_where, '@_ORG', ''''+@v_org+'''')           
      SET @output_where = replace(@output_where, '@_GroupID', ''''+@v_GroupID+'''')    
      SET @output_where = replace(@output_where, '@_LangID', ''''+@_LangID+'''')      
      
      IF(@cr_source is not null)  begin
      --print 1       
        SET @sp_SQLString = @cr_source + ' where 1 = 1 ' +     
          CASE isnull(@output_where, '') WHEN '' THEN '' ELSE 'and ' + @output_where END +     
          CASE isnull(@addWhere, '') WHEN '' THEN '' ELSE ' and ' + @addWhere END    
        END   
      ELSE    
      BEGIN    
        DECLARE @tabname nvarchar(250)    
        SET @tabname = (SELECT TableName FROM dbo.VS_Forms WHERE FormID = @cr_formid)    
        SET @sp_query = 'select @P1 = count(*) from ' + @tabname +' (nolock) '    
        SET @sp_SQLString = @sp_query + ' where 1 = 1 ' +     
        CASE isnull(@output_where, '') WHEN '' THEN '' ELSE 'and (' + @output_where  + ')' END  +      
        CASE isnull(@addWhere, '') WHEN '' THEN '' ELSE ' and (' + @addWhere + ')' END   
        
        --print @sp_query
        --print '----'
        --print @output_where
        --print '----'
        --print @addWhere
        --print '----'
        --print @sp_SQLString
            
      END       
      SET @sp_ParmDefinition = N'@where nvarchar(30), @P1 int output'          
      --print @sp_ParmDefinition
      SET @sp_where = null     
      EXECUTE sp_executesql @sp_SQLString, @sp_ParmDefinition, @where = @sp_where, @P1 = @sp_count output          
    END    
    ELSE 
    BEGIN    
      --Gdy korzystamy z warunku WHERE    
      SET @cr_where = replace(@cr_where, '@_UserID', ''''+@_UserID+'''')           
      SET @cr_where = replace(@cr_where, '@_ORG', ''''+@v_org+'''')           
      SET @cr_where = replace(@cr_where, '@_GroupID', ''''+@v_GroupID+'''')   
      SET @cr_where = replace(@cr_where, '@_LangID', ''''+@_LangID+'''')         
      SET @sp_SQLString = @cr_source + ' where 1 = 1 ' + CASE isnull(@cr_where, '') WHEN '' THEN '' ELSE 'and ' + @cr_where END          
      SET @sp_ParmDefinition = N'@where nvarchar(30), @P1 int output'          
           
      SET @sp_where = null          
      EXECUTE sp_executesql @sp_SQLString, @sp_ParmDefinition, @where = @sp_where, @P1 = @sp_count output          
    END
    
    SET @v_image = null          
    
    SELECT top 1 @v_image = KPR_IMAGE 
    from dbo.VS_KPIRANGE 
    where @sp_count between KPR_FROM and KPR_TO 
    and KPR_KPIID = (select ROWID from dbo.VS_KPI (nolock) where KPI_ID = @cr_id)          
    
    SET @v_image = isnull(@v_image,@cr_defimage)    
  
    IF (@sp_count > 0 OR @kpu_show_when_zero = 1) 
    BEGIN
      IF(@cr_formid is not null AND @cr_dataspy is not null) BEGIN
        SELECT @sp_link = '/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')
		+ (case when isnull(@cr_link,'') like '%/' then '?' else '&' end) 
		+ 'D=' + replace(isnull(@cr_dataspy,''),'@_UserID',@_UserID))      
      END
      ELSE IF LTRIM(RTRIM(ISNULL(@cr_formid,''))) = '' AND LTRIM(RTRIM(ISNULL(@cr_link,''))) <> '' BEGIN
        SELECT @sp_link = '/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')
		+ (case when isnull(@cr_link,'') like '%/' then '?' else '&' end) 
		+ 'W=' + dbo.VS_EncryptText( replace(isnull(@cr_where,''),'@_UserID',@_UserID) ) )   
      END
	  ELSE BEGIN       
        SELECT @sp_link = '#'    
      END 
       
      insert into @tmp_tab(cr_id, cr_desc, cr_link, cr_defimage, cr_count)
      select @cr_id,
             (isnull(@cr_desc,'')),
             isnull(@sp_link,''),
             isnull(@v_image,''),
             isnull(@sp_count,'')
    END
    FETCH NEXT FROM cKPI INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero             
  END
  
  CLOSE cKPI
  DEALLOCATE cKPI
  
  select cr_id, cr_desc, cr_link, cr_defimage, cr_count from @tmp_tab
  
  return 0
GO
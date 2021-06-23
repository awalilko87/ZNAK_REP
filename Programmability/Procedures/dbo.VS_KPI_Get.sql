SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

    
create procedure [dbo].[VS_KPI_Get]         
(        
    @p_UserID nvarchar(30),
    @p_AppCode nvarchar(100)             
)        
        
AS        
BEGIN  
  DECLARE @vertical_menu bit   
  DECLARE @verticalMenuKey nvarchar(100)
  DECLARE @verticalMenuValue nvarchar(4000)
  DECLARE @kpi varchar(max)  
  DECLARE @kpi2 varchar(max)  
         
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
  DECLARE @kpi_type bit   
  DECLARE @kpu_show_when_zero bit  
              
  DECLARE @sp_where nvarchar(1000);     
  DECLARE @sp_query nvarchar(1000);      
  DECLARE @sp_SQLString nvarchar(1000);        
  DECLARE @sp_ParmDefinition nvarchar(1000);        
  DECLARE @sp_count int        
        
  DECLARE @v_org varchar(30)        
  DECLARE @v_image varchar(1000)        
  DECLARE @v_GroupID nvarchar(20)      
  
  SET @verticalMenuKey = @p_AppCode + '_VMENU'
  SELECT @verticalMenuValue = SettingValue FROM dbo.SYSettings WHERE KeyCode = @verticalMenuKey
  IF (@verticalMenuValue is not null AND @verticalMenuValue <> '')
	SET @vertical_menu = 1
  ELSE	
	SET @vertical_menu = 0  
        
  SELECT @v_org = SiteID, @v_GroupID = isnull(UserGroupID,'') from dbo.SYUsers (nolock) where UserID = @p_UserID        
        
  DECLARE cKPI CURSOR STATIC FOR        
    SELECT KPI_ID, KPI_DESC, KPI_SOURCE, KPI_WHERE, KPI_DEFIMAGE, KPI_LINK, KPI_RPT, KPI_TYPE, KPI_FORMID, KPI_DATASPY, KPU_SHOW_WHEN_ZERO       
    FROM dbo.VS_KPI (nolock)     
      LEFT JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID  
    WHERE KPU_USERID = @p_UserID AND KPI_ACTIVE = 1 AND isnull(KPU_ORDER,0) <> 0   
    ORDER BY ISNULL(KPU_ORDER, 0)            
  
  SET @kpi = ''  
  SET @kpi2 = ''  
  SET @kpi = @kpi + '<div id="KPIContainer" class="KPIContainer">'   
        
  OPEN cKPI        
  FETCH NEXT FROM cKPI INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero           
  WHILE @@FETCH_STATUS = 0        
  BEGIN          
    IF(@cr_formid is not null AND @cr_dataspy is not null) BEGIN  
      --Gdy mamy zdefiniowane DataSpy dla KPI  
      DECLARE @qs_a varchar(1), @link varchar(1000), @index TinyInt  
      SET @link = @cr_link  
      SET @index = CHARINDEX('A=', @link)  
      IF @index <> 0  
        SET @qs_a = (SUBSTRING (@link, @index + 2, 1))  
      ELSE  
        SET @qs_a = 0  
     
      DECLARE @addWhere nvarchar(2000)  
      SET @addWhere = (SELECT AddWhere FROM dbo.VS_Forms WHERE FormID = @cr_formid)  
      SET @addWhere = replace(@addWhere, '@_UserID', ''''+@p_UserID+'''')         
      SET @addWhere = replace(@addWhere, '@_ORG', ''''+@v_org+'''')         
      SET @addWhere = replace(@addWhere, '@_GroupID', ''''+@v_GroupID+'''')    
      SET @addWhere = replace(@addWhere, '@QS_FID', ''''+@cr_formid+'''')   
      SET @addWhere = replace(@addWhere, '@QS_A', ''''+@qs_a+'''')   
        
      DECLARE @output_where nvarchar(4000)  
      SET @output_where = (select [dbo].[fn_GetDataSpyWhere] (@cr_dataspy))  
      SET @output_where = replace(@output_where, '@_UserID', ''''+@p_UserID+'''')         
      SET @output_where = replace(@output_where, '@_ORG', ''''+@v_org+'''')         
      SET @output_where = replace(@output_where, '@_GroupID', ''''+@v_GroupID+'''')    
    
      IF(@cr_source is not null)       
        SET @sp_SQLString = @cr_source + ' where 1 = 1 ' +   
          CASE isnull(@output_where, '') WHEN '' THEN '' ELSE 'and ' + @output_where END +   
          CASE isnull(@addWhere, '') WHEN '' THEN '' ELSE ' and ' + @addWhere END     
      ELSE  
      BEGIN  
        DECLARE @tabname nvarchar(250)  
        SET @tabname = (SELECT TableName FROM dbo.VS_Forms WHERE FormID = @cr_formid)  
        SET @sp_query = 'select @P1 = count(*) from ' + @tabname +' (nolock) '  
        SET @sp_SQLString = @sp_query + ' where 1 = 1 ' +   
        CASE isnull(@output_where, '') WHEN '' THEN '' ELSE 'and (' + @output_where  + ')' END  +    
        CASE isnull(@addWhere, '') WHEN '' THEN '' ELSE ' and (' + @addWhere + ')' END     
      END     
      SET @sp_ParmDefinition = N'@where nvarchar(30), @P1 int output'        
         
      SET @sp_where = null   
      EXECUTE sp_executesql @sp_SQLString, @sp_ParmDefinition, @where = @sp_where, @P1 = @sp_count output        
    END  
    ELSE BEGIN  
      --Gdy korzystamy z warunku WHERE  
      SET @cr_where = replace(@cr_where, '@_UserID', ''''+@p_UserID+'''')         
      SET @cr_where = replace(@cr_where, '@_ORG', ''''+@v_org+'''')         
      SET @cr_where = replace(@cr_where, '@_GroupID', ''''+@v_GroupID+'''')         
      SET @sp_SQLString = @cr_source + ' where 1 = 1 ' + CASE isnull(@cr_where, '') WHEN '' THEN '' ELSE 'and ' + @cr_where END        
      SET @sp_ParmDefinition = N'@where nvarchar(30), @P1 int output'        
         
      SET @sp_where = null        
      EXECUTE sp_executesql @sp_SQLString, @sp_ParmDefinition, @where = @sp_where, @P1 = @sp_count output        
    END            
            
    SET @v_image = null        
    SELECT top 1 @v_image = KPR_IMAGE from dbo.VS_KPIRANGE where @sp_count between KPR_FROM and KPR_TO and KPR_KPIID = (select ROWID from dbo.VS_KPI (nolock) where KPI_ID = @cr_id)        
    SET @v_image = isnull(@v_image,@cr_defimage)        
        
    SELECT @cr_rpt_Encode = [dbo].[VS_EncodeBase64] ('R;'+@cr_rpt)       
               
	IF (@kpi_type = 'True')
	BEGIN     
		IF (@sp_count > 0 OR @kpu_show_when_zero = 1) 
		BEGIN
			SET @kpi2 = @kpi2 + '<div class="KPIItem">'        
			IF(@cr_formid is not null AND @cr_dataspy is not null)    
			  SET @kpi2 = @kpi2 + '<a href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&D=' + replace(isnull(@cr_dataspy,''),'@_UserID',@p_UserID))   
				  + '" class="KPIItemHref">'        
			ELSE    
			  SET @kpi2 = @kpi2 + '<a href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&W=' + replace(isnull(@cr_where,''),'@_UserID',@p_UserID))  
				  + '" class="KPIItemHref">' 
			           
			SET @kpi2 = @kpi2 + '<img class="KPIItemImage" SRC="/Images/KPI/'+ isnull(@v_image,'') +'"/>'         
			SET @kpi2 = @kpi2 + '<br />'           
			SET @kpi2 = @kpi2 + '<span class="KPIItemText">' + (isnull(@cr_desc,'')) + ':<b><font color="Black"> ' + isnull(convert(varchar, @sp_count),'') + '</font></b></span>'         
			SET @kpi2 = @kpi2 + '</a>'    
			SET @kpi2 = @kpi2 + '</div>' 
			END 
		END
		        
    SET @sp_count = null                 
    FETCH NEXT FROM cKPI INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero      
  END          
  CLOSE cKPI          
  DEALLOCATE cKPI                     
   
  SET @kpi2 = @kpi2 + '</div>'     
   
  --DECLARE @scriptKPI varchar(1000)      
  --SET @scriptKPI = ''     
  --SET @scriptKPI = @scriptKPI + '<script type="text/javascript" language="javascript">'  
  --SET @scriptKPI = @scriptKPI + 'var width = document.body.offsetWidth;'  
  --SET @scriptKPI = @scriptKPI + 'var IEVersion = getIEVersionNumber();'  
  --SET @scriptKPI = @scriptKPI + 'if (IEVersion == 7) { '  
  --SET @scriptKPI = @scriptKPI + '  document.getElementById(''KPIContainer'').style.marginLeft = "0px"; } '  
  --SET @scriptKPI = @scriptKPI + 'else { '  
  --SET @scriptKPI = @scriptKPI + '  if (width > 1600) { '  
  --SET @scriptKPI = @scriptKPI + '  document.getElementById(''KPIContainer'').style.marginLeft = (((width-1372)/2)) + "px"; } '  
  --SET @scriptKPI = @scriptKPI + '  else { '  
  --SET @scriptKPI = @scriptKPI + '  document.getElementById(''KPIContainer'').style.marginLeft = (((width-1292)/2)+20) + "px"; } } '  
  --SET @scriptKPI = @scriptKPI + 'document.getElementById(''KPIContainer'').style.width = ((width-30)-((width-1183)/2)) + "px";'   
  --SET @scriptKPI = @scriptKPI + '</script>'  
  --SET @kpi2 = @kpi2 + @scriptKPI  
             
    DECLARE @scriptKPI varchar(max)    
	SET @scriptKPI = ''   
	SET @scriptKPI = @scriptKPI + '<script type="text/javascript" language="javascript">'
	SET @scriptKPI = @scriptKPI + 'var width = document.body.offsetWidth;'
	SET @scriptKPI = @scriptKPI + 'var IEVersion = getIEVersionNumber();'
	SET @scriptKPI = @scriptKPI + 'if (IEVersion == 7) '
	SET @scriptKPI = @scriptKPI + '	{ document.getElementById(''KPIContainer'').style.marginLeft = "0px"; } '
	SET @scriptKPI = @scriptKPI + 'else { '
	IF (@vertical_menu = 1)
	BEGIN
		SET @scriptKPI = @scriptKPI + 'if (width < 1300) { '
		SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = "0px"; '
		SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1240px"; } '
		SET @scriptKPI = @scriptKPI + 'else if (width >= 1300 && width < 1600) { '
		SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = "0px"; '
		SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1150px"; } ' 
		SET @scriptKPI = @scriptKPI + 'else if (width >= 1600 ) { '
		SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = (((width-1522)/2)+20) + "px"; '
		SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1240px"; } ' 
	END
	ELSE
	BEGIN
		SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = (((width-1292)/2)+20) + "px"; '
		SET @scriptKPI = @scriptKPI + 'document.getElementById(''KPIContainer'').style.width = "1240px";' 
	END
	SET @scriptKPI = @scriptKPI + ' } '
	SET @scriptKPI = @scriptKPI + '</script>'
	SET @kpi2 = @kpi2 + @scriptKPI       
                
    SELECT @kpi+@kpi2 AS [TABLE_KPI]   
END    
GO
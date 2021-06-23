SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

    
create procedure [dbo].[VS_KPI_LIST_Get]           
(          
    @p_UserID nvarchar(30)             
)          
          
AS          
BEGIN          
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
  DECLARE @kpi_fontsize int    
                
  DECLARE @sp_where nvarchar(1000);       
  DECLARE @sp_query nvarchar(1000);        
  DECLARE @sp_SQLString nvarchar(1000);          
  DECLARE @sp_ParmDefinition nvarchar(1000);          
  DECLARE @sp_count int          
          
  DECLARE @v_org varchar(30)          
  DECLARE @v_image varchar(1000)          
  DECLARE @v_GroupID nvarchar(20)          
  DECLARE @v_LangID nvarchar(10)    
      
  DECLARE @kpi_priority_text nvarchar(100)    
  DECLARE @kpi_desc_text nvarchar(100)    
  DECLARE @kpi_count_text nvarchar(100)    
  DECLARE @kpi_config_text nvarchar(100)    
      
  SELECT @v_org = SiteID, @v_LangID = isnull(LangID, 'PL'), @v_GroupID = isnull(UserGroupID,'') from dbo.SYUsers (nolock) where UserID = @p_UserID                   
       
  SELECT @kpi_priority_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'KPI_Priority' AND ObjectType = 'MSG'        
  SELECT @kpi_desc_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'KPI_Desc' AND ObjectType = 'MSG'        
  SELECT @kpi_count_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'KPI_Count' AND ObjectType = 'MSG'      
  SELECT @kpi_config_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'KPI_Configuration' AND ObjectType = 'MSG'        
                 
  DECLARE c CURSOR FOR          
    SELECT KPI_ID, KPI_DESC, KPI_SOURCE, KPI_WHERE, KPI_DEFIMAGE, KPI_LINK, KPI_RPT, KPI_TYPE, KPI_FORMID, KPI_DATASPY, KPU_SHOW_WHEN_ZERO, KPI_FONTSIZE         
    FROM dbo.VS_KPI (nolock)       
  LEFT JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID    
 WHERE KPU_USERID = @p_UserID AND KPI_ACTIVE = 1 AND isnull(KPU_ORDER,0) <> 0     
 ORDER BY ISNULL(KPU_ORDER, 0)              
    
 SET @kpi = ''    
 SET @kpi2 = ''    
 SET @kpi = @kpi + '<table><tr><td valign="top">'    
    SET @kpi = @kpi + '<table class="tableKPI" cellpadding="0" cellspacing="0">'    
    SET @kpi = @kpi + '<thead>'     
    SET @kpi = @kpi + '<tr>'     
    SET @kpi = @kpi + '<th class="thKPIPriority"><span>' + @kpi_priority_text + '</span></td>'    
    SET @kpi = @kpi + '<th class="thKPIDesc"><span>' + @kpi_desc_text + '</span></td>'    
    SET @kpi = @kpi + '<th class="thKPICount"><span>' + @kpi_count_text + '</span></td>'    
 SET @kpi = @kpi + '</tr>'     
 SET @kpi = @kpi + '</thead>'     
          
 OPEN c          
 FETCH NEXT FROM c INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero, @kpi_fontsize             
 WHILE @@FETCH_STATUS = 0          
 BEGIN                           
    IF(@cr_formid is not null AND @cr_dataspy is not null)    
 BEGIN    
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
 ELSE    
 BEGIN    
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
    SET @kpi2 = @kpi2 + '<tr class="tableTrKPI">'    
    SET @kpi2 = @kpi2 + '<td class="tableTdKPICenter">'    
    SET @kpi2 = @kpi2 + '<img SRC="/Images/KPI/'+ isnull(@v_image,'') +'"/>'    
    SET @kpi2 = @kpi2 + '</td>'    
    SET @kpi2 = @kpi2 + '<td class="tableTdKPI">'    
    IF(@cr_formid is not null AND @cr_dataspy is not null)    
     SET @kpi2 = @kpi2 + '<a href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&D=' + replace(isnull(@cr_dataspy,''),'@_UserID',@p_UserID)) + '" class="KPIItemHref">'        
    ELSE    
     SET @kpi2 = @kpi2 + '<a href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&W=' + replace(isnull(@cr_where,''),'@_UserID',@p_UserID)) + '" class="KPIItemHref">'      
    IF (@kpi_fontsize is not null AND @kpi_fontsize > 0)    
     SET @kpi2 = @kpi2 + '<span><font size="' + convert(varchar, @kpi_fontsize) + '">' + (isnull(@cr_desc,'')) + '</font></span>'     
       ELSE    
     SET @kpi2 = @kpi2 + '<span>' + (isnull(@cr_desc,'')) + '</span>'     
    SET @kpi2 = @kpi2 + '</a>'    
    SET @kpi2 = @kpi2 + '</td>'    
    SET @kpi2 = @kpi2 + '<td class="tableTdKPICenter">'    
        
    IF(@cr_formid is not null AND @cr_dataspy is not null)    
     SET @kpi2 = @kpi2 + '<a href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&D=' + replace(isnull(@cr_dataspy,''),'@_UserID',@p_UserID)) + '" class="KPIItemHref">'        
    ELSE    
     SET @kpi2 = @kpi2 + '<a href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&W=' + replace(isnull(@cr_where,''),'@_UserID',@p_UserID)) + '" class="KPIItemHref">'      
        
    IF (@kpi_fontsize is not null AND @kpi_fontsize > 0)    
     SET @kpi2 = @kpi2 + '<span><b><font color="Red" size="' + convert(varchar, @kpi_fontsize) + '">' +  isnull(convert(varchar, @sp_count),'') + '</font></b></span>'        
    ELSE    
     SET @kpi2 = @kpi2 + '<span><b><font color="Red">' +  isnull(convert(varchar, @sp_count),'') + '</font></b></span>'         
    SET @kpi2 = @kpi2 + '</a>'      
    SET @kpi2 = @kpi2 + '</td>'    
    SET @kpi2 = @kpi2 + '</tr>'    
   END     
  END    
      
        SET @sp_count = null                 
        FETCH NEXT FROM c INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero, @kpi_fontsize           
 END          
 CLOSE c          
 DEALLOCATE c                 
     
 SET @kpi2 = @kpi2 + '</table>'      
 SET @kpi2 = @kpi2 + '</td>'    
     
 DECLARE @show_kpi_config_button bit    
 SET @show_kpi_config_button = isnull((select cast(SettingValue as nvarchar(1))FROM SYSettings WHERE KeyCode = 'SHOW_KPI_LIST_CONF'),'0')
 IF (@show_kpi_config_button = 1)    
 BEGIN    
  SET @kpi2 = @kpi2 + '<td valign="top">'    
  SET @kpi2 = @kpi2 + '<table style="margin-top:20px;">'    
  SET @kpi2 = @kpi2 + '<tr>'    
  SET @kpi2 = @kpi2 + '<td>'    
  SET @kpi2 = @kpi2 + '<input class="e2-button e2-button-100" type="button" value="' + @kpi_config_text + '" OnClick="javascript:Simple_PopupWithoutReturnValue(''/HomePageConfiguration.aspx?RND=' + replace(RAND(),'.','') + '&TYPE=KPI'', 400,345);">'    
  SET @kpi2 = @kpi2 + '</td>'    
  SET @kpi2 = @kpi2 + '</tr>'    
  SET @kpi2 = @kpi2 + '</table>'    
  SET @kpi2 = @kpi2 + '</td>'    
 END     
 SET @kpi2 = @kpi2 + '</tr></table>'    
            
 SELECT @kpi+@kpi2 AS [TABLE_KPI]     
END     
GO
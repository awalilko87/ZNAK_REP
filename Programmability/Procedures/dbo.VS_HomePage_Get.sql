SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

    
CREATE procedure [dbo].[VS_HomePage_Get]       
(      
    @p_UserID nvarchar(30),
    @p_AppCode nvarchar(30)         
)      
      
AS      
BEGIN 
  DECLARE @vertical_menu bit 
  DECLARE @verticalMenuKey nvarchar(100)
  DECLARE @verticalMenuValue nvarchar(4000)
  DECLARE @inbox varchar(max)
  DECLARE @inbox2 varchar(max)
  DECLARE @kpi varchar(max)
  DECLARE @kpi2 varchar(max)
  DECLARE @report varchar(max)
  DECLARE @report2 varchar(max)
  DECLARE @chart varchar(max)
  DECLARE @chart2 varchar(max)
  DECLARE @inbox_count int
  DECLARE @kpi_count int
  DECLARE @rpt_count int
  DECLARE @chart_count int
       
  DECLARE @cr_id varchar(1000)      
  DECLARE @cr_desc varchar(1000)      
  DECLARE @cr_source varchar(1000)      
  DECLARE @cr_where varchar(1000)      
  DECLARE @cr_defimage varchar(1000)      
  DECLARE @cr_link varchar(1000)      
  DECLARE @cr_rpt varchar(1000)      
  DECLARE @cr_rpt_Encode varchar(1000)  
  DECLARE @cr_formid nvarchar(50)
  DECLARE @cr_dataspy nvarchar(100)
  DECLARE @kpi_type bit
  DECLARE @rpt_type bit
  DECLARE @inbox_type bit  
  DECLARE @chart_type bit 
  DECLARE @kpi_order int 
  DECLARE @kpu_order int
  DECLARE @kpu_show_when_zero bit
            
  DECLARE @sp_where nvarchar(1000);   
  DECLARE @sp_query nvarchar(1000);   
  DECLARE @sp_SQLString nvarchar(1000);      
  DECLARE @sp_ParmDefinition nvarchar(1000);      
  DECLARE @sp_count int      
      
  DECLARE @v_org varchar(30)      
  DECLARE @v_image varchar(1000)      
  DECLARE @v_GroupID nvarchar(20)   
  DECLARE @v_LangID nvarchar(10)      
  
  DECLARE @kpi_more_text nvarchar(100)
  DECLARE @kpi_add_text nvarchar(100)
  DECLARE @inbox_config_text nvarchar(100)
  DECLARE @rpt_config_text nvarchar(100) 
  DECLARE @chart_config_text nvarchar(100) 
  DECLARE @inbox_text nvarchar(100)
  DECLARE @rpt_text nvarchar(100) 
  DECLARE @chart_text nvarchar(100) 
  
  DECLARE @kpi_not_show_when_zero int
  DECLARE @inbox_not_show_when_zero int
  
  SET @verticalMenuKey = @p_AppCode + '_VMENU'
  SELECT @verticalMenuValue = SettingValue FROM dbo.SYSettings WHERE KeyCode = @verticalMenuKey
  IF (@verticalMenuValue is not null AND @verticalMenuValue <> '')
	SET @vertical_menu = 1
  ELSE	
	SET @vertical_menu = 0
      
  SELECT @v_org = SiteID, @v_LangID = isnull(LangID, 'PL'), @v_GroupID = isnull(UserGroupID,'') from dbo.SYUsers (nolock) where UserID = @p_UserID          
  
  SELECT @kpi_more_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'KPIMoreText' AND ObjectType = 'MSG'    
  SELECT @kpi_add_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'KPIAddText' AND ObjectType = 'MSG'    
  
  SELECT @inbox_config_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'HomePage_FavouritesInboxConfiguration' AND ObjectType = 'MSG'    
  SELECT @rpt_config_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'HomePage_FavouritesRptConfiguration' AND ObjectType = 'MSG'    
  SELECT @chart_config_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'HomePage_FavouritesChartConfiguration' AND ObjectType = 'MSG'        
      
  SELECT @inbox_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'InboxText' AND ObjectType = 'MSG'        
  SELECT @rpt_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'ReportText' AND ObjectType = 'MSG'    
  SELECT @chart_text = Caption FROM dbo.[VS_LangMsgs] WHERE [LangID] = @v_LangID AND ObjectID = 'ChartText' AND ObjectType = 'MSG'    
   
  DECLARE c CURSOR FOR        
    SELECT KPI_ID, KPI_DESC, KPI_SOURCE, KPI_WHERE, KPI_DEFIMAGE, KPI_LINK, KPI_RPT, KPI_TYPE, RPT_TYPE, INBOX_TYPE, KPI_ORDER, CHART_TYPE, KPU_ORDER, KPI_FORMID, KPI_DATASPY , KPU_SHOW_WHEN_ZERO    
    FROM dbo.VS_KPI (nolock)  	
		INNER JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID
	WHERE KPU_USERID = @p_UserID AND isnull(KPU_ORDER,0) <> 0 AND KPI_ACTIVE = 1 AND isnull(RSS_TYPE,0) = 0
	ORDER BY KPU_ORDER, KPI_ID    

	SET @inbox = '' 
	SET @inbox2 = ''
    SET @inbox = @inbox + '<div id="TableInboxContainerTop"><table cellpadding="0" cellspacing="0" style="width:100%;"><tr>'
    SET @inbox = @inbox + '<td id="tdColorTopInbox" style="width:8px;"></td>'
    SET @inbox = @inbox + '<td class="tdTableInboxContainerTopLeft" style="border-bottom:none 0px;"></td>'
    SET @inbox = @inbox + '<td class="tdTableInboxContainerTopMiddle"><span>' + @inbox_text + '</span></td>'
    SET @inbox = @inbox + '<td class="tdTableInboxContainerTopRight" style="border-bottom:none 0px;"></td>'
    SET @inbox = @inbox + '<td style="border-bottom:1px solid #D7D2D2;">&nbsp;</td>'
    SET @inbox = @inbox + '</tr></table></div>'
    SET @inbox = @inbox + '<table id="TableInboxContainer" cellpadding="0" cellspacing="0" class="TableInboxContainerClass">'
    SET @inbox = @inbox + '<tr>'
    SET @inbox = @inbox + '<td id="tdColorInbox" style="width:8px;"></td>'
    SET @inbox = @inbox + '<td id="tdTableInboxContainer" class="tdTableInboxContainerClass" style="border:1px solid #D7D2D2; border-top:none 0px; border-bottom:1px solid #D7D2D2;">'
	
	SET @kpi = ''
	SET @kpi2 = ''
    SET @kpi = @kpi + '<div id="KPIContainer" class="KPIContainer">' 
    
    SET @report = ''
    SET @report2 = ''
    SET @report = @report + '<div id="TableReportContainerTop"><table cellpadding="0" cellspacing="0" style="width:100%;"><tr>'
    SET @report = @report + '<td style="width:9px;"></td>'
    SET @report = @report + '<td class="tdTableReportContainerTopLeft" style="border-bottom:none 0px;"></td>'
    SET @report = @report + '<td class="tdTableReportContainerTopMiddle"><span>' +  @rpt_text + '</span></td>'
    SET @report = @report + '<td class="tdTableReportContainerTopRight" style="border-bottom:none 0px;"></td>'
    SET @report = @report + '<td style="border-bottom:1px solid #D7D2D2;">&nbsp;</td>'
    SET @report = @report + '</tr></table></div>'
    SET @report = @report + '<table id="TableReportContainer" cellpadding="0" cellspacing="0" class="TableReportContainerClass">'
    SET @report = @report + '<tr>'
    SET @report = @report + '<td style="width:10px;"></td>'
    SET @report = @report + '<td id="tdTableReportContainer" class="tdTableReportContainerClass" style="border:1px solid #D7D2D2; border-top:none 0px; border-bottom:1px solid #D7D2D2;">'
    
    SET @chart = ''
    SET @chart2 = ''
    SET @chart = @chart + '<div id="TableChartContainerTop"><table cellpadding="0" cellspacing="0" style="width:100%;"><tr>'
    SET @chart = @chart + '<td style="width:9px;"></td>'
    SET @chart = @chart + '<td class="tdTableChartContainerTopLeft" style="border-bottom:none 0px;"></td>'
    SET @chart = @chart + '<td class="tdTableChartContainerTopMiddle"><span>' +  @chart_text + '</span></td>'
    SET @chart = @chart + '<td class="tdTableChartContainerTopRight" style="border-bottom:none 0px;"></td>'
    SET @chart = @chart + '<td style="border-bottom:1px solid #D7D2D2;">&nbsp;</td>'
    SET @chart = @chart + '</tr></table></div>'
    SET @chart = @chart + '<table id="TableChartContainer" cellpadding="0" cellspacing="0" class="TableChartContainerClass">'
    SET @chart = @chart + '<tr>'
    SET @chart = @chart + '<td id="tdColorChartTop" style="width:11px;"></td>'
    SET @chart = @chart + '<td id="tdTableChartContainer" class="tdTableChartContainerClass" style="border:1px solid #D7D2D2; border-top:none 0px; border-bottom:1px solid #D7D2D2;">'

    SET @inbox_count = 1;
    SET @chart_count = 0;
	SET @kpi_count = 0;
	SET @rpt_count = 0;
	SET @kpi_not_show_when_zero = 0;
	SET @inbox_not_show_when_zero = 0;
		 
	  OPEN c      
	  FETCH NEXT FROM c INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @rpt_type, @inbox_type, @kpi_order, @chart_type, @kpu_order, @cr_formid, @cr_dataspy, @kpu_show_when_zero      
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
      
    SELECT @cr_rpt_Encode =  N'CR_'+@cr_rpt      
        
    IF (@inbox_type = 'True' AND @inbox_count <9)
    BEGIN
			IF (@sp_count > 0 OR @kpu_show_when_zero = 1) 
			BEGIN
				IF (@inbox_count%2 = 0)
					SET @inbox2 = @inbox2 + '<div class="InboxItemColor">'  
				ELSE
					SET @inbox2 = @inbox2 + '<div class="InboxItem">'  
				IF(@cr_formid is not null AND @cr_dataspy is not null)  
				SET @inbox2 = @inbox2 + '<a class="InboxItemHref" href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&D=' + replace(isnull(@cr_dataspy,''),'@_UserID',@p_UserID))+'">' + (isnull(@cr_desc,'')) + '<b><font color="Black"> ' + isnull(convert(varchar, @sp_count),'') + '</b></font></a>'         
		    ELSE   
				SET @inbox2 = @inbox2 + '<a class="InboxItemHref" href="/link.aspx?B=' + dbo.VS_EncodeBase64(isnull(@cr_link,'')+ '&W=' + replace(isnull(@cr_where,''),'@_UserID',@p_UserID)) + '">' + (isnull(@cr_desc,'')) + '<b><font color="Black"> ' + isnull(convert(varchar, @sp_count),'') + '</b></font></a>' 
			  SET @inbox2 = @inbox2 + '</div>' 
				SET @inbox_count = @inbox_count + 1
			END
			ELSE
				SET @inbox_not_show_when_zero = @inbox_not_show_when_zero + 1
		END
		    
		IF (@kpi_type = 'True' AND @kpi_count < 6)
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
				SET @kpi2 = @kpi2 + '<span class="KPIItemText">' + (isnull(@cr_desc,'')) + '<b><font color="Black"> ' + isnull(convert(varchar, @sp_count),'') + '</font></b></span>'       
				SET @kpi2 = @kpi2 + '</a>'  
				SET @kpi2 = @kpi2 + '</div>'   
				SET @kpi_count = @kpi_count + 1   
			END
			ELSE
				SET @kpi_not_show_when_zero = @kpi_not_show_when_zero + 1
		END	   
		
		IF (@rpt_type = 'True' AND @rpt_count < 6)
		BEGIN
		  SET @report2 = @report2 + '<div class="ReportItem">'      
	      SET @report2 = @report2 + '<a href="' + 'javascript:Simple_Popup(''/SimplePopup.aspx?FID=' + @cr_rpt_Encode + ''',null,''top=10 left=400 width=440 height=370,scrollbars=yes,menubar=no,resizable=yes'');void(0);" class="ReportItemHref">'   
		  SET @report2 = @report2 + '<img class="ReportItemImage" SRC="/Images/KPI/'+ isnull(@cr_defimage,'') +'"/>'       
		  SET @report2 = @report2 + '<br />'         
		  SET @report2 = @report2 + '<span class="ReportItemText">' + (isnull(@cr_desc,'')) + '</span>'       
		  SET @report2 = @report2 + '</a>'  
		  SET @report2 = @report2 + '</div>'    
		  SET @rpt_count = @rpt_count + 1 
		END
		
		IF (@chart_type = 'True' AND @chart_count < 6)
		BEGIN     
		  SET @chart2 = @chart2 + '<div class="ChartItem">'      
		  SET @chart2 = @chart2 + '<a href="' + 'javascript:Simple_Popup(''/SimplePopup.aspx?FID=' + isnull(@cr_link,'') + ''',null,''scrollbars=no,menubar=no,resizable=yes,fullscreen=no'');void(0);" class="ChartItemHref">'    
		  SET @chart2 = @chart2 + '<img class="ChartItemImage" SRC="/Images/KPI/'+ isnull(@cr_defimage,'') +'"/>'       
		  SET @chart2 = @chart2 + '<br />'         
		  SET @chart2 = @chart2 + '<span class="ChartItemText">' + (isnull(@cr_desc,'')) + '</span>'       
		  SET @chart2 = @chart2 + '</a>'  
		  SET @chart2 = @chart2 + '</div>'      
		  SET @chart_count = @chart_count + 1  
		END
    
    SET @sp_count = null      
            
    FETCH NEXT FROM c INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @kpi_type, @rpt_type, @inbox_type, @kpi_order, @chart_type, @kpu_order, @cr_formid, @cr_dataspy, @kpu_show_when_zero       
	END      
	CLOSE c      
	DEALLOCATE c      
	 
  DECLARE @KPIcount int
  SET @KPIcount = 0
  SET @KPIcount = (SELECT count(*) FROM dbo.VS_KPI (nolock) INNER JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID WHERE KPU_USERID = @p_UserID AND isnull(KPU_ORDER,0) <> 0 AND KPI_ACTIVE = 1 AND VS_KPI.KPI_TYPE = 1)    
  SET @KPIcount = @KPIcount - @kpi_not_show_when_zero 
	  
  DECLARE @Inboxcount int
  SET @Inboxcount = 0
  SET @Inboxcount = (SELECT count(*) FROM dbo.VS_KPI (nolock) INNER JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID WHERE KPU_USERID = @p_UserID AND isnull(KPU_ORDER,0) <> 0 AND KPI_ACTIVE = 1 AND VS_KPI.INBOX_TYPE = 1)  
  SET @Inboxcount = @Inboxcount - @inbox_not_show_when_zero
             
  DECLARE @Reportcount int
  SET @Reportcount = 0
  SET @Reportcount = (SELECT count(*) FROM dbo.VS_KPI (nolock) INNER JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID WHERE KPU_USERID = @p_UserID AND isnull(KPU_ORDER,0) <> 0 AND KPI_ACTIVE = 1 AND VS_KPI.RPT_TYPE = 1)  
                              
  DECLARE @Chartcount int
  SET @Chartcount = 0
  SET @Chartcount = (SELECT count(*) FROM dbo.VS_KPI (nolock) INNER JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID WHERE KPU_USERID = @p_UserID AND isnull(KPU_ORDER,0) <> 0 AND KPI_ACTIVE = 1 AND VS_KPI.CHART_TYPE = 1)              
   
    IF @Inboxcount = 0 
		SET @inbox2 = @inbox2 + '&nbsp;</td>'
	ELSE	
		SET @inbox2 = @inbox2 + '</td>'
		
	SET @inbox2 = @inbox2 + '<td style="width:10px;"></td>'
	SET @inbox2 = @inbox2 + '</tr>'
	SET @inbox2 = @inbox2 + '<tr style="height:20px;">'
    SET @inbox2 = @inbox2 + '<td colspan="3">'
    SET @inbox2 = @inbox2 + '<table id="tableBottomInbox" cellpadding="0" cellspacing="0" style="margin-left:8px; width:310px;">'
    SET @inbox2 = @inbox2 + '<tr>'
    SET @inbox2 = @inbox2 + '<td class="BottomBgLeft"></td>'
	  SET @inbox2 = @inbox2 + '<td class="BottomBg" id="tdBottomBgInbox"><a href="' + 'javascript:Simple_PopupWithoutReturnValue(''/HomePageConfiguration.aspx?RND=' + replace(RAND(),'.','') + '&TYPE=INBOX' + ''', 400, 345);" style="text-decoration:none; outline:none 0px; color:white;font-weight:bold; padding-left:15px;">' 
      + @inbox_config_text 
      + '</a></td>'  
    SET @inbox2 = @inbox2 + '<td class="BottomBgRight"></td>'
    SET @inbox2 = @inbox2 + '</tr>'
    SET @inbox2 = @inbox2 + '</table>'
    SET @inbox2 = @inbox2 + '</td>'
    SET @inbox2 = @inbox2 + '</tr>'  
	SET @inbox2 = @inbox2 + '</table>' 
	
    SET @kpi2 = @kpi2 + '<div id="divKPIMoreAndAdd" style="position:relative; float:left; width:32px; height:165px; text-align:center;">'  
    IF (@KPIcount > 6)
	BEGIN
		SET @kpi2 = @kpi2 + '<div class="divKPIMore">'    
		SET @kpi2 = @kpi2 + '<a href="/Tabs.aspx?MID=&TAB=&FID=KPI" class="aKPIMore">' 
		SET @kpi2 = @kpi2 + '<img SRC="/Images/KPI/wiecej.png" class="imgKPIMore"/>'   
		SET @kpi2 = @kpi2 + '<br />'       
		SET @kpi2 = @kpi2 + '<span class="textKPIMore">' + @kpi_more_text + '</span>'     
		SET @kpi2 = @kpi2 + '</a>'
		SET @kpi2 = @kpi2 + '</div>'  	
	END
	ELSE
	BEGIN
		SET @kpi2 = @kpi2 + '<div style="height:83px;"></div>'  	
	END
	
	SET @kpi2 = @kpi2 + '<div class="divKPIAdd">'  
	SET @kpi2 = @kpi2 + '<a href="' + 'javascript:Simple_PopupWithoutReturnValue(''/HomePageConfiguration.aspx?RND=' + replace(RAND(),'.','') + '&TYPE=KPI'', 400, 345);" class="aKPIMore">'   
	SET @kpi2 = @kpi2 + '<img SRC="/Images/KPI/dodaj.png" class="imgKPIAdd"/>'   
	SET @kpi2 = @kpi2 + '<br />'       
	SET @kpi2 = @kpi2 + '<span class="textKPIMore">' + @kpi_add_text + '</span>'     
	SET @kpi2 = @kpi2 + '</a>'
	SET @kpi2 = @kpi2 + '</div>' 
	SET @kpi2 = @kpi2 + '</div>' 
	SET @kpi2 = @kpi2 + '</div>'  
	
	IF @Reportcount = 0 
		SET @report2 = @report2 + '&nbsp;</td>'
	ELSE	
		SET @report2 = @report2 + '</td>'
	SET @report2 = @report2 + '</td>'
	SET @report2 = @report2 + '<td style="width:10px;"></td>'
	SET @report2 = @report2 + '</tr>'
	SET @report2 = @report2 + '<tr style="height:20px;">'
    SET @report2 = @report2 + '<td colspan="3">'
    SET @report2 = @report2 + '<table cellpadding="0" cellspacing="0" style="margin-left:10px;">'
    SET @report2 = @report2 + '<tr>'
    SET @report2 = @report2 + '<td class="BottomBgLeft"></td>'
	SET @report2 = @report2 + '<td class="BottomBg" id="tdBottomBgReport"><a href="' + 'javascript:Simple_PopupWithoutReturnValue(''/HomePageConfiguration.aspx?RND=' + replace(RAND(),'.','') + '&TYPE=RPT'', 400, 345);" style="text-decoration:none; outline:none 0px; color:white; font-weight:bold; padding-left:15px;">' + @rpt_config_text + '</a></td>' 
    SET @report2 = @report2 + '<td class="BottomBgRight"></td>'
    SET @report2 = @report2 + '</tr>'
    SET @report2 = @report2 + '</table>'
    SET @report2 = @report2 + '</td>'
    SET @report2 = @report2 + '</tr>'  
	SET @report2 = @report2 + '</table>' 
	
	IF @Chartcount = 0 
		SET @chart2 = @chart2 + '&nbsp;</td>'
	ELSE	
		SET @chart2 = @chart2 + '</td>'
	SET @chart2 = @chart2 + '<td id="tdColorChart" style="width:10px;"></td>'
	SET @chart2 = @chart2 + '</tr>'
	SET @chart2 = @chart2 + '<tr style="height:20px;">'
    SET @chart2 = @chart2 + '<td colspan="3">'
    SET @chart2 = @chart2 + '<table id="tableBottomChart" cellpadding="0" cellspacing="0" style="margin-left:10px;">'
    SET @chart2 = @chart2 + '<tr>'
    SET @chart2 = @chart2 + '<td class="BottomBgLeft"></td>'
	SET @chart2 = @chart2 + '<td class="BottomBg" id="tdBottomBgChart"><a href="' + 'javascript:Simple_PopupWithoutReturnValue(''/HomePageConfiguration.aspx?RND=' + replace(RAND(),'.','') + '&TYPE=CHART'', 400, 345);" style="text-decoration:none; outline:none 0px; color:white; font-weight:bold; padding-left:15px;">' + @chart_config_text + '</a></td>'  
    SET @chart2 = @chart2 + '<td class="BottomBgRight"></td>'
    SET @chart2 = @chart2 + '</tr>'
    SET @chart2 = @chart2 + '</table>'
    SET @chart2 = @chart2 + '</td>'
    SET @chart2 = @chart2 + '</tr>'  
	SET @chart2 = @chart2 + '</table>'  
	 
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
		IF (@KPIcount = 0)
		BEGIN
			SET @scriptKPI = @scriptKPI + 'if (width < 1300) { '
			SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1240px";' 
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = (((width-1522)/2)+20) + "px"; '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "-10px"; } '
			SET @scriptKPI = @scriptKPI + 'else if (width >= 1300 && width < 1600) { '
			SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1150px";' 
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = "0px"; '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "10px"; } '
			SET @scriptKPI = @scriptKPI + 'else if (width >= 1600 && width < 1900) { '
			SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1240px";' 
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = (((width-1522)/2)+20) + "px"; '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "-80px"; } '
			SET @scriptKPI = @scriptKPI + 'else if (width >= 1900) { '
			SET @scriptKPI = @scriptKPI + ' document.getElementById(''KPIContainer'').style.width = "1240px";' 
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = (((width-1522)/2)+20) + "px"; '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "-50px"; } '
		END
		ELSE
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
	END
	ELSE
	BEGIN
		SET @scriptKPI = @scriptKPI + '	document.getElementById(''KPIContainer'').style.marginLeft = (((width-1292)/2)+20) + "px"; '
		IF (@KPIcount = 0)
		BEGIN
			SET @scriptKPI = @scriptKPI + 'if (width < 1300) { '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "-10px"; } '
			SET @scriptKPI = @scriptKPI + 'else if (width >= 1300 && width < 1600) { '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "0px"; } '
			SET @scriptKPI = @scriptKPI + 'else if (width >= 1600) { '
			SET @scriptKPI = @scriptKPI + '	document.getElementById(''divKPIMoreAndAdd'').style.marginLeft = "-50px"; } '
		END
		SET @scriptKPI = @scriptKPI + 'document.getElementById(''KPIContainer'').style.width = "1240px";' 
	END
	SET @scriptKPI = @scriptKPI + ' } '
	SET @scriptKPI = @scriptKPI + '</script>'
	SET @kpi2 = @kpi2 + @scriptKPI
	
	DECLARE @scriptINBOX varchar(max)    
	SET @scriptINBOX = ''   
	SET @scriptINBOX = @scriptINBOX + '<script type="text/javascript" language="javascript">'
	SET @scriptINBOX = @scriptINBOX + 'var width = document.body.offsetWidth;'
	SET @scriptINBOX = @scriptINBOX + 'var height = document.body.offsetHeight;'
	SET @scriptINBOX = @scriptINBOX + 'var IEVersion = getIEVersionNumber();'
	SET @scriptINBOX = @scriptINBOX + 'if (IEVersion == 7) { '
	SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE2'').style.marginLeft = "0px"; '
	SET @scriptINBOX = @scriptINBOX + '  document.getElementById(''TableInboxContainerTop'').style.width = "318px";' 
	SET @scriptINBOX = @scriptINBOX + '  document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
	SET @scriptINBOX = @scriptINBOX + '  document.getElementById(''TableInboxContainer'').style.width = "330px";' 
	SET @scriptINBOX = @scriptINBOX + '  document.getElementById(''tdTableInboxContainer'').style.width = "250px";'  
	SET @scriptINBOX = @scriptINBOX + '  document.getElementById(''tdBottomBgInbox'').style.width = "290px";' 
	SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''tdColorInbox'').style.width = "8px"; '
	SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''tdColorTopInbox'').style.width = "9px"; '
	SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''tableBottomInbox'').style.marginLeft = "9px"; '
	SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''tableBottomInbox'').style.width = "309px"; '
	SET @scriptINBOX = @scriptINBOX + ' } else { '
	IF (@vertical_menu = 1)
	BEGIN	
		SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE2'').style.width = 310 + (((width-1292)/2)+20) + "px"; '  
		SET @scriptINBOX = @scriptINBOX + '  if (width < 1300) { '
		
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "300px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = "315px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = "305px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = "5px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "4px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "5px"; '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "309px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "300px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = "5px"; } '
		SET @scriptINBOX = @scriptINBOX + '   else if (width >= 1300 && width < 1500) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "300px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = "315px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = "305px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = "5px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "4px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "5px"; '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "309px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "300px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = "5px"; } '
		SET @scriptINBOX = @scriptINBOX + '   else if (width > 1500 && width <= 1600) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "400px"; ' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = "385px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = "376px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = "5px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "4px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "5px"; ' 	
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "357px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "372px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = "5px"; } ' 	
		SET @scriptINBOX = @scriptINBOX + '   else if (width > 1600 && width < 1900) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "400px"; ' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = "425px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = "416px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = "45px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "49px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = "50px"; ' 	
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "357px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "372px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = "45px"; } ' 
		SET @scriptINBOX = @scriptINBOX + '   else if (width >= 1900) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "373px"; ' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = 330 + (((width-1522)/2)+20) + "px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = 330 + (((width-1522)/2)+10) + "px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = (((width-1602)/2)+8) + "px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1602)/2)+9) + "px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1602)/2)+10) + "px"; ' 	
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "357px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "372px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = (((width-1602)/2)+8) + "px"; } ' 
	END
	ELSE 
	BEGIN	
		SET @scriptINBOX = @scriptINBOX + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE2'').style.width = 310 + (((width-1292)/2)+20) + "px"; '  
		SET @scriptINBOX = @scriptINBOX + '  if (width < 1300) { '
		SET @scriptINBOX = @scriptINBOX + '    document.getElementById(''tdTableInboxContainer'').style.width = 250 + (((width-1282)/2)+19) + "px";'   
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + 'document.getElementById(''TableInboxContainer'').style.width = 330 + (((width-1292)/2)+23) + "px";'
		ELSE
			SET @scriptINBOX = @scriptINBOX + 'document.getElementById(''TableInboxContainer'').style.width = 330 + (((width-1292)/2)+20) + "px";'
		SET @scriptINBOX = @scriptINBOX + '    document.getElementById(''TableInboxContainerTop'').style.width = 330 + (((width-1292)/2)+10) + "px";' 
		SET @scriptINBOX = @scriptINBOX + '    document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";'
		SET @scriptINBOX = @scriptINBOX + '	   document.getElementById(''tdColorTopInbox'').style.width = (((width-1282)/2)+19) + "px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1292)/2)+22) + "px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1292)/2)+24) + "px"; '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "309px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "316"; '
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.marginLeft = (((width-1282)/2)+19) + "px"; } '
		SET @scriptINBOX = @scriptINBOX + '   else if (width >= 1300 && width < 1600) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = 250 + (((width-1292)/2)+20) + "px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = 330 + (((width-1292)/2)+20) + "px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = 330 + (((width-1292)/2)+11) + "px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = (((width-1292)/2)+16) + "px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1292)/2)+22) + "px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1292)/2)+23) + "px"; '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "309px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "325px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = (((width-1292)/2)+16) + "px"; } '
		SET @scriptINBOX = @scriptINBOX + '   else if (width >= 1600 && width < 1900) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "375px"; ' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = 330 + (((width-1292)/2)+20) + "px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = 330 + (((width-1292)/2)+10) + "px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = (((width-1372)/2)+8) + "px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1372)/2)+10) + "px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1372)/2)+11) + "px"; ' 	
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "357px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "372px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = (((width-1372)/2)+8) + "px"; } ' 
		SET @scriptINBOX = @scriptINBOX + '   else if (width >= 1900) { '
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdTableInboxContainer'').style.width = "373px"; ' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainer'').style.width = 330 + (((width-1292)/2)+20) + "px";'
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.width = 330 + (((width-1292)/2)+10) + "px";' 
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''TableInboxContainerTop'').style.paddingTop = "23px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tdColorTopInbox'').style.width = (((width-1372)/2)+8) + "px"; '
		IF (@Inboxcount = 0)
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1372)/2)+10) + "px"; '
		ELSE
			SET @scriptINBOX = @scriptINBOX + '	document.getElementById(''tdColorInbox'').style.width = (((width-1372)/2)+11) + "px"; ' 	
		SET @scriptINBOX = @scriptINBOX + '     document.getElementById(''tdBottomBgInbox'').style.width = "357px";' 
		SET @scriptINBOX = @scriptINBOX + '		document.getElementById(''tableBottomInbox'').style.width = "372px"; '
		SET @scriptINBOX = @scriptINBOX + '	    document.getElementById(''tableBottomInbox'').style.marginLeft = (((width-1372)/2)+8) + "px"; } ' 
	END
	
	SET @scriptINBOX = @scriptINBOX + ' } </script>'
	SET @inbox2 = @inbox2 + @scriptINBOX
	
	DECLARE @scriptRPT varchar(max)    
	SET @scriptRPT = ''   
    SET @scriptRPT = @scriptRPT + '<script ty pe="text/javascript" language="javascript">'
	SET @scriptRPT = @scriptRPT + 'var width = document.body.offsetWidth;' 
	SET @scriptRPT = @scriptRPT + 'var IEVersion = getIEVersionNumber();'
	SET @scriptRPT = @scriptRPT + 'document.getElementById(''TableReportContainerTop'').style.width = "449px";'
	SET @scriptRPT = @scriptRPT + 'document.getElementById(''TableReportContainerTop'').style.paddingTop = "23px";'
	SET @scriptRPT = @scriptRPT + 'document.getElementById(''TableReportContainer'').style.width = "460px";'  
	SET @scriptRPT = @scriptRPT + 'document.getElementById(''tdTableReportContainer'').style.width = "438px";' 
	SET @scriptRPT = @scriptRPT + 'document.getElementById(''tdBottomBgReport'').style.width = "428px";' 
	SET @scriptRPT = @scriptRPT + 'if (IEVersion == 7) { '
	SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = "0px"; '
	SET @scriptRPT = @scriptRPT + '} else { '
	IF (@vertical_menu = 1)
	BEGIN
		SET @scriptRPT = @scriptRPT + '  if (width < 1300) { ' 	
			SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = "-20px"; } '
		SET @scriptRPT = @scriptRPT + '  else if (width >= 1300 && width < 1500) { ' 	
			SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = "-20px"; } '
		SET @scriptRPT = @scriptRPT + '  else if (width > 1500 && width < 1600) { ' 	
			SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = "53px"; } '
		SET @scriptRPT = @scriptRPT + '  else if (width == 1600) { ' 	
			SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = "58px"; } '	
		SET @scriptRPT = @scriptRPT + '  else { ' 	
			SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = (((width-1522)/2)+20) + "px"; } '
	END
	ELSE
		SET @scriptRPT = @scriptRPT + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_RPT'').style.marginLeft = (((width-1292)/2)+20) + "px"; '
	SET @scriptRPT = @scriptRPT + '} </script>'
	SET @report2 = @report2 + @scriptRPT
	
	DECLARE @scriptCHART varchar(max)    
	SET @scriptCHART = ''   
    SET @scriptCHART = @scriptCHART + '<script type="text/javascript" language="javascript">'
	SET @scriptCHART = @scriptCHART + 'var width = document.body.offsetWidth;' 
	SET @scriptCHART = @scriptCHART + 'var IEVersion = getIEVersionNumber();'
	SET @scriptCHART = @scriptCHART + 'if (IEVersion == 7) { '
	SET @scriptCHART = @scriptCHART + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_CHART'').style.marginLeft = "0px"; '
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainerTop'').style.width = "449px"; '
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainer'').style.width = "460px"; '
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''tdTableChartContainer'').style.width = "438px"; '
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''tdBottomBgChart'').style.width = "427px"; '  
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''tdColorChart'').style.width = "10px"; '  
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''tdColorChartTop'').style.width = "10px"; '  
	SET @scriptCHART = @scriptCHART + '  document.getElementById(''tableBottomChart'').style.width = "440px"; ' 
	SET @scriptCHART = @scriptCHART + ' } else { '
	IF (@vertical_menu = 1)
	BEGIN
		SET @scriptCHART = @scriptCHART + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_CHART'').style.marginLeft = (((width-1522)/2)+20) + "px"; ' 
		SET @scriptCHART = @scriptCHART + '  if (width < 1300) { ' 
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_CHART'').style.marginLeft = "-25px"; ' 
		IF (@Chartcount = 0) 
		BEGIN
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''TableChartContainer'').style.width = "448px"; ' 
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "8px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "358px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1522)/2)+20) + "px"; '
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainer'').style.width = "446px"; ' 
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "10px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "392px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1522)/2)+24) + "px"; ' 					
		END	
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "427px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "427px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "435px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '			
		SET @scriptCHART = @scriptCHART + ' } else if (width >= 1300 && width < 1500) { '
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_CHART'').style.marginLeft = "-25px"; ' 
		IF (@Chartcount = 0) 
		BEGIN
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''TableChartContainer'').style.width = "448px"; ' 
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "8px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "358px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1522)/2)+20) + "px"; '
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainer'').style.width = "446px"; ' 
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "10px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "392px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1522)/2)+24) + "px"; ' 					
		END	
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "427px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "427px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "435px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
		
		
		
		SET @scriptCHART = @scriptCHART + ' } else if (width >= 1500 && width <= 1600) { ' 
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''TableChartContainer'').style.width = "470px"; '
		IF (@Chartcount = 0)
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "8px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "375px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = "14px"; ' 
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "9px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "400px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = "16px"; '  
		END
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "444px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "420px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "452px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
			
			
		
		SET @scriptCHART = @scriptCHART + ' } else if (width > 1600 && width < 1900) { ' 
		SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainer'').style.width = "500px"; '
		IF (@Chartcount = 0)
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "8px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "375px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = "40px"; ' 
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "9px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "400px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = "43px"; '  
		END
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "444px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "420px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "452px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
		SET @scriptCHART = @scriptCHART + ' } else if (width >= 1900) { ' 
		SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainer'').style.width = "582px"; '
		IF (@Chartcount = 0)
		BEGIN
			SET @scriptCHART = @scriptCHART + '   	document.getElementById(''tdColorChartTop'').style.width = "9px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "396px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = "115px"; ' 
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '   	document.getElementById(''tdColorChartTop'').style.width = "10px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "438px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = "127px"; '   
		END
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "444px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "420px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "452px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; } } '
		SET @scriptCHART = @scriptCHART + ' </script>'
		SET @chart2 = @chart2 + @scriptCHART
	END
	ELSE
	BEGIN
		SET @scriptCHART = @scriptCHART + '	 document.getElementById(''ctl00_ContentPlaceHolder1_Simple1_lbbTABLE_CHART'').style.marginLeft = (((width-1292)/2)+20) + "px"; '
		SET @scriptCHART = @scriptCHART + '  document.getElementById(''TableChartContainer'').style.width = 460 + (((width-1292)/2)+35) + "px"; ' 
		SET @scriptCHART = @scriptCHART + '  if (width < 1300) { ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdTableChartContainer'').style.width = 438 + (((width-1292)/2)+20) + "px"; ' 
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''TableChartContainerTop'').style.width = "470px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+24) + "px"; ' 
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "461px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "427px"; ' 
		IF (@Chartcount = 0)
			SET @scriptCHART = @scriptCHART + '		document.getElementById(''tdColorChartTop'').style.width = "9px"; '
		ELSE
			SET @scriptCHART = @scriptCHART + '		document.getElementById(''tdColorChartTop'').style.width = "10px"; '	
		SET @scriptCHART = @scriptCHART + ' } else if (width >= 1300 && width < 1600) { ' 
		IF (@Chartcount = 0) 
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "8px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "378px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+20) + "px"; '
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "9px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "392px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+24) + "px"; ' 	
		END	
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "448px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "427px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "457px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
		SET @scriptCHART = @scriptCHART + ' } else if (width >= 1600 && width < 1900) { ' 
		IF (@Chartcount = 0)
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "8px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "375px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+6) + "px"; ' 
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + '	document.getElementById(''tdColorChartTop'').style.width = "9px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "400px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+19) + "px"; '  
		END
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "444px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "420px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "452px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; '
		SET @scriptCHART = @scriptCHART + ' } else if (width >= 1900) { ' 
		SET @scriptCHART = @scriptCHART + '   	document.getElementById(''tdColorChartTop'').style.width = "9px"; ' 
		IF (@Chartcount = 0)
		BEGIN
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "396px"; ' 
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+6) + "px"; ' 
		END
		ELSE
		BEGIN
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdTableChartContainer'').style.width = "414px"; '
			SET @scriptCHART = @scriptCHART + ' document.getElementById(''tdColorChart'').style.width = (((width-1292)/2)+19) + "px"; '  
		END
		SET @scriptCHART = @scriptCHART + '		document.getElementById(''tableBottomChart'').style.width = "444px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''tdBottomBgChart'').style.width = "420px"; ' 
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.width = "452px"; '
		SET @scriptCHART = @scriptCHART + '     document.getElementById(''TableChartContainerTop'').style.paddingTop = "23px"; } } '
		SET @scriptCHART = @scriptCHART + ' </script>'
		SET @chart2 = @chart2 + @scriptCHART
	END
	
	
	
	      	       
	SELECT @inbox+@inbox2 AS [TABLE], @kpi+@kpi2 AS [TABLE_KPI], @report+@report2 AS [TABLE_RPT], @chart+@chart2 AS [TABLE_CHART] 
END  
GO
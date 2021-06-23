SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetKSTTable](@p_POSKI nvarchar(30), @p_HEIGHT int)
returns nvarchar(max)
as
begin
	declare @v_HTML nvarchar(max)
	declare @v_SCRIPT nvarchar(max)
	declare @v_MAT_COUNT int
	declare @v_HEIGHT int

	select @v_MAT_COUNT = count(*) from dbo.COSTCLASSIFICATION_KST where CCA_CCFID = (select CCF_ROWID from COSTCLASSIFICATION where CCF_CODE = @p_POSKI)
	select @v_HEIGHT = case @v_MAT_COUNT when 0 then 0 else @p_HEIGHT end

	select 
	@v_HTML = N'
<style id="mat">
.naglowek_m
	{color:black;
	font-weight:700;
	text-align:center;
	vertical-align:middle;
	border:.5px solid windowtext;
	white-space:normal;
	background:url(Images/wypelnienie_grid.png);
	'+case when @v_MAT_COUNT > 0 then 'border-bottom:none;' else '' end+
	'}
.do_lewej_m
	{color:black;
	font-weight:400;
	text-align:left;
	vertical-align:middle;
	border:.5px solid windowtext;
	white-space:normal;}
.do_prawej_m
	{color:black;
	font-weight:400;
	text-align:right;
	vertical-align:middle;
	border:.5px solid windowtext;
	white-space:normal;}
.do_srodka_m
	{color:black;
	font-weight:400;
	text-align:center;
	vertical-align:middle;
	border:.5px solid windowtext;
	white-space:normal;}
</style>
<div style="width:400px;">
<table style="border-collapse:collapse;table-layout:fixed;" class="ARxListLight" >
 <tr>
  <td style="width:200px" class=naglowek_m>KŚT</td>
  <td style="width:100px" class=naglowek_m>Od</td>
  <td style="width:100px" class=naglowek_m>Do</td>
 </tr>
</table>
</div>
<div id="div_tabelka_mat" style="overflow:auto;width:400px;'+isnull('height:'+convert(varchar,@v_HEIGHT)+'px;','')+'">
<table style="border-collapse: collapse;table-layout:fixed;" class="ARxListLight" >'

select @v_HTML = @v_HTML + N'
 <tr>
  <td style="width:200px" class=do_lewej_m>'+CCA_TXTSEG+'</td>
  <td style="width:100px" class=do_lewej_m>'+cast(CCA_NDPER_OD as nvarchar(30))+'</td>
  <td style="width:100px" class=do_lewej_m>'+cast(CCA_NDPER_DO as nvarchar(30))+'</td>  
 </tr>'
from dbo.COSTCLASSIFICATION_KST where CCA_CCFID = (select CCF_ROWID from COSTCLASSIFICATION where CCF_CODE = @p_POSKI)

select @v_SCRIPT = N'<script type="text/javascript" language="javascript">
var width = document.body.offsetWidth;
var IEVersion = getIEVersionNumber();
if (IEVersion == 7) {
	document.getElementById(''div_tabelka_mat'').style.width = "400px";}
else {
	document.getElementById(''div_tabelka_mat'').style.width = "400px";}
</script>'

select @v_HTML = @v_HTML + N'
</table>
</div>
'+@v_SCRIPT+'

'
 return @v_HTML
end




GO
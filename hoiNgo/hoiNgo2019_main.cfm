<title>Hội Ngộ Thiết Giáp</title>
<cfparam name="url.sortOrder" default="defaultOrder">

<script>
	sortBy=function(sortBy)
	{
		ColdFusion.navigate('hoiNgo2019_view.cfm?sortOrder='+sortBy, 'hoiNgoiDiv');
	}
	
</script>
<cfprocessingdirective pageencoding = "utf-8">
<div style="font-size:20px; text-align:center; width:800px; margin-bottom:5px">
	<a href="http://daihoithietgiap-qlvnch.com/" target="_blank" style="text-decoration:none; color:blue; font-weight:bold">Hội Ngộ Thiết Giáp<br>Danh Sách Xác Nhận Tham Dự</a>
</div>

<div style="margin-bottom:5px" >
	<table border="0" style="width:900px">
		<tr>
			<td>
				Sort By:
				<input name="sortBy" value="orderNumber" type="radio" onclick="sortBy('order_number')">Order Number</input>
				<input name="sortBy" value="name" type="radio" onclick="sortBy('defaultOrder')" checked="checked" >Name</input>				
			</td>
			<td style="text-align:right">
				<a href="hoiNgoThietGiap.xlsx" target="_blank" style="color: blue; font-weight:bold" >Excel</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="Review & Print Labels" type="button" onclick="printLabels(<cfoutput>'#url.sortOrder#'</cfoutput>)"></input>				
			</td>
		</tr>
	</table>
</div>

<cfdiv bind="url:hoiNgo2019_view.cfm?sortOrder=#url.sortOrder#" id="hoiNgoiDiv"/>


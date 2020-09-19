

<cfspreadsheet action="read" src="hoiNgoThietGiap.xlsx"  query="dataQuery" excludeheaderrow="true" headerrow="1" >
<cfset hoiNgoList = queryNew("address,name,order_number,number_of_register,unit, defaultOrder","VarChar,varchar,integer,integer,varchar,integer")>

<script>

	exporToExcel=function(sortOrder)
	{
		var excelWindow = window.open('hoiNgo2019_excel.cfm?sortOrder='+sortOrder, 'locationWin', 'height=900, width=900, top=1'); 
		excelWindow.focus();
	}

	printLabels=function(sortOrder)
	{
		var pdfWindow = window.open('hoiNgo2019_pdf.cfm?sortOrder='+sortOrder, 'locationWin', 'height=900, width=900, top=1'); 
		pdfWindow.focus();
	}
		
</script>
<cfoutput query="dataQuery">
	<cfloop from="1" to="#dataQuery.number_of_register#" index="i">
		<cfset queryAddRow(hoiNgoList)>
		<cfset querySetCell(hoiNgoList, "address", dataQuery.address)>
		<cfset querySetCell(hoiNgoList, "name", dataQuery.name)>
		<cfset querySetCell(hoiNgoList, "order_number", dataQuery.order_number)>
		<cfset querySetCell(hoiNgoList, "number_of_register", dataQuery.number_of_register)>
		<cfset querySetCell(hoiNgoList, "unit", dataQuery.unit)>
		<cfset querySetCell(hoiNgoList, "defaultOrder", currentRow)>
	</cfloop>
</cfoutput>

<cfloop from="1" to="20" index="i">
	<cfset queryAddRow(hoiNgoList)>
	<cfset querySetCell(hoiNgoList, "address", '')>
	<cfset querySetCell(hoiNgoList, "name", 'x_blank')>
	<cfset querySetCell(hoiNgoList, "order_number", 0)>
	<cfset querySetCell(hoiNgoList, "number_of_register", 0)>
	<cfset querySetCell(hoiNgoList, "unit", '')>
	<cfset querySetCell(hoiNgoList, "defaultOrder", dataQuery.recordCount+i)>	
</cfloop>




<style>
	table.hoiNgoi
	{
		border:1px solid gray;
		border-collapse:collapse; 
		width:900px
	}

	table.hoiNgoi td, table.hoiNgoi th
	{
		border:1px solid gray;
		border-collapse:collapse;
		font-family: Times New Roman;
		font-size:14px;
		padding:5px;
	}

	table.hoiNgoi th
	{
		background-color:#CCCCCC
	}
	                    			
</style>


<cfprocessingdirective pageencoding = "utf-8">
		
<cfquery name="sortHoiNgoList" dbtype="query" >
	SELECT 	DISTINCT  order_number,*
	FROM 	hoiNgoList
	ORDER 	BY #url.sortOrder#
</cfquery>

<cfquery name="hoiNgoList_PDF" dbtype="query" >
	SELECT 	*
	FROM 	hoiNgoList
	ORDER BY #url.sortOrder#
</cfquery>

<cfset session.sortHoiNgoList = sortHoiNgoList>
<cfset session.sortHoiNgoList_PDF = hoiNgoList_PDF>

TOTAL OF REGISTERED GUESTS: <cfdump var="#hoiNgoList_PDF.recordCount#">
<table border="1" class="hoiNgoi">
	<tr>
		<th>Line No.</th>
		<th>order_number</th>
		<th>Name</th>
		<th>Unit</th>
		<th>Address</th>
		<th>number_of_register</th>
	</tr>

	<cfoutput query="sortHoiNgoList">
		<cfif sortHoiNgoList.name NEQ 'X_BLANK'>
		<tr>
			<td>#currentRow#</td>
			<td>#order_number#</td>
			<td style="font-size:20px">#UCASE(name)#</td>
			<td>#unit#</td>
			<td>#address#</td>
			<td>#number_of_register#</td>
		</tr>
		</cfif>
	</cfoutput>

</table>


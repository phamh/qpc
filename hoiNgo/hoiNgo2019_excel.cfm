<cfprocessingdirective pageencoding = "utf-8">

<cffunction name="function_getCellFormat" returntype="struct">
	<cfargument name="color" type="string" required="true">
	<cfargument name="bold" type="boolean" required="true">
	<cfargument name="alignment" type="string" required="true">
	<cfargument name="bottomborder" type="string" required="true">
	<cfargument name="bottombordercolor" type="string" required="true">
	<cfargument name="topborder" type="string" required="true">
	<cfargument name="topbordercolor" type="string" required="true">
	<cfargument name="leftborder" type="string" required="true">
	<cfargument name="leftbordercolor" type="string" required="true">
	<cfargument name="rightborder" type="string" required="true">
	<cfargument name="rightbordercolor" type="string" required="true">
	<cfargument name="fgcolor" type="string" required="true">
	<cfargument name="fontsize" type="numeric" required="true">
	<cfargument name="verticalalignment" type="string" required="true">
	<cfargument name="font" type="string"  required="true">	
	<cfargument name="textwrap" type="string"  required="true">	
	<cfargument name="underline" type="boolean"  required="true">	
	
	<cfset thisCellFormat =  StructNew()>
	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.color =  arguments.color>
	</cfif>

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.bold =  arguments.bold>
	</cfif>

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.alignment =  arguments.alignment>
	</cfif>

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.bottomborder =  arguments.bottomborder>
	</cfif>

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.bottombordercolor =  arguments.bottombordercolor>
	</cfif>

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.topborder =  arguments.topborder>
	</cfif>
		
	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.topbordercolor =  arguments.topbordercolor>
	</cfif>	

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.leftborder =  arguments.leftborder>
	</cfif>	
	
	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.leftbordercolor =  arguments.leftbordercolor>
	</cfif>		

	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.rightborder =  arguments.rightborder>
	</cfif>		
	
	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.rightbordercolor =  arguments.rightbordercolor>
	</cfif>		
	
	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.fgcolor =  arguments.fgcolor>
	</cfif>		
	
	<cfset thisCellFormat.fontsize =  arguments.fontsize>
		
	<cfif arguments.color NEQ ''>
		<cfset thisCellFormat.verticalalignment =  arguments.verticalalignment>
	</cfif>	
	
	<cfset thisCellFormat.font =  arguments.font>
	
	<cfset thisCellFormat.textwrap =  arguments.textwrap>
	
	<cfset thisCellFormat.underline =  arguments.underline>

	<cfreturn thisCellFormat>
	
</cffunction>
	
<cfset formatFontSize = 10>
<cfset formatFontColor = 'black'>
<cfset formatFontStyle = 'Arial'>
	
<cfinvoke method="function_getCellFormat"  returnvariable="header">
	<cfinvokeargument name="color" value="#formatFontColor#">
	<cfinvokeargument name="bold" value="true">
	<cfinvokeargument name="alignment" value="center">
	<cfinvokeargument name="bottomborder" value="thin">
	<cfinvokeargument name="bottombordercolor" value="black">
	<cfinvokeargument name="topborder" value="thin">
	<cfinvokeargument name="topbordercolor" value="black">
	<cfinvokeargument name="leftborder" value="thin">
	<cfinvokeargument name="leftbordercolor" value="black">
	<cfinvokeargument name="rightborder" value="thin">
	<cfinvokeargument name="rightbordercolor" value="black">
	<cfinvokeargument name="fgcolor" value="grey_25_percent">
	<cfinvokeargument name="fontsize" value="#formatFontSize#">
	<cfinvokeargument name="verticalalignment" value="vertical_center">
	<cfinvokeargument name="font" value="#formatFontStyle#">
	<cfinvokeargument name="textwrap" value="true">
	<cfinvokeargument name="underline" value="false">
</cfinvoke>

<cfinvoke method="function_getCellFormat"  returnvariable="data">
	<cfinvokeargument name="color" value="#formatFontColor#">
	<cfinvokeargument name="bold" value="false">
	<cfinvokeargument name="alignment" value="center">
	<cfinvokeargument name="bottomborder" value="thin">
	<cfinvokeargument name="bottombordercolor" value="black">
	<cfinvokeargument name="topborder" value="thin">
	<cfinvokeargument name="topbordercolor" value="black">
	<cfinvokeargument name="leftborder" value="thin">
	<cfinvokeargument name="leftbordercolor" value="black">
	<cfinvokeargument name="rightborder" value="thin">
	<cfinvokeargument name="rightbordercolor" value="black">
	<cfinvokeargument name="fgcolor" value="white">
	<cfinvokeargument name="fontsize" value="#formatFontSize#">
	<cfinvokeargument name="verticalalignment" value="vertical_center">
	<cfinvokeargument name="font" value="#formatFontStyle#">
	<cfinvokeargument name="textwrap" value="true">
	<cfinvokeargument name="underline" value="false">
</cfinvoke>

<cfset theSheet = spreadsheetNew("hoiNgoiSheet","true")>

<cfset SpreadSheetSetColumnWidth(theSheet,1,20)>
<cfset SpreadSheetSetColumnWidth(theSheet,2,30)>
<cfset SpreadSheetSetColumnWidth(theSheet,3,20)>
<cfset SpreadSheetSetColumnWidth(theSheet,4,30)>
<cfset SpreadSheetSetColumnWidth(theSheet,5,20)>

<cfset SpreadsheetFormatCell(theSheet, header, 1,1)>
<cfset SpreadsheetFormatCell(theSheet, header, 1,2)>
<cfset SpreadsheetFormatCell(theSheet, header, 1,3)>
<cfset SpreadsheetFormatCell(theSheet, header, 1,4)>
<cfset SpreadsheetFormatCell(theSheet, header, 1,5)>

<cfset SpreadsheetSetCellValue(theSheet,"order_number",1,1)>
<cfset SpreadsheetSetCellValue(theSheet,"Name",1,2)>
<cfset SpreadsheetSetCellValue(theSheet,"Unit",1,3)>
<cfset SpreadsheetSetCellValue(theSheet,"Address",1,4)>
<cfset SpreadsheetSetCellValue(theSheet,"number_of_register",1,5)>
<cfset resourceRowCounter = 2>
<cfoutput query="session.sortHoiNgoList">
	<cfset SpreadsheetSetCellValue(theSheet,session.sortHoiNgoList.order_number,resourceRowCounter,1)>
	<cfset SpreadsheetSetCellValue(theSheet,UCASE(session.sortHoiNgoList.name),resourceRowCounter,2)>
	<cfset SpreadsheetSetCellValue(theSheet,session.sortHoiNgoList.unit,resourceRowCounter,3)>
	<cfset SpreadsheetSetCellValue(theSheet,session.sortHoiNgoList.address,resourceRowCounter,4)>
	<cfset SpreadsheetSetCellValue(theSheet,session.sortHoiNgoList.number_of_register,resourceRowCounter,5)>
	
	<cfset SpreadsheetFormatCell(theSheet, data, resourceRowCounter,1)>
	<cfset SpreadsheetFormatCell(theSheet, data, resourceRowCounter,2)>
	<cfset SpreadsheetFormatCell(theSheet, data, resourceRowCounter,3)>
	<cfset SpreadsheetFormatCell(theSheet, data, resourceRowCounter,4)>
	<cfset SpreadsheetFormatCell(theSheet, data, resourceRowCounter,5)>
	
	<cfset resourceRowCounter = resourceRowCounter + 1>
</cfoutput>


<cfheader name="content-disposition" value="attachment;filename=hoiNgoi_2019.xlsx">
<cfcontent type="application/msexcel" variable="#spreadsheetReadBinary(theSheet)#" reset="false">

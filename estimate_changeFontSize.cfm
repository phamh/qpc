<cfinclude template="sourceFile.cfm">
<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC">

<script>		
	updateFontSize=function()
	{
		try
		{

				
		} 
		
		catch(error)
		{
			alert('error message function updateThisEstimate: '+ error.message)
		}

	}	
  	
</script>
<cfinclude template="checkAccess.cfm">
<cfquery name="getFontsize"  datasource="#REQUEST.dataSource#" >
    SELECT	pdfFontSize,marginTop,marginLeft,marginRight,marginBottom,footerFontSize
	FROM		printfontsize
</cfquery>

<table border=1>
	
		<tr>
        	<th>PDF Font size</th>
            <th>Margin  Top</th>
            <th>Margin Left</th>
            <th>Margin Right</th>
            <th>Margin Bottom</th>
            <th>Footer Font Size</th>
        </tr>
        <cfoutput query="getFontsize">
        <tr>
        	<td><input  id="pdfFontSize" value="#PDFFONTSIZE#" size=10/></td>
            <td><input  id="marginTop" value="#marginTop#" size=10/></td>
            <td><input  id="marginLeft" value="#marginLeft#" size=10/></td>
            <td><input  id="marginRight" value="#marginRight#" size=10/></td>
            <td><input  id="marginBottom" value="#marginBottom#" size=10/></td>
            <td><input  id="footerFontSize" value="#footerFontSize#" size=10/></td>
        </tr>
	</cfoutput>
</table>
<cfif isDefined('session.catch') AND cgi.SERVER_NAME CONTAINS "localhost">
	<cfdump var="#session.catch#">
</cfif>


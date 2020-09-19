
<cfinclude template="sourceFile.cfm">

<cfparam name="url.worksheetId" default="0">
<cfif url.worksheetId NEQ 0>
<div style="width:98%; border:0px dotted black" align=left>
	Viewing <cfoutput>#url.worksheetId#</cfoutput><br>
	<cfoutput>
        <input type="button" onclick="editThisWorksheet(<cfoutput>'#url.worksheetId#', '#url.estimateId#'</cfoutput>)" value="Edit" class="buttonsmall">
	</cfoutput>
</div>	
</cfif>

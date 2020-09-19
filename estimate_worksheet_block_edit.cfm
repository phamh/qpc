
<cfinclude template="sourceFile.cfm">
<cfparam name="url.worksheetId" default="0">
<cfif url.worksheetId NEQ 0>
<div style="width:98%; border:0px dotted black" align=left>
	Edit <cfoutput>#url.worksheetId#</cfoutput>
	<table border=1>
		<tr>
			<th>&nbsp;</th>
			<th>Quanlity</th>
			<th>Waste</th>
			<th>Total Count</th>
			<th>Unit Price</th>
			<th>Total</th>
		</tr>

		<tr>
			<td>Concrete</td>
			<td>Quanlity</td>
			<td>Waste</td>
			<td>Total Count</td>
			<td>Unit Price</td>
			<td>Total</td>
		</tr>

		<tr>
			<td>Concrete</td>
			<td>Quanlity</td>
			<td>Waste</td>
			<td>Total Count</td>
			<td>Unit Price</td>
			<td>Total</td>
		</tr>

		<tr>
			<td>Concrete</td>
			<td>Quanlity</td>
			<td>Waste</td>
			<td>Total Count</td>
			<td>Unit Price</td>
			<td>Total</td>
		</tr>

		<tr>
			<td>Concrete</td>
			<td>Quanlity</td>
			<td>Waste</td>
			<td>Total Count</td>
			<td>Unit Price</td>
			<td>Total</td>
		</tr>

		<tr>
			<td>Concrete</td>
			<td>Quanlity</td>
			<td>Waste</td>
			<td>Total Count</td>
			<td>Unit Price</td>
			<td>Total</td>
		</tr>
												
	</table>
	<cfoutput>
		<input type="text" size="20" onkeydown="theFormIsChanged()">
		<input type="button" onclick="saveWorksheetType(<cfoutput>'#url.worksheetId#', '#url.estimateId#'</cfoutput>)" value="Save #url.worksheetId#" class="buttonsmall">
		<input type="button" onclick="cancelWorksheetType(<cfoutput>'#url.worksheetId#', '#url.estimateId#'</cfoutput>)" value="Cancel" class="buttonsmall">
	</cfoutput>
</div>	
</cfif>

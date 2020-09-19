<cfinclude template="sourceFile.cfm">
<div align=left style="border:1px solid gray; width:222;background-color:#f0f0f0;float:left">		
	<div style="border:0px solid black; height:500px; overflow-y:scroll;">
		<table style="border-collapse:collapse;" id="estimateMenu">
			<cfoutput query="session.newEstimateQuery">
				<cfif currentRow MOD 2 EQ 1>
					<cfset rowBackgroundColor = 'white'>
				<cfelse>
					<cfset rowBackgroundColor = 'white'>
				</cfif>				
				<tr bgcolor=#rowBackgroundColor# style="cursor:pointer" onclick="selectThisMenu('#ESTIMATENUMBER#', 'currentRow_#currentRow#', '#rowBackgroundColor#')" id="currentRow_#currentRow#" >
					<td id="data1" style="border:1px solid gray; width:200px;border-left:0px solid gray;border-top:0px solid gray;color:blue">estimate [#ESTIMATENUMBER#] [currentRow_#currentRow#]</th>
				</tr>
			</cfoutput>
		</table>
	</div>
</div>


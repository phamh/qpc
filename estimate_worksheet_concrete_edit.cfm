
<!---<cfinclude template="sourceFile.cfm">--->
<cfparam name="url.worksheetId" default="0">
<cfset concreteWorksheet = 'Concrete,Ton rebar, Labor for Slab,Labor for Footings,BLock,Window Sill/lintel,Termite Treatment,Block Labor,Ton Rebar, Pump Truck,Trailer Pump,Forklift,Labor To Pour Cell,Total,Profit %20, Total 16 units'>
<cfif url.worksheetId NEQ 0>
<div style="width:98%; border:0px dotted black" align=left>
	<table style="border-collapse:collapse; border:2px solid black; text-align:left; margin-top:20px">
		<!---HEADERS --->
		<tr bgcolor=lightGrey>
			<th style="border:1px solid black;padding:5px; text-align:center; color:orange; background-color:#0000a0;"><cfoutput>Edit #url.worksheetId#</cfoutput></th>
			<th style="border:1px solid black;padding:5px; text-align:center">Quanlity</th>
			<th style="border:1px solid black;padding:5px; text-align:center">Waste</th>
			<th style="border:1px solid black;padding:5px; text-align:center">Total Count</th>
			<th style="border:1px solid black;padding:5px; text-align:center">Unit Price</th>
			<th style="border:1px solid black;padding:5px; text-align:center">Total</th>
		</tr>
		
		<!---Concrete Quanlity --->
		<tr>
			<th style="border:1px solid black;padding:5px; background-color:lightGrey">Concrete</th>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="concreteQuanlity" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="concreteWaste" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="1" id="concreteTotalCount_input" style="text-align:right" onkeydown="theFormIsChanged()">
				<span id="concreteTotalCount_display">xx</span>
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="concreteUnitPrice" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="concreteTotal" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
		</tr>

		<!---Ton Rebar --->
		<tr>
			<th style="border:1px solid black;padding:5px; background-color:lightGrey">Ton Rebar</th>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonRebarQuanlity" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonRebarWaste" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="1" id="tonRebarTotalCount_input" style="text-align:right" onkeydown="theFormIsChanged()">
				<span id="concreteTotalCount_display">xx</span>
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonRebarUnitPrice" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonRebarTotal" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
		</tr>

		<!---Labor For Lab --->
		<tr>
			<th style="border:1px solid black;padding:5px; background-color:lightGrey">Ton For Lab</th>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForLabQuanlity" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForLabWaste" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="1" id="tonForLabTotalCount_input" style="text-align:right" onkeydown="theFormIsChanged()">
				<span id="concreteTotalCount_display">xx</span>
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForLabUnitPrice" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForLabTotal" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
		</tr>

		<!---Labor For Footings --->
		<tr>
			<th style="border:1px solid black;padding:5px; background-color:lightGrey">Ton For Footings</th>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForFootingQuanlity" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForFootingWaste" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="1" id="tonForFootingTotalCount_input" style="text-align:right" onkeydown="theFormIsChanged()">
				<span id="concreteTotalCount_display">xx</span>
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForFootingUnitPrice" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="tonForFootingTotal" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
		</tr>

		<!---BLock --->
		<tr>
			<th style="border:1px solid black;padding:5px; background-color:lightGrey">Block</th>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="blockQuanlity" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="blockWaste" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="1" id="blockTotalCount_input" style="text-align:right" onkeydown="theFormIsChanged()">
				<span id="concreteTotalCount_display">xx</span>
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="blockUnitPrice" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
			<td style="border:1px solid black;padding:5px; text-align:center">
				<input type="text" size="10" id="blockTotal" style="text-align:right" onkeydown="theFormIsChanged()">
			</td>
		</tr>
																			
	</table>
	<cfoutput>
		<input type="text" size="20" onkeydown="theFormIsChanged()">
		<input type="button" onclick="saveWorksheetType(<cfoutput>'#url.worksheetId#', '#url.estimateId#'</cfoutput>)" value="Save #url.worksheetId#" class="buttonsmall">
		<input type="button" onclick="cancelWorksheetType(<cfoutput>'#url.worksheetId#', '#url.estimateId#'</cfoutput>)" value="Cancel" class="buttonsmall">
	</cfoutput>
</div>	
</cfif>

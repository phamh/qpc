<cfif url.printPDF EQ 1>
	<cfset variables.fontSize = '30pt'>
    <cfset variables.estimateNumberfontSize = '40pt'>
    <cfset variables.fontFamily = 'Arial'>
    <cfset variables.divBorder = '2px solid black'>
    <cfset variables.tableWidth= '100%'>   
     <cfset variables.qpConstructionWidth= '60%'> 
     <cfset variables.estimateWidth= '30%'>
 </cfif>   
		<!---DRAW HEADER --->
		<table style="width:<cfoutput>#variables.tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
			<cfoutput>
			<cfif url.printPDF EQ 0>
			<tr>
				<td style="border:0px solid black;text-align:center" colspan=3>
					<input type="button" value="Edit" class="buttonsmall" onclick="editThisEstimate('#url.id#')">
					<input type="button" value="Print" class="buttonsmall" onclick="printThisEstimate('#url.id#')">
				</td>
			</tr>
			</cfif>
			<tr valign="top">
				<th style="width:#variables.qpConstructionWidth#; border:0px solid black; font-size: #variables.fontSize#; text-align:left">QP Construction, Inc.</th>
				<th style="border:0px solid black; font-size: #variables.estimateNumberFontSize#; text-align:left" rowspan="2">Estimate ##:</th>
				<th style="width:#variables.estimateWidth#; border:0px solid black; font-size: #variables.estimateNumberFontSize#; text-align:left" rowspan="2">#getThisEstimate.estimateNumber#</th>
			</tr>
		
			<tr>
				<td style="border:0px solid black; font-size: #variables.fontSize#">3350 Ulmerton Road Suite 11</td>
			</tr>	
		<!---	<tr>
				<td style="width:#variables.qpConstructionWidth#;border:0px solid black; font-size: #variables.fontSize#">Clearwater, FL. 33762</td>
				<td style="border:0px solid black; font-size: #variables.fontSize#">Date of Estimate: </td>
				<td style="border:0px solid black; font-size: #variables.fontSize#">#dateFormat(getThisEstimate.estimateDate, 'MMM-dd-yyyy')#</td>			
			</tr>		
			<tr>
				<td style="border:0px solid black; font-size: #variables.fontSize#">Office: 727-350-5947</td>
				<td colspan=2 style="border:0px solid black; font-size: #variables.fontSize#">&nbsp;</td>
			</tr>	
			<tr>
				<td style="border:0px solid black; font-size: #variables.fontSize#">Fax: 877-453-7935</td>
				<td colspan=2 style="border:0px solid black; font-size: #variables.fontSize#">&nbsp;</td>
			</tr>	--->		
			</cfoutput>
		</table>
		
		<!---JOB --->
<!---		<table style="width:990px; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
			<cfoutput>
			<tr>
				<th colspan=2 style="border:0px solid black; font-size: #variables.fontSize#; text-align:left">JOB</th>
			</tr>
			
			<tr>
				<th style="width:150px; border:0px solid black; font-size: #variables.fontSize#; text-align:left">Company:</th>
				<td style="width:600px;  border:0px solid black; font-size: #variables.fontSize#">#getThisEstimate.companyName#</td>
			</tr>
	
			<tr>
				<th style="width:120px; border:0px solid black; font-size: #variables.fontSize#; text-align:left">Attention:</th>
				<td style=" border:0px solid black; font-size: #variables.fontSize#">#getThisEstimate.attention#</td>
			</tr>
		
			<tr>
				<th style="width:120px; border:0px solid black; font-size: #variables.fontSize#; text-align:left">Address:</th>
				<td style="border:0px solid black; font-size: #variables.fontSize#">#getThisEstimate.companyaddress#</td>
			</tr>
			<tr>
				<th style="width:120px; border:0px solid black; font-size: #variables.fontSize#; text-align:left">Job Site Address:</th>
				<td style="border:0px solid black; font-size: #variables.fontSize#">#getThisEstimate.jobsiteAddress#</td>
			</tr>									
			</cfoutput>
		</table>	--->
	
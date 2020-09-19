<cfparam name="url.width"  default="216px">
<cfparam name="url.height"  default="336px">


<style>
	table.hoiNgoi
	{
		border:1px solid gray;
		border-collapse:collapse
	}

	table.hoiNgoi td, table.hoiNgoi th
	{
		border:1px solid gray;
		border-collapse:collapse;
		font-family:arial condensed;
		padding:5px;
	}

	table.hoiNgoi th
	{
		background-color:#CCCCCC
	}

.pagebreak {
    clear: both;
    page-break-before: always;
}
             			
</style>
        <cfdump var="#TimeFormat(now(), "HHMM")#">
<cfprocessingdirective pageencoding = "utf-8">
<cfset nextPageHeight = 272>
<table cellspacing=0px; >
	<cfset counter = 0>
	<cfset pageCutOff = 0>
	<cfset pageNumber = 0>
	<cfloop query="session.sortHoiNgoList_PDF">

		<tr style="text-wrap:normal; vertical-align:middlea;">
			<cfloop from="1" to="3" index="i">
				<cfset counter = counter+1>
				<cfset pageCutOff = pageCutOff + 1>
				<cfif counter LE session.sortHoiNgoList_PDF.recordCount>
					<cfoutput>
						<td>
							<div style="border:1px solid gray; height:#url.height#; width:#url.width#; text-align:center; padding:0px;  word-wrap:break-word">
								<br><br><br>
								<span style="font-size:18px; font-weight:bold;color:blue;font-family: Constantia">
								<cfif session.sortHoiNgoList_PDF.Name[counter] NEQ 'x_blank'>
									<cfoutput>&nbsp;#UCASE(session.sortHoiNgoList_PDF.Name[counter])#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
								</span>
								<br><br><br>
								<img src="../hoiNgo/background_6.png">
								<br><br><br>
								<span style="font-size:16px; font-weight:bold;color:blue;font-family: Arial"><cfoutput>#UCASE(session.sortHoiNgoList_PDF.unit[counter])#</cfoutput></span>	
	
							</div>
							<cfif pageCutOff EQ 6>
								<div style="page-break-before: always"></div> 
								<cfset pageCutOff = 0>
							</cfif>		
						</td>
					</cfoutput>
				<cfelse>
					<cfbreak>	
				</cfif>
			</cfloop>
		</tr>
	</cfloop>
</table>






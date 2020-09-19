<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">
<cfparam name="url.id" default="0">
<cfparam name="url.printPDF" default="0">

<cfquery name="getFontsize"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		printfontsize
</cfquery>
<cfif url.printPDF EQ 0>
	<cfset variables.fontSize = '16px'>
	<cfset variables.estimateNumberFontSize = '24px'>
	<cfset variables.divBorder = '2px solid black'>
<cfelse>
	<cfset variables.fontSize = getFontsize.pdfFontSize>
	<cfset variables.estimateNumberFontSize = '30px'>
    <cfset variables.divBorder = '0px solid black'>
</cfif>

<cffunction name="convertNumberToWriteCheck">
	<cfargument name="check_amount" type="numeric">
	
	<cfoutput>
	<cfif IsNumeric(arguments.check_amount)> <!--- is it a number? --->
	<cfparam name="write_single" default="one,two,three,four,five,six,seven,eight,nine, ">
	<cfparam name="write_double" default=" ,twenty,thirty,fourty,fifty,sixty,seventy,eighty,ninety">
	<cfparam name="teens" default="11,12,13,14,15,16,17,18,19">
	<cfparam name="teens_written" default="eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen">
	<cfparam name="triplet_after" default="hundred, thousand, million, billion, trillion, quadrillion, quintillion, hexillion, heptillion, octillion, nonillion, decillion, unodecillion, duodecillion">
	<cfset variables.totalText = ''>
    <cfset variables.display = 'none'>
    
	<cfset x=#ListLen(DecimalFormat(arguments.check_amount))#>
	<!--- seperate the number into sections, using the built-in Decimal Format to make it into a list of 3-digit numbers --->
	<cfloop list="#DecimalFormat(arguments.check_amount)#" index="trips" delimiters=",">
	<!--- seperate the number into hundreds tens and singles, making the teens exception --->
	<cfif #Evaluate(Int(trips))# NEQ "0">
		<cfif Len(Int(trips)) EQ "3">
			<cfif mid(Int(trips), 1, 1) EQ "0">
				<cfif #ListFind(teens, right(Int(trips), 2), ',')# NEQ "0">
					<span style="display: #variables.display#">#listGetAt(teens_written, ListFind(teens, right(int(trips), 2), ','), ',')#</span>
                    <cfset variables.totalText = variables.totalText & ' ' & listGetAt(teens_written, ListFind(teens, right(int(trips), 2), ','), ',')>
				<cfelse>
					<span style="display: #variables.display#">#listGetAt(write_double, mid(Int(trips), 2, 1), ',')#</span>
                    <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_double, mid(Int(trips), 2, 1), ',')>
                    
					<cfif mid(Int(trips), 3, 1) NEQ "0">
						<span style="display: #variables.display#">#listGetAt(write_single, mid(Int(trips), 3, 1), ',')#</span>
                        <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_single, mid(Int(trips), 3, 1), ',')>
					</cfif>
				</cfif>
			<cfelse>
				<span style="display: #variables.display#">#listGetAt(write_single, mid(Int(trips), 1, 1), ',')# #listGetAt(triplet_after, 1, ',')#</span>
                <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_single, mid(Int(trips), 1, 1), ',') & ' '& listGetAt(triplet_after, 1, ',')>
                
			</cfif>
			<cfif mid(trips, 2, 1) NEQ "0">
				<cfif #ListFind(teens, right(Int(trips), 2), ',')# NEQ "0">
					<span style="display: #variables.display#">#listGetAt(teens_written, ListFind(teens, right(int(trips), 2), ','), ',')#</span>
                     <cfset variables.totalText = variables.totalText & ' ' & listGetAt(teens_written, ListFind(teens, right(int(trips), 2), ','), ',')>
				<cfelse>
					<span style="display: #variables.display#">#listGetAt(write_double, mid(Int(trips), 2, 1), ',')#</span>
                    <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_double, mid(Int(trips), 2, 1), ',')>
					<cfif mid(trips, 3, 1) NEQ "0">
						<span style="display: #variables.display#">#listGetAt(write_single, mid(Int(trips), 3, 1), ',')#</span>
                        <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_single, mid(Int(trips), 3, 1), ',')>
					</cfif>
				</cfif>
			<cfelse>
				<cfif mid(trips, 3, 1) NEQ "0">
					<span style="display: #variables.display#">#listGetAt(write_single, mid(Int(trips), 3, 1), ',')#</span>
                    <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_single, mid(Int(trips), 3, 1), ',')>
				</cfif> 
			</cfif> 
		<cfelseif Len(Int(trips)) EQ "2" AND mid(Int(trips), 1, 1) NEQ "0">
			<cfif #ListFind(teens, right(Int(trips), 2), ',')# NEQ "0">
				<span style="display: #variables.display#">#listGetAt(teens_written, ListFind(teens, right(int(trips), 2), ','), ',')#</span>
                <cfset variables.totalText = variables.totalText & ' ' & listGetAt(teens_written, ListFind(teens, right(int(trips), 2), ','), ',')>
			<cfelse>
				<span style="display: #variables.display#">#listGetAt(write_double, mid(Int(trips), 1, 1), ',')#</span>
                <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_double, mid(Int(trips), 1, 1), ',')>
				<cfif mid(trips, 2, 1) NEQ "0">
					<span style="display: #variables.display#">#listGetAt(write_single, mid(Int(trips), 2, 1), ',')#</span>
                    <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_single, mid(Int(trips), 2, 1), ',')>
				</cfif>
			</cfif>
		<cfelseif Len(Int(trips)) EQ 1 AND mid(int(trips), 1, 1) NEQ "0">
			<span style="display: #variables.display#">#listGetAt(write_single, mid(Int(trips), 1, 1), ',')# </span>
            <cfset variables.totalText = variables.totalText & ' ' & listGetAt(write_single, mid(Int(trips), 1, 1), ',')>
		</cfif>
		<!--- deal with the thousands and millions seperators, doesn't include hundreds on last loop --->
        <cfif x NEQ "1">
        		<span style="display: #variables.display#">#listGetAt(triplet_after, x, ',')# and</span>
                 <cfset variables.totalText = variables.totalText & ' ' & listGetAt(triplet_after, x, ',') & ' and'>
		</cfif>
	<cfelse>
		<!--- Zero Dollars? How about... --->
		<cfif x EQ #ListLen(DecimalFormat(arguments.check_amount))#>
         	<span style="display: #variables.display#">No </span>
            <cfset variables.totalText = variables.totalText & ' ' &  'No'>
		 </cfif> 
	</cfif>
	<cfset x=x-1><!--- next loop, next valuations --->
	</cfloop>
	<!--- output tailing text and cents in check format --->
	<span style="display: #variables.display#">dollars and <sup>#right(DecimalFormat(arguments.check_amount), 2)#</sup>/<sub>100</sub> cents</p></span>
    <cfset variables.totalText = variables.totalText & ' ' &  'dollars' & ' and ' & '<sup>' & right(DecimalFormat(arguments.check_amount), 2) & '</sup>/<sub>' & 100& '</sub>' & ' cents'>
	</cfif>

    <span style="font-size:#variables.fontSize#">#ReReplaceNoCase(variables.totalText,"\b(\w)","\u\1","ALL")#</span>
    
	</cfoutput>

</cffunction>	

<cfif url.id EQ 0>
	<cfabort>
</cfif>

<script>

	printThisEstimate=function(estimateId)
	{
		try
		{	
			var urlstring = "estimate_pdf.cfm?id=" + estimateId + '&printPDF=1';	
			myPDFWindow = window.open(urlstring,"estimateWorksheet","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1;");			

		}
		
		catch(error)
		{
			alert('error message function printThisEstimate: '+ error.message)
		}

	}
				
</script>
<cfoutput>
	<input type="hidden" value="0" id="numberofNewRows">
</cfoutput>

<cfquery name="getThisEstimate"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimate
	WHERE	estimateNumber =  <cfqueryparam cfsqltype="cf_sql_integer"  value=" #url.id#">
</cfquery>

<cfquery name="getThisEstimateItems"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimateScopework
    <cfif getThisEstimate.recordCount>
    	WHERE	estimateID_fk = <cfqueryparam value="#getThisEstimate.estimateID_pk#" cfsqltype="cf_sql_integer">
    <cfelse>
    	WHERE	estimateID_fk = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
	</cfif>
	
</cfquery>

<cfquery name="getThisRemark"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimateRemark
    <cfif getThisEstimate.recordCount>
    	WHERE	estimateID_fk = <cfqueryparam value="#getThisEstimate.estimateID_pk#" cfsqltype="cf_sql_integer">
    <cfelse>
    	WHERE	estimateID_fk = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
	</cfif>  
</cfquery>

<div align=center style="border:<cfoutput>#variables.divBorder#</cfoutput> ; width:1000px; height:1200px;padding:5px; font-family:Arial">	
	<cfif url.printPDF EQ 0>
		<div style="width:990px; border-bottom:2px solid black; margin-bottom:5px">
	<!---		View Estimate <cfoutput>#url.id#</cfoutput>--->
		<cfoutput>
        <table border=0 style="width:990px;">
        	<td style="width:300px">
            		
					<input type="button" value="Edit" class="buttonsmall" onclick="editThisEstimate('#url.id#')">
					<input type="button" value="Print" class="buttonsmall" onclick="printThisEstimate('#url.id#')">
                    
            </td>
            <th style="text-align:center; font-size:26px">
            	View Estimate #url.id#
            </th>
            <td style="width:300px;text-align:right"><input type="button" value="Delete" class="buttonsmall_red" onclick="deleteThisEstimate('#getThisEstimate.estimateID_pk#')"></td>
        </table>
        </cfoutput>
        </div>
	
	</cfif>	
		
		<!---DRAW HEADER --->
		<table style="width:990px; border-collapse:collapse;border:0px solid black; margin-bottom:70px">
			<cfoutput>

			<tr>
				<th style="width:600px; border:0px solid black; font-size: #variables.fontSize#; text-align:left">QP CONSTRUCTION, INC.</th>
				<th style="border:0px solid black; font-size: #variables.estimateNumberFontSize#; text-align:left" rowspan="2">Estimate ##:</th>
				<th style="width:200px;; border:0px solid black; font-size: #variables.estimateNumberFontSize#; text-align:left" rowspan="2">#getThisEstimate.estimateNumber#</th>
			</tr>
		
			<tr>
				<td style="border:0px solid black; font-size: #variables.fontSize#">3350 Ulmerton Road Suite 11</td>
			</tr>	
			<tr>
				<td style="border:0px solid black; font-size: #variables.fontSize#">Clearwater, FL. 33762</td>
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
       
			</tr>			
			</cfoutput>
		</table>
		
		<!---JOB --->
		<table style="width:990px; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
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
		</table>	
	

	<!---VIEW ESTIMATE LINE ITEM START HERE --->
	<table cellpadding=0 cellspacing=0 style="width:990px; border-collapse:collapse;border:0px solid black; border-top:1px solid black; margin-bottom:5px;" id="estimateTable">
		<cfoutput>
			<tr bgcolor="lightGrey">
				<th style="width:120px; border:1px solid black; text-align:center; font-size: #variables.fontSize#; height:30px">Item</th>
				<th style="width:700px; border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Scope of Work</th>
				<th style="width:100px; border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Amount</th>
			</tr>
		</cfoutput>
		
		<cfset variables.estimateTotal = 0>      
		<cfoutput query="getThisEstimateItems">
			<cfset variables.estimateTotal = variables.estimateTotal + getThisEstimateItems.amount>
			<tr valign="middle" style="height:10px">
				<td   style="width:50px; border-left:1px solid black; border-right:1px solid black; border-bottom:1px solid black; font-size: #variables.fontSize#; height:30px;padding-left:5px;padding-right:5px">#item# </td>
				<td  style="width:700px; border-right:1px solid black; border-bottom:1px solid black; font-size: #variables.fontSize#;padding-left:5px;padding-right:5px">#scopeWork# </td>
				<td  style="width:100px; border-right:1px solid black; border-bottom:1px solid black; text-align: right; font-size: #variables.fontSize#;padding-right:5px" >$#DecimalFormat(amount)#</td>
			</tr>
		</cfoutput>
	</table>

	<!---TOTAL --->
	<table style="width:990px; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
		<cfoutput>
		<tr valign="top">
			<th style="width:705px; border:0px solid black; text-align:right; font-size: #variables.fontSize#" id="estimateTotalText">&nbsp;</th>
			<th style="width:90px; border:0px solid black; text-align:right; font-size: #variables.fontSize#">
            	Total: 
            </th>
			<th style="width:105px; border:0px solid black; text-align:right; font-size: #variables.fontSize#;padding-right:3px" id="estimateTotal">$#DecimalFormat(variables.estimateTotal)#</th>
		</tr>
        <tr>
        	<td colspan="3" style="text-align:right">#convertNumberToWriteCheck(variables.estimateTotal)#</td>
        </tr>
					
		</cfoutput>
	</table>

	<!---REMARKS START HERE --->	
	<div align=left>
		<span style="font-weight:bold; font-size:<cfoutput>#variables.fontSize#</cfoutput>; padding-left:3px">Remarks:</span>
		<ul style="border:0px solid black; margin-left:20px; margin-top:5px">
			<cfoutput query="getThisRemark">
                <li style="border:0px solid black; margin-bottom:10px; font-size: #variables.fontSize#">#remark#</li>
            </cfoutput>
		</ul>	
	</div>
    
    <!---EXPIRED DAYS --->
    <cfoutput>
    <div align=center style="font-weight:bold; margin-top:5px; font-size:#variables.fontSize#">
        This estimate will be expired on #dateFormat(dateAdd("d", getThisEstimate.expiredDays, getThisEstimate.estimateDate), 'mmm-dd-yyyy')# (#getThisEstimate.expiredDays# days from the date of estimate.)   
    </div>
    </cfoutput> 
    
	<!---SIGNATURES --->	
    <cfif url.printPDF EQ 0 OR 1 EQ 1>
        <cfquery name="getPreparer"  datasource="#REQUEST.dataSource#" >
            SELECT	*
            FROM		userAccount
            WHERE	userAccountID_pk =   <cfqueryparam cfsqltype="cf_sql_integer"  value="#getThisEstimate.userAccountID_fk#">
        </cfquery>    
        <div align=left style="position:absolute;  top:1005px;margin-left:40px ">
                <table border= 0 style="width:990px">
                    <tr valign="top">
                        <cfoutput>
                        <td style="width:450px">
                            <div style="margin-bottom:80px;font-size: #variables.fontSize#">
                                Sincerely,
                            </div>
                            <div style="margin-bottom:0px">
                                    <table border=0 style="width:100%">
                                        <tr>
                                                <td style="font-size: #variables.fontSize#">#getPreparer.firstName# #getPreparer.lastName#</td>
                                        </tr>
                                          <tr>
                                                <td style="font-size: #variables.fontSize#"> #getPreparer.title#</td>
                                        </tr>              
                                          <tr>
                                                <td style="font-size: #variables.fontSize#"> QP Construction, Inc.</td>
                                        </tr> 
                                          <tr>
                                                <td style="font-size: #variables.fontSize#"> #getPreparer.phoneNumber#</td>
                                        </tr> 
                                          <tr>
                                                <td style="font-size: #variables.fontSize#"> #getPreparer.userName#</td>
                                        </tr>                                                                                                                          
                                    </table>
                            </div>                    
                        </td>
                        </cfoutput> 
                    </tr>
                </table>
 
        </div>    
    </cfif>	
    					
</div>
<cfif isDefined('session.catch') AND cgi.SERVER_NAME CONTAINS "localhost" AND 1 EQ 2>
	<cfdump var="#session.catch#">
</cfif>


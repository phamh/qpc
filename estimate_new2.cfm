<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>jQuery UI Datepicker - Default functionality</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
  <script>
  $( function() {
    $( "#datepicker1Id" ).datepicker();
  } );

        
  </script>
 
</head>

<body>
	
<style>
	.ui-datepicker 
	{
		font-size:14px;
	} 	
</style> 
<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">
<cfoutput>
	<input type="hidden" value="0" id="numberofNewItems">
	<input type="hidden" value="0" id="numberofNewRemarks">
	<input type="hidden" value="0" id="numberofEditItems">
</cfoutput>

<cfquery name="getNextEstimateNumber" datasource="#REQUEST.dataSource#">
    SELECT 	*
    FROM		estimate
    ORDER BY 	 estimateID_pk DESC
    LIMIT 1
</cfquery>

<cfif getNextEstimateNumber.recordCount>
	<cfset variables.nextEstimateNumber = getNextEstimateNumber.ESTIMATENUMBER+1>
<cfelse>
	<cfset variables.nextEstimateNumber = 1001>	
</cfif>

<cfset borderWidth = '0px'>
<cfset tableWidth = '990px'>

<div align=center style="border:2px solid black; width:1000px; height:900px;padding:5px">
	
		<cfoutput>
		<div style="width:990px; border-bottom:2px solid black; margin-bottom:5px">
		<table border=0 style="width:#tableWidth#">
        	<td style="width:300px">
				<input type="button" value="Submit" class="buttonsmall" onclick="submitNewEstimate();">
				<input type="button" value="Cancel" class="buttonsmall" onclick="cancelNewEstimate()">
                <input type="hidden" name="token" id="token" value="#CSRFGenerateToken()#" size="50">
            </td>
            <th style="text-align:center; font-size:26px">
            	New Estimate
            </th>
            <td style="width:300px"></td>
        </table>
        </div>
        </cfoutput>
	
	<!---DRAW HEADER --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
		<cfoutput>
		<tr>
			<th style="width:700px; border:#borderWidth# solid black">QP CONSTRUCTION, INC.</th>
			<th style=" border:#borderWidth# solid black">Estimate ##:</th>
			<th style="width:150px; border:#borderWidth# solid black">#variables.nextEstimateNumber#
				<input type="text" size=10 id="estimateNumber" value="#variables.nextEstimateNumber#" readOnly style="background-color:lightGray; display:none">
			</th>
		</tr>
			
		<tr>
			<td style="border:#borderWidth# solid black">3350 Ulmerton Road Suite 11</td>
			<td style="border:#borderWidth# solid black">Date: </td>
			<td style="border:#borderWidth# solid black">		
				<input type="text" id="estimateDate"  name="estimateDate" value="#dateFormat(now(), 'MMM-dd-yyyy')#" readOnly size="10" onClick="return showCalendar2('estimateDate', 'btnEstimateDate','', 1); changeExpiredDate()" >
				<input class="noPrint" id="btnEstimateDate" onClick="return showCalendar2('estimateDate', 'btnEstimateDate','', 1);" type="image" src="jscalendar-1.0/img.gif" align="middle" />                
			</td>
		</tr>	
		<tr>
			<td style="border:#borderWidth# solid black">Clearwater, FL. 33762</td>
			<td colspan=2 style="border:#borderWidth# solid black">&nbsp;</td>
		</tr>		
		<tr>
			<td style="border:#borderWidth# solid black">Office: 727-350-5947</td>
			<td colspan=2 style="border:#borderWidth# solid black">&nbsp;</td>
		</tr>	
		<tr>
			<td style="border:#borderWidth# solid black">Fax: 877-4537935</td>
			<td colspan=2 style="border:#borderWidth# solid black">&nbsp;</td>
		</tr>			
		</cfoutput>
	</table>
	
	<!---JOB --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
		<cfoutput>
		<tr>
			<th colspan=2 style="border:#borderWidth# solid black">TO:</th>
			<td rowspan="4">
				<fieldset>
					<legend style="color:red">Estimate Status</legend>
					<input id="estimateStatus1" name="estimateStatus" type="radio" value=0 checked/>Pending
					<input id="estimateStatus2" name="estimateStatus" type="radio" value=1/>Approved
					<input id="estimateStatus3" name="estimateStatus" type="radio" value=2/>Rejected
				</fieldset>
			</td>
		</tr>
		
		<tr>
			<th style="width:130px; border:#borderWidth# solid black">Company:</th>
			<th style=" border:#borderWidth# solid black"><input id="companyName" type="text" size="50" onkeydown="changeIsMade()"></th>
		</tr>

		<tr>
			<th style="border:#borderWidth# solid black">Attention:</th>
			<th style=" border:#borderWidth# solid black"><input id="attention" type="text" size="50" onkeydown="changeIsMade()"></th>
		</tr>
		<tr>
			<th style="border:#borderWidth# solid black">Address:</th>
			<th style=" border:#borderWidth# solid black"><input id="companyAddress" type="text" size="50" onkeydown="changeIsMade()"></th>
		</tr>	

		<tr>
			<th style="border:#borderWidth# solid black">Job Site Address:</th>
			<th style=" border:#borderWidth# solid black">
				<input id="jobsiteAddress" type="text" size="50" onkeydown="changeIsMade()">
			</th>
		</tr>
									
		</cfoutput>
	</table>	

	<div align=left style="padding-left:10px; margin-bottom:5px; color:blue; cursor:pointer;" onclick="newItem(<cfoutput>'#theBrowser#'</cfoutput>)">
		[+] New Item
	</div>
	
	<!---ESTIMATE START HERE --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:1px solid black; margin-bottom:5px" id="estimateTable">
		<cfoutput>
		<tr bgcolor="lightGrey">
			<th style="width:100px; border:1px solid black; text-align:center">Delete?</th>
			<th style="width:150px; border:1px solid black; text-align:center">Item</th>
			<th style="width:640px; border:1px solid black; text-align:center">Scope of Work</th>
			<th style="width:100px; border:1px solid black; text-align:center">Amount</th>
		</tr>
					
		</cfoutput>
	</table>
		
	<!---TOTAL --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
		<cfoutput>
		<tr>
			<th style="border:0px solid black; text-align:left" id="estimateTotalText">&nbsp;</th>
			<th style="width:15%;border:0px solid black; text-align:right">Total: </th>
			<th style="width:15%; border:0px solid black; text-align:right" id="estimateTotal"><span id="estimateTotal">0.00</span></th>
		</tr>
					
		</cfoutput>
	</table>

	<!---REMARKS START HERE --->
	<div align=left style="padding-left:10px; margin-bottom:5px; color:blue; cursor:pointer;" onclick="newRemark(<cfoutput>'#theBrowser#'</cfoutput>)">
		[+] New Remark
	</div>
	
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:1px solid black; margin-bottom:5px" id="remarkTable">
		<cfoutput>
		<tr bgcolor="lightGrey">
			<th style="width:100px; border:1px solid black; text-align:center">Delete?</th>
			<th style="width:890px; border:1px solid black; text-align:center">Remark </th>
		</tr>
					
		</cfoutput>
	</table>
	
	<!---EXPIRED DAYS --->
	<div align=left>
		<ul>
			<li>This estimate will be expired on <span id="expiredDate"><cfoutput>#dateFormat(now(), 'mmm-dd-yyyy')#</cfoutput></span>
			(<input id="expiredDays" type="text" size="1" 
					onkeypress="unHighlightRequiredField('expiredDays');return numeralsOnly(event);" 
					onclick="unHighlightRequiredField('expiredDays')" 
					onchange="changeExpiredDate()"
                    onkeydown="changeIsMade()"> days from the date of estimate.)</li>
		</ul>	
	</div>	

	<!---SIGNATURES --->	
    <cfquery name="getPreparerList"  datasource="#REQUEST.dataSource#" >
        SELECT	*
        FROM		userAccount
        WHERE	authorizedToEstimate = 1
    </cfquery>    
	<div align=left>
    <blockquote>        
    	<div style="margin-bottom:70px">
        	Sincerely,
        </div>
		<div style="margin-bottom:10px">
            <select  id="preparedBy">
                <option value="0">prepared by</option>
                <cfoutput query="getPreparerList">
                    <option value="#userAccountID_pk#">#firstName# #lastName#</option>
                </cfoutput>        	
            </select>
        </div>         
    </blockquote>     
	</div>
        
</div>

<cfif isDefined('session.catch') AND cgi.SERVER_NAME CONTAINS "localhost">
	<cfdump var="#session.catch#">
</cfif>
<table style="border-collapse:c collapse">
	<tr>
		<th>Date 1: </th><td><input type="text" id="datepicker1Id"></td>
	</tr>

				
</table>
 
 
</body>
</html>
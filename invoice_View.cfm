<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<cfset tableWidth = '1100px'>
<Style>
	table.invoiceTable
	{
		border:1px solid black;
		border-collapse:collapse;
		width:<cfoutput>#tableWidth#</cfoutput>;
	}

	table.invoiceTable th
	{
		font-weight:bold;
		text-align:center;
		background-color:#CCCCCC;
	}	
		
	table.invoiceTable th, table.invoiceTable td
	{
		border:1px solid black;
		padding:5px;
	}	

	table.headerTable
	{
		border:0px solid black;
		border-collapse:collapse;
		width:<cfoutput>#tableWidth#</cfoutput>;
	}

	table.headerTable th
	{
		font-weight:bold;
		text-align:center;
		background-color:#CCCCCC;
	}	
		
	table.headerTable th, table.headerTable td
	{
		border:0px solid gray;
		padding:5px;
	}
				
</Style>

<script>

	editThisInvoice=function(invoiceId_pk)
	{
		
		var urlString =  'invoice_edit.cfm?invoiceId_pk='+ invoiceId_pk;		
		var windowName = 'edit_invoice_cfWidnow';
		var windowTitle = 'Edit Invoice';
		var theHeight = 900;
		var theWidth  = 1200;
		openThisCfWindow(urlString, windowName, windowTitle,theHeight,theWidth);
	}


	printThisInvoice=function(invoiceId_pk)
	{
		try
		{	
			var urlstring = "invoice_pdf.cfm?invoiceId_pk=" + invoiceId_pk + '&printPDF=1';	
			myPDFWindow = window.open(urlstring,"estimateWorksheet","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1;");	
		}
		
		catch(error)
		{
			alert('error message function printThisInvoice: '+ error.message)
		}
	}
			

</script>

<Cfparam name="url.invoiceId_pk" default="0">
<Cfparam name="url.printPDF" default="0">

<cfif url.invoiceId_pk EQ 0>
	<cfabort>
</cfif>

<cfif url.printPDF EQ 0>
	<cfset variables.fontSize = '16px'>
	<cfset variables.invoiceNumberFontSize = '28px'>
	<cfset variables.divBorder = '2px solid black'>
<cfelse>
	<cfset variables.fontSize = '22px'>
	<cfset variables.invoiceNumberFontSize = '30px'>
    <cfset variables.divBorder = '0px solid black'>
</cfif>

<cfquery name="getThisInvoice"  datasource="#REQUEST.dataSource#" >
    SELECT 	invoiceDate,customerId_fk,term,projectName,projectLocation,invoiceNumber,invoiceID_pk,datePaid,amountPaid
    FROM 	invoice
    WHERE	invoiceId_pk = <cfqueryparam value="#url.invoiceId_pk#">
</cfquery>

<cfquery name="getThisCustomer"  datasource="#REQUEST.dataSource#" >
    SELECT 	customerId_pk,company,address,city, zip
    FROM 	customer
    WHERE	customerId_pk = <cfqueryparam value="#getThisInvoice.customerId_fk#">
</cfquery>
		
<cfquery name="getThisInvoiceItems"  datasource="#REQUEST.dataSource#" >
    SELECT 	serviceDate,product,description,amount, invoiceId_fk
    FROM 	invoice_item
    WHERE	invoiceId_fk = <cfqueryparam value="#getThisInvoice.invoiceId_pk#">
</cfquery>

<cfset variables.invoiceTotal = 0>
<cfoutput query="getThisInvoiceItems">
	<cfset variables.invoiceTotal = variables.invoiceTotal + getThisInvoiceItems.amount>
</cfoutput>

<!---DRAW HEADER --->
<cfif NOT url.printPDF>
	<div style="padding-left:0px; margin-bottom:10px;  border:0px solid gray;width:99%; text-align:left">
		<cfoutput>
			<input type="button" value="[+] New Invoice" onClick="newInvoice()" id="newEmployee" class="buttonSmall2">      
			<input type="button" value="Summary" onClick="summaryInvoice()" id="summaryId" class="buttonSmall2">			
			<input type="button" value="  Edit  "  class="buttonSmall2" onclick=editThisInvoice(#url.invoiceId_pk#)>  
			<input type="button" value="  PDF & Print  " class="buttonSmall2" onclick="printThisInvoice('#url.invoiceId_pk#')">
			<input type="button" value="Log Out" onClick="logout_local()" id="logout" class="buttonSmall2"> 
		</cfoutput>	
	</div>
</cfif>

<table class="headerTable" align="center" border="1" style="margin-bottom:20px;border-collapse:collapse;">
	<tr style="vertical-align:top">
		<td style="width:120px">
			<img src="images/qpcLogo_130.png">
		</td>
		<td style="width:580px; font-size: <cfoutput>#variables.fontSize#</cfoutput>">
			<span style="font-weight:bold;">QP CONSTRUCTION, INC.</span><br>
			3350 Ulmerton Road Suite 11<br>
			Clearwater, FL. 33762<br>
			813-239-4354<br>
			quoc.p.pham@qpconstruction.com
		</td>
		<td style="text-align:left;  font-size:<cfoutput>#variables.invoiceNumberFontSize#</cfoutput>; font-weight:bold; color:#f16427;">
			<cfoutput>
			Invoice #getThisInvoice.invoiceNumber#<br><br>
			<table align="center" border="0" style="margin-bottom:20px;border-collapse:collapse;" cellpadding="0"cellspacing="0">
				<tr>
					<td style="text-align:center; border-bottom:1px solid ##f16427;border-top:1px solid ##f16427; padding:15px; background-color:##fcd7c7; font-size: #variables.fontSize#">
						INVOICE DATE<br>
						#dateFormat(getThisInvoice.invoiceDate, 'mm/dd/yyyy')#
					</td>
					<td style="text-align:center; border-bottom:1px solid ##f16427;border-top:1px solid ##f16427; padding:15px; color:white; background-color:##f16427; font-size: #variables.fontSize#">
						PLEASE PAY<br>
						$#DecimalFormat(variables.invoiceTotal)#&nbsp;&nbsp;
					</td>	
					<td style="text-align:center; border-bottom:1px solid ##f16427;border-top:1px solid ##f16427; padding:15px; background-color: ##fcd7c7; font-size: #variables.fontSize#">
						DUE DATE<br>
						<cfif getThisInvoice.invoiceDate NEQ ''>
							#dateFormat(dateAdd("d",getThisInvoice.term,getThisInvoice.invoiceDate),'mm/dd/yyyy')#
						</cfif>
					</td>									
				</tr>
			</table>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td></td>
		<td style="font-size:<cfoutput> #variables.fontSize#</cfoutput>">
			<span style="font-weight:bold">BILL TO</span><br>
			<cfoutput>#getThisCustomer.company#</cfoutput><br>
			<cfoutput>#getThisCustomer.address#</cfoutput><br>
			<cfoutput>#getThisCustomer.city#</cfoutput><br>
			<cfoutput>#getThisCustomer.zip#</cfoutput><br>
			
		</td>
		<cfif NOT url.printPDF>
		<td>
			<fieldset style="border:1px solid gray;padding:5px">
				<legend style="font-weight:bold">For Office Use Only</legend>
					Amount Paid: <cfoutput>#getThisInvoice.amountPaid#</cfoutput><br>
					Date Paid: <cfoutput>#dateFormat(getThisInvoice.datePaid, 'mm/dd/yyyy')#</cfoutput>
			</fieldset>
		</td>
		</cfif>
	</tr>
</table>
<cfif url.printPDF>
	<div style="width:1100px;text-align:center;font-size:<cfoutput> #variables.fontSize#</cfoutput>">
		Please detach top portion and return with your payment.  Thank you
		************************************************************************************************
	</div>	
</cfif>	
<!---<table class="invoiceTable" align="center"  style="margin-bottom:20px;border-collapse:collapse;">--->
<table align="center" cellpadding=0 cellspacing=0 style="width:1100px; border-collapse:collapse;border:0px solid black; border-top:1px solid black; margin-bottom:5px;" id="invoiceTable" class="invoiceTable">
		
	<tr bgcolor="lightGrey">
		<cfoutput>
		<th style="border-left:1px solid black;border-right:1px solid black; border-bottom:0px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Invoice No.</th>
		<th style="border-left:0px solid black;border-right:1px solid black; border-bottom:0px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Invoice Date</th>
		<th style="border-left:0px solid black;border-right:1px solid black; border-bottom:0px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Term</th>
		<th style="border-left:0px solid black;border-right:1px solid black; border-bottom:0px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Due Date</th>
		<th style="border-left:0px solid black;border-right:1px solid black; border-bottom:0px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Project Name</th>
		<th style="border-left:0px solid black;border-right:1px solid black; border-bottom:0px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">Project Location</th>
		</cfoutput>
	</tr>
				
	<cfoutput query="getThisInvoice">

		<tr style="vertical-align:top">
			<td style=" width:120px; text-align:center;font-size: #variables.fontSize#;border-left:1px solid black;">#invoiceNumber#</td>
			<td style=" width:140px; text-align:center;font-size: #variables.fontSize#;border-left:0px solid black;">#dateFormat(invoiceDate, 'mm/dd/yyyy')#</td>
			<td style=" width:80px; text-align:center;font-size: #variables.fontSize#;border-left:0px solid black;">#term#</td>
			
			<td style=" width:110px; text-align:center;font-size: #variables.fontSize#;border-left:0px solid black;">
				<cfif invoiceDate NEQ ''>
					#dateFormat(dateAdd("d",term,invoiceDate),'mm/dd/yyyy')#
					<cfset dueDate = dateAdd("d",term,invoiceDate)>
					<cfif dateDiff('d',now(),dueDate) LT 0 AND (amountPaid NEQ 0 OR amountPaid NEQ '')>
						<span style="color:red"><br>Over due (#dateDiff('d',now(),dueDate)#)</span>
					</cfif>					
				</cfif>
			</td>		
			
			<td style=" width:250px; text-align:center;font-size: #variables.fontSize#;border-left:0px solid black;">#projectName#</td>
			<td style=" width:370px; text-align:center;font-size: #variables.fontSize#;border-left:0px solid black;">#projectLocation#</td>
		</tr>
	</cfoutput>
</table>

<table align="center" cellpadding=0 cellspacing=0 style="width:1100px; border-collapse:collapse;border:0px solid black; border-top:1px solid black; margin-bottom:5px;" class="invoiceTable">
	<tr>
		<cfoutput>
		<th style="width:140px;border-left:1px solid black;border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#; height:30px;white-space:nowrap">SERVICE DATE</th>
		<th style="width:200px;border-left:0px solid black;border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">PRODUCT/SERVICE</th>
		<th style="width:450px;border-left:0px solid black;border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#">DESCRIPTION</th>
		<th style="width:140px;border-left:0px solid black;border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black; text-align:center; font-size: #variables.fontSize#;">AMOUNT</th>
		
		</cfoutput>
	</tr>

	<cfoutput query="getThisInvoiceItems">
	<tr style="vertical-align:top">		
		<td style="border-left:1px solid black; border-right:1px solid black;border-bottom:1px solid black;border-top:0px solid black;font-size: #variables.fontSize#;text-align:center">#dateFormat(serviceDate, 'mm/dd/yyyy')#</td>
		<td style="border-left:0px solid black; border-right:1px solid black;border-bottom:1px solid black;border-top:0px solid black;font-size: #variables.fontSize#;text-align:left">#product#</td>
		<td style="border-left:0px solid black; border-right:1px solid black;border-bottom:1px solid black;border-top:0px solid black;font-size: #variables.fontSize#;">#description#</td>
		<td style="border-left:0px solid black; border-right:1px solid black;border-bottom:1px solid black;border-top:0px solid black;font-size: #variables.fontSize#;text-align:right;">$#DecimalFormat(amount)#</td>
	</tr>		
	</cfoutput>
</table>
	
<!---TOTAL --->
<table align="center" style="border:0px slid gray; width:<cfoutput>#tableWidth#</cfoutput>; margin-top:10px"> 
	<cfoutput>
	<tr>
<!---		<td>&nbsp;</th>
		<th style="width:15%;border:0px solid black; text-align:right; font-weight:bold;color:##f16427; font-size:#variables.invoiceNumberFontSize#">TOTAL DUE: </th>--->
		<th style="width:100%; border:0px solid black; text-align:right;color:##f16427; font-size:#variables.invoiceNumberFontSize#">
			TOTAL DUE: &nbsp;&nbsp;&nbsp;<cfoutput>$#DecimalFormat(variables.invoiceTotal)#&nbsp;</cfoutput>
		</th>
	</tr>		
	</cfoutput>
</table>



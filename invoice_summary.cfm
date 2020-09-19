<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<cfset tableWidth = '1300px'>
<Style>
	table.invoiceTable
	{
		border:1px solid gray;
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
		border:1px solid gray;
		padding:5px;
	}	

			
</Style>

<cfquery name="GetCustomerList"  datasource="#REQUEST.dataSource#" >
    SELECT 	*
    FROM 	customer

</cfquery>

<cfquery name="getAllInvoices"  datasource="#REQUEST.dataSource#" >
    SELECT 	invoiceDate,customerId_fk,term,projectName,projectLocation,invoiceNumber,invoiceID_pk,datePaid,amountPaid
    FROM 	invoice
</cfquery>

<div style="padding-left:45px; margin-bottom:5px;  border:0px solid gray;width:99%; text-align:left; padding-top:5px">
	<input type="button" value="   Done   "  class="buttonSmall2" onclick=closeThisCfWindow('summary_invoice_cfWidnow','','')> 
</div>


<table class="invoiceTable" align="center" border="1" style="margin-bottom:20px">
	<tr>
		<th>Invoice No</th>
		<th>Billing Address</th>
		<th>Invoice Date</th>
		<th>Terms</th>
		<th>Due Date</th>
		<th>Over Due?</th>
		<th>Project Name</th>
		<th>Amount Due</th>
		<th>Amount Paid</th>
		<th>Date Paid</th>
	</tr>
	<cfset summaryInvoiceTotal = 0>
	<cfoutput query="getAllInvoices">
		<cfquery name="getThisCustomer"  datasource="#REQUEST.dataSource#" >
		    SELECT 	customerId_pk,company,address,city, zip
		    FROM 	customer
		    WHERE	customerId_pk = <cfqueryparam value="#customerId_fk#">
		</cfquery>	

		<cfquery name="getThisInvoiceItems"  datasource="#REQUEST.dataSource#" >
		    SELECT 	serviceDate,product,description,amount, invoiceId_fk
		    FROM 	invoice_item
		    WHERE	invoiceId_fk = <cfqueryparam value="#invoiceId_pk#">
		</cfquery>
		
		<cfset variables.invoiceTotal = 0>
		<cfif getThisInvoiceItems.recordCount>
			<cfloop query="getThisInvoiceItems">
				<cfset variables.invoiceTotal = variables.invoiceTotal + getThisInvoiceItems.amount>
			</cfloop>			
		</cfif>
		<cfset summaryInvoiceTotal = summaryInvoiceTotal + variables.invoiceTotal>
		<tr>
			<td>#InvoiceNumber#</td>
			<td>#getThisCustomer.company#</td>
			<td>#dateFormat(invoiceDate, 'mm/dd/yyyy')#</td>
			<td>#term#</td>
			<cfset dueDate = dateAdd("d",term,invoiceDate)>
			<td>#dateFormat(dueDate,'mm/dd/yyyy')#</td>
			<td>
				<cfif dateDiff('d',now(),dueDate) LT 0>
					<span style="color:red">#dateDiff('d',now(),dueDate)#</span>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td>#projectName#</td>
			<td style="text-align:right">$#DecimalFormat(variables.invoiceTotal)#</td>
			<td style="text-align:right">#DecimalFormat(amountPaid)#</td>
			<td style="text-align:right">#dateFormat(datePaid, 'mm/dd/yyyy')#</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="7" style="text-align:right; font-weight:bold">TOTAL</td>
		<td style="text-align:right; font-weight:bold">$<cfoutput>#DecimalFormat(variables.summaryInvoiceTotal)#</cfoutput></td>
		<td style="text-align:right; font-weight:bold"></td>
		<td>&nbsp;</td>
	</tr>
</table>

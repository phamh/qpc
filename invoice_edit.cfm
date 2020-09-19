<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<cfset tableWidth = '1100px'>
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

<script>
	newItemInvoice=function(theBrowser)
	{
		try
		{

			var itemWidth = 20;
			var scopeWorkWidth = 100;
			var amtWidth = 12;

			document.getElementById("numberofNewItems").value++;
			rowID = document.getElementById("numberofNewItems").value;
			theTable = document.getElementById('newInvoiceTableId');

			//INSERT NEW ROW
			var newRow = theTable.insertRow();
			newRow.id = 'trItem_' + rowID;


			//Insert New Delete
			var td_delete = newRow.insertCell();	
			td_delete.align = 'center';
			td_delete.style.width = '60px';
			td_delete.style.borderTop = '1px solid black';
			
			var delButton = document.createElement('span');	
/*
			delButton.type = 'button';
			delButton.value = 'Delete';
*/
			delButton.innerHTML = '[X]';
			delButton.style.color = 'red';
			delButton.style.cursor = 'pointer';
			delButton.style.fontWeight = 'bold';
			//delButton.className = 'smallerInputText';
			delButton.onclick = function(){deleteRow(newRow.id)};
			td_delete.appendChild(delButton);
			
			
			//Insert New product/Service
			var td_serviceDate = newRow.insertCell();
			td_serviceDate.style.border = '1px solid black';
			var inputServiceDate = document.createElement('input');
			inputServiceDate.name = inputServiceDate.id = 'serviceDate_' + rowID;
			//inputServiceDate.style.fontSize = '13px';
			inputServiceDate.style.backgroundColor = newFieldColor;
			inputServiceDate.style.width = '150px'
			//inputServiceDate.type = 'date';
			inputServiceDate.style.overflow = 'hidden';					
			inputServiceDate.onclick = function(){unHighlightRequiredField(inputServiceDate.id);}
			inputServiceDate.onkeydown=function() {changeIsMade();};
			td_serviceDate.appendChild(inputServiceDate);

			//Insert New Item

			//Insert New product/Service
			var td_product = newRow.insertCell();
			td_product.style.border = '1px solid black';
			var inputProduct = document.createElement('input');
			inputProduct.name = inputProduct.id = 'product_' + rowID;
			inputProduct.style.width = '200px'
			inputProduct.style.backgroundColor = newFieldColor;
			inputProduct.maxLength = 100;

			inputProduct.style.overflow = 'hidden';					
			inputProduct.onclick = function(){unHighlightRequiredField(inputProduct.id);}
			inputProduct.onkeydown=function() {changeIsMade();};
			td_product.appendChild(inputProduct);

			//Insert New Description
			var td_description = newRow.insertCell();
			td_description.style.border = '1px solid black';
			var inputDescription = document.createElement('input');
			inputDescription.name = inputDescription.id = 'description_' + rowID;

			inputDescription.style.backgroundColor = newFieldColor;
			inputDescription.style.width = '500px';	
			inputDescription.maxLength = 200;		
			inputDescription.onclick = function(){unHighlightRequiredField(inputDescription.id);}
			inputDescription.onkeydown=function() {changeIsMade();};
			td_description.appendChild(inputDescription);

			//Insert New Amount
			var td_amount = newRow.insertCell();
			td_amount.style.border = '1px solid black';
			td_amount.style.width = '70px';
			var inputAmount = document.createElement('input');		
			inputAmount.style.backgroundColor = newFieldColor;
			inputAmount.style.width = '120px';
			inputAmount.name = inputAmount.id = 'amount_' + rowID;
			inputAmount.style.textAlign = 'right';

			inputAmount.style.overflow = 'hidden';					
			inputAmount.onclick = function(){unHighlightRequiredField(inputAmount.id);}
			inputAmount.onkeydown=function() {changeIsMade();};

			inputAmount.onkeypress = function(){return isDecimalNumber(this,event)};
			inputAmount.onblur = function(){return roundItToTwo(this.id)};
			inputAmount.onchange = function(){return calculateInvoiceTotal(this.value)};
						
			td_amount.appendChild(inputAmount);
									
		}

		catch(error)
		{
			alert('error on function newItem: '+ error.message)
		}		
	}		
	
	updateThisInvoice=function()
	{
		var e = new qpcCFC();
		e.setHTTPMethod("POST");
		var amountPaid = document.getElementById('amountPaid').value;
		var datePaid = document.getElementById('datePaid').value;
		var invoiceId_pk = document.getElementById('invoiceId_pk').value;		
		var customerId = document.getElementById('company').value;
		var term = document.getElementById('term').value;
		var invoiceDate = document.getElementById('invoiceDate').value;
		var project = document.getElementById('project').value;
		var location = document.getElementById('location').value;
		var theToken = document.getElementById('token').value
		var serviceDateArray = new Array();
		var productServiceArray = new Array();
		var descriptionArray = new Array();
		var amountArray = new Array();

		try
		{
			var arrayIndex = 0;
			var currentEditRows = document.getElementById("numberofNewItems").value;		
			for(i = 1; i <= currentEditRows; i++)
			{       
	    		if(document.getElementById("serviceDate_"+i) != null)
				{	

					serviceDateArray[arrayIndex] = document.getElementById("serviceDate_"+i).value;
					productServiceArray[arrayIndex] = document.getElementById("product_"+i).value;	
					descriptionArray[arrayIndex] = document.getElementById("description_"+i).value;			
					amountArray[arrayIndex] = document.getElementById("amount_"+i).value;	
					arrayIndex++;					
																								
				}
			}

			var updateThisInvoice = e.function_updateThisInvoice
								(
									invoiceId_pk,
									customerId,
									term,
									invoiceDate,
									project,
									location,
									serviceDateArray,
									productServiceArray,
									descriptionArray,
									amountArray,
									theToken,
									amountPaid,
									datePaid
								);	
			
			if(updateThisInvoice == 'no error on function_updateThisInvoice')
			{
				alert('The invoice is updated');
				//ColdFusion.navigate('invoice_view.cfm?invoiceId_pk='+invoiceId_pk, 'invoiceViewBody');
				ColdFusion.navigate('invoiceContent.cfm', 'invoiceContentBody');
				
				// onChange="ColdFusion.navigate('invoice_view.cfm?invoiceId_pk=' + this.value, 'invoiceViewBody')" multiple="true"> 
			}
			else
			{
				alert(updateThisInvoice);
				return false;
			}
		
		}
		
		catch(error)
		{
			alert('error message function updateThisInvoice: ' + error.message)
		}
				
	}

	calculateInvoiceTotal=function(value)
	{
		try
		{
			var arrayIndex = 0;
			var js_invoiceTotal = 0;
			var currentEditRows = document.getElementById("numberofNewItems").value;	

			for(i = 1; i <= currentEditRows; i++)
			{       
	    		if(document.getElementById("amount_"+i) != null)
				{	
					if(document.getElementById("amount_"+i).value != '')
					{
						js_invoiceTotal = parseFloat(js_invoiceTotal) + parseFloat(document.getElementById("amount_" + i).value);
					}								
				}
				arrayIndex++;
				
			} 
			//alert(js_invoiceTotal);
								
			document.getElementById("invoiceTotal").innerHTML = js_invoiceTotal.toFixed(2);	
		}
		
		catch(error)
		{
			alert('error message function calculateInvoiceTotal: ' + error.message)
		}
		
		return value;
	}	

	
	highlightRequiredRow=function(rowId)
	{	
		try
		{		
			document.getElementById(rowId).style.backgroundColor ='red'		
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
		
	}	
			
			
</script>

<!---<cfdump var="#session.catch.message#">--->
<cfquery name="GetCustomerList"  datasource="#REQUEST.dataSource#" >
    SELECT 	*
    FROM 	customer

</cfquery>

<cfquery name="getThisInvoiceHeader"  datasource="#REQUEST.dataSource#" >
    SELECT 	invoiceDate,customerId_fk,term,projectName,projectLocation,invoiceNumber,invoiceID_pk,datePaid,amountPaid
    FROM 	invoice
    WHERE	invoiceId_pk = <cfqueryparam value="#url.invoiceId_pk#">
    
</cfquery>

<cfquery name="getThisInvoiceItems"  datasource="#REQUEST.dataSource#" >
    SELECT 	serviceDate,product,description,amount, invoiceId_fk, id_pk
    FROM 	invoice_item
    WHERE	invoiceId_fk = <cfqueryparam value="#url.invoiceId_pk#">
</cfquery>

<cfoutput>
	<input type="hidden" name="token" id="token" value="#CSRFGenerateToken()#" size="50">
	<input type="hidden" value="#getThisInvoiceItems.recordCount#" id="numberofNewItems">
	<input type="hidden" id="invoiceId_pk" value="#url.invoiceId_pk#"></input>
</cfoutput>

<cfset variables.invoiceTotal = 0>
<cfoutput query="getThisInvoiceItems">
	<cfif getThisInvoiceItems.amount NEQ ''>
	<cfset variables.invoiceTotal = variables.invoiceTotal + getThisInvoiceItems.amount>		
	</cfif>
</cfoutput>

<div style="padding-left:45px; margin-bottom:5px;  border:0px solid gray;width:99%; text-align:left; padding-top:5px">
	<input type="button" value="Submit"  class="buttonSmall2" onclick=updateThisInvoice();closeThisCfWindow('edit_invoice_cfWidnow','','')> 
	<input type="button" value="Cancel"  class="buttonSmall2" onclick=closeThisCfWindow('edit_invoice_cfWidnow','','')>
</div>

<table class="invoiceTable" align="center" border="1" style="margin-bottom:10px">
	<tr>
		<cfoutput query="getThisInvoiceHeader">
			<th style="width:120px; text-align:left">Amount Paid: </th>
			<td style="width:150px">
				<input id="amountPaid" style="width:170px;border:0px solid gray;" value="#getThisInvoiceHeader.amountPaid#" onkeypress="return isDecimalNumber(this,event)" onblur="roundItToTwo(this.id)">
			</td>
			<th style="width:100px; text-align:left">Date Paid: </th>
			<td style="width:170px">
				<input id="datePaid" style="width:150px; border:0px solid gray;" value="#getThisInvoiceHeader.datePaid#" type="date">
			</td>
			<th></th>
		</cfoutput>
	</tr>
</table>
	
<table class="invoiceTable" align="center" border="1" style="margin-bottom:20px">
	<tr>
		<th>Invoice Number</th>
		<th>Billing Address</th>	
		<th>Terms</th>
		<th>Invoice Date</th>
		<th>Due Date</th>
		<th>Project Name</th>
		<th>Project Location</th>
	</tr>
	<cfoutput query="getThisInvoiceHeader">
	<tr style="vertical-align:top">
		<td style="width:140px; text-align:center; font-weight:bold" id="invoiceNumber">
			#getThisInvoiceHeader.invoiceNumber#
		</td>
		<td style="width:200px">

			<cfquery name="getThisCustomer"  datasource="#REQUEST.dataSource#" >
			    SELECT 	customerId_pk,company,address,city, zip
			    FROM 	customer
			    WHERE	customerId_pk = <cfqueryparam value="#getThisInvoiceHeader.customerId_fk#">
			</cfquery>	
					
			<select id="company" style="width:200px" onchange="selectThisCustomer(this.value)">
				<option value="0">Select a customer</option>
				<cfloop query="GetCustomerList">
					<option value="#customerId_pk#" <cfif GetCustomerList.customerId_pk EQ getThisCustomer.customerId_pk> selected</cfif>>#company#</option>
				</cfloop>
			</select>
			
			<input id="companyAddress" style="width:200px; border:0px solid gray;background-color:white" disabled="disabled" value="#getThisCustomer.address#"></input><br>
			<input id="companyState" style="width:200px; border:0px solid gray;background-color:white" disabled="disabled" value="#getThisCustomer.city#"></input><br>
			<input id="companyZip" style="width:200px; border:0px solid gray;background-color:white" disabled="disabled" value="#getThisCustomer.zip#"></input>
		</td>
		<td style="width:100px">
			<select id="term" onchange="updateDueDate()">
				<option value="0">0 Days</option>
				<option value="30" <cfif term EQ 30> selected</cfif>>30 Days</option>
				<option value="60" <cfif term EQ 60> selected</cfif>>60 Days</option>
				<option value="90" <cfif term EQ 90> selected</cfif>>90 Days</option>
			</select>
		</td>
		<td>
			<input id="invoiceDate" style="width:150px" type="date" value="#dateFormat(getThisInvoiceHeader.invoiceDate, 'yyyy-mm-dd')#" onchange="updateDueDate()"></input>
		</td>

		<td>
			<input id="dueDate" style="width:100px; border:0px solid gray" type="text" value="#dateFormat(getThisInvoiceHeader.invoiceDate, 'mm/dd/yyyy')#" readonly="readonly"></input>
		</td>
				
		<td><input id="project" style="width:170px" maxlength="100" value="#projectLocation#"></input></td>
		<td><input id="location" style="width:170px" maxlength="100" value="#projectName#"></input></td>
	</tr>
	</cfoutput>
</table>

<div style="padding-left:45px; margin-bottom:5px; color:blue; cursor:pointer; border:0px solid gray;width:99%; text-align:left;font-weight:bold">

	<span onclick="newItemInvoice()">[+] New Item</span>
</div>
	
<table class="invoiceTable" align="center" border="1" id="newInvoiceTableId">
	<tr>
		<th style="width:60px">DELETE</th>
		<th style="width:130px">SERVICE DATE</th>
		<th style="width:200px">PRODUCT/SERVICE</th>
		<th style="width:500px">DESCRIPTION</th>
		<th style="width:120px">AMOUNT</th>
	</tr>
	<cfoutput query="getThisInvoiceItems">
		<tr id="tr_#currentRow#">
			<td style="color:red; text-align:center; font-weight:bold" >
				<span  id="tr_#currentRow#" onclick="deleteRow(this.id);updateDueDate()">[X]</span>
			</td>
			<td>
				<input id="serviceDate_#currentRow#" type="date" value="#dateFormat(serviceDate, 'yyyy-mm-dd')#" style="width:150px"></input>
			</td>
			<td>
				<input id="product_#currentRow#" type="text" value="#product#" style="width:200px"></input>
			</td>

			<td>
				<input id="description_#currentRow#" type="text" value="#description#" style="width:500px"></input>
			</td>

			<td>
				<input onkeypress="return isDecimalNumber(this,event)" onblur="roundItToTwo(this.id)"id="amount_#currentRow#" type="text" value="#amount#" style="text-align:right;width:120px" onchange="calculateInvoiceTotal(this.value)"></input>
			</td>
		</tr>
	</cfoutput>
</table>

<!---TOTAL --->
<table align="center" style="border:0px slid gray; width:<cfoutput>#tableWidth#</cfoutput>; margin-top:10px">
	<cfoutput>
	<tr>
		<td>&nbsp;</th>
		<th style="width:15%;border:0px solid black; text-align:right; font-weight:bold">Total: </th>
		<th style="width:15%; border:0px solid black; text-align:right"><span id="invoiceTotal">#DecimalFormat(variables.invoiceTotal)#</span></th>
	</tr>		
	</cfoutput>
</table>


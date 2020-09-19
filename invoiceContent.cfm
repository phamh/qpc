<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<script>

	newInvoice=function()
	{	
		var urlString =  'invoice_new.cfm';		
		var windowName = 'new_invoice_cfWidnow';
		var windowTitle = 'New Invoice';
		var theHeight = 900;
		var theWidth  = 1200;
		openThisCfWindow(urlString, windowName, windowTitle,theHeight,theWidth);
	}

	summaryInvoice=function()
	{	
		var urlString =  'invoice_summary.cfm';		
		var windowName = 'summary_invoice_cfWidnow';
		var windowTitle = 'Invoice Summary';
		var theHeight = 900;
		var theWidth  = 1400;
		openThisCfWindow(urlString, windowName, windowTitle,theHeight,theWidth);
	}
		
</script>

<cfquery name="getInvoices"  datasource="#REQUEST.dataSource#" >
    SELECT 	*
    FROM 	invoice
    ORDER BY INVOICEID_PK DESC
</cfquery> 

<cfset topInvoiceId_pk = getInvoices.INVOICEID_PK>

<table style="margin-top:10px">
<!--- 	<tr style="border-bottom: 0px solid gray;vertical-align:middle; height:30px">
        <td style="text-align:left;border-bottom: 0px solid gray; xxpadding-left:3px" colspan="2">         
           	<input type="button" value="[+] New Invoice" onClick="newInvoice()" id="newEmployee" class="buttonSmall2">      
           	<input type="button" value="Summary" onClick="summaryInvoice()" id="summaryId" class="buttonSmall2"> 	
           	<!---<input type="button" value="[+] New Employee OLD" onClick="newEmployee()" id="newEmployee" class="buttonSmall2">--->	       
           	<input type="button" value="Log Out" onClick="logout_local()" id="logout" class="buttonSmall2">    		          
       </td>
    </tr>--->
	<tr style="vertical-align:top">
        <td>
            <!---Employee Menu--->
            <div style="border:2px solid gray; width:150px; text-align:left">

                <select name="invoiceMenuList" id="invoiceMenuList" style="width:100%;height:800px; border:0px solid black"  onChange="ColdFusion.navigate('invoice_view.cfm?invoiceId_pk=' + this.value, 'invoiceViewBody')" multiple="true">      
                 	<cfoutput query="getInvoices">
                    <option value="#INVOICEID_PK#" <cfif getInvoices.INVOICEID_PK EQ topInvoiceId_pk>selected</cfif>>#invoiceNumber#</option>
                	</cfoutput>
                </select>                
            </div>  
        </td>
		<td>
          <td>
            <!---Employee Content--->
            <div style="margin-left:2px; text-align:left; border:0px solid red;padding:0px;border: 2px solid gray;min-height:805px; padding:5px">
            	<cfdiv bind="url:invoice_view.cfm?invoiceId_pk=#getInvoices.invoiceId_pk#" id="invoiceViewBody">
            		
            </div>		
        </td>  			
		</td>
	</tr>
</table> 


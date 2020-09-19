<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">
<!---<div style="margin:5px">
	<input type="button" value="[+] New Invoice" onClick="newInvoice()" id="newEmployee" class="buttonSmall2">      
	<input type="button" value="Summary" onClick="summaryInvoice()" id="summaryId" class="buttonSmall2"> 	      
	<input type="button" value="Log Out" onClick="logout_local()" id="logout" class="buttonSmall2"> 
</div>--->
	
<div style="text-align:center; border:0px solid red">
    <cfdiv bind="url:invoiceContent.cfm" id="invoiceContentBody">     
</div>


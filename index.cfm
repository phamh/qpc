<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>QP Constructions, Inc.</title>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

</head>

<!---<body onbeforeunload="if(gFormChanged == true){ return confirmLeaveEstimateScreen();}">--->
<body>

<cfif  cgi.SERVER_NAME CONTAINS "test" OR  cgi.SERVER_NAME CONTAINS "localhost">
    <div style="color:red; font-weight:bold; font-size:20px; border:0px solid red">
        <cfif  cgi.SERVER_NAME CONTAINS "test" >
        THIS IS TESTING SITE
        </cfif>               
        
        <cfif cgi.SERVER_NAME CONTAINS "localhost">
        THIS IS DEVELOPEMENT SITE
        </cfif>     
    </div>     
</cfif> 
<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<cfinclude template="scripts/qpcJS.cfm">
<cfinclude template="css/qpcCSS.cfm">

<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC">
<cfajaximport tags="CFDIV,CFWINDOW">
					
<cflayout  type="tab" tabposition="top" style="height:1000px; overflow-y:hidden; border:1px solid gray">
    <cflayoutarea title="Estimate" source="estimate.cfm" refreshonactivate="true"></cflayoutarea>
<!---    <cflayoutarea title="Employee" source="employee.cfm" refreshonactivate="true"></cflayoutarea>
    <cflayoutarea title="Payroll" source="payroll.cfm" refreshonactivate="true"></cflayoutarea>--->
    <cflayoutarea title="Invoice" source="invoice.cfm" refreshonactivate="true"></cflayoutarea>     
</cflayout>
<!---
<cflayout  type="tab" tabposition="top" style="height:1000px; border:1px solid red; overflow-y:hidden">
    <cflayoutarea title="Estimate" source="estimate.cfm" refreshonactivate="true"></cflayoutarea>
    <cflayoutarea title="Invoice" source="invoice.cfm" refreshonactivate="true"></cflayoutarea>
    <cflayoutarea title="Employee" overflow="hidden" >

        <cflayout type="tab" tabHeight="100" style="padding:20px;height:1000px; width:900px;; border:1px solid blue">
        	<cflayoutarea title="Employee Information" source="employee.cfm" refreshonactivate="true"></cflayoutarea>
			<cflayoutarea title="Tax" source="payroll.cfm" refreshonactivate="true"></cflayoutarea>
			<cflayoutarea title="Payroll" source="payroll.cfm" refreshonactivate="true"></cflayoutarea>
        </cflayout>
        
            	
    </cflayoutarea>
    
</cflayout>
--->
</body>
</html>

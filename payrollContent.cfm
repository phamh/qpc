<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<script>
	showThisPayroll=function(id)
	{
		if(id != '')
			ColdFusion.navigate('payroll_view.cfm?employeeId_pk=' + id, 'payrollBody');
	}

</script>

<cfparam name="url.employeeId_pk"  default="0">

<cfquery name="getAllEmployees"  datasource="#REQUEST.dataSource#" >
  	SELECT 		*
	FROM 		employee
	ORDER BY 	lastName ASC 

	
</cfquery>

<cfif url.employeeId_pk NEQ 0>
	<cfset variables.currentEmployee = url.employeeId_pk>
	
<cfelseif getAllEmployees.recordCount>	
	<cfset variables.currentEmployee = getAllEmployees.employeeId_pk>
<cfelse>
	<input id="currentEstimate" value="0" type="hidden">
	<cfset variables.currentEmployee = 0>
</cfif>

<Style>
	table.payrollTable
	{
		border:0px solid gray;
		border-collapse:collapse;
		width:600px
	}
	
	table.payrollTable th, table.payrollTable td
	{
		border:1px solid gray;
		text-align:left;
		padding:5px;
	}	

	.ui-datepicker
	{
    	width: 300px;
    	height: 250px;
    	margin: 5px auto 0;
    	font: 12pt Arial, sans-serif;
	}
		
</Style>

<div style="text-align:center; border:0px solid red;padding-left:5px;">
                	    
    <table border="0" style="border-collapse:collapse;">

        <tr valign="top">
            <td>
                <!---Employee Menu--->
                <div style="border:2px solid gray; width:150px;">
                    <select name="employeeMenuList" 
                    				id="employeeMenuList" 
                                    onClick="showThisPayroll(this.value)" 
                                    style="width:100%;height:800px; border:0px solid black" multiple="true">
                                    
                              <cfoutput query="getAllEmployees">
                                <option value="#employeeId_pk#">#lastName#,  #firstName#</option>
                            </cfoutput>
                    </select>
                </div>  
            </td>
            
            <td>
                <!---Employee Content--->
                <div style="margin-left:2px; text-align:left; border:0px solid gray;padding:10px">
                	<cfdiv bind="url:payroll_view.cfm?employeeId_pk=#variables.currentEmployee#" id="payrollBody">
                </div>		
            </td>
        </tr>
	</table>        
</div>


<!---<cfquery name="getThisEmployee"  datasource="#REQUEST.dataSource#" >
  	SELECT 	*
  	FROM	employee
	WHERE 	employeeId_pk = <cfqueryparam value="#url.employeeId_pk#" cfsqltype="cf_sql_integer" >
   
</cfquery>--->


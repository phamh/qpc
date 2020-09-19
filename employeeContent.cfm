<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<script>
	showThisEmployee=function(id)
	{
		if(id != '')
			ColdFusion.navigate('employee_view.cfm?employeeId_pk=' + id, 'employeeBody');
	}
	
	newEmployee=function()
	{
		ColdFusion.navigate('employee_new.cfm', 'employeeBody');
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

<div style="text-align:center; border:0px solid red;padding-left:5px;">
                	    
    <table border="0" style="border-collapse:collapse;">
    	<tr style="border-bottom: 0px solid gray;vertical-align:middle; height:30px">
            <td style="text-align:left;border-bottom: 0px solid gray; xxpadding-left:3px" colspan="2">         
               	<input type="button" value="[+] New Employee" onClick="newThisEmployee()" id="newEmployee" class="buttonSmall2">      	
               	<!---<input type="button" value="[+] New Employee OLD" onClick="newEmployee()" id="newEmployee" class="buttonSmall2">--->	           		          
           </td>
        </tr>
        <tr valign="top">
            <td>
                <!---Employee Menu--->
                <div style="border:2px solid gray; width:150px;">
                    <select name="employeeMenuList" 
                    				id="employeeMenuList" 
                                    onClick="showThisEmployee(this.value)" 
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
                	<cfdiv bind="url:employee_view.cfm?employeeId_pk=#variables.currentEmployee#" id="employeeBody">
                </div>		
            </td>
        </tr>
	</table>        
</div>

<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">
<!---<cfdiv bind="url:employee_view.cfm?employeeId_pk=#variables.currentEmployee#" id="employeeBody">--->

<script>
	
	deleteThisEmployee=function(id)
	{
		//ColdFusion.navigate('employee_edit.cfm?employeeId_pk=' + id, 'employeeBody');
	}
	
	editThisPayroll=function(employeeId_pk)
	{
		alert(employeeId_pk)
	}

	editThisTax=function(employeeId_pk)
	{
		alert(employeeId_pk)
	}

	editThisEmployee=function(id)
	{
		
		var urlString =  'employee_edit.cfm?employeeId_pk=' + id;		
		var windowName = 'edit_employee_cfWidnow';
		var windowTitle = 'Edit Employee';
		var theHeight = 600;
		var theWidth  = 700;
		
		openThisCfWindow(urlString, windowName, windowTitle,theHeight,theWidth);
	}	
					  				
</script>

<cfquery name="getThisEmployee"  datasource="#REQUEST.dataSource#" >
  	SELECT 	*
  	FROM	employee
	WHERE 	employeeId_pk = <cfqueryparam value="#url.employeeId_pk#" cfsqltype="cf_sql_integer" >
   
</cfquery>

<cfinvoke method="ssnFormat" component="aJaxFunc.qpc" returnvariable="theSNN">
	<cfinvokeargument name="ssn" value="#getThisEmployee.ssn#" >
</cfinvoke>

<cfinvoke method="phoneFormat" component="aJaxFunc.qpc" returnvariable="theCellPhone">
	<cfinvokeargument name="phoneNumber" value="#getThisEmployee.cellPhone#" >
</cfinvoke>

<cfinvoke method="phoneFormat" component="aJaxFunc.qpc" returnvariable="theHomePhone">
	<cfinvokeargument name="phoneNumber" value="#getThisEmployee.homePhone#" >
</cfinvoke>

<table class="employeeTable" align="center">
	<cfoutput query="getThisEmployee">

		<tr>
			<th colspan="2" style="font-weight:bold; text-align:left; background-color:##CCCCCC">
				Employee Profile
				<!---<input type="button" value="Edit"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=editThisEmployee_NEW(this.id)>--->
				<input type="button" value="Edit"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=editThisEmployee(this.id)>
				<input type="button" value="Delete"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=deleteThisEmployee(this.id)>
			</th>
		</tr>
		<tr>
			<th style="width:200px">
				Last Name
			</th>
			<td style="width:400px; font-weight:bold">
				#lastName#
			</td>
		</tr>
		
		<tr>
			<th style="width:200px">
				First Name
			</th>
			<td style="width:300px; font-weight:bold">
				#firstName#
			</td>
		</tr>
		
		<tr>
			<th>
				Middle Name
			</th>
			<td>
				#middleName#
			</td>
		</tr>
		<tr>
			<th>
				Active?
			</th>
			<td>
				<cfif activeFlag EQ 1>
					Yes
				<cfelse>
					No
				</cfif>
			</td>
		</tr>
		
		<tr>
			<th>
				Social Security Number
			</th>
			<td>
				#theSNN#
			</td>
		</tr>
		<tr>
			<th>
				DOB
			</th>
			<td>
				#dateFormat(DOB, 'mm/dd/yyyy')# 
			</td>
		</tr>
		
		<tr>
			<th>
				Address
			</th>
			<td>
				#address#
			</td>
		</tr>
		<tr>
			<th>
				City
			</th>
			<td>
				#city#
			</td>
		</tr>
		
		<tr>
			<th>
				State
			</th>
			<td>
				#state#
			</td>
		</tr>
		
		<tr>
			<th>
				Zip Code
			</th>
			<td>
				#zipCode#
			</td>
		</tr>
		<tr>
			<th>
				Cell Phone
			</th>
			<td>
				#theCellPhone#
			</td>
		</tr>
		
		<tr>
			<th>
				Home Phone
			</th>
			<td>
				#theHomePhone#
			</td>
		</tr>

		<tr>
			<th colspan="2" style="font-weight:bold; text-align:left; background-color:##CCCCCC">
				Rate ($ per hour)
				<input type="button" value="Edit"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=editThisPayroll(this.id)>
				<input type="button" value="New"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=editThisPayroll(this.id)>
			</th>			
		</tr>
		
		<tr>
			<th>
				Rate per Hour
			</th>
			<td>
				$#FEDTAX#
			</td>
		</tr>

		</tr>


		<tr>
			<th colspan="2" style="font-weight:bold; text-align:left; background-color:##CCCCCC">
				Tax Withheld
				<input type="button" value="Edit"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=editThisPayroll(this.id)>
				<input type="button" value="New"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=editThisPayroll(this.id)>
			</th>			
		</tr>
		
		<tr>
			<th>
				FIT %
			</th>
			<td>
				#FEDTAX#
			</td>
		</tr>
		
		<tr>
			<th>
				FICA %
			</th>
			<td>
				#ficaTax#
			</td>
		</tr>
		<tr>
		
			<th>
				MEDI %
			</th>
			<td>
				#MEDICARETAX#
			</td>
		</tr>


		<tr>
			<th colspan="2" style="font-weight:bold; text-align:left; background-color:##CCCCCC">Company Paid Benefits</th>
		</tr>

		<tr>
			<th>
				FUTA %
			</th>
			<td>
				#FEDTAX#
			</td>
		</tr>
		
		<tr>
			<th>
				FICA %
			</th>
			<td>
				#ficaTax#
			</td>
		</tr>
		<tr>
		
			<th>
				MEDI %
			</th>
			<td>
				#MEDICARETAX#
			</td>
		</tr>	

		<tr>
		
			<th>
				SUTA-FL %
			</th>
			<td>
				#MEDICARETAX#
			</td>
		</tr>
					
	</cfoutput>
</table>
<div id="employeeEditDiv"></div>
<!---<cfif session.catch.message NEQ ''>
	<cfdump var="#session.catch#">
</cfif>--->
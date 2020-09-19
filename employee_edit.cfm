
<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">
<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC">

<script>		

	$( function() 
	{
	   $( "#dob_edit" ).datepicker(
	   	{
		   	changeMonth: true,
		   	changeYear: true,
		   	yearRange: "1950:"+"2018",
	   	}
	   	);
	});
		
	updateThisEmployee=function(employeeId_pk)
	{
		//ColdFusion.navigate('employee_edit.cfm?employeeId_pk=' + id, 'employeeBody');

		var lastName_edit = document.getElementById('lastName_edit').value;
		var firstName_edit = document.getElementById('firstName_edit').value;
		var middleName_edit = document.getElementById('middleName_edit').value;
		if((active_1_edit).checked)
		{
			var active_edit = 1;
		}
		else
			var active_edit = 0;

		var ssn_edit = document.getElementById('ssn_edit').value;
		var dob_edit = document.getElementById('dob_edit').value;
		var address_edit = document.getElementById('address_edit').value;
		var city_edit = document.getElementById('city_edit').value;
		var state_edit = document.getElementById('state_edit').value;
		var zipCode_edit = document.getElementById('zipCode_edit').value;
		var cellPhone_edit = document.getElementById('cellPhone_edit').value;
		var homePhone_edit = document.getElementById('homePhone_edit').value;
/*		var fedTax_edit = document.getElementById('fedTax_edit').value;
		var stateTax_edit = document.getElementById('stateTax_edit').value;
		var ficaTax_edit = document.getElementById('ficaTax_edit').value;
		var medTax_edit = document.getElementById('medTax_edit').value;*/
		theToken = document.getElementById('token').value;
		
		if(lastName_edit == '' || firstName_edit == '' || ssn_edit == '' || address_edit == '' || city_edit == '' || 
			state_edit == '' || zipCode_edit == '')
		{
			alert('All required data need to be entered.');
			return false;
		}
		
		var e = new qpcCFC();
		e.setHTTPMethod("POST");

		var js_updateEmployee = e.function_updateEmployee(
														employeeId_pk,
														lastName_edit,
														firstName_edit, 
														middleName_edit, 
														active_edit,
														ssn_edit,
														dob_edit, 
														address_edit, 
														city_edit,
														state_edit,
														zipCode_edit, 
														cellPhone_edit, 
														homePhone_edit,
														theToken																																				
														);	
	
		if(js_updateEmployee == 'hacker')
		{
			jsLogout = e.function_logout();
			ColdFusion.navigate('login.cfm');
		}
		else
		{
			alert('Updated');
			ColdFusion.navigate('employee_view.cfm?employeeId_pk=' + employeeId_pk, 'employeeBody');
			ColdFusion.navigate('employeeContent.cfm?employeeId_pk=' + employeeId_pk, 'employeeContentBody');
			closeThisCfWindow('edit_employee_cfWidnow');	
		}	

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

<input type="hidden" name="token" id="token" value="<cfoutput>#CSRFGenerateToken()#</cfoutput>" size="100">

<table class="employeeTable" align="center" border="0">
	<tr>
		<th style="border:0px solid gray">
			<cfoutput>
				<input type="button" value="Update"  id="#url.employeeId_pk#" class="buttonSmall2" onclick=updateThisEmployee(this.id)> 
				<input type="button" value="Cancel"  id="#url.employeeId_pk#" class="buttonSmall2" onclick="closeThisCfWindow('edit_employee_cfWidnow');" > 
			</cfoutput>		
		</th>	
		<td style="text-align:right;border:0px solid gray">
			<span style="color:red">*&nbsp;</span>Required data
		</td>			

	</tr>
</table>

<table class="employeeTable" align="center">
	
	<cfoutput query="getThisEmployee">
	<tr>
		<th style="width:200px">
			Last Name
		</th>
		<td style="width:300px">
			<input type="text" id="lastName_edit" value="#lastName#" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input>
			 <span style="color:red">*</span>
		</td>
	<tr>
		<th style="width:200px">
			First Name
		</th>
		<td style="width:300px">
			<input id="firstName_edit" value="#firstName#" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input>
			 <span style="color:red">*</span>
		</td>
	</tr>		

	<tr>
		<th>
			Middle Name
		</th>
		<td style="width:300px">
			<input id="middleName_edit" value="#middleName#" style="font-family:Tw Cen MT;font-size:16px"></input>
		</td>
	</tr>

	<tr>
		<th>
			Is Active?
		</th>
		<td style="width:300px">
			<input id="active_1_edit" name="active_edit" type="radio" value="1" <cfif ACTIVEFLAG EQ 1> checked="checked"</cfif>>&nbsp;Yes</input>
			<input id="active_2_edit" name="active_edit" type="radio" value="0"  <cfif ACTIVEFLAG EQ 0> checked="checked"</cfif>>&nbsp;No</input>
		</td>
	</tr>

	<tr>
		<th>
			Social Security Number
		</th>
		<td style="width:300px">
			<input id="ssn_edit" value="#ssn#" onkeypress="return isDecimalNumber(this,event)" maxlength="9" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input>
			<span style="color:red">*</span> (9 numerics only)
		</td>
	</tr>			

	<tr>
		<th>
			DOB
		</th>
		<td style="width:300px">
			<input id="dob_edit" value="#dateFormat(dob,'YYYY-MM-DD')#"  style="font-family:Tw Cen MT;font-size:16px"></input>
		</td>
	</tr>

	<tr>
		<th>
			Address
		</th>
		<td style="width:300px">
			<input id="address_edit" value="#address#" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input>
			 <span style="color:red">*</span>
		</td>
	</tr>	
	<tr>
		<th>
			City
		</th>
		<td style="width:300px">
			<input id="city_edit" value="#city#" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input> <span style="color:red">*</span>
		</td>
	</tr>

	<tr>
		<th>
			State
		</th>
		<td style="width:300px">
			<input id="state_edit" value="#state#" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input>
			 <span style="color:red">*</span>
		</td>
	</tr>

	<tr>
		<th>
			Zip Code
		</th>
		<td style="width:300px">
			<input id="zipCode_edit" value="#zipCode#" onkeypress="return numeralsOnly(event)" maxlength="5" style="font-family:Tw Cen MT;font-size:16px" placeholder="Required data"></input>
			<span style="color:red">*</span> (5 numerics only)
		</td>
	</tr>
		<tr>
		<th>
			Cell Phone
		</th>
		<td style="width:300px">
			<input id="cellPhone_edit" value="#cellPhone#" onkeypress="return numeralsOnly(event)" maxlength="10" style="font-family:Tw Cen MT;font-size:16px"> (10 numerics only)</input>
		</td>
	</tr>

	<tr>
		<th>
			Home Phone
		</th>
		<td style="width:300px">
			<input id="homePhone_edit" value="#homePhone#" onkeypress="return numeralsOnly(event)" maxlength="10" style="font-family:Tw Cen MT;font-size:16px"> (10 numerics only)</input>
		</td>
	</tr>
			
	</cfoutput>		
</table>

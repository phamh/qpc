<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<script>
	SubmitNewEmployee=function(windowName)
	{
		//ColdFusion.navigate('employee_edit.cfm?employeeId_pk=' + id, 'employeeBody');
		var lastName_new = document.getElementById('lastName_new').value;
		var firstName_new = document.getElementById('firstName_new').value;
		var middleName_new = document.getElementById('middleName_new').value;
		if((active_1_new).checked)
		{
			var active_new = 1;
		}
		else
			var active_new = 0;
		
		var ssn_new = document.getElementById('ssn_new').value;
		var dob_new = document.getElementById('dob_new').value;
		var address_new = document.getElementById('address_new').value;
		var city_new = document.getElementById('city_new').value;
		var state_new = document.getElementById('state_new').value;
		var zipCode_new = document.getElementById('zipCode_new').value;
		var cellPhone_new = document.getElementById('cellPhone_new').value;
		var homePhone_new = document.getElementById('homePhone_new').value;
/*		var fedTax_new = document.getElementById('fedTax_new').value;
		var stateTax_new = document.getElementById('stateTax_new').value;
		var ficaTax_new = document.getElementById('ficaTax_new').value;
		var medTax_new = document.getElementById('medTax_new').value;*/
		theToken = document.getElementById('token').value;	

		if(lastName_new == '' || firstName_new == '' || ssn_new == '' || address_new == '' || city_new == '' || 
			state_new == '' || zipCode_new == '')
		{
			alert('All required data need to be entered.');
			return false;
		}
		
		var e = new qpcCFC();
		e.setHTTPMethod("POST");

		var js_newEmployee = e.function_submitNewEmployee(
														lastName_new,
														firstName_new, 
														middleName_new, 
														active_new,
														ssn_new,
														dob_new, 
														address_new, 
														city_new,
														state_new,
														zipCode_new, 
														cellPhone_new, 
														homePhone_new,
/*														fedTax_new,
														ficaTax_new, 
														medTax_new,*/
														theToken																																				
														);	
		if(js_newEmployee == 'hacker')
		{
			jsLogout = e.function_logout();
			ColdFusion.navigate('login.cfm');
		}
		else
		{

			alert('Submit');
			ColdFusion.navigate('employeeContent.cfm', 'employeeContentBody');
			closeThisCfWindow(windowName)			
		}														
		
	}

	$( function() 
	{
	   $( "#dob_new" ).datepicker(
	   	{
		   	changeMonth: true,
		   	changeYear: true,
		   	yearRange: "1950:"+"2018",
	   	}
	   	);
	});
			
</script>

<input type="hidden" name="token" id="token" value="<cfoutput>#CSRFGenerateToken()#</cfoutput>" size="100">
 
<table class="employeeTable" align="center" border="0">
	<tr>
		<th style="border:0px solid gray">
			<cfoutput>
		<input type="button" value="Submit"  class="buttonSmall2" onclick=SubmitNewEmployee('new_employee_cfWidnow')> 
		<input type="button" value="Cancel"  class="buttonSmall2" onclick=closeThisCfWindow('new_employee_cfWidnow')> 
			</cfoutput>		
		</th>	
		<td style="text-align:right;border:0px solid gray">
			<span style="color:red">*&nbsp;</span>Required data
		</td>			

	</tr>
</table>

<table class="employeeTable" align="center">

	<tr>
		<th style="width:200px">
			Last Name <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="lastName_new"></input>
		</td>
	<tr>
		<th style="width:200px">
			First Name <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="firstName_new"></input>
		</td>
	</tr>		

	<tr>
		<th>
			Middle Name
		</th>
		<td style="width:300px">
			<input id="middleName_new"></input>
		</td>
	</tr>

	<tr>
		<th>
			Is Active?
		</th>
		<td style="width:300px">
			<input id="active_1_new" name="active_new" type="radio" value="1" checked="checked">&nbsp;Yes</input>
			<input id="active_2_new" name="active_new" type="radio" value="0">&nbsp;No</input>
		</td>
	</tr>

	<tr>
		<th>
			Social Security Number <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="ssn_new" onkeypress="return isDecimalNumber(this,event)" maxlength="9"> (9 numerics only)</input>
		</td>
	</tr>			

	<tr>
		<th>
			DOB
		</th>
		<td style="width:300px">
			<input id="dob_new"> (mm/dd/yyyy)</input>
		</td>
	</tr>

	<tr>
		<th>
			Address <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="address_new" style="width:250px"></input>
		</td>
	</tr>	
	<tr>
		<th>
			City <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="city_new"</input>
		</td>
	</tr>

	<tr>
		<th>
			State <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="state_new"></input>
		</td>
	</tr>

	<tr>
		<th>
			Zip Code <span style="color:red">*</span>
		</th>
		<td style="width:300px">
			<input id="zipCode_new" onkeypress="return numeralsOnly(event)" maxlength="5"> (5 numerics only)</input>
		</td>
	</tr>
		<tr>
		<th>
			Cell Phone
		</th>
		<td style="width:300px">
			<input id="cellPhone_new" onkeypress="return numeralsOnly(event)" maxlength="10"> (10 numerics only)</input>
		</td>
	</tr>

	<tr>
		<th>
			Home Phone
		</th>
		<td style="width:300px">
			<input id="homePhone_new" onkeypress="return numeralsOnly(event)" maxlength="10"> (10 numerics only)</input>
		</td>
	</tr>	
<!---	<tr>
		<th>
			FIT % <span style="color:red">*</span>
		</th>

		<td style="width:300px">
			<input id="fedTax_new"  onkeypress="return isDecimalNumber(this,event)"> (decimals only)</input>
		</td>

	</tr>
	
	<tr>
		<th>
			FICA % <span style="color:red">*</span>
		</th>

		<td style="width:300px">
			<input id="ficaTax_new"  onkeypress="return isDecimalNumber(this,event)"> (decimals only)</input>
		</td>
	</tr>
	<tr>

		<th>MEDI % <span style="color:red">*</span></th>
		<td style="width:300px">
			<input id="medTax_new" onkeypress="return isDecimalNumber(this,event)"> (decimals only)</input>
		</td>		
	</tr>--->

</table>


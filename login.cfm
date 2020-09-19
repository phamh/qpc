<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>QP Constructions, Inc.</title>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script>
	
	login=function()
	{

			//document.getElementById('invalidLoginMessage').innerHTML = 'Invalid login information.  Check your user  name and/or password ';
			userName = document.getElementById('userName').value;
			password = document.getElementById('thePassword').value;
			var jsRememberUserId = document.getElementById('remembrUserId').checked;
			var e = new qpcCFC();
			e.setHTTPMethod("POST");
			jsLogin = e.logMeIn(userName,password,jsRememberUserId);		
			if(jsLogin == 0)
			{
				document.getElementById('invalidLoginMessage').innerHTML = 'Invalid user  name and/or password. ';
				return false;
			}
			else
			{
				ColdFusion.navigate('index.cfm');
				return true;
			}
			
		
		return true;
	}	

	function searchKeyPress(e)
	{
	    // look for window.event in case event isn't passed in
	    e = e || window.event;
	    if (e.keyCode == 13)
	    {
	        login()
	        return false;
	    }
	    return true;
	}

   $(function () {
        $(document).on('keyup keydown keypress', function (event) {
            if (event.keyCode == 13) {
                login();
				return false;
            }
            else {
                //alert("Not Enter key pressed");
				//return false;
            }

        return true});
    });		
</script>

</head>

<cfset borderColor = 'dbdbdb'>		
<cfset borderBakcground = 'dbdbdb'>	

<body onload="document.getElementById('userName').focus();" style="background-color: #dbdbdb">
	<cfinclude template="sourceFile.cfm">
	<cfinclude template="css/qpcCSS.cfm"> 
	<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC"> 
	
	<cfif cgi.SERVER_NAME CONTAINS "localhost">
	<cfelse>
		<cfif cgi.SERVER_PORT NEQ "443">
		  <cfset redir = 'Https://' & HTTP_HOST & PATH_INFO>
		  <cflocation url="#redir#" addtoken="No">
		</cfif>
	</cfif>   

	<cfif IsDefined("cookie.qpcUsername")>
	    <!--- a cookie exist, so let's put in this username automatically into the form --->
	    <cfset variables.username = cookie.qpcUsername>
	<cfelse>
	    <!--- a cookie DOES NOT exist, so let's put a blank value in the username field --->
	    <cfset variables.username = "">
	</cfif>
	<div style="text-align:center; width:100%; border:0px dotted gray; ">
	    <table style="height:400px" align="center">
			<tr>
				<td style="text-align:center">
<!---						<div style="text-align:left; font-weight:bold;font-size:20px">
							QP Construction
						</div>--->
					<div style="border:3px solid #f16427;width:400px; height:220px;font-family:Arial;font-size:12px; background-color:white; ">
	
						<div style="background-color: #f16427; color:black; height:25px;margin-bottom:10px">
							<table style="border-collapse:collapse; font-family:Arial;font-size:12px; height:100%;color:black"  align="center">
								<tr valign=middle>
									<th style="text-align:center; color:white">QP Construction</th>
								</tr>
							</table>
						</div>
						<div>
						<table border=0 style="border-collapse:collapse; font-family:Arial;font-size:12px" align="center">
							<tr>
								<td colspan=2 style="text-align:left;color:red" id="invalidLoginMessage">&nbsp;</td>
							</tr>
							<tr>
								<td style="text-align:left">
									<b>User ID</b><br />
									<input id="userName" type="text" value="<cfoutput>#variables.username#</cfoutput>" style="width:250px; border:1px solid #dbdbdb ">
								</td>
							</tr>
						
							<tr>
								<td style="text-align:left; padding-top:8px">
									<b>Password: </b><br />
									<input id="thePassword" type="password" style="width:250px; border:1px solid #dbdbdb ">
								</td>
							 </tr>
							<tr>
								<td style="text-align:left">
									<input  type="checkbox" id="remembrUserId" <cfif IsDefined("cookie.qpcUsername") > CHECKED</cfif>/> Remember User ID
								</td>
							 </tr>							 
							 <tr style="height:30px">
								<td colspan=1 style="text-align:center">
								   <input type="submit" class="buttonsmallx" value="Log In" name="login"  id="login" onclick="return login()" style="width:250px">
								</td>
							</tr>
						</table>
					</div>				
					</div>
				</td>
			</tr>
	    </table>
	</div>    
</body>
</html>

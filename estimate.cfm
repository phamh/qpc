
<cfinclude template="sourceFile.cfm">
<link rel="stylesheet" type="text/css" href="jscalendar-1.0/calendar-brown.css">
<!-- main calendar program -->
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
   adding a calendar a matter of 1 or 2 lines of code. -->
<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC">   
<script type="text/javascript" src="jscalendar-1.0/calendar-setup.js"></script>

<cfinclude template="css/qpcCSS.cfm">
<!---<cfinclude template="estimateJS.cfm">
<cfinclude template="scripts/qpcJS.cfm">--->

<cfif cgi.SERVER_NAME EQ 'localhost'>
	<cfset session.uploadDocDir = 'C:\ColdFusion11\cfusion\wwwroot\qpc\workSheet\'>
<cfelse>
	<cfset session.uploadDocDir = 'C:\Inetpub\vhosts\phamhomesite.com\qpc\workSheet\'>
</cfif>	
            
<cfquery name="getEstimates" datasource="#REQUEST.dataSource#">
    SELECT 		*
    FROM		estimate
    WHERE 		deletedFlag  <>  <cfqueryparam cfsqltype="cf_sql_integer"  value="1">
    ORDER BY 	estimateID_pk 
</cfquery>
           
<cfparam name="url.estimateCurrentRow" default="1">
<cfparam name="url.isLogout" default="0">

<cfquery name="sortMenuList"  dbtype="query" >
    SELECT	*
	FROM	getEstimates
	ORDER BY	estimateNumber DESC
</cfquery>
<cfset getEstimates = sortMenuList>

<cfif getEstimates.recordCount>
	<cfoutput>
		<input type="hidden" id="numberofMenuRows" value="#valueList(getEstimates.estimateNumber)#" size="120">
		<input type="hidden" id="currentEstimate" value="<cfoutput>#getEstimates.estimateNumber#</cfoutput>">
		<cfset variables.currentEstimate = getEstimates.estimateNumber>
	</cfoutput>
<cfelse>
	<input id="currentEstimate" value="0" type="hidden">
	<cfset variables.currentEstimate = 0>
</cfif>

<input type="hidden" id="estimateCurrentRow" value="<cfoutput>#url.estimateCurrentRow#</cfoutput>">	

<script>
	logout_local=function()
	{
		try
		{

			theConfirm = confirm('Log out?');
			if(theConfirm == true)
			{
				gFormChanged = false;
				var e = new qpcCFC();
				e.setHTTPMethod("POST");
				jsLogout = e.function_logout();		
				ColdFusion.navigate('estimate.cfm');
				//window.close();					
			}

			else
			{
			
			}

		}
		catch(error)
		{
			alert('error on function logout_local: '+ error.message);
		}
		return true;
	}
	
	logout_local_OLD=function()
	{
		try
		{
			if(gFormChanged == true)
			{
				theConfirm = confirm('You are making some changes.  Are you sure you want to log out without saving your changes?  Click OK to log out or Cancel to stay on current page.');
				if(theConfirm == true)
				{
					gFormChanged = false;
					var e = new qpcCFC();
					e.setHTTPMethod("POST");
					jsLogout = e.function_logout();		
					ColdFusion.navigate('estimate.cfm');
					//window.close();		
								
				}
				
			}
			else
			{
					gFormChanged = false;
					var e = new qpcCFC();
					e.setHTTPMethod("POST");
					jsLogout = e.function_logout();		
					ColdFusion.navigate('index.cfm');
					//window.close();				
			}

		}
		catch(error)
		{
			alert('error on function logout_local: '+ error.message);
		}
		return true;
	}	
		
	
	showInvalidLogInMessage=function()
	{
		try
		{
			document.getElementById('invalidLoginMessage').innerHTML = 'Invalid login information.  Check your user  name and/or password ';
			//document.getElementById('invalidLoginMessage').innerHTML = 'test';
			//alert('Invalid log in information.  Please check your user name/password');
		}
		catch(error)
		{
			alert('error on function showInvalidLogInMessage: '+ error.message)
		}		
	}	
		
</script>

<cfinclude template="checkAccess.cfm">

<div style="text-align:center; border:px solid red">               	
    
    <table border="0" style="border-collapse:collapse">
    	<tr style="border-bottom: 0px solid gray;vertical-align:middle; height:30px">
            <td style="text-align:left;border-bottom: 0px solid gray; xxpadding-left:3px" colspan="2">         
               	<input type="button" value="[+] New Estimate" onClick="newEstimate()" id="newEstimate" class="buttonSmall2">             
                <input type="button" value="Log Out" onClick="logout_local()" id="logout" class="buttonSmall2">
           </td>
        </tr>
        <tr valign="top">
            <td>
                <!---Estimate Menu--->
                <div style="border:2px solid black; width:150px;">
                    <select name="menuList" 
                    				id="menuList" 
                                    onChange="ColdFusion.navigate('estimate_view.cfm?id=' + document.getElementById('menuList').options[selectedIndex].value, 'estimateBody');document.getElementById('estimateCurrentRow').value=menuList.selectedIndex+1;document.getElementById('currentEstimate').value=document.getElementById('menuList').options[selectedIndex].value" 
                                    style="width:100%;height:800px; border:0px solid black" multiple="true">
                                    
                              <cfoutput query="getEstimates">
                                <option value="#ESTIMATENUMBER#"<cfif getEstimates.currentRow EQ url.estimateCurrentRow>selected</cfif>>#ESTIMATENUMBER#</option>
                            </cfoutput>
                    </select>
                </div>  
            </td>
            
            <td>
                <!---Estimate Content--->
                <div style="margin-left:2px">
                    <cfif variables.currentEstimate NEQ 0>
                        <cfdiv bind="url:estimate_view.cfm?id=#variables.currentEstimate#" id="estimateBody">
                        <span id="pleaseSelectEstimate" style="display:none"></span>
                        
                        <cfif isDefined('session.newEstimateNumber')>
                            <script>
                               <cfoutput>
                                  var #toScript(session.newEstimateNumber, "jsVar")#;
                               </cfoutput>
                               /* document.getElementById('currentRow_'+ jsVar).style.backgroundColor = selectedMenuIdColor;*/
                            </script>	
                            <cfset session.newEstimateNumber = 0>		
                        </cfif>
                    
                    <cfelse>
                        <cfdiv id="estimateBody">
                        <span id="pleaseSelectEstimate">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Please select an estimate or click on "New Estimate"........</span>
                    </cfif>
                </div>		
            </td>
        </tr>
	</table>        
</div>
<!---<cfdump var="#cgi#">
<cfif cgi.HTTP_REFERER DOES NOT CONTAIN 'index.cfm'>
	go to index
	<!---<cflocation url="index.cfm" >--->
  <script>
  $( function() {

    window.location.href  ='index.cfm';
  } );
  </script>
	
</cfif>--->
<cfif isDefined('session.catch') AND cgi.SERVER_NAME CONTAINS "localhost">
	<cfdump var="#session.catch#">
</cfif>


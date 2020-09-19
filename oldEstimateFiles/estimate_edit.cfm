<cfinclude template="sourceFile.cfm">
<cfinclude template="estimateJS.cfm">
<cfset borderWidth = '0px'>sssss
<cfset tableWidth = '990px'>
<cfabort>
<script>		
	updateThisEstimate=function(estimateId)
	{
		try
		{
			alert('xxxx');return false;
			var updateTheseScopeWorkArray = new Array();
			var editItemArray = new Array();
			var editScopeWorkArray = new Array();
			var editAmountArray = new Array();
			var editRemarkArray = new Array();
		
			var updateTheseRemarkArray = new Array();
			var newItemArray = new Array();
			var newScopeWorkArray = new Array();
			var newAmountArray = new Array();
			var newRemarkArray = new Array();
			
			var requiredValueMessage = '';
			
			//Gathering edit item information 
			var arrayIndex = 0;
			var currentEditRows = document.getElementById("numberofEditItems").value;		
			for(i = 1; i <= currentEditRows; i++)
			{           
	    		if(document.getElementById("editEstimateID_"+i) != null)
				{	
					updateTheseScopeWorkArray[arrayIndex] = document.getElementById('editEstimateID_' + i).innerHTML;
					
					if(document.getElementById("editItem_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("editItem_"+i);
					}
					else
					{
						editItemArray[arrayIndex] = document.getElementById("editItem_"+i).value;
					}
						
					if(document.getElementById("editScopeWork_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("editScopeWork_"+i);
					}
					else
					{
						editScopeWorkArray[arrayIndex] = document.getElementById("editScopeWork_"+i).value;
					}											
											
					if(document.getElementById("editAmount_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("editAmount_"+i);
					}					
					else
					{
						editAmountArray[arrayIndex] = document.getElementById("editAmount_"+i).value;
					}							
				}
				arrayIndex++;
				
			} 

			//Gathering new item information numberofEditRemarks
			var arrayIndex = 0;
			var currentNewRows = document.getElementById("numberofNewItems").value;		
			for(i = 1; i <= currentNewRows; i++)
			{           
	    		if(document.getElementById("amount_"+i) != null)
				{
					
					if(document.getElementById("item_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("item_"+i);
					}
					else
					{
						newItemArray[arrayIndex] = document.getElementById("item_"+i).value;
					}
						
					if(document.getElementById("scopeWork_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("scopeWork_"+i);
					}
					else
					{
						newScopeWorkArray[arrayIndex] = document.getElementById("scopeWork_"+i).value;
					}											
											
					if(document.getElementById("amount_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("amount_"+i);
					}					
					else
					{
						newAmountArray[arrayIndex] = document.getElementById("amount_"+i).value;
					}							
				}
				arrayIndex++;
				
			} 

			//Gathering edit remark information 
			var arrayIndex = 0;
			var currentEditRows = document.getElementById("numberofEditRemarks").value;		

			for(i = 1; i <= currentEditRows; i++)
			{           
				if(document.getElementById("editRemark_"+i) != null)
				{	
					updateTheseRemarkArray[arrayIndex] = document.getElementById('updateThisRemark_' + i).innerHTML;
					if(document.getElementById("editRemark_"+i).value == '')
					{
						requiredValueMessage = 'yes';
						highlightRequiredField("editRemark_"+i);
					}
					else
					{
						editRemarkArray[arrayIndex] = document.getElementById("editRemark_"+i).value;
					}							
				}
				arrayIndex++;
				
			} 
						
			//Gathering new remark information
				var arrayIndex = 0;
				var currentNewRemarks = document.getElementById("numberofNewRemarks").value;		
				for(i = 1; i <= currentNewRemarks; i++)
				{           
		    		
					if(document.getElementById("remark_"+i) != null)
					{
						if(document.getElementById("remark_"+i).value == '')
						{
							requiredValueMessage = 'yes';
							highlightRequiredField("remark_"+i);
						}
						else
						{
							newRemarkArray[arrayIndex] = document.getElementById("remark_"+i).value;
						}
							
					}
					arrayIndex++;
					
				}	
			
			//validate expired days
			if(document.getElementById('expiredDays').value == '')
			{
				requiredValueMessage = 'yes';
				highlightRequiredField('expiredDays');
			}
			

			if(requiredValueMessage != '')
			{
				alert('Please enter required field(s). ');
				formChanged = true;
				requiredValueMessage = '';
				return false;
			}
			
			else
			{
				var editEstimateId = document.getElementById('editEstimateId').value;
				var estimateNumber = document.getElementById('estimateNumber').innerHTML;
				var estimateDate = document.getElementById('estimateDate').value;
				var companyName = document.getElementById('companyName').value;
				var attention = document.getElementById('attention').value;
				var companyAddress = document.getElementById('companyAddress').value;
				var jobsiteAddress = document.getElementById('jobsiteAddress').value;
				var expiredDays = document.getElementById('expiredDays').value;		
				var deleteTheseScopeWork = document.getElementById("numberofDeleteItems").value;		
				var deleteTheseRemark = document.getElementById("numberofDeleteRemarks").value;
				
				var preparedBy = document.getElementById('preparedBy').value;
				
				//alert(approvedDate);
				//return false;
				var e = new qpcCFC();
				e.setHTTPMethod("POST");

				js_updateEstimate = e.function_updateEstimate(editEstimateId,estimateNumber,estimateDate, companyName, attention, 
															companyAddress,jobsiteAddress,expiredDays,preparedBy,
															 updateTheseScopeWorkArray, 
															 editItemArray,editScopeWorkArray,editAmountArray,deleteTheseScopeWork,
															 updateTheseRemarkArray, 
															 editRemarkArray,
															 deleteTheseRemark,
															 newItemArray,newScopeWorkArray,newAmountArray,newRemarkArray);
				
				ableNewEstimateButton();
				ableEstimateMenu();
				gFormChanged = false;
				ColdFusion.navigate('estimate_view.cfm?id=' + estimateId, 'estimateBody');					
			}		
	
		}
		
		catch(error)
		{
			alert('error message function updateThisEstimate: '+ error.message)
		}

	}	
  	
</script>
<cfinclude template="checkAccess.cfm">
<cffunction name="calculateTextAreaRows">
	<cfargument name="text" type="string" required="true">
	<cfargument name="width" type="numeric" required="true">
	<cfif width LTE 0>
		<cfreturn 0>
	</cfif>
	<cfset words = ListToArray(text, Chr(32), true)>
	<cfset rows = 1>
	<cfset lineLength = 0>
	<cfloop array="#words#" index="word">
		<cfset tempLength = lineLength + 1 + Len(word)>
		<cfif tempLength GT width>
			<cfset rows = rows + 1>
			<cfset lineLength = 1 + Len(word)>
		<cfelse>
			<cfset lineLength = lineLength + 1 + Len(word)>
		</cfif>
	</cfloop>
	<cfset nl = Chr(13)&Chr(10)>
	<cfset index = Find(nl, text, 1)>
	<cfloop condition="index GT 0">
		<cfset rows = rows + 1>
		<cfset index = index + 2>
		<cfset index = Find(nl, text, index)>
	</cfloop>
	<cfreturn rows>
</cffunction>


<cfquery name="getThisEstimate"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimate
	WHERE	estimateNumber = #url.id#
</cfquery>

<cfquery name="getThisEstimateItems"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimateScopework
    <cfif getThisEstimate.recordCount>
    	WHERE	estimateID_fk = <cfqueryparam value="#getThisEstimate.estimateID_pk#" cfsqltype="cf_sql_integer">
    <cfelse>
    	WHERE	estimateID_fk = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
	</cfif>
	
</cfquery>

<cfquery name="getThisRemark"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimateRemark
    <cfif getThisEstimate.recordCount>
    	WHERE	estimateID_fk = <cfqueryparam value="#getThisEstimate.estimateID_pk#" cfsqltype="cf_sql_integer">
    <cfelse>
    	WHERE	estimateID_fk = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
	</cfif>  
</cfquery>

<div style="display:none">
<cfoutput>
	edit Item: <input type="text" value="#getThisEstimateItems.recordCount#" id="numberofEditItems" size="5">
	edit Remark: <input type="text" value="#getThisRemark.recordCount#" id="numberofEditRemarks" size="5">
    delete Item: <input type="text" value="" id="numberofDeleteItems" size="5">
    delete remark:<input type="text" value="" id="numberofDeleteRemarks" size="5" />
	new item: <input type="text" value="" id="numberofNewItems" size="5">
	new remark: <input type="text" value="" id="numberofNewRemarks" size="5">
	estimate ID: <input type="text" value="#getThisEstimate.estimateID_pk#" id="editEstimateId" size="5">
</cfoutput>
</div>

<div align=center style="border:2px solid black; width:1000px; height:auto;padding:5px">
		<cfoutput>
        <!---HEADER--->
		<div style="width:#tableWidth#; border-bottom:2px solid black; margin-bottom:5px">
		<table border=0 style="width:#tableWidth#">
        	<td style="width:300px">
				<input type="button" value="Update" class="buttonsmall" onclick="updateThisEstimate('#url.id#')">
				<input type="button" value="Worksheet" class="buttonsmall" onclick="openWorksheet('#url.id#')">
				<input type="button" value="Cancel" class="buttonsmall" onclick="cancelNewEstimate('#url.id#')">          
            </td>
            <th style="text-align:center; font-size:26px">
            	Edit Estimate #url.id#
            </th>
            <td style="width:300px"></td>
        </table>
        </div>
        </cfoutput>
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:50px">
		<cfoutput>
		<tr>
			<th style="width:710px; border:#borderWidth# solid black">QP CONSTRUCTION, INC.</th>
			<th style="border:#borderWidth# solid black">Estimate ##:</th>
			<th style="width:150px; border:#borderWidth# solid black"><span id="estimateNumber">#getThisEstimate.estimateNumber#</span>
			</th>
		</tr>
        
		<tr>
			<td style="border:#borderWidth# solid black">3350 Ulmerton Road Suite 11</td>
			<td style="border:#borderWidth# solid black">Date of Estimate: </td>
			<td style="border:#borderWidth# solid black">
				<input type="text" id="estimateDate"  name="estimateDate" value="#dateFormat(getThisEstimate.estimateDate, 'mmm dd, yyyy')#" readOnly size="13"
                									onClick="return showCalendar2('estimateDate', 'btnEstimateDate','', 1); changeExpiredDate()" onchange="alert('test')">
				<input class="noPrint" id="btnEstimateDate" onClick="return showCalendar2('estimateDate', 'btnEstimateDate','', 1);" type="image" src="jscalendar-1.0/img.gif" align="bottom" />
			</td>
		</tr>	
        
		<tr>
			<td style="border:#borderWidth# solid black">Clearwater, FL. 33762</td>
<!---			<td colspan=1 style="border:#borderWidth# solid black">Approved By:</td>
            <td>
				<input type="text" id="approvedBy"  name="approvedBy" value="#getThisEstimate.approvedBy#"  size="15">
           	</td>--->
		</tr>		
		<tr valign="middle">
			<td style="border:#borderWidth# solid black">Office: 727-350-5947</td>
<!---			<td colspan=1 style="border:#borderWidth# solid black">Date of Approve:</td>
            <td>
				<input type="text" id="approvedDate"  name="approvedDate" value="#dateFormat(getThisEstimate.approvedDate, 'mmm dd, yyyy')#" readOnly size="10" onClick="return showCalendar2('approvedDate', 'btnApprovedDate','', 1); changeExpiredDate()" onchange="alert('test')">
				<input class="noPrint" id="btnApprovedDate" onClick="return showCalendar2('approvedDate', 'btnApprovedDate','', 1);" type="image" src="jscalendar-1.0/img.gif" align="bottom" />
                <span title="remove Approved Date"  style=" cursor:pointer;  color:red; font-weight:bold; "onclick="document.getElementById('approvedDate').value=''";>[X]</span>     
            </td>  --->          
		</tr>	
		<tr>
			<td style="border:#borderWidth# solid black">Fax: 877-4537935</td>
			<td colspan=2 style="border:#borderWidth# solid black">&nbsp;</td>
		</tr>			
		</cfoutput>
	</table>
	
	<!---SEND TO --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
		<cfoutput>
		<tr>
			<th colspan=2 style="border:#borderWidth# solid black">JOB</th>
		</tr>
		
		<tr>
			<th style="width:130px; border:#borderWidth# solid black" >Company:</th>
			<th style="border:#borderWidth# solid black">
			<input type="text" size="50" value="#getThisEstimate.companyName#" id="companyName"onkeydown="changeIsMade()"></th>
		</tr>

		<tr>
			<th style="border:#borderWidth# solid black">Attention:</th>
			<th style="border:#borderWidth# solid black"><input id="attention" type="text" size="50" value="#getThisEstimate.attention#"onkeydown="changeIsMade()"></th>
		</tr>
		<tr>
			<th style="border:#borderWidth# solid black">Address:</th>
			<th style="border:#borderWidth# solid black"><input id="companyAddress" type="text" size="50" value="#getThisEstimate.companyAddress#"onkeydown="changeIsMade()"></th>
		</tr>	

		<tr>
			<th style="border:#borderWidth# solid black">Job Site Address:</th>
			<th style="border:#borderWidth# solid black"><input id="jobsiteAddress" type="text" size="50" value="#getThisEstimate.jobsiteAddress#"onkeydown="changeIsMade()"></th>
		</tr>
									
		</cfoutput>
	</table>	

        <cfif cgi.http_user_agent CONTAINS 'chrome' OR cgi.http_user_agent CONTAINS 'safair'> 
        	<cfset scopeWorkWidth = 78>
            <cfset itemWidth = 15>
            <cfset amtWidth = 10>
            <cfset remarkWidth = 110>
            <cfset theBrowser = 'chrome'>
         <cfelse>
         	<cfset scopeWorkWidth = 100>
            <cfset itemWidth = 20>
            <cfset amtWidth = 12>
            <cfset remarkWidth = 137>
            <cfset theBrowser = 'ie'>
		</cfif>
        	
	<div align=left style="padding-left:10px; margin-bottom:5px; color:blue; cursor:pointer;" onclick="newItem(<cfoutput>'#theBrowser#'</cfoutput>)">
		[+] New Item
	</div>

	<!---ESTIMATE START HERE --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:1px solid black; margin-bottom:5px" id="estimateTable">
		<cfoutput>
		<tr bgcolor="lightGrey">
			<th style="width:100px; border:1px solid black; text-align:center">Delete?</th>
			<th style="width:150px; border:1px solid black; text-align:center">Item</th>
			<th style="width:640px; border:1px solid black; text-align:center">Scope of Work</th>
			<th style="width:100px; border:1px solid black; text-align:center">Amount</th>
		</tr>	
		</cfoutput>			
			
		<cfset variables.estimateTotal = 0>
		<cfoutput query="getThisEstimateItems">
			<cfset scopeWorkRows = calculateTextAreaRows(getThisEstimateItems.scopeWork, scopeWorkWidth)>
            <cfset itemRows = calculateTextAreaRows(getThisEstimateItems.item, itemWidth)>
			<cfset variables.estimateTotal = variables.estimateTotal + getThisEstimateItems.amount>
			<tr id="trEditItem_#currentRow#" valign="top">
				<td style="border:1px solid black; color:red;  font-weight:bold;text-align:center; cursor:pointer" onclick="deleteScopeWork('trEditItem_#currentRow#', '#auto_ID#')" class="td_input">
                	[X]<span style="display:none" id ="editEstimateID_#currentRow#">#auto_ID#</span>
               </td>
				<td style="border:1px solid black;" class="td_input">
					<!---<input id="editItem_#currentRow#" type="text" value="#item#" size="15" onclick="unHighlightRequiredField(this.id)">--->
					<textarea id="editItem_#currentRow#" cols="#itemWidth#" rows="#itemRows#" style="overflow:hidden; " onclick="unHighlightRequiredField(this.id)" onkeyup="determineHeight(this);limitText(this);" onkeydown="changeIsMade()">#item#</textarea>                      
				</td>
				<td style="border:1px solid black;" class="td_input">
					<!---<input id="editScopeWork_#currentRow#" type="text" value="#scopeWork#" size="110" onclick="unHighlightRequiredField(this.id)">--->
					<textarea id="editScopeWork_#currentRow#" cols="#scopeWorkWidth#" rows="#scopeWorkRows#" style="overflow:hidden; " onclick="unHighlightRequiredField(this.id)" onkeyup="determineHeight(this);limitText(this);" onkeydown="changeIsMade()">#scopeWork#</textarea>                    
				</td>
				<td style="border:1px solid black;" class="td_input">
					<input id="editAmount_#currentRow#" type="text" value="#amount#" size="#amtWidth#" style="text-align: right" 
							onclick="unHighlightRequiredField(this.id)" 
							onkeypress="return isDecimalNumber(this,event)" onblur="roundItToTwo(this.id)"
							onchange="calculateEstimateTotal(this.value)"
                            onkeydown="changeIsMade()">
				</td>
			</tr>
		</cfoutput>
				
	</table>

	<!---TOTAL --->
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:0px solid black; margin-bottom:20px">
		<cfoutput>
		<tr>
			<th style="border:0px solid black; text-align:left" id="estimateTotalText"></th>
			<th style="width:15%;border:0px solid black; text-align:right">Total: </th>
			<th style="width:15%; border:0px solid black; text-align:right" id="estimateTotal">
				<span id="estimateTotal">#DecimalFormat(variables.estimateTotal)#</span>
			</th>
		</tr>
					
		</cfoutput>
	</table>

	<!---REMARKS START HERE --->
	<div align=left style="padding-left:10px; margin-bottom:5px; color:blue; cursor:pointer;" onclick="newRemark(<cfoutput>'#theBrowser#'</cfoutput>)">
		[+] New Remark
	</div>
	<table style="width:<cfoutput>#tableWidth#</cfoutput>; border-collapse:collapse;border:1px solid black; margin-bottom:5px" id="remarkTable">
		<cfoutput>
		<tr bgcolor="lightGrey">
			<th style="width:100px; border:1px solid black; text-align:center">Delete?</th>
			<th style="border:1px solid black; text-align:center">Remark</th>
		</tr>
		</cfoutput>
        
		<cfoutput query="getThisRemark">
        	<cfset remarkRows = calculateTextAreaRows(getThisRemark.remark, remarkWidth)>
			<tr id="trEditRemark_#currentRow#">
				<td style="width:100px;border:1px solid black; text-align:center; color:red; font-weight:bold;cursor:pointer" onclick="deleteRemark('trEditRemark_#currentRow#', '#auto_ID#')">
                [X]<span style="display:none" id ="updateThisRemark_#currentRow#">#auto_ID#</span>
                </td>
				<td  style="border:1px solid black;" class="td_input">
					<textarea id="editRemark_#currentRow#" cols="#remarkWidth#" rows="#remarkRows#" style="overflow:hidden; " onclick="unHighlightRequiredField(this.id)" onkeyup="determineHeight(this);limitText(this);" onkeydown="changeIsMade()">#remark#</textarea>	
				</td>
				<td style="display:none">edit</td>
			</tr>			
		</cfoutput>
	</table>

	<!---EXPIRED DAYS --->	
	<div align=center style="font-weight:bold; margin-top:5px">
			<cfoutput>
				This estimate will be expired on <span id="expiredDate">#dateFormat(dateAdd("d", getThisEstimate.expiredDays, getThisEstimate.estimateDate), 'mmm dd, yyyy')#</span> 
				(<input id="expiredDays" type="text" size="1" value="#getThisEstimate.expiredDays#" 
					onkeypress="unHighlightRequiredField('expiredDays'); return numeralsOnly(event);" 
					onclick="unHighlightRequiredField('expiredDays')" 
					onchange="changeExpiredDate()"
                    onkeydown="changeIsMade()"> days from the date of estimate.)
			</cfoutput>
	</div>	
	<!---SIGNATURES --->	
    <cfquery name="getPreparerList"  datasource="#REQUEST.dataSource#" >
        SELECT	*
        FROM		userAccount
        WHERE	authorizedToEstimate = 1
    </cfquery> 
    
	<div align=left>
    <blockquote>
        <table border=0 style="width:915px">
            <tr valign="top">
                <td style="width:450px">
                    <div style="margin-bottom:70px">
                        Sincerely,
                    </div>
                    <div style="margin-bottom:10px">
                        <select  id="preparedBy" onchange="changeIsMade()">
                            <option value="0">prepared by</option>
                            <cfoutput query="getPreparerList">
                                <option value="#userAccountID_pk#" <cfif getPreparerList.userAccountID_pk EQ getThisEstimate.userAccountID_fk>selected</cfif>>#firstName# #lastName#</option>
                            </cfoutput>        	
                        </select>
                    </div>                
                </td>
                <td style="width:450px">&nbsp;
                            
                </td>
            </tr>
        </table>    
 
    </blockquote>     
	</div>    		
</div>
<cfif isDefined('session.catch') AND cgi.SERVER_NAME CONTAINS "localhost">
	<cfdump var="#session.catch#">
</cfif>


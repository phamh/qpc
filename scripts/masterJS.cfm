
<script language="VBScript">
<!--
Function makeMsgBox(title,message,icon,buttons,defButton,mode)
   butVal = icon + buttons + defButton + mode
   makeMsgBox = MsgBox(message,butVal,title)
End Function
// -->
</script>

<script type="text/javascript" language="javascript">
//<
//-----------:-----------------------------------------------------------------------
//   Filename: mpl_missionsJS.cfm
//    Project: TRMPT
//     Author: Karl VanWie
//    Company: Booz Allen Hamilton
//       Date: April 2006
//  Copyright: All rights reserved. 
//    Purpose: Functions to support TRMPT Mission Definition
//-----------:-----------------------------------------------------------------------
//>

//used to determine whether form has changed or not.  will be checked on exit and a confirmation will be presented to make
//sure the user wants to exit without saving (ER - 2/19/07)
var formChanged = false;
var idSelected = 'none';
var rowSelected = 'none';
var exitMessagePage = "Your changes will be lost if you press OK.";
var exitMessageItem = "Your changes will be lost if you press OK.\n \nPress OK to continue or Cancel to stay on the current mission.";
var exitMessageTab = "Your changes will be lost if you press OK.\n \nPress OK to continue, or Cancel to stay on the current tab.";
// used to keep a list of assets added and removed, in order to reset the table if the user navigates away with unsaved changes
var assetsAdded = '';
var assetsRemoved = '';

var LL_order_in = 'lessonLearnedID_fk';
var LL_categoryID_in = 0;
var LL_Timeline_in = 0;
var LL_Disposition_in = 0;
var LLA_order_in = 'missionID_fk, lessonLearnedID_fk ASC';
var LLA_lessonLearnedID_in = 0;
var LLA_categoryID_in = 0;
var LLA_Timeline_in = 0;
var LLA_Disposition_in = 0;
var	inputTextLimit = 255;

//<
//  FUNCTION Name: confirmLeave()
//    Description: routine to determine if the form has changed and to prompt the user that they will lose their changes
//     Parameters: none
//        Returns: either returns true (discard changes and continue) or false (cancel and stay on the current page)
//  Relationships: 
//       Comments:
//>
function confirmLeave()
{
	if(formChanged)
	{
		return exitMessagePage;
		
	}
}

function confirmLeaveTab()
{

}

//<
//  FUNCTION Name: alternateRows()
//    Description: Routine to alter the row colors of a table output, uses CSS
//     Parameters: ID of table to be manipulated
//        Returns: Modifications to Table ID class definition
//  Relationships: called by hiliteRow()
//       Comments:
//>
function alternateRows()
{ 
	var table = document.getElementById("myListTable");   
	var rows = table.getElementsByTagName("tr");   
	for(i = 0; i < (rows.length); i++)
	{           
		//manipulate rows
		currRow = i + 1;
		rowID = currRow.toString();
		var col1 = 'row' + rowID + '_1';
		var col2 = 'row' + rowID + '_2';
		if(i % 2 == 0)
		{ 
			document.getElementById(col1).className = "missiondefTextSmallEven"; 
			document.getElementById(col2).className = "missiondefTextSmallEven"; 
		}
		else
		{ 
			document.getElementById(col1).className = "missiondefTextSmallOdd"; 
			document.getElementById(col2).className = "missiondefTextSmallOdd"; 
		}       
	} 
}

//<
//  FUNCTION Name: hiliteRow(rowNum)
//    Description: Routine to highlight table row, uses CSS
//     Parameters: ID of TDs to be manipulated
//        Returns: Modifications to TD class definition
//  Relationships: calls alternateRows()
//       Comments:
//>
function hiliteRow(rowNum)
{
	// clear previous highligted rows
	restripeTable();
	// highlight selected row
	var col1 = 'row'+ rowNum + '_1';
	var col2 = 'row'+ rowNum + '_2';
	document.getElementById(col1).className="missiondefTextSmallHighlight";
	document.getElementById(col2).className="missiondefTextSmallHighlight";
}


//<
//  FUNCTION Name: displayMissionTabs()
//    Description: Controls the display of Mission Details
//               : (only turns on if already off)
//     Parameters: none
//        Returns: Display ON
//  Relationships: 
//       Comments: 
//>
function displayMissionTabs()
{
	if (document.getElementById("missionDetails").style.display=="none")
		document.getElementById("missionDetails").style.display="block";
}





//<
//  FUNCTION Name: displayNew()
//    Description: Toggle to display New Record tab information
//               : also manipulated Mission Details display
//     Parameters: none
//        Returns: Display ON/OFF
//  Relationships: calls clearActionMsg()
//       Comments: 
//>
function displayNew()
{
	formChanged = false;
	clearActionMsg();
	if (document.getElementById("newMission").style.display=="none")
	{
		document.getElementById("newMission").style.display="block";
		document.getElementById("missionDetails").style.display="none";
		document.getElementById("pis_prd_documents").style.display = "none";
		document.getElementById("lessonLearnedActionDiv").style.display = "none";
	}
	else
	{
		document.getElementById("newMission").style.display="none";
	}
}

//<
//  FUNCTION Name: hideNew()
//    Description: if user clicks "Add" and then clicks elsewhere, "add" form needs to go away
//     Parameters: none
//        Returns: none
//  Relationships: 
//       Comments: 
//>
function hideNew()
{
	if (document.getElementById("newMission").style.display!="none")
	{
		document.getElementById("newMission").style.display="none";
	}
}


function sortLessonLearned(recordID, myOrder)
{
	LL_order_in = myOrder;
	//DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', recordID, myOrder, setMissionLessonLearnedRequest)
	DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', recordID, myOrder, LL_categoryID_in, LL_Timeline_in, LL_Disposition_in,setMissionLessonLearnedRequest);
	formChanged = false;
}


function sortLessonLearnedAction(myOrder)
<!---wwww--->
{
	LLA_order_in = myOrder;
	DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', LLA_order_in, LLA_lessonLearnedID_in, LLA_categoryID_in, LLA_Timeline_in, LLA_Disposition_in, setMissionLessonLearnedAction);
	formChanged = false;
	
}

	
//---------------:-----------------------------------------------------------------------
//<
//          START: CFAJAX based functions 
//>
//---------------:-----------------------------------------------------------------------

//<
//  FUNCTION Name: getMissionInfo(id,row)
//    Description: Retrieves database information for the specified record ID
//               :   (uses the CFAJAX DWREngine)
//     Parameters: id - record id for the mission of interest
//               : row - row position within the select list
//        Returns: multiple Objects
//  Relationships: calls hiliteRow(), displayMissionTabs(), clearActionMsg()
//       Comments: 
//>

function getMissionInfo(id,row)
{

	// if they have unsaved changes, prompt them before changing the mission info
	document.getElementById('mBoxscoreForm').innerHTML = 'please wait - updating...';
	document.getElementById('missionPreMissionForm').innerHTML = 'please wait - updating...';
	document.getElementById("pis_prd_documents").style.display = 'none';
	document.getElementById("lessonLearnedActionDiv").style.display = 'none';

	//clear the formChanged flag when initially displaying the info
	
	formChanged = false;
	hiliteRow(row);  //highlight row
	displayMissionTabs();
	clearActionMsg();
	hideNew(); //if "Add" form displayed, hide it
	var recordID = id;
	idSelected = id;
	rowSelected = row;
	
	// get the record specific information about the Mission
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "su,msn_link"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', recordID, setTCSWorksheet);
	</cfif>

	// get requirements assigned to the Mission
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msn_link,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		/*if(document.getElementById('myAssignedRequirementsTable'))
		  {
			  DWREngine._execute(_cfscriptLocation, null, 'getReqsAssigned', recordID, setReqsAssigned);
		  }*/
		  <!--- code to support static requirements documents --->
		  DWREngine._execute(_cfscriptLocation, null, 'get_uds_ors_documents', recordID, set_uds_ors_document);
		  <!--- /code to support static requirements documents --->

	</cfif>	

	// get lesson Learn assigned to the Mission
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msn_link,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		  <!--- code to support static requirements documents --->
		  DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', recordID, setMissionLessonLearnedRequest);
		  
		  <!--- /code to support static requirements documents --->
	</cfif>	

	// get lesson Learn Action to the Mission
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msn_link,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		  DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', LLA_order_in, setMissionLessonLearnedAction);
	</cfif>	

	// populate TRM Form
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msnedit,msnCTFedit,su,msn_link"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', recordID, getMissionAssignRequest);
		//since we now have 2 worksheets (ft and ctf), let's go ahead and pre-select the ft worksheet
		
		//a bit of a cludge, but I've ran into timing issues on certain machines if the user pulls up a mission quickly after
		//loading the page.  I think this command sometimes gets executed before the page fully loads and it tries to set the
		//content of the div before the div has been drawn.  This delay seems to pause just long enough to let everything get drawn
		//setTimeout("getAssetGroup('default');", 1000);
	</cfif>
	
	// populate Pre-Mission worksheet Form
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msnedit,msnCTFedit,su,msn_link"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		//var returnURL = document.getElementById('returnURLstring').value;
		DWREngine._execute(_cfscriptLocation, null, 'getPreMissionWorksheet', recordID, setPreMissionWorksheet);
	</cfif>
	
	// populate Pre-Mission Asset worksheet Form
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msnedit,msnCTFedit,su,msn_link"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', recordID, setAssetPreMissionWorksheet);
		//since we now have 2 worksheets (ft and ctf), let's go ahead and pre-select the ft worksheet		
		//setTimeout("getPMAssetGroup('default');", 1000);
	</cfif>
	
	// populate Boxscore worksheet Form
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "su,msn_link"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', recordID, setBoxscoreWorksheet);
	</cfif>
}

//<
//  FUNCTION Name: refreshView(recordID, refreshIDs, editable)
//    Description: refreshes the Mission Edit screen after a new version is created
//     Parameters: recordid - missionID
//				   refreshIDs - binary indicating whether or not to update the mission ID list on the LHS (this is for when the user changes the missionID)
//				   editable - binary to indicate whether to display the TCS view or the TCS edit screen
//        Returns: 
//  Relationships: 
//       Comments:
//>	
function refreshView(recordID, refreshIDs, editable)
{
	if(refreshIDs)
	{
		document.getElementById('row' + rowSelected + '_2').innerHTML = refreshIDs;	
	}
	if(editable)
	{
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSForm', recordID, setTCSWorksheet);
	}else{
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', recordID, setTCSWorksheet);
	}
	DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', recordID, setBoxscoreWorksheet);
	DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', recordID, setAssetPreMissionWorksheet);
	DWREngine._execute(_cfscriptLocation, null, 'getPreMissionWorksheet', recordID, setPreMissionWorksheet);
	DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', recordID, getMissionAssignRequest);
}

//<
//  FUNCTION Name: changeActionMessage(message)
//    Description: function to display and alter the action message via javascript, rather than url.msg
//     Parameters: message:  the message to display
//        Returns: 
//  Relationships: 
//       Comments:
//>	
function changeActionMessage(message)
{
	document.getElementById('actionMsg').style.display='block';
	document.getElementById('actionMsg').innerHTML=message;
}



//<
//  FUNCTION Name: setUPreqsAssignedSelectList(object)
//    Description: populates the values of the associated DIVs with the returned information from the database call
//					and updates checkboxes
//     Parameters: object - object returned from cfajax call
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>	
function setUPreqsAssignedSelectList(object)
{
	// save original list of Assigned values
	//DWRUtil.setValue("origUpIDsAssigned", object.REQSASSIGNEDLIST);//commented out by Hung Pham on Feb 4th
	
	//used to deactivate the form if the mission is marked as deleted
	if(object.DELETED == 1)
	{
		document.forms.upRangeRequirementsALL.disabled = true;
		document.forms.upRangeRequirementsALL.submit.disabled = true;
		for (i=0; i< document.forms.upRangeRequirementsALL.upReqsAssignedCheckbox.length; i++) 
		{
			document.forms.upRangeRequirementsALL.upReqsAssignedCheckbox[i].disabled = true;
		}
	}else{
		document.forms.upRangeRequirementsALL.disabled = false;
		document.forms.upRangeRequirementsALL.submit.disabled = false;
		for (i=0; i< document.forms.upRangeRequirementsALL.upReqsAssignedCheckbox.length; i++) 
		{
			document.forms.upRangeRequirementsALL.upReqsAssignedCheckbox[i].disabled = false;

		}
	}
	
	//unchecks all the checkboxes
	for (i=0; i< document.forms.upRangeRequirementsALL.upReqsAssignedCheckbox.length; i++) 
	{
		document.forms.upRangeRequirementsALL.upReqsAssignedCheckbox[i].checked = false;
	}
	// update the checkboxes according to IDs list passed in
	// splits the comma seprated list to put in the array
	var curID_Array = object.REQSASSIGNEDLIST.split(',');
	for (var x=0; x<curID_Array.length; x++) 
	{	
		var myID = "upReqID" + curID_Array[x].toString();
		document.getElementById(myID).checked = "true"
	}	
}

//<
//  FUNCTION Name: setDOWNreqsAssignedSelectList(object)
//    Description: populates the values of the associated DIVs with the returned information from the database call
//					and updates checkboxes
//     Parameters: object - object returned from cfajax call
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>		
function setDOWNreqsAssignedSelectList(object)
{
	// save original list of Assigned values
	//DWRUtil.setValue("origDownIDsAssigned", object.REQSASSIGNEDLIST);//commented out by Hung Pham on Feb 4th

	//used to deactivate the form if the mission is marked as deleted
	if(object.DELETED == 1)
	{
		document.forms.downRangeRequirementsALL.disabled = true;
		document.forms.downRangeRequirementsALL.submit.disabled = true;
		for (i=0; i< document.forms.downRangeRequirementsALL.downReqsAssignedCheckbox.length; i++) 
		{
			document.forms.downRangeRequirementsALL.downReqsAssignedCheckbox[i].disabled = true;

		}
	}else{
		document.forms.downRangeRequirementsALL.disabled = false;
		document.forms.downRangeRequirementsALL.submit.disabled = false;
		for (i=0; i< document.forms.downRangeRequirementsALL.downReqsAssignedCheckbox.length; i++) 
		{
			document.forms.downRangeRequirementsALL.downReqsAssignedCheckbox[i].disabled = false;
		}
	}
	
	//unchecks all the checkboxes
	for (i=0; i< document.forms.downRangeRequirementsALL.downReqsAssignedCheckbox.length; i++) 
	{
		document.forms.downRangeRequirementsALL.downReqsAssignedCheckbox[i].checked = false;
	}
	// update the checkboxes according to IDs list passed in
	// splits the comma seprated list to put in the array
	var curID_Array = object.REQSASSIGNEDLIST.split(',');
	for (var x=0; x<curID_Array.length; x++) 
	{	
		var myID = "downReqID" + curID_Array[x].toString();
		document.getElementById(myID).checked = "true"
	}	
}

//<
//  FUNCTION Name: setMIDreqsAssignedSelectList(object)
//    Description: populates the values of the associated DIVs with the returned information from the database call
//					and updates checkboxes
//     Parameters: object - object returned from cfajax call
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>		
function setMIDreqsAssignedSelectList(object)
{
	// save original list of Assigned values
	//DWRUtil.setValue("origMidIDsAssigned", object.REQSASSIGNEDLIST);//commented out by Hung Pham on Feb 4th

	//used to deactivate the form if the mission is marked as deleted
	if(object.DELETED == 1)
	{
		document.forms.midRangeRequirementsALL.disabled = true;
		document.forms.midRangeRequirementsALL.submit.disabled = true;
		for (i=0; i< document.forms.midRangeRequirementsALL.midReqsAssignedCheckbox.length; i++) 
		{
			document.forms.midRangeRequirementsALL.midReqsAssignedCheckbox[i].disabled = true;
		}
	}else{
		document.forms.midRangeRequirementsALL.disabled = false;
		document.forms.midRangeRequirementsALL.submit.disabled = false;
		for (i=0; i< document.forms.midRangeRequirementsALL.midReqsAssignedCheckbox.length; i++) 
		{
			document.forms.midRangeRequirementsALL.midReqsAssignedCheckbox[i].disabled = false;
		}
	}
	
	//unchecks all the checkboxes
	for (i=0; i< document.forms.midRangeRequirementsALL.midReqsAssignedCheckbox.length; i++) 
	{
		document.forms.midRangeRequirementsALL.midReqsAssignedCheckbox[i].checked = false;
	}
	// update the checkboxes according to IDs list passed in
	// splits the comma seprated list to put in the array
	var curID_Array = object.REQSASSIGNEDLIST.split(',');
	for (var x=0; x<curID_Array.length; x++) 
	{	
		var myID = "midReqID" + curID_Array[x].toString();
		document.getElementById(myID).checked = "true"
	}	
}

//<
//  FUNCTION Name: setMissionRecordInfo(missionObject)
//    Description: Populates ID containers
//     Parameters: Return Object from AJAX Call
//        Returns: Modifications to respective ID containers
//  Relationships: called by getMissionRecordInfo()
//       Comments:
//>
function setMissionRecordInfo(missionObject)
{
	DWRUtil.setValue("recordID", missionObject.MISSIONRECID);
	DWRUtil.setValue("missionID", missionObject.MISSIONID);
	DWRUtil.setValue("missionName", missionObject.MISSIONNAME);
	DWRUtil.setValue("launchType", missionObject.LAUNCHTYPE);
	DWRUtil.setValue("rangeType", missionObject.RANGETYPE);
	
	if(missionObject.MISSIONDATE != missionObject.MISSIONDATEEND)
	{
		DWRUtil.setValue("missionDate", missionObject.MISSIONDATE + ' - ' + missionObject.MISSIONDATEEND);
		isWindow = 1;
	}else{
		DWRUtil.setValue("missionDate", missionObject.MISSIONDATE);
		isWindow = 0;
	}
	//DWRUtil.setValue("missionDateEnd", missionObject.MISSIONDATEEnd);
	DWRUtil.setValue("missionObjective", missionObject.MISSIONOBJECTIVE);
	DWRUtil.setValue("missionDescription", missionObject.MISSIONDESCRIPTION);
	DWRUtil.setValue("missionUsername", missionObject.MISSIONUSERNAME);
	DWRUtil.setValue("missionCreated", missionObject.MISSIONCREATED);
	DWRUtil.setValue("missionUpdated", missionObject.MISSIONUPDATED);
	DWRUtil.setValue("missionElements", missionObject.MISSIONELEMENTS);
	DWRUtil.setValue("missionTargetName", missionObject.MISSIONTARGETNAME);
	DWRUtil.setValue("missionInterceptorName", missionObject.MISSIONINTERCEPTORNAME);
	DWRUtil.setValue("missionUpRangeName", missionObject.MISSIONUPRANGENAME);
	DWRUtil.setValue("missionDownRangeName", missionObject.MISSIONDOWNRANGENAME);
	DWRUtil.setValue("missionUpRangeLead", missionObject.UPRANGELEADDESIGNATOR);
	DWRUtil.setValue("missionDownRangeLead", missionObject.DOWNRANGELEADDESIGNATOR);
	DWRUtil.setValue("missionMidRangeName", missionObject.MISSIONMIDRANGENAME);		
	
	
	if(missionObject.INREVIEW == 1)
	{
		document.getElementById('missionDate').innerHTML += ' (In Review)';
	}
	//check to see if there are any lessons learned posted about the mission
	if(missionObject.B_LESSONSLEARNED == 1)
	{
		
		document.getElementById("td_lessonsLearned").innerHTML = missionObject.TD_LESSONSLEARNED;
	}else{
		
		document.getElementById("td_lessonsLearned").innerHTML = '';
	}
	
	
	//if deleted, turn off print display
	if(missionObject.DELETEDFLAG == 1)
	{
		document.getElementById('tr_print').style.display = 'none';
	}else{
		document.getElementById('tr_print').style.display = '';
	}

	// delete values
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msndel,msnundel,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWRUtil.setValue("deleteID", missionObject.MISSIONRECID);
		DWRUtil.setValue("deleteItemName", missionObject.MISSIONID);
		DWRUtil.setValue("deleteItem", missionObject.MISSIONID);
		// delete values
		DWRUtil.setValue("deleteID", missionObject.MISSIONRECID);
		DWRUtil.setValue("deleteItemName", missionObject.MISSIONID);
		DWRUtil.setValue("deleteItem", missionObject.MISSIONID);
		DWRUtil.setValue("origDeleteComments", missionObject.DELETECOMMENTS);
		DWRUtil.setValue("origUndeleteComments", missionObject.UNDELETECOMMENTS);
		
		if (missionObject.DELETEDFLAG == 1)  // already deleted
			{
				DWRUtil.setValue("deletebutton", "UNDELETE");
				DWRUtil.setValue("rationaleType", "Undelete");
				DWRUtil.setValue("delType", "Undelete");
			}
		else
			{
				DWRUtil.setValue("deletebutton", "DELETE");
				DWRUtil.setValue("rationaleType", "Delete");
				DWRUtil.setValue("delType", "Delete");
			}
			
	</cfif>
<!---  FIX: NEW LOCATION for code test
				so we can be sensitive to turning Range TABS on/off based on RANGETYPE  --->
	// populate Assign Requirement forms
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msnasgnreq,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilegeAssignREQ" >
	<!--- check to see if access is granted --->
	<cfif NOT variables.userHasPrivilegeAssignREQ>
		<!--- don't do anything --->
	<cfelse>
		// turn on Downrange and Midrange tabs
		
		// get UPRANGE requirements assigned to the Mission
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssignedSelectList', missionObject.MISSIONRECID, 'target', setUPreqsAssignedSelectList);
		// get DOWNRANGE requirements assigned to the Mission
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssignedSelectList', missionObject.MISSIONRECID, 'interceptor', setDOWNreqsAssignedSelectList);
		// get MIDRANGE requirements assigned to the Mission
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssignedSelectList', missionObject.MISSIONRECID, 'other', setMIDreqsAssignedSelectList);
		
		// turn on DOWN and MID range displays
		
		document.getElementById("zzDown").style.visibility="visible";
		document.getElementById("zzMid").style.visibility="visible";

	</cfif>
		
	// NULL out TLOG info... it is old data and needs to be retrieved to be current
	// TLOG is only populate "on demand" so we don't have to suffer more of a time delay
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msntlog,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWRUtil.setValue("missionTLOGinfo", "");
	</cfif>
	
}

//<
//  FUNCTION Name: getReqsAssigned(id)
//    Description: make AJAX call to get Requirements information (not currently being used)
//     Parameters: id - record id passed in
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>
function getReqsAssigned(id)
{
	var recordID = id;
	if(document.getElementById('myAssignedRequirementsTable'))
	{
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssigned', recordID, setReqsAssigned);
	}
}

//<
//  FUNCTION Name: getReqsAssigned(reqAssignedObject)
//    Description: populated the values of the associated DIVs with the returned information from the database call
//     Parameters: reqAssignedObject - Return Object from AJAX Call
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>	
function setReqsAssigned(reqAssignedObject)
{
	DWRUtil.setValue("myAssignedRequirementsTable", reqAssignedObject.MYASSIGNEDREQUIREMENTSTABLE);
}

	
//<
//  FUNCTION Name: setMissionEditForm(formObject)
//    Description: populated the values of the associated DIVs with the returned information from the database call
//					and client-side validation with qForms
//     Parameters: formObject - Return Object from AJAX Call
//        Returns: 
//  Relationships: CALLS:disableDownAndMid()
//       Comments: CFAJAX and qForms
//>
function setMissionEditForm(formObject)
{
	DWRUtil.setValue("missionEditForm", formObject.MISSIONEDITFORM);
	// alert("R:" + formObject.THEURL);
	if (document.forms.missionDefForm.singleRange[1].checked) // Single
	{
		disableDownAndMid();
	}
	// initialize the qForm object
	objForm = new qForm("missionDefForm");
	
	// make these fields more descriptive
	objForm.missionID.description = "Mission ID";
	objForm.missionDateEdit.description = "Mission Date";
	objForm.missionDescription.description = "Description";
	
	objForm.missionDateEdit.validateDate();
 
	// make these fields required
	objForm.required("missionID, missionDateEdit, missionDescription");
}



function getMissionAssignRequest(formObject)
{
	DWRUtil.setValue("missionAssignRequestForm", formObject.ASSIGNREQUEST);		
}


function setMissionLessonLearnedRequest(formObject)
{
	//document.getElementById('missionLessonLearnedForm').style.display = 'inline';
	DWRUtil.setValue("missionLessonLearnedForm", formObject.LESSONLEARNEDREQUEST);		
}


function setMissionLessonLearnedAction(formObject)//missionLessonLearnedActionForm
{
	//DWRUtil.setValue("lessonLearnedActionID", formObject.LESSONLEARNEDACTION);	
//alert('setMissionLessonLearnedAction');
	document.getElementById("lessonLearnedActionDiv").innerHTML = formObject.LESSONLEARNEDACTION;
	
}


function setPreMissionWorksheet(formObject)
{
	DWRUtil.setValue("missionPreMissionForm", formObject.REQMISSIONWORKSHEET);		
}

function setTCSWorksheet(missionObject)
{
	DWRUtil.setValue("missionTCSForm", missionObject.MISSIONTCSFORM);		
	
	// delete values
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msndel,msnundel,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWRUtil.setValue("deleteID", missionObject.MISSIONRECID);
		DWRUtil.setValue("deleteItemName", missionObject.MISSIONID);
		DWRUtil.setValue("deleteItem", missionObject.MISSIONID);
		// delete values
		DWRUtil.setValue("deleteID", missionObject.MISSIONRECID);
		DWRUtil.setValue("deleteItemName", missionObject.MISSIONID);
		DWRUtil.setValue("deleteItem", missionObject.MISSIONID);
		DWRUtil.setValue("origDeleteComments", missionObject.DELETECOMMENTS);
		DWRUtil.setValue("origUndeleteComments", missionObject.UNDELETECOMMENTS);
		
		if (missionObject.DELETEDFLAG == 1)  // already deleted
			{
				DWRUtil.setValue("deletebutton", "UNDELETE");
				DWRUtil.setValue("rationaleType", "Undelete");
				DWRUtil.setValue("delType", "Undelete");
			}
		else
			{
				DWRUtil.setValue("deletebutton", "DELETE");
				DWRUtil.setValue("rationaleType", "Delete");
				DWRUtil.setValue("delType", "Delete");
			}
			
	</cfif>
<!---  FIX: NEW LOCATION for code test
				so we can be sensitive to turning Range TABS on/off based on RANGETYPE  --->
	// populate Assign Requirement forms
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msnasgnreq,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilegeAssignREQ" >
	<!--- check to see if access is granted --->
	<cfif NOT variables.userHasPrivilegeAssignREQ>
		<!--- don't do anything --->
	<cfelse>
		// turn on Downrange and Midrange tabs
		
		// get UPRANGE requirements assigned to the Mission
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssignedSelectList', missionObject.MISSIONRECID, 'target', setUPreqsAssignedSelectList);
		// get DOWNRANGE requirements assigned to the Mission
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssignedSelectList', missionObject.MISSIONRECID, 'interceptor', setDOWNreqsAssignedSelectList);
		// get MIDRANGE requirements assigned to the Mission
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssignedSelectList', missionObject.MISSIONRECID, 'other', setMIDreqsAssignedSelectList);
		
		// turn on DOWN and MID range displays
		
		document.getElementById("zzDown").style.visibility="visible";
		document.getElementById("zzMid").style.visibility="visible";

	</cfif>
		
	// NULL out TLOG info... it is old data and needs to be retrieved to be current
	// TLOG is only populate "on demand" so we don't have to suffer more of a time delay
	<cfmodule template="#application.taglibrary#tag_checkprivileges.cfm" 
		requiredprivileges = "msntlog,su"
		errmessage = "variables.errmsg"
		returnitem = "variables.userHasPrivilege" >
	<!--- check to see if access is granted --->
	<cfif NOT userHasPrivilege>
		<!--- don't do anything --->
	<cfelse>
		DWRUtil.setValue("missionTLOGinfo", "");
	</cfif>
}

function setAssetPreMissionWorksheet(formObject)
{
	DWRUtil.setValue("missionAssetPreMissionForm", formObject.REQASSETMISSIONWORKSHEET);		
}

function setBoxscoreWorksheet(formObject)
{
	DWRUtil.setValue("mBoxscoreForm", formObject.REQBOXSCOREWORKSHEET);		
}

//<
//  FUNCTION Name: getUprangeReqs(id)
//    Description: make AJAX call to get Requirements information (not currently being used)
//     Parameters: id - record id passed in
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>
function getUprangeReqs(id)
{
	var recordID = id;
	DWREngine._execute(_cfscriptLocation, null, 'getUprangeReqs', recordID, setUprangeReqs);
}


//<
//  FUNCTION Name: updReqsAssigned(origList, newList)
//    Description: make AJAX call to update Requirements mappings to specific Mission
//     Parameters: origList - list containing the original/unassigned requirements
//				   newList - list containing the new/assigned requirements	
//        Returns: object to dummy() - which does nothing
//  Relationships: 
//       Comments: CFAJAX
//>	
function updReqsAssigned(origList, newList)
{
	var recordID = document.getElementById('recordID').innerHTML;
	DWREngine._execute(_cfscriptLocation, null, 'updReqsAssigned', recordID, origList, newList, dummy);
}

// this does nothing
function dummy()
{
	var dummy = true;
}

//<
//  FUNCTION Name: refreshReqsAssigned()
//    Description: make AJAX call to update Requirements mappings to specific Mission
//     Parameters: 	
//        Returns: return object to setReqsAssigned() 
//  Relationships: 
//       Comments: CFAJAX
//>	
function refreshReqsAssigned()
{
	var recordID = document.getElementById('recordID').innerHTML;
	if(document.getElementById('myAssignedRequirementsTable'))
	{
		DWREngine._execute(_cfscriptLocation, null, 'getReqsAssigned', recordID, setReqsAssigned);
	}
}

//<
//  FUNCTION Name: toggleTLOGdetails(id)
//    Description: toggles t-log details display on and off and sets style accordingly
//     Parameters: id - tlog id
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function toggleTLOGdetails(id)
{
	var idName = "tlogDetails" + id;
	var idNameTop1 = "tlogDetailsTop1" + id;
	var idNameTop2 = "tlogDetailsTop2" + id;
	var idNameTop3 = "tlogDetailsTop3" + id;
	var idNameTop4 = "tlogDetailsTop4" + id;
	var idNameTop5 = "tlogDetailsTop5" + id;
	if (document.getElementById(idName).style.display=="none")
	{
		document.getElementById(idName).style.display="block";
		document.getElementById(idNameTop1).style.backgroundColor="#dddddd";
		document.getElementById(idNameTop2).style.backgroundColor="#dddddd";
		document.getElementById(idNameTop3).style.backgroundColor="#dddddd";
		document.getElementById(idNameTop4).style.backgroundColor="#dddddd";
		document.getElementById(idNameTop5).style.backgroundColor="#dddddd";
		document.getElementById(idNameTop1).style.borderTop="solid black 1px";
		document.getElementById(idNameTop2).style.borderTop="solid black 1px";
		document.getElementById(idNameTop3).style.borderTop="solid black 1px";
		document.getElementById(idNameTop4).style.borderTop="solid black 1px";
		document.getElementById(idNameTop5).style.borderTop="solid black 1px";
		document.getElementById(idNameTop1).style.borderLeft="solid black 1px";
		document.getElementById(idNameTop5).style.borderRight="solid black 1px";
	}
	else
	{
		document.getElementById(idName).style.display="none";
		document.getElementById(idNameTop1).style.backgroundColor="thistle";
		document.getElementById(idNameTop2).style.backgroundColor="thistle";
		document.getElementById(idNameTop3).style.backgroundColor="thistle";
		document.getElementById(idNameTop4).style.backgroundColor="thistle";
		document.getElementById(idNameTop5).style.backgroundColor="thistle";
		document.getElementById(idNameTop1).style.borderTop="none";
		document.getElementById(idNameTop2).style.borderTop="none";
		document.getElementById(idNameTop3).style.borderTop="none";
		document.getElementById(idNameTop4).style.borderTop="none";
		document.getElementById(idNameTop5).style.borderTop="none";
		document.getElementById(idNameTop1).style.borderLeft="none";
		document.getElementById(idNameTop5).style.borderRight="none";
	}
}

//<
//  FUNCTION Name: toggleREQdetails(id)
//    Description: make AJAX call to update requirement details and toggle display
//     Parameters: 	
//        Returns: return object to setRequirementDetails() 
//  Relationships: 
//       Comments: CFAJAX
//>		
function toggleREQdetails(id)
{
	var idName = "msnReqDetails" + id;
	if (document.getElementById(idName).style.display=="none")
	{
		DWREngine._execute(_cfscriptLocation, null, 'getRequirementDetails', id, idName, setRequirementDetails);
		document.getElementById(idName).style.display="block";
	}
	else
	{
		document.getElementById(idName).style.display="none";
	}
}

//<
//  FUNCTION Name: toggleASSIGNREQdetails(id)
//    Description: make AJAX call to update assigned requirement details and toggle display
//     Parameters: 	
//        Returns: return object to setAssignReqDetails() 
//  Relationships: 
//       Comments: CFAJAX
//>		
function toggleASSIGNREQdetails(id)
{
	var idName = "msnAssignReqDetails" + id;
	if (document.getElementById(idName).style.display=="none")
	{
		DWREngine._execute(_cfscriptLocation, null, 'getAssignReqDetails', id, idName, setAssignReqDetails);
		document.getElementById(idName).style.display="block";
	}
	else
	{
		document.getElementById(idName).style.display="none";
	}
}
	
//<
//  FUNCTION Name: setRequirementDetails(reqObject)
//    Description: populated the values of the associated DIVs with the returned information from the database call
//     Parameters: reqObject - Return Object from AJAX Call
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>	
function setRequirementDetails(reqObject)
{
	DWRUtil.setValue(reqObject.IDNAME, reqObject.REQDETAILS);
}
	
//<
//  FUNCTION Name: setAssignReqDetails(reqAssignObj)
//    Description: populated the values of the associated DIVs with the returned information from the database call
//     Parameters: reqAssignObj - Return Object from AJAX Call
//        Returns: 
//  Relationships: 
//       Comments: CFAJAX
//>		
function setAssignReqDetails(reqAssignObj)
{
	DWRUtil.setValue(reqAssignObj.REQASSIGNIDNAME, reqAssignObj.REQASSIGNDETAILS );

}

//<
//  FUNCTION Name: toggleTLOGdetails(id)
//    Description: initialization routine for CFAJAX (executed on page load)
//     Parameters: id - tlog id
//        Returns: 
//  Relationships: 
//       Comments: 	
//>		)
function init()
{
	DWREngine._errorHandler =  errorHandler;
}
//---------------:-----------------------------------------------------------------------
//<
//            END: CFAJAX based functions
//>
//---------------:-----------------------------------------------------------------------

//---------------:-----------------------------------------------------------------------
//<
//          START: RICO based functions 
//>
//---------------:-----------------------------------------------------------------------
var startTop, startLeft;
var effectDone = false;
//<
//  FUNCTION Name: toggleEffect()
//    Description: controls the display (on/off) of Search Menu
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function toggleEffect() 
{
	if ( !effectDone ) 
	{
		startEffect();
		effectDone = true;
	}
	else 
	{
		resetEffect();
		effectDone = false;
	}
}

//<
//  FUNCTION Name: startEffect()
//    Description: specfic details for Search Menu (name, position, iFrame characteristics)
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function startEffect() 
{
	startTop   = $('searchFilter2').offsetTop;
	startLeft  = $('searchFilter2').offsetLeft;
	new Rico.Effect.Position( 'searchFilter2', 300, 220, 500, 20, '' );
	var DivRef = document.getElementById('searchFilter');
	var IfrRef = document.getElementById('filterIframe');
	// iFrame specifics (used to block SELECT bleed-through)
	IfrRef.style.width = DivRef.offsetWidth;
	IfrRef.style.height = DivRef.offsetHeight;
	IfrRef.style.top = DivRef.style.top;
	IfrRef.style.left = DivRef.style.left;
	IfrRef.style.zIndex = 45;
	IfrRef.style.display = "block";
}

//<
//  FUNCTION Name: resetEffect()
//    Description: resets Search Menu to original location when dismissed/closed
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function resetEffect()
{
	$('searchFilter2').style.top   = startTop;
	$('searchFilter2').style.left  = startLeft;
}

//<
//  FUNCTION Name: displayFilter()

//    Description: display the Search Filter
//     Parameters: 
//        Returns: 
//  Relationships: CALLS: clearActionMsg(), toggleEffect()
//       Comments: 	
//>	
function displayFilter()
{
	clearActionMsg();  // make sure record Action messages are cleared
	toggleEffect();
}
//---------------:-----------------------------------------------------------------------
//<
//            END: RICO based functions 
//>
//---------------:-----------------------------------------------------------------------

//<
//  These functions support Mission Edit Capability
//>

//<
//  FUNCTION Name: enableDownAndMid()
//    Description: enables range fields
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 
//>
function enableDownAndMid()
{
	document.getElementById("downRangeID_fkSelect").disabled = false;
	document.getElementById("midRangeID_fkSelect").disabled = false;
	document.getElementById("myDownLeadradio").style.display = "";
}

//<
//  FUNCTION Name: disableDownAndMid()
//    Description: disables range fields
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 
//>
function disableDownAndMid()
{
	document.getElementById("downRangeID_fkSelect").disabled = true;
	document.getElementById("midRangeID_fkSelect").disabled = true;
	document.getElementById("myDownLeadradio").style.display = "none";
	document.getElementById("frmUpLeadRadio").checked = "false";
	
}

//<
//  FUNCTION Name: cal_Selected(cal, date)
//    Description: Item Selected Callendar Callback
//     Parameters: cal - calendar object
//				   date - date value
//        Returns: 
//  Relationships: 
//       Comments: 
//>
function cal_Selected(cal, date)
{
	cal.sel.value = date;
	if (cal.dateClicked)
	{
		cal.callCloseHandler();
		if(document.getElementById('duedateInput_'+globalID).value != document.getElementById('oldDuedateInput'+globalID).value)
		{
			if(document.getElementById('oldDispositionCurrentInput'+globalID).value == 1)
			{
				document.getElementById('lessonLearnedEdit'+globalID).value = 1;
			}
			else
			{
				document.getElementById('lessonLearnedEdit'+globalID).value = 2;
			}
			
			formChanged=1;
		}
		else
		{
			document.getElementById('lessonLearnedEdit'+globalID).value = document.getElementById('lessonLearnedEdit'+globalID).value;
		}
	}
		
}

//<
//  FUNCTION Name: cal_Close(cal)
//    Description: Close Calendar Callback
//     Parameters: cal - calendar object
//        Returns: 
//  Relationships: 
//       Comments: 
//>
function cal_Close(cal)
{
	cal.hide();
}

//<
//  FUNCTION Name: showCalendar(txtId, imgId)
//    Description: Show Calendar (uses JS Calendar)
//     Parameters: txtId - calendar text
//				   imgId - calendar image
//        Returns: true/false
//  Relationships: 
//       Comments: uses properties and methods of calendar object (cal)
//>
function showCalendar(txtId, imgId)
{
	var txt = document.getElementById(txtId);
	var img = document.getElementById(imgId);
	if (_dynarch_popupCalendar != null)
	{
		_dynarch_popupCalendar.hide();
	}
	else
	{
		var cal = new Calendar(0, null, cal_Selected(id), cal_Close, id);

		cal.weekNumbers = false;
		cal.showsOtherMonths = true;
		cal.setRange(1900, 2070);
		cal.setDateFormat("%m/%d/%Y");
		cal.create();
		_dynarch_popupCalendar = cal;
	}
	_dynarch_popupCalendar.parseDate(txt.value);
	_dynarch_popupCalendar.sel = txt;
	_dynarch_popupCalendar.showAtElement(img, "Br");

	return false;
}

var globalID = 0;
function showCalendar2(txtId, imgId, theForm, id)
{
	globalID = id;
	var txt = document.getElementById(txtId);
	var img = document.getElementById(imgId);
	if (_dynarch_popupCalendar != null)
	{
		_dynarch_popupCalendar.hide();
		
	}
	else
	{
		var cal = new Calendar(0, null, cal_Selected, cal_Close);
		var tempID =  id;

		cal.weekNumbers = false;
		cal.showsOtherMonths = true;
		cal.setRange(1900, 2070);
		cal.setDateFormat("%d-%b-%y");
		cal.create();
		_dynarch_popupCalendar = cal;
		
	}
	_dynarch_popupCalendar.parseDate(txt.value);
	_dynarch_popupCalendar.sel = txt;
	_dynarch_popupCalendar.showAtElement(img, "Br");

	//alert(cal.sel.value);
	
	
	return false;
}

var mywinPDF = null;	
//<
//  FUNCTION Name: printMissionTestSchedulePDF(startYear, queryString)
//    Description: opens pdf window for Mission Test Schedule report
//     Parameters: queryString - string passed in for report criteria
//				   startYear - year to start at passed in for report criteria
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printMissionTestSchedulePDF(queryString)
{
	if(mywinPDF && !mywinPDF.closed)
	{
		//if the conflict report has already been ran, close it before re-running it
		if(mywinPDF.name == "DeconflictionTextReport")
		{
			mywinPDF.close();
		}
	}
	var reportName = document.forms.hiddenStuff.testScheduleReportSelection[document.getElementById("testScheduleReportSelection").selectedIndex].value;
	var ar_report = reportName.split("_");
	var mywinPDF2 = null;
	var urlstring = "mpl_reportMissionTestSchedule_pdf.cfm?" + queryString + "&startYear=" + ar_report[1];
	
	mywinPDF2 = window.open(urlstring,"MissionTestSchedulePDF","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(!mywinPDF2)
	{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}


//<
//  FUNCTION Name: printSummaryReports(startDate, endDate, type, url)
//    Description: opens window for the summary reports that are triggered from the bottom, LHS forms
//     Parameters: startDate - start date for the summary
//				   endDate - end date for the summary
//				   type - the type of report (Deconfliction, Conflict, Boxscore)
//				   url - url for the target report
//        Returns: 
//  Relationships: 
//       Comments: 	
//>

function printSummaryReports(startDate, endDate, type, url)
{	
	/*Re initial all Deconfliction Report Cookies*/
	createCookie('fontSizeCookie', 12, 1 );			<!---To Keep track the current font size: default size 12px--->
	//createCookie('allHeightCookie', 30, 1 );
	createCookie('fontStyleCookie', 'bold', 1 );	<!---Bold or Normal--->
	createCookie('hideNonMDAMissionCookie', '', 1 );<!---To keep track what non MDA missions users want to hide--->
	createCookie('expandRowHeightCookie', '', 1 );	<!---To Keep Track the height of each row--->
	createCookie('expandRowAssetCookie', '', 1 );	<!---To Keep Track what asset that its height is stored in expandRowAssetCookie--->
	createCookie('allRowHeightCookie', '', 1 );		<!---Power Point: Keep Track the eight of each row when print to PPT format--->
	createCookie('allRowAssetCookie', '', 1 );		<!---Power Point: no longer use--->
	//createCookie('hideEventsCookie', '', 1 );
	createCookie('rowHeightCookie', '', 1 );		<!---Keep Track --->
	
	
	if(mywinPDF && !mywinPDF.closed)
	{
		//if the conflict report has already been ran, close it before re-running it
		if(mywinPDF.name == type)
		{
			mywinPDF.close();
		}
	}
	//var urlstring = "mpl_reportBoxscoreSummary.cfm?startDate=" + startDate + "&endDate=" + endDate;
	if(url == 'tst_findConflicts.cfm?conflictReport=1&fromDecon=0&filteredOut=')
	{
		var urlstring = url + "&startDate=" + startDate + "&endDate=" + endDate;
	}else{
		var urlstring = url + "?startDate=" + startDate + "&endDate=" + endDate;
	}
	
	mywinPDF = window.open(urlstring,type,"width=1500,height=1500,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}		

}

//<
//  FUNCTION Name: printTRMReport(missionID, assetGroup)
//    Description: opens window for the TRM Input Sheet report
//     Parameters: missionID - ID of the mission requested
//				   assetGroup - whether the report is for FT assets or Operational Assets
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printTRMReport(missionID, assetGroup)
{
	var urlstring = "mpl_reportTRMSheet_pdf.cfm?printit=1&missionID=" + missionID + "&assetGroup=" + assetGroup;
	
	mywinPDF = window.open(urlstring,"TRMReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printTRMReport_ppt(missionID, assetGroup)
//    Description: opens window for the TRM Input Sheet report
//     Parameters: missionID - ID of the mission requested
//				   assetGroup - whether the report is for FT assets or Operational Assets
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printTRMReport_ppt(missionID, assetGroup)
{
	var urlstring = "mpl_reportTRMSheet_ppt.cfm?printit=1&missionID=" + missionID + "&assetGroup=" + assetGroup;
	
	mywinPDF = window.open(urlstring,"TRMReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printATTRMReport(missionID, assetGroup)
//    Description: opens window for the TRM Input Sheet report
//     Parameters: missionID - ID of the mission requested
//				   assetGroup - whether the report is for FT assets or Operational Assets
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printATTRMReport(missionID, assetGroup)
{
	var urlstring = "mpl_reportATTRMSheet_pdf.cfm?printit=1&ID=" + missionID + "&assetGroup=" + assetGroup;
	
	mywinPDF = window.open(urlstring,"TRMReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printATTRMReport_ppt(missionID, assetGroup)
//    Description: opens window for the TRM Input Sheet report
//     Parameters: missionID - ID of the mission requested
//				   assetGroup - whether the report is for FT assets or Operational Assets
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printATTRMReport_ppt(missionID, assetGroup)
{
	var urlstring = "mpl_reportATTRMSheet_ppt.cfm?printit=1&ID=" + missionID + "&assetGroup=" + assetGroup;
	
	mywinPDF = window.open(urlstring,"TRMReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printPMReport(missionID)
//    Description: opens window for the Pre-Mission Events report
//     Parameters: missionID - ID of the mission requested
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printPMReport(missionID)
{
	var urlstring = "mpl_reportPMWksht.cfm?printit=1&missionID=" + missionID;
	
	mywinPDF = window.open(urlstring,"PMReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{

		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printPMReport_ppt(missionID)
//    Description: opens window for the Pre-Mission Events report
//     Parameters: missionID - ID of the mission requested
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printPMReport_ppt(missionID)
{
	var urlstring = "mpl_reportPMWksht_ppt.cfm?missionID=" + missionID;
	
	mywinPDF = window.open(urlstring,"PMReport_ppt","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printPMAssetReport(missionID, assetGroup)
//    Description: opens window for the Pre-Mission Events/Asset Assignment report
//     Parameters: missionID - ID of the mission requested
//				   assetGroup - whether to print SUT or FT assets
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	

function printPMAssetReport(missionID, assetGroup)
{
	var urlstring = "mpl_reportPMAssetWksht.cfm?printit=1&recordID=" + missionID + "&assetGroup=" + assetGroup;
	
	mywinPDF = window.open(urlstring,"PMAssetReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printPMAssetReport_ppt(missionID)
//    Description: opens window for the Pre-Mission Events/Asset Assignment report
//     Parameters: missionID - ID of the mission requested
//				   num _events - number of pre-mission events the report contains (for formatting purposes)
//				   num_assets - number of assets assigned to the mission (for formatting purposes)
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printPMAssetReport_ppt(missionID, num_events, num_assets, assetGroup)
{
	var urlstring = "mpl_reportPMAssetWksht_ppt.cfm?num_events=" + num_events+ "&num_assets=" + num_assets + "&printit=1&recordID=" + missionID + "&assetGroup=" + assetGroup;
	
	mywinPDF = window.open(urlstring,"PMAssetReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker

	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: printMissionRequirementsReport(missionID)
//    Description: opens window for the Pre-Mission Events/Asset Assignment report
//     Parameters: missionID - ID of the mission requested
//        Returns: 
//  Relationships: 
//       Comments: 	
//>	
function printMissionRequirementsReport(missionID)
{
	var urlstring = "mpl_reportRequirements.cfm?printit=1&ID=" + missionID;
	
	mywinPDF = window.open(urlstring,"ReqsReport","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
}

//<
//  FUNCTION Name: performMissionEditValidation()
//    Description: client-side validation via qForms
//     Parameters: 
//        Returns: validation OK - submit / validation NOT ok - alert message
//  Relationships: 
//       Comments: 	qForms
//>		
var isWindow = 0;
function performMissionEditValidation()	
{	
	var missionValidationOK = true;
	var msgValidateNotOK = 'The following error(s) occured:';	
	
	
	//In Window: the End Date must be AFTER Start Date.  Implemented by HP on March 14th, 2012	
	if(document.forms('missionDefForm').elements('convertingToWindow').value == 1)
	{
		var startDate = document.forms('missionDefForm').elements('missionDateEdit').value;
		startDate = startDate.split('-')[1] + " " + startDate.split('-')[0] + ", 20" + startDate.split('-')[2];
	
		var endDate = document.forms('missionDefForm').elements('missionDateEndEdit').value;
		endDate = endDate.split('-')[1] + " " + endDate.split('-')[0] + ", 20" + endDate.split('-')[2];
		
		if(Date.parse(endDate) < Date.parse(startDate))
		{
			alert('The End Date cannot be AFTER Start Date.');
			document.forms('missionDefForm').elements('missionDateEndEdit').style.backgroundColor = qFormAPI.errorColor;
			return false;
		}		
	}
	
	/*
	if((document.forms('missionDefForm').elements('ATCName').value.length < 1) && (document.forms('missionDefForm').elements('ATCdoc').value.length > 1))
	{
		alert("The ATC Filename cannot be left blank");
		document.forms('missionDefForm').elements('ATCName').style.backgroundColor = qFormAPI.errorColor;
		return false;	
	}else if((document.forms('missionDefForm').elements('ATCName').value.length > 1) && (document.forms('missionDefForm').elements('ATCdoc').value.length < 1)){
		alert("You must uplaod an ATC File");
		document.forms('missionDefForm').elements('ATCdoc').style.backgroundColor = qFormAPI.errorColor;
		return false;
	}
	*/
	
	//alert(document.forms('missionDefForm').missionDateEndEdit.currentStyle.display);
	if((document.getElementById('editEndLabel').style.display != 'none') && (document.forms('missionDefForm').missionDateEdit.value != document.forms('missionDefForm').missionDateEndEdit.value))
	{
		isWindow = 1;
	}else{
		isWindow = 0;
	}
		
	//check validation 
	if(document.forms('missionDefForm').elements('missionDateEdit').value.split('-').length != 3)
	{
		alert("The Mission Date is not a valid date in the format \'DD-MMM-YY\' (ex: \'01-JAN-08\')");
		document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = qFormAPI.errorColor;
		return false;
	}else if(isWindow && document.forms('missionDefForm').elements('missionDateEndEdit').value.split('-').length != 3){
		alert("The Mission End Date is not a valid date in the format \'DD-MMM-YY\' (ex: \'01-JAN-08\')");
		document.forms('missionDefForm').elements('missionDateEndEdit').style.backgroundColor = qFormAPI.errorColor;
		return false;
	}
	
	
	if(document.forms['missionDefForm'].missionDateEdit.value.length)
	{
	  if(document.forms['missionDefForm'].missionDateEdit.value != document.forms['missionDefForm'].missionDateEdit_orig.value)
	  {
		  //check to make sure the date isn't more than 2 months in the past
		  convertDate(document.forms['missionDefForm'].missionDateEdit.value);
		  var missionDate = convertDate(document.forms['missionDefForm'].missionDateEdit.value);
		  var today = convertDate('<cfoutput>#dateFormat(now())#</cfoutput>');
		  var twoMonthsAgo = new Date();
		  twoMonthsAgo.setMonth(today.getMonth()-2);
		  twoMonthsAgo.setDate(1);
		  //ignore the time aspect - just interested in the dates
		  twoMonthsAgo.setHours(0,0,0,0);
		  missionDate.setHours(0,0,0,0);

		  if(missionDate < twoMonthsAgo)
		  {
			msgValidateNotOK = msgValidateNotOK + "\n\r -Cannot set the Mission Date more than 2 months in the past";
			missionValidationOK = false;
		  }
	  }
	  
	  if(!validate_date(document.forms['missionDefForm'].missionDateEdit.value))
	  { 
		   msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission Date is not a date";
		   missionValidationOK = false;
		   document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = qFormAPI.errorColor;
	  }
	  else
	  {		
		   document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = 'white';
	  }
	  if(!isWindow){
		document.forms('missionDefForm').elements('missionDateEndEdit').value = document.forms('missionDefForm').elements('missionDateEdit').value;
	  }else{
	
		if (!validate_date(document.forms('missionDefForm').elements('missionDateEndEdit').value))
		  { 
			   msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission End Date is not a date";
			   missionValidationOK = false;
			   document.forms('missionDefForm').elements('missionDateEndEdit').style.backgroundColor = qFormAPI.errorColor;
		  }
		  else
		  {		
			   document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = 'white';
		  }
		//make sure the end date is later than the begin date
		//check year  
		if(document.forms('missionDefForm').elements('missionDateEdit').value.split('-')[2] < document.forms('missionDefForm').elements('missionDateEndEdit').value.split('-')[2])
		{
			dateGood = 1;
		}else if(document.forms('missionDefForm').elements('missionDateEdit').value.split('-')[2] > document.forms('missionDefForm').elements('missionDateEndEdit').value.split('-')[2]){
			msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission Start Date must be before the Mission End Date";
			document.forms('missionDefForm').elements('missionDateEndEdit').style.backgroundColor = qFormAPI.errorColor;
			//document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = qFormAPI.errorColor;
			missionValidationOK = false;
		}else{
			//years are equal - check months
			if(calcMonth(document.forms('missionDefForm').elements('missionDateEdit').value.split('-')[1]) < calcMonth(document.forms('missionDefForm').elements('missionDateEndEdit').value.split('-')[1]))
			{
				dateGood = 1;
			}else if(calcMonth(document.forms('missionDefForm').elements('missionDateEdit').value.split('-')[1]) > calcMonth(document.forms('missionDefForm').elements('missionDateEndEdit').value.split('-')[1]))
			{
				msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission Start Date must be before the Mission End Date";
				document.forms('missionDefForm').elements('missionDateEndEdit').style.backgroundColor = qFormAPI.errorColor;
				//document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = qFormAPI.errorColor;
				missionValidationOK = false;
			}else{
				//month and year are the same - check date
				if(parseInt(document.forms('missionDefForm').elements('missionDateEdit').value.split('-')[0]) <= parseInt(document.forms('missionDefForm').elements('missionDateEndEdit').value.split('-')[0]))
				{
					dateGood = 1;
				}else{
					msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission Start Date must be before the Mission End Date";
					document.forms('missionDefForm').elements('missionDateEndEdit').style.backgroundColor = qFormAPI.errorColor;
					//document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = qFormAPI.errorColor;
					missionValidationOK = false;
				}
			}
		}		  
		  
	  }
		 
	  } 
	  else
	
	  {
			msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission Date field is required";
			missionValidationOK = false;
			document.forms('missionDefForm').elements('missionDateEdit').style.backgroundColor = qFormAPI.errorColor;
	  }
									  
	if  (!(document.forms['missionDefForm'].missionID.value.length))
	{ 
		document.forms('missionDefForm').elements('missionID').style.backgroundColor = qFormAPI.errorColor;
		msgValidateNotOK = msgValidateNotOK + "\n\r -The Mission ID field is required";
		missionValidationOK = false; 
	}
	else
	{
		document.forms('missionDefForm').elements('missionID').style.backgroundColor = "white";
	}
		
	if (missionValidationOK == true) 
	{ 
		//all validation succeeded, let's save it to the database
		var missionElements = '';
		formChanged = false;
	
		return true;
		
	}
	else
	{
		alert(msgValidateNotOK);
		return false;
	}	
}

//<
//  FUNCTION Name: getIDFromDropDown(form, field)
//    Description: takes drop-down list as input, returns the value of the currently-selected item
//     Parameters: form name and field name
//        Returns: value of the selected item
//  Relationships: 
//       Comments: 
//>	
function getIDFromDropDown(form, field)
{
	for(i=0; i<document.forms(form).elements(field).length; i++)

	{
		if(document.forms(form).elements(field)[i].selected)
		{
			return(document.forms(form).elements(field)[i].value);
		}
	}
}

//<
//  FUNCTION Name: addAsset()
//    Description: client-side addition of assets to the requested assets list
//     Parameters: asset to add, test date (BETD), which table to add to, id of record
//        Returns: none
//  Relationships: 
//       Comments: takes the asset that is clicked in the left-hand column and adds it to a table on the right-hand side.  It is called by the inc_missionAssignRequest.cfm
//>	
function addAsset(asset, betd, betdEnd, table, assetID, hasLocations, tdp, tdm, isWindow)
{
	hasLocations = hasLocations || false;
	tdp = tdp || 0;
	tdm = tdm || 0;
	isWindow = isWindow || false;
	
	//check to make sure it doesn't already exist
	if(!document.getElementById(table + '_' + 'row_' + assetID))
	{		
		var theClassName = "inputSheetText";
		
		var tbl_prefix;
		if(table == 'rangeTable')
		{
			tbl_prefix = 'ra';
			document.forms['frm_trm'].rangesAdded.value += assetID + ',';
		}else if(table == 'analysisTableTeam')
		{
			tbl_prefix = 'at';
			document.forms['frm_trm'].assetsAdded.value += assetID + ',';
		}else{
			tbl_prefix = 'nr';
			document.forms['frm_trm'].assetsAdded.value += assetID + ',';
		}
		
		//create table elements
		var theTable = document.getElementById(table);
		row_asset = document.createElement('tr');
		row_asset.id = table + '_row_' + assetID;
		cell_name = document.createElement('td');
		cell_tdp = document.createElement('td');
		cell_betd = document.createElement('td');
		cell_tdm = document.createElement('td');
		cell_comments = document.createElement('td');
		cell_asset_comments = document.createElement('td');
		
		//set cell attributes
		cell_name.className = theClassName;
		cell_tdp.className = theClassName;
		cell_betd.className = theClassName;
		cell_tdm.className = theClassName;
		cell_comments.className = theClassName;
		cell_betd.align = "center";
		cell_tdp.align = "center";
		cell_tdm.align = "center";
		
		//betd = 28-Jun-07
		var dateParts = betd.split("-");
		var datePartsEnd = betdEnd.split("-");
		
		//add cell data
		cell_name.innerHTML = '<table><tr><td align=\"left\" class=\"' + theClassName + '\"><a href=\"#\" onMouseOver=\"window.status=\'Click to remove from Mission\'; return true;\" onMouseOut=\"window.status=\'\'; return true;\" onMouseDown=\"window.status=\'\'; return true;\" onClick=\"removeAsset(\'' + assetID + '\',\'' + table + '\');window.status=\'\'; return true;\" onMouseUp=\"window.status=\'\'; return true;\" title=\"Click to remove from Mission\"><img src=\"images\\document_delete16.gif\" border=\"0\"></a></td><td  class=\"' + theClassName + '\">' + asset + '</td></tr></table>';

		/*var assetTable = document.createElement('table');
		var assetRow = document.createElement('tr');
		var assetCell = document.createElement('td');
		assetCell.align = 'left';
		assetCell.className = theClassName;
		var assetLink = document.createElement('a');
		assetLink.onMouseOver="window.status='Click to remove from Mission'; return true;";
		assetLink.onMouseOut="window.status=''; return true;";
		assetLink.onClick = function(){removeAsset(asset, table);};
		assetLink.href = '#';
		assetLink.title = 'Click to remove from mission';
		var removeImage = document.createElement('img');
		removeImage.src = 'images/document_delete16.gif';
		removeImage.border = 0;
		assetLink.appendChild(removeImage);
		assetCell.appendChild(assetLink);
		assetRow.appendChild(assetCell);
		assetTable.appendChild(assetRow);
		cell_name.appendChild(assetTable);*/

		if (hasLocations != 0) 
		{
			var locationTable = document.createElement('table');
			var namesRow = document.createElement('tr');
			var namesCell = document.createElement('td');
			namesCell.colspan = 2;
			namesCell.className = 'small2';
			namesCell.id = 'locationNames_' + assetID;
			namesRow.appendChild(namesCell);
			locationTable.appendChild(namesRow);

			var selectRow = document.createElement('tr');
			
			var selectCell = document.createElement('td');
			selectCell.className = 'small2';
			var selectLink = document.createElement('a');
			selectLink.href = '#';
			selectLink.onclick = 'window.open(\"inc_missionAssignRequestLocation.cfm?assetID_fk=' + assetID + '&selectedLocations=\", \"locationWin\", \"height=400, width=400, location=no, menubar=no, status=no, titlebar=no, toolbar=no, scrollbars=yes, top=200\"); return false;';
			selectLink.style.textDecoration = 'none';
			selectLink.onMouseOver="window.status='Click to add location(s) for this asset'; return true;";
			selectLink.onMouseOut="window.status=''; return true;";
			selectLink.innerHTML = 'Select Location';
			
			var inputLocation = document.createElement('input');
			inputLocation.type = 'hidden';
			inputLocation.id = inputLocation.name = 'locationIDs_' + assetID;
			
			selectCell.appendChild(selectLink);
			selectCell.appendChild(inputLocation);
			selectRow.appendChild(selectCell);
			locationTable.appendChild(selectRow);
			cell_name.appendChild(locationTable);
			
		}
		
		cell_name.innerHTML += '</table>';
		
		
		if(betd != betdEnd)
		{
			cell_tdp.innerHTML = betdEnd;
			cell_tdp.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdp_' + assetID + ' value=' + tdp + '>';
			cell_tdp.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdp_locked_' + assetID + ' value=\'0\'>';
			cell_tdp.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdp_' + assetID + '_orig value=0>';

		}else{
			cell_tdp.innerHTML = '<div id=\"' + tbl_prefix + '_tdp_' + assetID + '_date\" style=\"font-size:9px;\">' + betdEnd + '</div>';
			cell_tdp.innerHTML += '<input onkeypress="formChanged=\'frm_trm\';" type=text name=' + tbl_prefix + '_tdp_' + assetID + ' size=1 style="{width: 2em;}" value=' + tdp + ' maxlength=3 ondeactivate=\"if(this.value >=0 && this.value <=300){showDate(\'' + tbl_prefix + '_tdp_' + assetID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', this.value);formChanged=\'frm_trm\';}else{alert(\'TD must be between 0-300\');showDate(\'' + tbl_prefix + '_tdp_' + assetID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', 0);this.value=0;}\">';
			cell_tdp.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdp_' + assetID + '_orig value=0>';
		}
				
		if(betd != betdEnd)
		{
			cell_betd.innerHTML = 'thru';
		}else{
			cell_betd.innerHTML = betd;
		}
		
		
		if(betd != betdEnd)
		{
		
			cell_tdm.innerHTML = betd;
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_' + assetID + ' value=' + tdm + '>';
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_locked_' + assetID + ' value=\'0\'>';
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_' + assetID + '_orig value=0>';

		}else{
			cell_tdm.innerHTML = '<div id=\"' + tbl_prefix + '_tdm_' + assetID + '_date\" style=\"font-size:9px;\">' + betd + '</div>';
			cell_tdm.innerHTML += '<input onkeypress="formChanged=\'frm_trm\';" type=text name=' + tbl_prefix + '_tdm_' + assetID + ' size=1 style="{width: 2em;}" value=' + tdm + ' maxlength=3 ondeactivate=\"if(this.value >=0 && this.value <=300){showDate(\'' + tbl_prefix + '_tdm_' + assetID + '_date\', \'' + calcMonth(dateParts[1]) + '/' + dateParts[0] + '/' + dateParts[2] + '\', -this.value);}else{alert(\'TD must be between 0-300\');showDate(\'' + tbl_prefix + '_tdm_' + assetID + '_date\', \'' + calcMonth(dateParts[1]) + '/' + dateParts[0] + '/' + dateParts[2] + '\', 0);this.value=0;}\">';
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_locked_' + assetID + ' value=\'0\'>';
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_' + assetID + '_orig value=0>';
		}
			
		cell_comments.innerHTML = '<input onkeypress="formChanged=\'frm_trm\';" type=\"text\" name=' + tbl_prefix + 'comments_' + assetID + ' maxlength=\"300\" />';
		cell_asset_comments.innerHTML = '<br/><input type=\"hidden\" name=' + tbl_prefix + '_asset_comments_' + assetID + ' /><input type=\"hidden\" name=' + tbl_prefix + '_asset_tdm_' + assetID + ' value=\"0\" /><input type=\"hidden\" name=' + tbl_prefix + '_asset_tdp_' + assetID + ' VALUE=\"0\"/>';
		
		//append cells to row
		row_asset.appendChild(cell_name);
		row_asset.appendChild(cell_tdm);
		row_asset.appendChild(cell_betd);
		row_asset.appendChild(cell_tdp);

		row_asset.appendChild(cell_comments);
		row_asset.appendChild(cell_asset_comments);
		
		//append row to table
		theTable.tBodies[0].appendChild(row_asset);
		
		//keep up with what was added
		assetsAdded += ' ' + row_asset.id;
		formChanged='frm_trm';
	}else{
		//asset is already added to mission
		alert('This asset has already been added to the list');
	}
}

//<
//  FUNCTION Name: removeAsset()
//    Description: client-side deletion of assets from the requested assets list
//     Parameters: asset to delete, which table to delete from
//        Returns: none
//  Relationships: 
//       Comments: removes asset from mission on TRM input sheet.  It is called by the inc_missionAssignRequest.cfm
//>	
function removeAsset(assetID, table)
{
	var row;
	var box;
	var string;
	var i;
	row = document.getElementById(table + '_row_' + assetID);
	
	if(table == 'rangeTable')
	{
		document.forms('frm_trm').rangesRemoved.value += assetID + ',';
		//clear the value of the input boxes to guard against re-adding the asset			
		document.getElementById('ra_asset_comments_' + assetID).removeNode(true);
		document.getElementById('ra_asset_tdm_' + assetID).removeNode(true);
		document.getElementById('ra_asset_tdp_' + assetID).removeNode(true);

	}else{
		document.forms('frm_trm').assetsRemoved.value += assetID + ',';
		box = 'nr_asset_tdm_' + assetID;
		document.getElementById('nr_asset_comments_' + assetID).removeNode(true);
		document.getElementById('nr_asset_tdm_' + assetID).removeNode(true);
		document.getElementById('nr_asset_tdp_' + assetID).removeNode(true);
	}
	document.getElementById(table).deleteRow(row.sectionRowIndex);
	formChanged='frm_trm';
}

//<
//  FUNCTION Name: addTeam()
//    Description: client-side addition of assets to the requested assets list
//     Parameters: asset to add, test date (BETD), which table to add to, id of record
//        Returns: none
//  Relationships: 
//       Comments: takes the asset that is clicked in the left-hand column and adds it to a table on the right-hand side.  It is called by the inc_missionAssignRequest.cfm
//>	
function addTeam(team, betd, betdEnd, table, teamID, tdp, tdm, isWindow)
{
	//check to make sure it doesn't already exist
	if(!document.getElementById(table + '_' + 'row_' + teamID))
	{		
		var theClassName = "inputSheetText";
		
		var tbl_prefix;
		if(table == 'analysisTeamTable')
		{
			tbl_prefix = 'at';
			document.forms['frm_trm'].teamsAdded.value += teamID + ',';
		}
		
		//create table elements
		var theTable = document.getElementById(table);
		row_team = document.createElement('tr');
		row_team.id = table + '_row_' + teamID;
		cell_name = document.createElement('td');
		cell_tdp = document.createElement('td');
		cell_betd = document.createElement('td');
		cell_tdm = document.createElement('td');
		cell_comments = document.createElement('td');
		cell_team_comments = document.createElement('td');
		
		//set cell attributes
		cell_name.className = theClassName;
		cell_tdp.className = theClassName;
		cell_betd.className = theClassName;
		cell_tdm.className = theClassName;
		cell_comments.className = theClassName;
		cell_betd.align = "center";
		cell_tdp.align = "center";
		cell_tdm.align = "center";
		
		//betd = 28-Jun-07
		var dateParts = betd.split("-");
		var datePartsEnd = betdEnd.split("-");
		
		//add cell data
		cell_name.innerHTML = '<table><tr><td align=\"left\" class=\"' + theClassName + '\"><a href=\"#\" onMouseOver=\"window.status=\'Click to remove from Mission\'; return true;\" onMouseOut=\"window.status=\'\'; return true;\" onMouseDown=\"window.status=\'\'; return true;\" onClick=\"removeTeam(\'' + teamID + '\',\'' + table + '\');window.status=\'\'; return true;\" onMouseUp=\"window.status=\'\'; return true;\" title=\"Click to remove from Mission\"><img src=\"images\\document_delete16.gif\" border=\"0\"></a></td><td  class=\"' + theClassName + '\">' + team + '</td></tr></table>';
		
		if(betd != betdEnd)
		{
			cell_tdp.innerHTML = '<div id=\"' + tbl_prefix + '_tdp_' + teamID + '_date\" style=\"font-size:9px;\">' + betdEnd + '</div>';
			cell_tdp.innerHTML += '<input onkeypress="formChanged=\'frm_trm\';" type=text name=' + tbl_prefix + '_tdp_' + teamID + ' size=1 style="{width: 3em;}" value=' + tdp + ' maxlength=4 ondeactivate=\"if(this.value >=-999){showDate(\'' + tbl_prefix + '_tdp_' + teamID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', this.value);formChanged=\'frm_trm\';}else{alert(\'TD must be an integer\');showDate(\'' + tbl_prefix + '_tdp_' + teamID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', 0);this.value=0;}\">';
			cell_tdp.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdp_' + teamID + '_orig value=0>';
			
		}else{
			cell_tdp.innerHTML = '<div id=\"' + tbl_prefix + '_tdp_' + teamID + '_date\" style=\"font-size:9px;\">' + betdEnd + '</div>';
			cell_tdp.innerHTML += '<input onkeypress="formChanged=\'frm_trm\';" type=text name=' + tbl_prefix + '_tdp_' + teamID + ' size=1 style="{width: 3em;}" value=' + tdp + ' maxlength=4 ondeactivate=\"if(this.value >=-999){showDate(\'' + tbl_prefix + '_tdp_' + teamID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', this.value);formChanged=\'frm_trm\';}else{alert(\'TD must be an integer\');showDate(\'' + tbl_prefix + '_tdp_' + teamID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', 0);this.value=0;}\">';
			cell_tdp.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdp_' + teamID + '_orig value=0>';
		}
				
		if(betd != betdEnd)
		{
			cell_betd.innerHTML = betdEnd;
		}else{
			cell_betd.innerHTML = betd;
		}
		
		
		if(betd != betdEnd)
		{
		
			cell_tdm.innerHTML = '<div id=\"' + tbl_prefix + '_tdm_' + teamID + '_date\" style=\"font-size:9px;\">' + betdEnd + '</div>';
			cell_tdm.innerHTML += '<input onkeypress="formChanged=\'frm_trm\';" type=text name=' + tbl_prefix + '_tdm_' + teamID + ' size=1 style="{width: 3em;}" value=' + tdm + ' maxlength=4 ondeactivate=\"if(this.value >=-999){showDate(\'' + tbl_prefix + '_tdm_' + teamID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', -this.value);}else{alert(\'TD must be an integer\');showDate(\'' + tbl_prefix + '_tdm_' + teamID + '_date\', \'' + calcMonth(datePartsEnd[1]) + '/' + datePartsEnd[0] + '/' + datePartsEnd[2] + '\', 0);this.value=0;}\">';
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_' + teamID + '_orig value=0>';

		}else{
			cell_tdm.innerHTML = '<div id=\"' + tbl_prefix + '_tdm_' + teamID + '_date\" style=\"font-size:9px;\">' + betd + '</div>';
			cell_tdm.innerHTML += '<input onkeypress="formChanged=\'frm_trm\';" type=text name=' + tbl_prefix + '_tdm_' + teamID + ' size=1 style="{width: 3em;}" value=' + tdm + ' maxlength=4 ondeactivate=\"if(this.value >=-999){showDate(\'' + tbl_prefix + '_tdm_' + teamID + '_date\', \'' + calcMonth(dateParts[1]) + '/' + dateParts[0] + '/' + dateParts[2] + '\', -this.value);}else{alert(\'TD must be an integer\');showDate(\'' + tbl_prefix + '_tdm_' + teamID + '_date\', \'' + calcMonth(dateParts[1]) + '/' + dateParts[0] + '/' + dateParts[2] + '\', 0);this.value=0;}\">';
			cell_tdm.innerHTML += '<input type=\'hidden\' name=' + tbl_prefix + '_tdm_' + teamID + '_orig value=0>';
		}
			
		cell_comments.innerHTML = '<input onkeypress="formChanged=\'frm_trm\';" type=\"text\" name=' + tbl_prefix + 'comments_' + teamID + ' maxlength=\"300\" />';
		cell_team_comments.innerHTML = '<br/><input type=\"hidden\" name=' + tbl_prefix + '_team_comments_' + teamID + ' /><input type=\"hidden\" name=' + tbl_prefix + '_team_tdm_' + teamID + ' value=\"0\" /><input type=\"hidden\" name=' + tbl_prefix + '_team_tdp_' + teamID + ' VALUE=\"0\"/>';
		
		//append cells to row
		row_team.appendChild(cell_name);
		row_team.appendChild(cell_tdm);
		row_team.appendChild(cell_betd);
		row_team.appendChild(cell_tdp);

		row_team.appendChild(cell_comments);
		row_team.appendChild(cell_team_comments);
		
		//append row to table
		theTable.tBodies[0].appendChild(row_team);
		
		//keep up with what was added
		teamsAdded += ' ' + row_team.id;
		formChanged='frm_trm';
	}else{
		//team is already added to mission
		alert('This team has already been added to the list');
	}
}

//<
//  FUNCTION Name: removeTeam()
//    Description: client-side deletion of assets from the requested assets list
//     Parameters: asset to delete, which table to delete from
//        Returns: none
//  Relationships: 
//       Comments: removes asset from mission on TRM input sheet.  It is called by the inc_missionAssignRequest.cfm
//>	
function removeTeam(teamID, table)
{
	var row;
	var box;
	var string;
	var i;
	row = document.getElementById(table + '_row_' + teamID);
	
	if(table == 'analysisTeamTable')
	{
		document.forms('frm_trm').teamsRemoved.value += teamID + ',';
		//clear the value of the input boxes to guard against re-adding the asset			
		document.getElementById('at_team_comments_' + teamID).removeNode(true);
		document.getElementById('at_team_tdm_' + teamID).removeNode(true);
		document.getElementById('at_team_tdp_' + teamID).removeNode(true);
	}
	document.getElementById(table).deleteRow(row.sectionRowIndex);
	formChanged='frm_trm';
}

//<
//  FUNCTION Name: processTRMForm(assetGroup)
//    Description: process the TRM form and massage it into data structures to send to the AJAX engine
//     Parameters: assetGroup - variable to signify whether the assets are FT or SUT
//        Returns: none
//  Relationships: 
//       Comments: this is the main call that gets executed when a user clicks "Save Changes" on the TRM Worksheet
//>	
function processTRMForm(assetGroup)
{
	//retro-fitting the ability to also process SUT assets, along with FT assets and ranges
	assetGroup = assetGroup || 'nr';
	
	var rangesExisting='', ra_tdm_existing='', ra_tdm_existing_orig='', ra_tdp_existing='', ra_tdp_existing_orig='', ra_comments_existing='', ra_asset_comments_existing='', ra_asset_tdm_existing='', ra_asset_tdp_existing='', ra_locationIDs_existing='';
	var assetsExisting='', nr_tdm_existing='', nr_tdm_existing_orig='', nr_tdp_existing='', nr_tdp_existing_orig='', nr_comments_existing='', nr_asset_comments_existing='', nr_asset_tdm_existing='', nr_asset_tdp_existing='', nr_locationIDs_existing='';
	
	for(i=0; i<document.forms['frm_trm'].elements.length; i++)
	{
		//I am keying off the comments field to get the asset IDs
		if(document.forms['frm_trm'].elements[i].name.substring(0, 11) == 'racomments_')
		{
			var rangeAsset = document.forms['frm_trm'].elements[i].name.split('_')[1];
			rangesExisting += rangeAsset + ',';
			ra_tdm_existing += eval('document.forms[\'frm_trm\'].ra_tdm_' + rangeAsset + '.value') + ',';
			ra_tdm_existing_orig += eval('document.forms[\'frm_trm\'].ra_tdm_' + rangeAsset + '_orig.value') + ',';
			ra_tdp_existing += eval('document.forms[\'frm_trm\'].ra_tdp_' + rangeAsset + '.value') + ',';
			ra_tdp_existing_orig += eval('document.forms[\'frm_trm\'].ra_tdp_' + rangeAsset + '_orig.value') + ',';
			ra_asset_tdm_existing += eval('document.forms[\'frm_trm\'].ra_asset_tdm_' + rangeAsset + '.value') + ',';
			ra_asset_tdp_existing += eval('document.forms[\'frm_trm\'].ra_asset_tdp_' + rangeAsset + '.value') + ',';
			
			ra_locationIDs_existing += ',';
			
			//gotta do some fancy footwork to deal with blank comments
			if(eval('document.forms[\'frm_trm\'].racomments_' + rangeAsset + '.value').replace(/^\s+|\s+$/g, '') == '')
			{
				//if blank, insert the literal text "NULL".   CF's list functions don't like empty elements.  we'll deal with NULL on the other side
				ra_comments_existing += 'NULL`';
			}else{
				ra_comments_existing += eval('document.forms[\'frm_trm\'].racomments_' + rangeAsset + '.value').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&') + '`';
			}
			
			if(eval('document.forms[\'frm_trm\'].ra_asset_comments_' + rangeAsset + '.value').replace(/^\s+|\s+$/g, '')  == '')
			{
				ra_asset_comments_existing += 'NULL`';
			}else{
				ra_asset_comments_existing += eval('document.forms[\'frm_trm\'].ra_asset_comments_' + rangeAsset + '.value').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&') + '`';
			}				
		
		}else if(document.forms['frm_trm'].elements[i].name.substring(0, 11) == 'nrcomments_')
		{
			
			var nonRangeAsset = document.forms['frm_trm'].elements[i].name.split('_')[1];
			assetsExisting += nonRangeAsset + ',';
			nr_tdm_existing += eval('document.forms[\'frm_trm\'].nr_tdm_' + nonRangeAsset + '.value') + ',';
			nr_tdm_existing_orig += eval('document.forms[\'frm_trm\'].nr_tdm_' + nonRangeAsset + '_orig.value') + ',';
			nr_tdp_existing += eval('document.forms[\'frm_trm\'].nr_tdp_' + nonRangeAsset + '.value') + ',';
			nr_tdp_existing_orig += eval('document.forms[\'frm_trm\'].nr_tdp_' + nonRangeAsset + '_orig.value') + ',';
			nr_asset_tdm_existing += eval('document.forms[\'frm_trm\'].nr_asset_tdm_' + nonRangeAsset + '.value') + ',';
			nr_asset_tdp_existing += eval('document.forms[\'frm_trm\'].nr_asset_tdp_' + nonRangeAsset + '.value') + ',';
			
			try {
				nr_locationIDs_existing += eval('document.forms[\'frm_trm\'].locationIDs_' + nonRangeAsset + '.value') + ',';
			}catch(e)
			{
				nr_locationIDs_existing += ',';
			}
			
			//gotta do some fancy footwork to deal with blank comments
			if(eval('document.forms[\'frm_trm\'].nrcomments_' + nonRangeAsset + '.value').replace(/^\s+|\s+$/g, '') == '')
			{
				//if blank, insert the literal text "NULL".   CF's list functions don't like empty elements.  we'll deal with NULL on the other side
				nr_comments_existing += 'NULL`';
			}else{
				nr_comments_existing += eval('document.forms[\'frm_trm\'].nrcomments_' + nonRangeAsset + '.value').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&') + '`';
			}
			
			if(eval('document.forms[\'frm_trm\'].nr_asset_comments_' + nonRangeAsset + '.value').replace(/^\s+|\s+$/g, '')  == '')
			{
				nr_asset_comments_existing += 'NULL`';
			}else{
				nr_asset_comments_existing += eval('document.forms[\'frm_trm\'].nr_asset_comments_' + nonRangeAsset + '.value').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&') + '`';
			}			
		}			
	}
	
	//got all the data squared away - let's update
	DWREngine._execute(_cfscriptLocation, null, 'updTRMWorksheet', 
						idSelected, rangesExisting, assetsExisting, ra_tdm_existing, ra_tdm_existing_orig, ra_tdp_existing, 
						ra_tdp_existing_orig, ra_asset_tdp_existing, ra_asset_tdm_existing, ra_comments_existing, ra_asset_comments_existing, 
						nr_tdm_existing, nr_tdm_existing_orig, nr_tdp_existing, nr_tdp_existing_orig, nr_asset_tdm_existing, nr_asset_tdp_existing, 
						nr_comments_existing, nr_asset_comments_existing, cleanString(nr_locationIDs_existing), document.forms['frm_trm'].rangesAdded.value, 
						document.forms['frm_trm'].assetsAdded.value, document.forms['frm_trm'].rangesRemoved.value, document.forms['frm_trm'].assetsRemoved.value,
						assetGroup, updateTRMForms);

}

//<
//  FUNCTION Name: cleanString(thisString)
//    Description: replace empty list items and strip off the trailing comma
//     Parameters: string to clean
//        Returns: clean string
//  Relationships: 
//       Comments: 
//>	

function cleanString(thisString)
{
	var splitString = thisString.split(',');
	var cleanString = '';
	var i=0;
	
	while(i<splitString.length-1)
	{
		if(splitString[i].length > 0)
		{
			cleanString += splitString[i] + ',';
		}else{
			cleanString += '-1,';
		}
		i++;
	}
	return(cleanString.substr(0, cleanString.length-1));
}

//<
//  FUNCTION Name: processATTRMForm(assetGroup)
//    Description: process the TRM form and massage it into data structures to send to the AJAX engine
//     Parameters: assetGroup - variable to signify whether the assets are FT or SUT
//        Returns: none
//  Relationships: 
//       Comments: this is the main call that gets executed when a user clicks "Save Changes" on the TRM Worksheet
//>	
function processATTRMForm(assetGroup)
{
	
	//retro-fitting the ability to also process SUT assets, along with FT assets and ranges
	assetGroup = assetGroup || 'at';
	
	var teamsExisting='', at_tdm_existing='', at_tdm_existing_orig='', at_tdp_existing='', at_tdp_existing_orig='', at_comments_existing='', at_team_comments_existing='', at_team_tdm_existing='', at_team_tdp_existing='';
	
	for(i=0; i<document.forms['frm_trm'].elements.length; i++)
	{
		//I am keying off the comments field to get the asset IDs
		if(document.forms['frm_trm'].elements[i].name.substring(0, 11) == 'atcomments_')
		{
			var team = document.forms['frm_trm'].elements[i].name.split('_')[1];
			
			//now that users can add positive and negative numbers in the TDM and TDP, we need to make sure they don't get out of order
			if(eval('document.forms[\'frm_trm\'].at_tdm_' + team + '.value') < 0)
			{
				if(Math.abs(eval('document.forms[\'frm_trm\'].at_tdm_' + team + '.value')) > Math.abs(eval('document.forms[\'frm_trm\'].at_tdp_' + team + '.value')))
				{
					alert('Your negative L- will result in a date that is after your L+ ');
					document.forms['frm_trm'].disabled=0;
					document.forms['frm_trm'].elements['at_tdm_' + team].focus();
					document.forms['frm_trm'].elements['at_tdm_' + team].style.backgroundColor='red';
					return false;
				}
			}
			
			if(eval('document.forms[\'frm_trm\'].at_tdp_' + team + '.value') < 0)
			{				
				if(Math.abs(eval('document.forms[\'frm_trm\'].at_tdp_' + team + '.value')) > Math.abs(eval('document.forms[\'frm_trm\'].at_tdm_' + team + '.value')))
				{
					alert('Your negative L+ will result in a date that is before your L- ');
					document.forms['frm_trm'].disabled=0;
					document.forms['frm_trm'].elements['at_tdp_' + team].focus();
					document.forms['frm_trm'].elements['at_tdp_' + team].style.backgroundColor='red';
					return false;
				}			
			}
			
			teamsExisting += team + ',';
			at_tdm_existing += eval('document.forms[\'frm_trm\'].at_tdm_' + team + '.value') + ',';
			at_tdm_existing_orig += eval('document.forms[\'frm_trm\'].at_tdm_' + team + '_orig.value') + ',';
			at_tdp_existing += eval('document.forms[\'frm_trm\'].at_tdp_' + team + '.value') + ',';
			at_tdp_existing_orig += eval('document.forms[\'frm_trm\'].at_tdp_' + team + '_orig.value') + ',';
			at_team_tdm_existing += eval('document.forms[\'frm_trm\'].at_team_tdm_' + team + '.value') + ',';
			at_team_tdp_existing += eval('document.forms[\'frm_trm\'].at_team_tdp_' + team + '.value') + ',';
			
			
			//gotta do some fancy footwork to deal with blank comments
			if(eval('document.forms[\'frm_trm\'].atcomments_' + team + '.value').replace(/^\s+|\s+$/g, '') == '')
			{
				//if blank, insert the literal text "NULL".   CF's list functions don't like empty elements.  we'll deal with NULL on the other side
				at_comments_existing += 'NULL`';
			}else{
				at_comments_existing += eval('document.forms[\'frm_trm\'].atcomments_' + team + '.value').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&') + '`';
			}
			
			if(eval('document.forms[\'frm_trm\'].at_team_comments_' + team + '.value').replace(/^\s+|\s+$/g, '')  == '')
			{
				at_team_comments_existing += 'NULL`';
			}else{
				at_team_comments_existing += eval('document.forms[\'frm_trm\'].at_team_comments_' + team + '.value').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&') + '`';
			}				
		}			
	}

	//got all the data squared away - let's update
	DWREngine._execute(_cfscriptLocation, null, 'updATTRMWorksheet', 
						idSelected, teamsExisting, at_tdm_existing, at_tdm_existing_orig, at_tdp_existing, 
						at_tdp_existing_orig, at_team_tdp_existing, at_team_tdm_existing, at_comments_existing, at_team_comments_existing, 
						document.forms['frm_trm'].teamsAdded.value, document.forms['frm_trm'].teamsRemoved.value,
						updateATTRMForms);

}

//<
//  FUNCTION Name: updateTRMForms(success)
//    Description: show confirmation message and update related forms if the update is successful
//     Parameters: flag to determine if the TRM update was successful
//        Returns: none
//  Relationships: 
//       Comments:
//>	
function updateTRMForms(success)
{	
	if(success != 'false')
	{
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
		DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', idSelected, setBoxscoreWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', idSelected, setTCSWorksheet);
		if(success == 'op')
		{
			getPMAssetGroup('sut',recordID);
			getAssetGroup('sut', recordID);
		}else{
			getPMAssetGroup('ft',recordID);
			getAssetGroup('ft', recordID);
		}
		alert('TRM Worksheet has been updated');
	}else{
		alert('There was a problem saving your worksheet.  We apologize for the inconvenience and the TRMP-T team has been alerted to the problem.')
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
	}
}

//<
//  FUNCTION Name: updateATTRMForms(success)
//    Description: show confirmation message and update related forms if the update is successful
//     Parameters: flag to determine if the TRM update was successful
//        Returns: none
//  Relationships: 
//       Comments:
//>	
function updateATTRMForms(success)
{	
	if(success != 'false')
	{
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
		DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', idSelected, setBoxscoreWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', idSelected, setTCSWorksheet);
		getAssetGroup('at', idSelected)
		alert('Analysis Team Worksheet has been updated');
	}else{
		alert('There was a problem saving your worksheet.  We apologize for the inconvenience and the TRMP-T team has been alerted to the problem.')
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
	}
}

//<
//  FUNCTION Name: processPreMission()
//    Description: make call to the AJAX engine to update the PM worksheet
//     Parameters: none
//        Returns: none
//  Relationships: 
//       Comments: this is the main call that gets executed when a user clicks "Save Changes" on the PM Worksheet
//>	
function processPreMission()
{
	DWREngine._execute(_cfscriptLocation, null, 'updPMWorksheet', 
						document.forms('frm_updateSchedule').missionID.value, 
						document.forms('frm_updateSchedule').eventsAdded.value, 
						document.forms('frm_updateSchedule').eventsDeleted.value, 
						document.forms('frm_updateSchedule').eventsChanged.value, 
						document.forms('frm_updateSchedule').othersAdded.value, 
						document.forms('frm_updateSchedule').assetsAdded.value, 
						document.forms('frm_updateSchedule').assetsRemoved.value,
						updatePMForms);
}


//<
//  FUNCTION Name: updatePMForms(success)
//    Description: show confirmation message and update related forms if the update is successful
//     Parameters: flag to determine if the PreMission update was successful
//        Returns: none
//  Relationships: 
//       Comments:
//>	
function updatePMForms(success)
{
	if(success == 'true')
	{
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
		getAssetGroup('ft',idSelected);
		DWREngine._execute(_cfscriptLocation, null, 'getPreMissionWorksheet', idSelected, setPreMissionWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', idSelected, setTCSWorksheet);
		getPMAssetGroup('ft',idSelected);
		alert('Pre-Mission Worksheet has been updated');
	}else{
		alert('There was a problem saving your worksheet.  We apologize for the inconvenience and the TRMP-T team has been alerted to the problem.')
		DWREngine._execute(_cfscriptLocation, null, 'getPreMissionWorksheet', idSelected, setPreMissionWorksheet);
	}
	document.forms('frm_updateSchedule').eventsAdded.value = '';
	document.forms('frm_updateSchedule').eventsDeleted.value = '';
	document.forms('frm_updateSchedule').othersAdded.value = '';
}

//<
//  FUNCTION Name: processPreMissionAssets(assetGroup)
//    Description: make call to the AJAX engine to update the PM worksheet
//     Parameters: assetGroup - whether the function is dealing with FT assets or SUT assets
//        Returns: none
//  Relationships: 
//       Comments: this is the main call that gets executed when a user clicks "Save Changes" on the PM Worksheet
//>	
function processPreMissionAssets(assetGroup)
{
	var i=0;
	var events = '';
	
	// if there aren't any clickable boxes, don't try to update anything
	if (typeof(document.forms('frm_eventAssets').events) != "undefined"){
	
		//if there is only one checkbox, the form does not return an array, therefore, there is no .length attribute
		//so, we have to handle that case differently
		if (typeof(document.forms('frm_eventAssets').events.length) == "undefined"){
			//single element
			if(document.forms('frm_eventAssets').events.checked)
				{
					events += document.forms('frm_eventAssets').events.value + ",";
					
				}
		}else{
			//process checboxes by building list
			for(i=0; i<document.forms('frm_eventAssets').events.length; i++)
			{
				if(document.forms('frm_eventAssets').events[i].checked)
				{
					if(document.forms('frm_eventAssets').events[i].value != 0)
					{
						events += document.forms('frm_eventAssets').events[i].value + ",";
					}	
				}
			}
		}

		DWREngine._execute(_cfscriptLocation, null, 'updPMAssetWorksheet', 
							document.forms('frm_eventAssets').eventList.value, 
							events, 
							document.forms('frm_eventAssets').missionID_fk.value, 
							assetGroup,
							updatePMAssetForms);
	}else{
		updatePMAssetForms('true')
	}
}

//<
//  FUNCTION Name: updatePMAssetForms(success)
//    Description: show confirmation message and update related forms if the update is successful
//     Parameters: flag to determine if the PreMission update was successful
//        Returns: none
//  Relationships: 
//       Comments:
//>	
function updatePMAssetForms(success)
{
	if(success != 'false')
	{
		//update the TRM worksheet
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
		if(success == 'sut' || success == 'op')
		{
			getPMAssetGroup('sut',recordID);
			getAssetGroup('sut', recordID);
		}else{
			getPMAssetGroup('ft',recordID);
			getAssetGroup('ft', recordID);
		}
		alert('Pre-Mission Asset Worksheet has been updated');
	}else{
		alert('There was a problem saving your worksheet.  We apologize for the inconvenience and the TRMP-T team has been alerted to the problem.');
		//re-set the form
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
	}
}

//<
//  FUNCTION Name: getAssetGroup(assetGroup)
//    Description: gets Operational or Flight Test TRM worksheet
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 
//>	
function getAssetGroup(assetGroup)
{
	formChanged=false;
	if(assetGroup == 'op' || assetGroup == 'sut')
	{
		//setTimeout("document.forms['test'].selectAssets[1].checked=true;", 700);
		document.forms['test'].selectAssets[1].checked=true;
		DWREngine._execute(_cfscriptLocation, null, 'getAssetGroupWorksheet', assetGroup, idSelected, setAssetGroupWorksheet);
	}else if(assetGroup == 'ft'){
		//setTimeout("document.forms['test'].selectAssets[0].checked=true;", 700);
		document.forms['test'].selectAssets[0].checked=true;
		DWREngine._execute(_cfscriptLocation, null, 'getAssetGroupWorksheet', assetGroup, idSelected, setAssetGroupWorksheet);
	}else if(assetGroup == 'at'){
		//setTimeout("document.forms['test'].selectAssets[0].checked=true;", 700);
		document.forms['test'].selectAssets[2].checked=true;
		DWREngine._execute(_cfscriptLocation, null, 'getAssetGroupWorksheet', assetGroup, idSelected, setAssetGroupWorksheet);
	}else{
		<cfif listcontains(session.userprivileges, "msnCTFedit")>
			//setTimeout("document.forms['test'].selectAssets[1].checked=true;", 700);
			document.forms['test'].selectAssets[1].checked=true;
			DWREngine._execute(_cfscriptLocation, null, 'getAssetGroupWorksheet', 'sut', idSelected, setAssetGroupWorksheet);
		<cfelse>
			//setTimeout("document.forms['test'].selectAssets[0].checked=true;", 700);
			document.forms['test'].selectAssets[0].checked=true;
			DWREngine._execute(_cfscriptLocation, null, 'getAssetGroupWorksheet', 'ft', idSelected, setAssetGroupWorksheet);
		</cfif>
	}
}

//<
//  FUNCTION Name: getAssetGroup(assetGroup)
//    Description: gets Operational or Flight Test TRM worksheet
//     Parameters: 
//        Returns: 
//  Relationships: 
//       Comments: 
//>	
function getPMAssetGroup(assetGroup)
{
	formChanged=false;
	
	if(assetGroup == 'op' || assetGroup == 'sut')
	{
		//setTimeout("document.forms['pmAssettest'].selectAssets[1].checked=true;", 700);
		document.forms['pmAssettest'].selectAssets[1].checked=true;
		DWREngine._execute(_cfscriptLocation, null, 'getPMAssetGroupWorksheet', assetGroup, idSelected, setPMAssetGroupWorksheet);
		//document.forms['pmAssettest'].selectAssets[1].checked=true;
	}else if(assetGroup == 'ft'){
		//setTimeout("document.forms['pmAssettest'].selectAssets[0].checked=true;", 700);
		document.forms['pmAssettest'].selectAssets[0].checked=true;
		DWREngine._execute(_cfscriptLocation, null, 'getPMAssetGroupWorksheet', assetGroup, idSelected, setPMAssetGroupWorksheet);
		//document.forms['pmAssettest'].selectAssets[0].checked=true;
	}else{
		<cfif listcontains(session.userprivileges, "msnCTFedit")>
			//setTimeout("document.forms['pmAssettest'].selectAssets[1].checked=true;", 700);
			document.forms['pmAssettest'].selectAssets[1].checked=true;
			DWREngine._execute(_cfscriptLocation, null, 'getPMAssetGroupWorksheet', 'sut', idSelected, setPMAssetGroupWorksheet);
			//document.forms['pmAssettest'].selectAssets[1].checked=true;
		<cfelse>
			//setTimeout("document.forms['pmAssettest'].selectAssets[0].checked=true;", 700);
			document.forms['pmAssettest'].selectAssets[0].checked=true;
			DWREngine._execute(_cfscriptLocation, null, 'getPMAssetGroupWorksheet', 'ft', idSelected, setPMAssetGroupWorksheet);
			//document.forms['pmAssettest'].selectAssets[0].checked=true;
		</cfif>
	}
}



//<
//  FUNCTION Name: setAssetGroupWorksheet(formObject)
//    Description: populated the TRM worksheet with the appropriate assets
//     Parameters: formObject - Return Object from AJAX Call
//        Returns: 
//  Relationships: 
//       Comments:
//>
function setAssetGroupWorksheet(formObject)
{
	DWRUtil.setValue("assetGroupWorksheet", formObject.ASSETGROUPWORKSHEET);
}

//<
//  FUNCTION Name: setAssetGroupWorksheet(formObject)
//    Description: populated the TRM worksheet with the appropriate assets
//     Parameters: formObject - Return Object from AJAX Call
//        Returns: 
//  Relationships: 
//       Comments:
//>
function setPMAssetGroupWorksheet(formObject)
{
	
	DWRUtil.setValue("assetGroupPMWorksheet", formObject.ASSETGROUPWORKSHEET);
}

//<
//  FUNCTION Name: showDate(div, betd, offset)
//    Description: converts TD+ and TD- days relative to the BETD into actual date 
//     Parameters: div		name of the div to update
//				 : betd		mission date
//				 : offset	number of days (positive or negative) to add/subtract from the BETD
//        Returns: date in format of dd-mmm-yy
//  Relationships: 
//       Comments: 
//>		
function showDate(div, betd, offset)
{	
	//required for if they leave the field blank
	if(!offset.toString().length)
	{
		offset = 0;
	}
	///have to convert text date into real javascript date in order to do the date comparison
	var a_BETD = betd.split("/")
	var d_BETD = new Date();

	var year 	//used to remove first two numbers of year (2007 -> 07) or to pad a 0 (7 -> 07)

	//create the javascript date based on the string that was passed in
	d_BETD.setMonth(a_BETD[0]-1, 1);
	d_BETD.setDate(a_BETD[1]);
	d_BETD.setYear(a_BETD[2]);

	//calculate the date by adding the number of days to the created date.  offset can be a positive or negative number
	d_BETD.setDate(d_BETD.getDate() + parseInt(offset));
	
	//getYear returns 4-character year for dates greater than 1999 and 2-character for dates less than or equal to 1999
	//I want to force 2-character for all years, so I convert it to a string and only return the last 2 numbers as the year
	if(d_BETD.getYear().toString().length == 1)
	{
		year = '0' + d_BETD.getYear().toString();
	}else if(d_BETD.getYear().toString().length == 2)
	{
		year = d_BETD.getYear().toString();
	}else if(d_BETD.getYear().toString().length == 4)
	{
		year = d_BETD.getYear().toString().substring(2, 4);
	}else{
		year = d_BETD.getYear();
	}
	document.getElementById(div).innerHTML = d_BETD.getDate() + "-" + calcMonth(d_BETD.getMonth()) + "-" + year;	
}

//<
//  FUNCTION Name: calcMonth(month)
//    Description: converts text month into number (JAN = 1, FEB = 2, etc)
//     Parameters: month		name of month
//        Returns: numeric representation of month
//  Relationships: 
//       Comments: 
//>		
function calcMonth(month)
{
// months are indexed from 0, just like any other array
	switch (month){
	case 0: 
		return("Jan");
		break;
	case 1: 
		return("Feb");
		break;
	case 2: 
		return("Mar");
		break;
	case 3: 
		return("Apr");
		break;
	case 4: 
		return("May");
		break;
	case 5: 
		return("Jun");
		break;
	case 6: 
		return("Jul");
		break;
	case 7: 
		return("Aug");
		break;
	case 8: 
		return("Sep");
		break;
	case 9: 
		return("Oct");
		break;
	case 10: 
		return("Nov");
		break;
	case 11: 
		return("Dec");
		break;
		
	//added so that it will work either way 0->Jan or Jan ->0
	case "Jan": 

		return(1);
		break;
	case "Feb": 
		return(2);
		break;
	case "Mar": 
		return(3);
		break;
	case "Apr": 
		return(4);
		break;
	case "May": 
		return(5);
		break;
	case "Jun": 
		return(6);
		break;
	case "Jul": 
		return(7);
		break;
	case "Aug": 
		return(8);
		break;
	case "Sep": 
		return(9);
		break;
	case "Oct": 
		return(10);
		break;
	case "Nov": 
		return(11);
		break;
	case "Dec": 
		return(12);
		break;
	}
	//probably not the best way to do this, but I also need a case-insensitive comparison and I'm not sure if it would hose up the previous switch, so I'm just adding another one
	switch (month.toUpperCase()){
		case "JAN": 
			return(1);
			break;
		case "FEB": 
			return(2);
			break;
		case "MAR": 
			return(3);
			break;
		case "APR": 
			return(4);
			break;
		case "MAY": 
			return(5);
			break;
		case "JUN": 
			return(6);
			break;
		case "JUL": 
			return(7);
			break;
		case "AUG": 
			return(8);
			break;
		case "SEP": 
			return(9);
			break;
		case "OCT": 
			return(10);
			break;
		case "NOV": 
			return(11);
			break;
		case "DEC": 
			return(12);
			break;
	
	}
}

//function: 	shortenWindow(sDate, eDate)
//inputs:		sdate - start Date; eDate - ending Date
//returns:		redirects window to Deconfliction Report for desired timeframe
//description:	validates that start date is before end date, then redirects to a shortened window of the deconfliction report
function shortenWindow(sDate, eDate, type, url)
{
	RestartSessionTimer();
	sDate = sDate.split('/')[0] + '/01/' + sDate.split('/')[1];
	eDate = eDate.split('/')[0] + '/01/' + eDate.split('/')[1];
	printSummaryReports(sDate, eDate, type, url);
}

//function: 	calcEndDate(myDate, type, report)
//inputs:		myDate - the month or year to be processed; type - whether 'myDate' represents the month or the year; report - whether this is the Deconfliction Report or the Conflict Report
//returns:		
//description:	redraws the end date drop-down to show the next 6 months, relative to the start month/year that the user selects
function calcEndDate(myDate, type, report)
{
	var i=0;
	//if the user changed the month drop-down, we have to check for windows rolling to the next year
	if(type == 'mon')
	{
		myDate = myDate-1;
		var endYear, endDate;
		if(report == 'decon')
		{
			endYear = parseInt(document.getElementById('startYear').options[document.getElementById('startYear').selectedIndex].value);
			endDate = 'endDate';
		}else if(report == 'conflict'){
			endYear = parseInt(document.getElementById('conflictStartYear').options[document.getElementById('conflictStartYear').selectedIndex].value);
			endDate = 'conflictEndDate';
		}else{
			endYear = parseInt(document.getElementById('boxscoreStartYear').options[document.getElementById('boxscoreStartYear').selectedIndex].value);
			endDate = 'boxscoreEndDate';
		}
		
		if(report != 'boxscore')
		{
			for(i=1; i<7; i++)
			{
				//do some checking to make sure the 6-month window doesn't roll into the next year
				if(parseInt(myDate) + i > 12)
				{
					myDate = parseInt(myDate)-12;
					endYear += 1;
				}
				//quick-n-dirty way to convert int to string
				var str_endYear = endYear + '';
				//replace the options with the mm/yy format of the 6-month window
				document.getElementById(endDate).options[i-1].value = parseInt(myDate) + i + '/' +str_endYear.substr(2,2);
				document.getElementById(endDate).options[i-1].text = parseInt(myDate) + i + '/' + str_endYear.substr(2,2);
			}
		}else{
			for(i=1; i<13; i++)
			{
				//do some checking to make sure the 6-month window doesn't roll into the next year
				if(parseInt(myDate) + i > 12)
				{
					myDate = parseInt(myDate)-12;
					endYear += 1;
				}
				//quick-n-dirty way to convert int to string
				var str_endYear = endYear + '';
				//replace the options with the mm/yy format of the 6-month window
				document.getElementById(endDate).options[i-1].value = parseInt(myDate) + i + '/' +str_endYear.substr(2,2);
				document.getElementById(endDate).options[i-1].text = parseInt(myDate) + i + '/' + str_endYear.substr(2,2);
			}
		}
	}else{
		var firstYear;
		var displayYear;
		var endDate;
		
		if(report == 'decon')
		{
			endDate = 'endDate';
			firstYear = document.getElementById(endDate).options[0].value.split('/')[1];
		}else if(report == 'conflict'){
			endDate = 'conflictEndDate';
			firstYear = document.getElementById(endDate).options[0].value.split('/')[1];
		}else{
			endDate = 'boxscoreEndDate';
			firstYear = document.getElementById(endDate).options[0].value.split('/')[1];
		}
		
		if(report != 'boxscore')
		{
			for(i=0; i<6; i++)
			{
				//had to do a little fancy footwork to change the years.  I capture the first year on the current list and key everything else
				//off of that.  We know that there will never be more than 2 years represented (since it's a 6-month window).
				if(document.getElementById(endDate).options[i].value.split('/')[1] == firstYear)
				{
					myDate += '';
					document.getElementById(endDate).options[i].value = document.getElementById(endDate).options[i].value.split('/')[0] + '/' + myDate.substr(2,2);
					document.getElementById(endDate).options[i].text =  document.getElementById(endDate).options[i].value.split('/')[0] + '/' +  myDate.substr(2,2);
				}else{
					displayYear = parseInt(myDate)+1;
					displayYear += '';
					document.getElementById(endDate).options[i].value = document.getElementById(endDate).options[i].value.split('/')[0] + '/' +  displayYear.substr(2,2);
					document.getElementById(endDate).options[i].text =  document.getElementById(endDate).options[i].value.split('/')[0] + '/' +  displayYear.substr(2,2);
				}
			}
		}else{
			for(i=0; i<12; i++)
			{
				if(document.getElementById(endDate).options[i].value.split('/')[1] == firstYear)
				{
					myDate += '';
					document.getElementById(endDate).options[i].value = document.getElementById(endDate).options[i].value.split('/')[0] + '/' + myDate.substr(2,2);
					document.getElementById(endDate).options[i].text =  document.getElementById(endDate).options[i].value.split('/')[0] + '/' +  myDate.substr(2,2);
				}else{
					displayYear = parseInt(myDate)+1;
					displayYear += '';
					document.getElementById(endDate).options[i].value = document.getElementById(endDate).options[i].value.split('/')[0] + '/' +  displayYear.substr(2,2);
					document.getElementById(endDate).options[i].text =  document.getElementById(endDate).options[i].value.split('/')[0] + '/' +  displayYear.substr(2,2);
				}
			}
		}
			
	}
	//since the endDate drop down is what drives the execution of the report, change it back to the blank selection to force them to change it
	document.getElementById(endDate).selectedIndex = 0;
}

function validate_date(myDate)
{
	var dateParts;
	dateParts = myDate.toString().split('-');

	//make sure it at least has 2 -'s
	if(dateParts.length != 3)
	{
		alert('Date must be in the format \'DD-MMM-YY\' (ex: \'01-JAN-08\')');
		return false;
	}
	//make sure they entered a valid mon abbreviation
	if(!calcMonth(dateParts[1]))
	{
		alert('Date must be in the format \'DD-MMM-YY\' (ex: \'01-JAN-08\')');
		return false;
	}else{
		var erDate = new Date();
		//check to make sure it's a valid date
		//fail anytime there are more than 31 days entered
		if(dateParts[0] > 31)
		{
			alert('Invalid date');
			return false;
		}
		//make sure they don't put the 31st on a month that only has 30 days
		if(dateParts[0] > 30)
		{
			//fail if it is any of these months because they only have (at most) 30 days
			if((dateParts[1].toString().toUpperCase() == 'FEB') || (dateParts[1].toString().toUpperCase() == 'APR') || (dateParts[1].toString().toUpperCase() == 'JUN') || (dateParts[1].toString().toUpperCase() == 'SEP') || (dateParts[1].toString().toUpperCase() == 'NOV'))
			{
				alert('Invalid date');
				return false;
			}
		}
		//special case for Feb, since it NEVER has 30 days
		if(dateParts[0] == 30 && dateParts[1].toString().toUpperCase() == 'FEB')
		{
			alert('Invalid date');
			return false;
		}
		//if they entered Feb 29th, make sure it's a leap year (divisible by 4)
		if(dateParts[0] == 29 && dateParts[1].toString().toUpperCase() == 'FEB')
		{
			//check for leap year
			if(dateParts[2]%4)
			{
				alert('Invalid date');
				return false;
			}
		}
		
		//date looks good
		return true;
	}
}

//<
//  FUNCTION Name: showMyCalendar(txtId, imgId)
//    Description: Show Calendar (uses JS Calendar)
//     Parameters: txtId - calendar text
//				   imgId - calendar image
//        Returns: true/false
//  Relationships: 
//       Comments: uses dd-mon-yy format
//>
function showMyCalendar(txtId, imgId)
{
	var txt = document.getElementById(txtId);
	var img = document.getElementById(imgId);
	if (_dynarch_popupCalendar != null)
	{
		_dynarch_popupCalendar.hide();
	}
	else
	{
		var cal = new Calendar(0, null, cal_Selected, cal_Close);

		cal.weekNumbers = false;
		cal.showsOtherMonths = true;
		cal.setRange(1900, 2070);
		cal.setDateFormat("%e-%b-%y");
		cal.create();
		_dynarch_popupCalendar = cal;
	}
	_dynarch_popupCalendar.parseDate(txt.value);
	_dynarch_popupCalendar.sel = txt;
	_dynarch_popupCalendar.showAtElement(img, "Br");

	return false;
}

function setConflict(result)
{
	var id = result.split(',')[0];
	var myTD = result.split(',')[1];

	if(id != 'nc')
	{
		if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'G')
		{			
			document.getElementById('conflicts_' + id.split('_')[2] + '_' + id.split('_')[1]).style.display='';
			var i=0;
			var yellowID;
			
			//find which option is the "Y" option - this could be hardcoded, but it's something you'd have to keep up with if you changed the order
			while(i<document.getElementById(id).options.length)
			{
				//added kind of a hidden value for when assets are yellow only because of conflicts - WBG ("would be green")
				if((document.getElementById(id).options[i].value == 'Y') || (document.getElementById(id).options[i].value == 'WBG'))
				{
					yellowID = i;
				}
				i++;
			}
			document.getElementById(id).selectedIndex = yellowID;
			document.getElementById(myTD).style.backgroundColor = 'yellow';
		}else{
			if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'Y')
			{
				document.getElementById(myTD).style.backgroundColor = 'yellow';
			}
		}
	}else{
		id = result.split(',')[1];
		myTD = result.split(',')[2];
		document.getElementById(myTD).style.backgroundColor = 'green';
		document.getElementById('mainBoxscoreTable').style.filter = 'alpha(opacity=100)';
		document.forms('boxScore').btnSave.disabled = 0;
		toggleDropDown('');
	}
}

function closeOtherWindows()
{
	//close any windows that might be open for resolving other conflicts
	var divs = document.getElementsByTagName('div');

	var i=0;
	for(i=0; i<divs.length; i++)
	{
		if(divs[i].id.substr(0, 10) == 'conflicts_')
		{
			divs[i].style.display = 'none';
		}
	}
	
	//clear any forms that might have been checked - I'm only allowing them to work with one asset at a time
	var chks = document.getElementsByTagName('input');
	var i=0;
	for(i=0; i<chks.length; i++)
	{
		//if(chks[i].id.substr(0, 14) == 'frm_conflicts_')
		if(chks[i].getAttribute("type") == "checkbox")
		{
			chks[i].checked = 0;
		}
	}
}

function resolveConflictResult(assetInfo)
{
	if(assetInfo.split('_').length == 2)
	{
		alert('Conflict Resolved!');
		updateConflictList(assetInfo.split('_')[0], assetInfo.split('_')[1]);
	}else{
		alert('There was a problem resolving the conflict');
	}
}

function updateConflictList(assetID, assetType)
{
	DWREngine._execute(_cfscriptLocation, null, 'updateConflictLists', document.getElementById('hdn_missionID_pk').value, document.getElementById('hdn_missionID').value, assetID, assetType, updateConflictListBox);
}

function updateConflictListBox(completeList)
{
	var overallList = completeList.split(';')[0];
	var assetConflictList = completeList.split(';')[1];
	var assetID = completeList.split(';')[2];
	var assetType = completeList.split(';')[3];
	
	/*if(overallList.length)
	{
		document.getElementById('allConflicts').value = 'Conflicts: ' + overallList;
	}else{
		document.getElementById('allConflicts').style.display = 'none';
	}
	
	if(assetConflictList.length)
	{
		document.getElementById('input_conflicts_' + assetType + '_' + assetID).value = 'Conflicts: ' + assetConflictList;
	}else{
		document.getElementById('input_conflicts_' + assetType + '_' + assetID).style.display='none';
	}*/
}

/*******	FUNCTIONS TO SUPPORT THE BOXSCORE REPORT *****************/
//We don't allow assets that have conflicts to be set to green, so if they try, we re-set it to yellow
//Also, to make the report stand out more, we get the background color of the table cell to match the g/r/y status of the drop-down

//the thinking behind this is that, I know which assets have conflicts when I load the page.  However, I'm going to be using
//the form to resolve conflicts.  In order to avoid making round-trips to the server and losing the state(s) of the other
//drop-down lists, we do it all via ajax.
var stillHasConflicts=0;
//this function only gets ran for assets that have conflicts when we load the page initially.
//if they try to set the status to green, we run a query via ajax to see if it's still part of a conflict.  if so, we don't let them set it to green.
//since they will also use this form to resolve queries, we can't just assume the asset has conflicts the whole time it's loaded - we have to 
//query to make sure the conflicts haven't been resolved.
function checkConflicts(id, hasConflicts, myTD, assetID, asset_type)
{	
	closeOtherWindows();
	if(hasConflicts > 0 && document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'G')
	{
		//check to see if it's still a conflict
		//change the look of the form to let the user know it's working
		document.getElementById('mainBoxscoreTable').style.filter = 'alpha(opacity=15)';
		//hide the "ilc status" drop-downs because they will otherwise show through the conflict "window"
		toggleDropDown('none');
		//run query to see if it's still part of a conflict
		DWREngine._execute(_cfscriptLocation, null, 'checkNewConflicts', id, myTD, assetID, asset_type, idSelected, setConflict);
	}else{
		if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'Y')
		{
			document.getElementById(myTD).style.backgroundColor = 'yellow';
		}else if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'G')
		{
			document.getElementById(myTD).style.backgroundColor = 'green';
		}else if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'R')
		{
			document.getElementById(myTD).style.backgroundColor = 'red';
		}else if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'nr')
		{
			document.getElementById(myTD).style.backgroundColor = 'white';
		}else if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'WBG')
		{
			document.getElementById(myTD).style.backgroundColor = 'yellow';
			document.getElementById(myTD).style.border = '';
			document.getElementById(id).options[document.getElementById(id).selectedIndex].value = 'Y';
		}
	}
	
	if(myTD.substr(0, 13) == 'td_ilcstatus_')
	{
		if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'R' && (document.forms['boxScore'].elements['summaryBETDStatus'].selectedIndex == 1 || document.forms['boxScore'].elements['summaryBETDStatus'].selectedIndex == 0))
		{
			document.forms['boxScore'].elements['summaryBETDStatus'].selectedIndex = 2;
		}else if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'Y' && document.forms['boxScore'].elements['summaryBETDStatus'].selectedIndex != 2){
			document.forms['boxScore'].elements['summaryBETDStatus'].selectedIndex = 1;
		}
	}else{
		if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'R' && (document.forms['boxScore'].elements['summaryStatus'].selectedIndex == 1 || document.forms['boxScore'].elements['summaryStatus'].selectedIndex == 0))
		{
			document.forms['boxScore'].elements['summaryStatus'].selectedIndex = 2;
		}else if(document.getElementById(id).options[document.getElementById(id).selectedIndex].value == 'Y' && document.forms['boxScore'].elements['summaryStatus'].selectedIndex != 2){
			document.forms['boxScore'].elements['summaryStatus'].selectedIndex = 1;
		}
	}
	
}


//this is kinda a cludge, but we added the "ILC Status" drop-down column at the last minute.  IE has a bug where drop-down boxes show through
//layers that are floating above them.  In order to combat this, we will have to hide all of the "ilc status" drop-downs when we display the 
//Conflict Resolution div
function toggleDropDown(displayType)
{
	var i=0;
	
	while(i<document.forms['boxScore'].elements.length)
	{
		if((document.forms['boxScore'].elements[i].id.substr(0,13) == 'ilcstatus_ra_') || (document.forms['boxScore'].elements[i].id.substr(0,13) == 'ilcstatus_nr_'))
		{
			document.forms['boxScore'].elements[i].style.display=displayType;
		}
		i++;
	}
}

//function to validate the worksheet.  All status's must be set and, if red, they must have some text in the "Impact/Action Plan" field
function validate_boxscore()
{				
	var i=0;
	var assetIDList='', assetTypeList='', statusList='', ilcStatusList='', actionPlan='';
	var newEventNames='', newEventDates='', newDocs='', newDocDates='', newDocStatuses='';
	var existingEventIDs='', existingEventNames='', existingEventDates='', existingDocIDs='', existingDocs='', existingDocDates='', existingDocStatuses='';
	
	// if "Current" or "BETD" is not green, user must provide action plan
	if((document.forms['boxScore'].summaryStatus[document.forms['boxScore'].summaryStatus.selectedIndex].value != 'G' || document.forms['boxScore'].summaryBETDStatus[document.forms['boxScore'].summaryBETDStatus.selectedIndex].value != 'G') && !document.forms['boxScore'].summaryComments.value.length)
	{
		alert('If Current Status or BETD Plan is not green, you must enter an impact/action plan');
		return false;
	}
	
	while(i<document.forms['boxScore'].elements.length)
	{
		if((document.forms['boxScore'].elements[i].id.substr(0,10) == 'status_ra_') || (document.forms['boxScore'].elements[i].id.substr(0,10) == 'status_nr_') || (document.forms['boxScore'].elements[i].id.substr(0,13) == 'ilcstatus_ra_') || (document.forms['boxScore'].elements[i].id.substr(0,13) == 'ilcstatus_nr_'))
		{				
			if(document.forms['boxScore'].elements[i].selectedIndex == -1)
			{
				alert('You must set a status for every asset');

				document.forms['boxScore'].elements[document.forms['boxScore'].elements[i].id].focus();
				return false;
			}
			
			//also check to make sure wherever there's a RED status that the user inputs some kind of text in the "Action Plan" textbox
			if(document.forms['boxScore'].elements[document.forms['boxScore'].elements[i].id].options[document.forms['boxScore'].elements[i].selectedIndex].value == 'R' || document.forms['boxScore'].elements[document.forms['boxScore'].elements[i].id].options[document.forms['boxScore'].elements[i].selectedIndex].value == 'Y' || document.forms['boxScore'].elements[document.forms['boxScore'].elements[i].id].options[document.forms['boxScore'].elements[i].selectedIndex].value == 'WBG')
			{
				var thisID = 'actionPlan_' + document.forms['boxScore'].elements[i].id.split('_')[1] + '_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(document.forms['boxScore'].elements[thisID].value.length == 0)
				{
					alert('Any Yellow or Red statuses must have an action plan');
					document.forms['boxScore'].elements[thisID].focus();
					return false;
				}
			}
		}
		
		if((document.forms['boxScore'].elements[i].id.substr(0,24) == 'input_newOtherEventName_') || (document.forms['boxScore'].elements[i].id.substr(0,29) == 'input_ExistingOtherEventName_'))
		{
			if(document.forms['boxScore'].elements[i].value.length == 0)
			{
				alert('You must enter a name for all events on the Key Events Schedule');
				document.forms['boxScore'].elements[i].focus();
				return false;
			}
		}
		
		if((document.forms['boxScore'].elements[i].id.substr(0,24) == 'input_newOtherEventDate_') || (document.forms['boxScore'].elements[i].id.substr(0,29) == 'input_ExistingOtherEventDate_'))
		{					
			if(!(document.forms['boxScore'].elements[i].value.length))
			{
				alert('You must enter a date for all events on the Key Events Schedule');
				document.forms['boxScore'].elements[i].focus();
				return false;						
			}else if(!validate_date(document.forms['boxScore'].elements[i].value))
			{
				document.forms['boxScore'].elements[i].focus();
				return false;
			}
		}
		
		//copy data to js lists for xfer to cffunction
		if(document.forms['boxScore'].elements[i].id.substr(0,7) == 'status_')
		{
			if(!assetIDList.length)
			{
				assetIDList = document.forms['boxScore'].elements[i].id.split('_')[2]
				assetTypeList = document.forms['boxScore'].elements[i].id.split('_')[1]
				statusList = document.forms['boxScore'].elements[i].value;
				
				var thisID = 'ilc' + document.forms['boxScore'].elements[i].id;
				ilcStatusList = document.forms['boxScore'].elements[thisID].value;
				
				var thisID = 'actionPlan_' + document.forms['boxScore'].elements[i].id.split('_')[1] + '_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(document.forms['boxScore'].elements[thisID].value.replace(/\|/g, ' ').length)
				{
					actionPlan = document.forms['boxScore'].elements[thisID].value.replace(/\|/g, ' ').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&');
					
				}else{
					actionPlan = '_';
				}
				
			}else{
				assetIDList += '|' + document.forms['boxScore'].elements[i].id.split('_')[2];
				assetTypeList += '|' + document.forms['boxScore'].elements[i].id.split('_')[1];
				statusList += '|' + document.forms['boxScore'].elements[i].value;
				
				var thisID = 'ilc' + document.forms['boxScore'].elements[i].id;
				ilcStatusList += '|' + document.forms['boxScore'].elements[thisID].value;
				
				var thisID = 'actionPlan_' + document.forms['boxScore'].elements[i].id.split('_')[1] + '_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(document.forms['boxScore'].elements[thisID].value.replace(/\|/g, ' ').length)
				{
					actionPlan += '|' + document.forms['boxScore'].elements[thisID].value.replace(/\|/g, ' ').replace(/`/g, '\'').replace(/"/g, '\'').replace(/#/g, '&lb;&');
				}else{
					actionPlan += '|' + '_';
				}
			}
		}
		
		if(document.forms['boxScore'].elements[i].id.substr(0,24) == 'input_newOtherEventName_')
		{
			if(!newEventNames.length)
			{
				//newEventNames = document.forms['boxScore'].elements[i].value;
				newEventNames = document.forms['boxScore'].elements[i].value.split("|").join("");
				var dateID = 'input_newOtherEventDate_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(validate_date(document.forms['boxScore'].elements[dateID].value))
				{
					newEventDates = document.forms['boxScore'].elements[dateID].value;
				}else{
					alert('You must enter a valid date');
					return false;
				}
			}else{
				newEventNames += '|' + document.forms['boxScore'].elements[i].value.split("|").join("");
				var dateID = 'input_newOtherEventDate_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(validate_date(document.forms['boxScore'].elements[dateID].value))
				{
					newEventDates += '|' + document.forms['boxScore'].elements[dateID].value;
				}else{
					alert('You must enter a valid date');
					return false;
				}
			}
		}
		
		if(document.forms['boxScore'].elements[i].id.substr(0,29) == 'input_ExistingOtherEventName_')
		{
			if(!existingEventIDs.length)
			{
				existingEventIDs = document.forms['boxScore'].elements[i].id.split('_')[2];
				existingEventNames = document.forms['boxScore'].elements[i].value.split("|").join("");
				var dateID = 'input_ExistingOtherEventDate_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(validate_date(document.forms['boxScore'].elements[dateID].value))
				{
					existingEventDates = document.forms['boxScore'].elements[dateID].value;
				}else{
					alert('You must enter a valid date');
					return false;
				}				
			}else{
				existingEventIDs += '|' + document.forms['boxScore'].elements[i].id.split('_')[2];
				existingEventNames += '|' + document.forms['boxScore'].elements[i].value.split("|").join("");
				var dateID = 'input_ExistingOtherEventDate_' + document.forms['boxScore'].elements[i].id.split('_')[2];
				if(validate_date(document.forms['boxScore'].elements[dateID].value))
				{
					existingEventDates += '|' + document.forms['boxScore'].elements[dateID].value;
				}else{
					alert('You must enter a valid date');
					return false;
				}
			}
		}
		
		
		if(document.forms['boxScore'].elements[i].id.substr(0,18) == 'input_ExistingDoc_')
		{	
			if(document.forms['boxScore'].elements[i].value.length)
			{
				if(!existingDocs.length)
				{
					existingDocs = document.forms['boxScore'].elements[i].value.split("|").join("");
					existingDocIDs = document.forms['boxScore'].elements[i].id.split('_')[2];
				}else{
					existingDocs += '|' + document.forms['boxScore'].elements[i].value.split("|").join("");
					existingDocIDs += '|' + document.forms['boxScore'].elements[i].id.split('_')[2];
				}
			}else{
				alert('You must enter a title for the document');
				document.forms['boxScore'].elements[i].focus();
				return false;
			}
		}
		
		if(document.forms['boxScore'].elements[i].id.substr(0,22) == 'input_ExistingDocDate_')
		{
			if(document.forms['boxScore'].elements[i].value.length && validate_date(document.forms['boxScore'].elements[i].value))
			{
				if(!existingDocDates.length)
				{
					existingDocDates = document.forms['boxScore'].elements[i].value.split("|").join("");
				}else{
					existingDocDates += '|' + document.forms['boxScore'].elements[i].value.split("|").join("");
				}
			}else{
				alert('You must enter a valid date in the format of dd-mmm-yy for the document');
				document.forms['boxScore'].elements[i].focus();
				return false;
			}
		}
		
		if(document.forms['boxScore'].elements[i].id.substr(0,24) == 'input_ExistingDocStatus_')
		{
			if(!existingDocStatuses.length)
			{
				existingDocStatuses = document.forms['boxScore'].elements[i].value;
			}else{
				existingDocStatuses += '|' + document.forms['boxScore'].elements[i].value;
			}
		}
		
		if(document.forms['boxScore'].elements[i].id.substr(0,22) == 'input_newDocumentName_')
		{
			if(document.forms['boxScore'].elements[i].value.length)
			{
				if(!newDocs.length)
				{
					newDocs = document.forms['boxScore'].elements[i].value.split("|").join("");
				}else{
					newDocs += '|' + document.forms['boxScore'].elements[i].value.split("|").join("");
				}
			}else{
				alert('You must enter a title for the document');
				document.forms['boxScore'].elements[i].focus();
				return false;
			}
		}
		
		if(document.forms['boxScore'].elements[i].id.substr(0,22) == 'input_newDocumentDate_')
		{
			if(document.forms['boxScore'].elements[i].value.length && validate_date(document.forms['boxScore'].elements[i].value))
			{
				if(!newDocDates.length)
				{
					newDocDates = document.forms['boxScore'].elements[i].value;
				}else{
					newDocDates += '|' + document.forms['boxScore'].elements[i].value;
				}
			}else{
				alert('You must enter a valid date in the format of dd-mmm-yy for the document');
				document.forms['boxScore'].elements[i].focus();
				return false;
			}
		}
		
		
		if(document.forms['boxScore'].elements[i].id.substr(0,21) == 'dd_newDocumentStatus_')
		{
			if(!newDocStatuses.length)
			{
				newDocStatuses = document.forms['boxScore'].elements[i].value;
			}else{
				newDocStatuses += '|' + document.forms['boxScore'].elements[i].value;
			}
		}
		
		i++;
	}	


<!--- changes for allowing "NA" on the static boxscore dates --->	
	if(document.forms['boxScore'].etpr_date.value != 'NA' && document.forms['boxScore'].etpr_date.value != 'TBD')
	{
		if(!validate_date(document.forms['boxScore'].etpr_date.value))
		{
			alert('You must either enter a valid date, \"TBD\" or "NA" for ETPR Date');
			return false;
		}
	}
	
	if(document.forms['boxScore'].etr_date.value != 'NA' && document.forms['boxScore'].etr_date.value != 'TBD')
	{
		if(!validate_date(document.forms['boxScore'].etr_date.value))
		{
			alert('You must either enter a valid date, \"TBD\" or "NA" for ETR Date');
			return false;
		}
	}
	
	if(document.forms['boxScore'].emr_date.value != 'NA' && document.forms['boxScore'].emr_date.value != 'TBD')
	{
		if(!validate_date(document.forms['boxScore'].emr_date.value))
		{
			alert('You must either enter a valid date, \"TBD\" or "NA" for EMR Date');
			return false;
		}
	}
<!--- /changes for allowing "NA" on the static boxscore dates --->
	
	DWREngine._execute(_cfscriptLocation, null, 'updBoxscoreWorksheet', 
							idSelected, 
							assetIDList, 
							assetTypeList, 
							statusList, 
							ilcStatusList, 
							actionPlan, 
							document.forms['boxScore'].etpr_date.value, 
							document.forms['boxScore'].etr_date.value,
							document.forms['boxScore'].emr_date.value,
							document.forms['boxScore'].hdn_otherEventsDeleted.value,
							document.forms['boxScore'].hdn_docsDeleted.value.substr(0, document.forms['boxScore'].hdn_docsDeleted.value.length-1),

							newEventNames.split("#").join("##").split('\"').join("'"),
							newEventDates,
							existingEventIDs,
							existingEventNames.split("#").join("##").split('\"').join("'"),
							existingEventDates,
							existingDocIDs,
							existingDocs.split("#").join("##").split('\"').join("'"),
							existingDocDates,
							existingDocStatuses,
							newDocs.split("#").join("##").split('\"').join("'"),
							newDocDates,
							newDocStatuses,
							document.forms['boxScore'].elements['summaryStatus'].options[document.forms['boxScore'].elements['summaryStatus'].selectedIndex].value,
							document.forms['boxScore'].elements['summaryBETDStatus'].options[document.forms['boxScore'].elements['summaryBETDStatus'].selectedIndex].value,
							document.forms['boxScore'].elements['summaryComments'].value.replace(/#/g, '##').replace(/"/g, '\''),
							document.forms['boxScore'].boxscoreVersionNumber.value.split("#").join("##").split('\"').join("'"),
							<!---document.forms['boxScore'].elements['trmName'].value.replace(/#/g, '##').replace(/"/g, '\''),--->
							document.forms['boxScore'].elements['trmID'].options[document.forms['boxScore'].elements['trmID'].selectedIndex].value,
							updateBoxscore);
	//alert(document.forms['boxScore'].elements['trmName'].options[document.forms['boxScore'].elements['trmName'].selectedIndex].value);
}

///function to add entries to the "Other Key Events" table
function addOtherEvents()
{
	var theTable = document.getElementById('tbl_Schedule');
	num_rows = theTable.rows.length;
	var row_event = document.createElement('tr');
	row_event.id = 'row_' + num_rows;
	row_event.style.backgroundColor = 'white';
	
	//create cells to hold new row
	var cell_eventName = document.createElement('td');
	cell_eventName.id = 'cell_otherEventName_' + num_rows;
	cell_eventName.innerHTML = '<a onclick=\"javascript:deleteUnsavedEvent(\'' + row_event.id + '\');\" style=\"font-size:9px;color:blue;text-decoration:underline;cursor:pointer\"><img border=\"0\" src=\'images/document_delete16.gif\'></a>&nbsp;';
	var cell_eventDate = document.createElement('td');
	cell_eventDate.id = 'cell_otherEventDate_' + num_rows;
	
	//create form elements to input data
	var input_eventName = document.createElement('input');
	input_eventName.type = 'text';
	input_eventName.id = 'input_newOtherEventName_' + num_rows;
	input_eventName.name = 'input_newOtherEventName_' + num_rows;
	input_eventName.size = 10;
	input_eventName.maxLength = 20;
	input_eventName.className = 'missiondefTextSmall';
	var input_eventDate = document.createElement('input');
	input_eventDate.type = 'text';
	input_eventDate.size = 7;
	input_eventDate.maxLength = 10;
	input_eventDate.id = 'input_newOtherEventDate_' + num_rows;
	input_eventDate.name = 'input_newOtherEventDate_' + num_rows;
	input_eventDate.className = 'missiondefTextSmall';
	
	var input_eventDatePicker = document.createElement('input');
	input_eventDatePicker.id = 'btn' + input_eventDate.id;
	input_eventDatePicker.type = 'image';
	input_eventDatePicker.src = 'jscalendar-1.0/img.gif';
	input_eventDatePicker.onclick = function(){return showMyCalendar(input_eventDate.id, input_eventDatePicker.id);};
	
	cell_eventName.appendChild(input_eventName);
	cell_eventDate.appendChild(input_eventDate);
	cell_eventDate.appendChild(input_eventDatePicker);
	
	row_event.appendChild(cell_eventName);
	row_event.appendChild(cell_eventDate);
	theTable.tBodies[0].appendChild(row_event);
}


function addDocument()
{	
	var theTable = document.getElementById('tbl_documents');
	num_rows = theTable.rows.length;
	var row_item = document.createElement('tr');
	row_item.id = 'row_item_' + num_rows;
	row_item.style.backgroundColor = 'white';
	
	//create cells to hold new row
	var cell_itemName = document.createElement('td');
	cell_itemName.id = 'cell_document_' + num_rows;
	cell_itemName.innerHTML = '<a onclick=\"javascript:deleteUnsavedEvent(\'' + row_item.id + '\');\" style=\"font-size:9px;color:blue;text-decoration:underline;cursor:pointer\"><img border=\"0\" src=\'images/document_delete16.gif\'></a>';
	
	//create form elements to input data
	var input_itemName = document.createElement('input');
	input_itemName.type = 'text';
	input_itemName.id = 'input_newDocumentName_' + num_rows;
	input_itemName.name = 'input_newDocumentName_' + num_rows;
	input_itemName.size = 10;
	input_itemName.maxLength = 50;
	input_itemName.className = 'missiondefTextSmall';
	input_itemName.onchange = function(){formChanged='boxscore';};
	
	cell_itemName.appendChild(input_itemName);
	
	var cell_eventDate = document.createElement('td');
	cell_eventDate.id = 'cell_newDocumentDate_' + num_rows;
	
	var input_eventDate = document.createElement('input');
	input_eventDate.type = 'text';
	input_eventDate.size = 5;
	input_eventDate.maxLength = 10;
	input_eventDate.id = 'input_newDocumentDate_' + num_rows;
	input_eventDate.name = 'input_newDocumentEventDate_' + num_rows;
	input_eventDate.className = 'missiondefTextSmall';
	input_eventDate.onchange = function(){formChanged='boxscore';};
	
	var input_eventDatePicker = document.createElement('input');
	input_eventDatePicker.id = 'btn' + input_eventDate.id;
	input_eventDatePicker.type = 'image';
	input_eventDatePicker.src = 'jscalendar-1.0/img.gif';
	input_eventDatePicker.onclick = function(){return showMyCalendar(input_eventDate.id, input_eventDatePicker.id);};
	
	cell_eventDate.appendChild(input_eventDate);
	cell_eventDate.appendChild(input_eventDatePicker);
	
	var cell_status = document.createElement('td');
	cell_status.id = 'cell_newDocumentStatus_' + num_rows;
	
	var dd_status = document.createElement('select');
	dd_status.id = 'dd_newDocumentStatus_' + num_rows;
	var op_status_green = document.createElement('option');
	op_status_green.value = 'G';
	op_status_green.text = 'G';
	op_status_green.style.backgroundColor = 'green';
	var op_status_yellow = document.createElement('option');
	op_status_yellow.value = 'Y';
	op_status_yellow.text = 'Y';
	op_status_yellow.style.backgroundColor = 'yellow';
	var op_status_red = document.createElement('option');
	op_status_red.value = 'R';
	op_status_red.text = 'R';
	op_status_red.style.backgroundColor = 'red';
	
	dd_status.options.add(op_status_green);
	dd_status.options.add(op_status_yellow);
	dd_status.options.add(op_status_red);
	dd_status.onchange = function(){formChanged='boxscore';};
	
	cell_status.align='center';
	cell_status.appendChild(dd_status);
	
	row_item.appendChild(cell_itemName);
	row_item.appendChild(cell_eventDate);
	row_item.appendChild(cell_status);
	theTable.tBodies[0].appendChild(row_item);
	
}

//function to remove events that were just added and haven't been saved yet
function deleteUnsavedEvent(id)
{
	var parent = document.getElementById(id).parentNode;
	parent.removeChild(document.getElementById(id));				
}

//function to remove events that were pre-existing
function deleteSavedEvent(id, hiddenID)
{
	var parent = document.getElementById(id).parentNode;
	var eventID = id.split('_')[2];
	parent.removeChild(document.getElementById(id));	
	document.forms['boxScore'].elements[hiddenID].value += eventID + ',';
}

//function to resolve conflicts from the boxscore report
function submitResolve(assetID, assetType, ddID, myTD)
{
	var fieldName = 'frm_conflicts_' + assetID + '_' + assetType;
	var spanName;
	var i=0;
	var checkedConflicts = '';
	var stillSome = false;
	
	//weird thing where a checkbox list is only an array if there are multiple items
	if(typeof(document.forms['boxScore'].elements[fieldName].length)!="undefined")
	{ 	
		for(i=0; i<document.forms['boxScore'].elements[fieldName].length; i++)
		{
			//loop through and only pay attention to conflicts that are checked
			if(document.forms['boxScore'].elements[fieldName][i].checked)
			{
				//span to be hidden once it's resolved
				spanName = 'span_conflicts_' + assetID + '_' + assetType + '_' + document.forms['boxScore'].elements[fieldName][i].value;
				//add to conflict list
				checkedConflicts += document.forms['boxScore'].elements[fieldName][i].value + '|';
				//hide the conflict
				document.getElementById(spanName).style.display = 'none';
				document.forms['boxScore'].elements[fieldName][i].style.display = 'none';
			}else{
				if(document.forms['boxScore'].elements[fieldName][i].style.display != 'none')
				{
					stillSome = true;
				}
			}
		}
		if(!stillSome)
		{
			document.forms['boxScore'].elements[ddID].selectedIndex = 0;
			document.getElementById(myTD).style.backgroundColor = 'green';
			document.getElementById(myTD).style.border = 'none';
		}
	//there was only one conflict for the asset
	}else{
		checkedConflicts = document.forms['boxScore'].elements[fieldName].value;
		//span to be hidden once it's resolved
		spanName = 'span_conflicts_' + assetID + '_' + assetType + '_' + checkedConflicts;
		//hide the conflict
		document.getElementById(spanName).style.display = 'none';
		document.forms['boxScore'].elements[ddID].selectedIndex = 0;
		document.getElementById(myTD).style.backgroundColor = 'green';
		document.getElementById(myTD).style.border = 'none';
	}
	//resolve the conflict(s)
	DWREngine._execute(_cfscriptLocation, null, 'resolveConflictsFromBoxscore', assetID, assetType, checkedConflicts, '<cfoutput>#session.username#</cfoutput>', resolveConflictResult);
}

function checkStatus(type)
{
	var i=0;
	var lowestRated = 'G';
	
	while(i<document.forms['boxScore'].elements.length)
	{
		if(document.forms['boxScore'].elements[i].id.substr(0, type.length) == type)
		{
			if(document.forms['boxScore'].elements[i].value == 'Y' || document.forms['boxScore'].elements[i].value == 'WBG')
			{
				lowestRated = 'Y';
			}else if(document.forms['boxScore'].elements[i].value == 'R')
			{
				lowestRated = 'R';
				break;
			}
		}
		i++;
	}
	
	return(lowestRated);	
}

function setStatus(lowestRated, overall_type)
{
	//lowest ranking is R
	if(lowestRated == 'R' && (document.forms['boxScore'].elements[overall_type].options[0].selected || document.forms['boxScore'].elements[overall_type].options[1].selected))
	{
		alert('Because you have individual statuses that are red, the overall status must also be red');
		document.forms['boxScore'].elements[overall_type].options[2].selected = true;
	}else if(lowestRated == 'Y' && document.forms['boxScore'].elements[overall_type].options[0].selected){
		alert('Because you have individual statuses that are yellow, the overall status must also be yellow or red');
		document.forms['boxScore'].elements[overall_type].options[1].selected = true;
	}
}

function updateBoxscore(success)
{
	if(success == 'true')
	{
		alert('Mission Boxscore Worksheet Updated!');
	}else{
		alert(success);
	}
	document.forms['boxScore'].btnSave.disabled = 0;
	DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', idSelected, setBoxscoreWorksheet);
}

function confirmConflictsChecked(fieldName)
{
	if(typeof(document.forms['boxScore'].elements[fieldName].length)!="undefined")
	{
		for(i=0; i<document.forms['boxScore'].elements[fieldName].length; i++)
		{
			if(document.forms['boxScore'].elements[fieldName][i].checked)
			{
				return true;
			}
		}
	}else{
		if(document.forms['boxScore'].elements[fieldName].checked)
		{
			return true;
		}
	}
	return false;
}

/*******	/FUNCTIONS TO SUPPORT THE BOXSCORE REPORT *****************/

// function to expand/collapse the System Under Test area of the TCS Worksheet by elements
function toggleElementAssets(elementID, visible, newPrefix)
{
	var table = document.getElementById(newPrefix + "elementsTable");   
	var rows = table.getElementsByTagName("tr");  
	var i=0;
	
	//this is so I can use this function both for toggling the expand/collapse button
	//but also the initial expansion, based on what assets are checked
	if(!visible)
	{
		for(i=0; i<rows.length; i++)
		{
			if(rows[i].id == newPrefix + elementID)
			{
				if(rows[i].style.display == 'none')
				{
					rows[i].style.display='';
					document.getElementById(newPrefix + 'header_' + elementID).style.fontStyle = 'italic';
				}else{
					rows[i].style.display='none';
					document.getElementById(newPrefix + 'header_' + elementID).style.fontStyle = '';
				}
			}
		}
	//otherwise, just expand the button and don't toggle
	}else{
		for(i=0; i<rows.length; i++)
		{
			if(rows[i].id == newPrefix + elementID)
			{
				rows[i].style.display=visible;

				document.getElementById(newPrefix + 'header_' + elementID).style.fontStyle = 'italic';
			}
		}
	}
}

function changeFieldStatus(isChecked, configField, statusField)
{
	if(isChecked)
	{
		document.getElementById(configField).disabled = 0;
		document.getElementById(statusField).disabled = 0;
		document.getElementById(configField).style.backgroundColor = 'white';
		document.getElementById(statusField).style.backgroundColor = 'white';
	}else{
		document.getElementById(configField).value = '';
		document.getElementById(statusField).value = '';
		document.getElementById(configField).disabled = 1;
		document.getElementById(statusField).disabled = 1;
		document.getElementById(configField).style.backgroundColor = '#EFEFEF';
		document.getElementById(statusField).style.backgroundColor = '#EFEFEF';
	}
}

function toggleMultiple(elementList, display)
{
	var i=0;
	
	for(i=0; i<elementList.split(',').length; i++)
	{
		if(display == '')
		{
			document.getElementById('img_expand_' + elementList.split(',')[i]).src = 'menudir/collapsebtn.gif';
		}else{
			document.getElementById('img_expand_' + elementList.split(',')[i]).src = 'menudir/expandbtn.gif';
		}
		toggleElementAssets(elementList.split(',')[i], display, '');
	}
}

function checkImageType()
{
	var imageType = document.getElementById('txt_bmds_configuration').value.split('.')[document.getElementById('txt_bmds_configuration').value.split('.').length-1];
	
	if(imageType)
	{
		if(imageType.toUpperCase() == 'GIF' || imageType.toUpperCase() == 'JPG')
		{
			return true;
		}else{
			alert('BMDS Configuration must be either a GIF or JPEG file');
			return false;
		}
	}
}

function checkImageTypeATC()
{
	var imageType = document.getElementById('ATCdoc').value.split('.')[document.getElementById('ATCdoc').value.split('.').length-1];
	
	if(imageType)
	{
		if(imageType.toUpperCase() == 'PDF' || imageType.toUpperCase() == 'PDF')
		{
			return true;
		}else{
			alert('ATC Upload must be a PDF file');
			return false;
		}
	}
}

<!--- code to support static requirements documents --->
function set_uds_ors_document(missionObject)
{	
	document.getElementById("upload_uds_ors_document_id").innerHTML = missionObject.DIVUPLOADDOCS;
}

function toggleDeletedMissions(myDisplay)
{
	var rows = document.getElementsByTagName('tr');
	var i=0, numChanged = 0;
	var listOfDisplayed = new Array();
	
	for(i=0; i<rows.length; i++)
	{
		if(rows[i].id.substr(0, 8) == 'deleted_')
		{
			rows[i].style.display = myDisplay;
			numChanged++;
		}
	}
	
	//update the "Missions ()" count to reflect whether or not deleted missions are being displayed
	if(myDisplay == 'none')
	{
		document.getElementById('missionCount').innerHTML = parseInt(document.getElementById('missionCount').innerHTML) - numChanged;
	}else{
		document.getElementById('missionCount').innerHTML = parseInt(document.getElementById('missionCount').innerHTML) + numChanged;
	}
	
	//showing/hiding the deleted missions hoses up the striping, so re-stripe it
	restripeTable();
}

function restripeTable()
{
	var missionsTable = document.getElementById('myListTable');
	var rows = myListTable.getElementsByTagName('tr');
	var i=0;
	var listOfDisplayed = new Array();
	
	for(i=0; i<rows.length; i++)
	{
		if(rows[i].style.display != 'none')
		{
			listOfDisplayed[listOfDisplayed.length] = i;
		}
	}
	
	for(i=0; i<listOfDisplayed.length; i++)
	{		
		if(i%2)
		{
			rows[listOfDisplayed[i]].cells[0].className = 'missiondefTextSmallOdd';
			rows[listOfDisplayed[i]].cells[1].className = 'missiondefTextSmallOdd';
		}else{
			rows[listOfDisplayed[i]].cells[0].className = 'missiondefTextSmallEven';
			rows[listOfDisplayed[i]].cells[1].className = 'missiondefTextSmallEven';
		}
	}
}

function reloadFilterDefaults(thisForm)
{
	thisForm.leadrangelist.selectedIndex = 0;
	thisForm.elementslist.selectedIndex = 0;
	thisForm.likeClause.value = '';
	thisForm.showPastMissions.checked = true;
	thisForm.sortBy.selectedIndex = 0;
}

function refreshUploadedReqs(missionID)
{
	DWREngine._execute(_cfscriptLocation, null, 'get_uds_ors_documents', missionID, set_uds_ors_document);
}

function deleteReqDoc(docID, missionID)
{
	DWREngine._execute(_cfscriptLocation, null, 'delete_uds_ors_documents', docID, dummy);
	refreshUploadedReqs(missionID);
	alert('Document successfully deleted');
}

function showUDSDocuments()
{
	document.getElementById("missionDetails").style.display = "none";
	document.getElementById("newMission").style.display = "none";
	document.getElementById("pis_prd_documents").style.display = "";
	document.getElementById("lessonLearnedActionDiv").style.display = "none";
}

function deletePIDoc(docID, filename)
{
	DWREngine._execute(_cfscriptLocation, null, 'delete_PIS_documents', docID, filename, dummy);
	location.href="mpl_missions.cfm?showUDSDocs=1";
}


function deletePRDDoc(docID, filename)
{
	DWREngine._execute(_cfscriptLocation, null, 'delete_PRD_documents', docID, filename, dummy);
	location.href="mpl_missions.cfm?showUDSDocs=1";
}

function convertDate(myDate)
{
	var dateParts;
	dateParts = myDate.toString().split('-');
	
	var thisMonth = calcMonth(dateParts[1]);

	var thisDate = thisMonth + '/' + dateParts[0] + '/20' + dateParts[2];
	
	var erDate = new Date(thisDate);
	return erDate;
}

<!---LIMIT INPUT TEXT--->
function limitText(limitField,limitCount, limitNum)
{
	if (limitField.value.length > limitNum) 
	{
		limitField.value = limitField.value.substring(0, limitNum);
	} 
	else 
	{
		limitCount.value = limitNum - limitField.value.length;
	}
}

<!---ADD NEW LESSON LEARNED--->
function addLessonLearned(theForm, tableID, missionID, missionName)
{
	//var theClassName = "inputSheetText";
	//var theClassName2 = "inputSheetDate";
	var inputs = document.getElementsByTagName('input');
	var theLessonLearned = "lessonLearn";
	var theLessonLearned2 = "lessonLearn2";
	var theEquipment = "equipment";
	var theLimitText = "limitText";
	var inputBackGroundColor = 'oldlace';
	var theActionRequestedReminder = "actionRequestedReminder";
	var theNoRigthBorder = "noRightBorder";
	var inputSize = 10;
	var theTable = document.getElementById(tableID);
	var tempRow = 0;
	var listOfCurrentRowID = new Array();
	
	<!---GET THE MAX LESSON LEARNED ID--->
	for (i=0; i< inputs.length; i++)
	{
		if(document.forms[theForm].elements['lessonLearnedCurrentInputID'+i] != null)
		{	
			listOfCurrentRowID[i] = document.forms[theForm].elements['lessonLearnedCurrentInputID'+i].value;
		}	
		
		if(document.forms[theForm].elements['lessonLearnedInputID'+i] != null)
		{	
			listOfCurrentRowID[i] = document.forms[theForm].elements['lessonLearnedInputID'+i].value;	
		}				
	}

	if(typeof(listOfCurrentRowID[listOfCurrentRowID.length-1]) == 'undefined')
	{
		var row_id = 1;
	}
	else
	{
		//var row_id = parseInt(listOfCurrentRowID[listOfCurrentRowID.length-1]) + 1;
		var row_id= listOfCurrentRowID[1];
		for (i=1;i<listOfCurrentRowID.length;i++)
		{
			if(listOfCurrentRowID[i] != null)
			{
			row_id=Math.max(row_id,listOfCurrentRowID[i]);	
			}
		}
		row_id = row_id+1;
	}		
	
	//create table elements		
	var row_event = document.createElement('tr');
	//row_event.style.backgroundColor = 'lightgrey';
	row_event.id = 'rowLessonLearned_' + row_id;	
	row_event.style.verticalAlign = 'top';
	var td_id = document.createElement('td');
	
	var td_category = document.createElement('td');
	var td_timeline = document.createElement('td');
	var td_description = document.createElement('td');
	var td_disposition = document.createElement('td');
	var td_actionRequestedCheckbox = document.createElement('td');
	var td_actionRequested = document.createElement('td');
	//var td_actionRequestedReminder = document.createElement('td');
	td_actionRequested.style.verticalAlign = 'bottom';
	td_actionRequestedCheckbox.style.borderRight = '0px solid blue';
	td_actionRequested.style.borderLeft = '0px solid blue';
	
	row_event.appendChild(td_id);
	row_event.appendChild(td_category);
	row_event.appendChild(td_timeline);
	row_event.appendChild(td_description);
	row_event.appendChild(td_disposition);
	row_event.appendChild(td_actionRequestedCheckbox);
	row_event.appendChild(td_actionRequested);
	//row_event.appendChild(td_actionRequestedReminder);
	
	theTable.tBodies[0].appendChild(row_event);

	<!---IMAGE TO DELETE ROW--->
	var deleteRow = document.createElement('img');
	deleteRow.src = 'images/document_delete16.gif';
	deleteRow.onclick = function (){ removeLessonLearnedRow('rowLessonLearned_' + row_id, 0)};
	td_id.appendChild(deleteRow);

	<!---ID--->
	var llID = parseInt(row_id);// + parseInt(maxID);
	var idInput = document.createElement('input');
	idInput.type = 'text';
	idInput.size = inputSize;
	idInput.id = missionName + '-'+ llID;
	idInput.value = idInput.id;
	idInput.readOnly = 'readOnly';
	idInput.className = theLessonLearned;
	idInput.style.backgroundColor = inputBackGroundColor;
	idInput.style.border = 'transparent';
	td_id.appendChild(idInput);		

	<!---LESSON LEARNED ID--->
	var lessonLearnedInputID = document.createElement('input');
	lessonLearnedInputID.type = 'hidden';
	lessonLearnedInputID.size = inputSize;
	lessonLearnedInputID.id = 'lessonLearnedInputID'+llID;
	lessonLearnedInputID.value = llID;
	lessonLearnedInputID.disabled = 'disabled';
	lessonLearnedInputID.className = theLessonLearned2;
	td_id.appendChild(lessonLearnedInputID);

	<!---CALTEGORY--->
	var categoryInput = createCategoryDropDown(theForm, llID);
	//categoryInput.size = theClassSize;
	categoryInput.id  = categoryInput.name = 'categoryInput'+ llID;
	categoryInput.className = theLessonLearned;
	categoryInput.style.backgroundColor = inputBackGroundColor;
	td_category.appendChild(categoryInput);	
	//document.forms[theForm].elements[categoryInput.id].focus();
	
	<!---EQUIPMENT--->
	var equipmentInput = createEquipmentDropDown(missionID);
	equipmentInput.id  = equipmentInput.name = 'equipmentInput'+ llID;
	td_category.appendChild(equipmentInput);
	equipmentInput.className = theEquipment;
	equipmentInput.style.backgroundColor = inputBackGroundColor;
	document.getElementById('equipmentInput'+ llID).style.display='none';
	

	<!---TIMELINE--->
	var timelineInput = createTimelineDropDown();
	timelineInput.id = timelineInput.name = 'timelineInput'+ llID;
	timelineInput.value = '';
	timelineInput.className = theLessonLearned;
	timelineInput.style.backgroundColor = inputBackGroundColor;
	td_timeline.appendChild(timelineInput);

	<!---LIMIT CHARS--->
	var limitCountdown = document.createElement('input');
	limitCountdown.id = limitCountdown.name = 'limitCountdown'+ llID;
	limitCountdown.value = 255;
	limitCountdown.className = theLessonLearned;
	limitCountdown.size = 1;
	limitCountdown.readOnly = 'readOnly';
	//td_description.appendChild(limitCountdown);


	<!---DISPLAY TEXT--->
	var spanLimitText = document.createElement('span');
	spanLimitText.id = 'spanLimitText'+ llID;
	spanLimitText.className = theLimitText;
	spanLimitText.innerHTML = "characters left.";
	
	<!---DESCRIPTION--->
	var descriptionInput = document.createElement('textarea');
	descriptionInput.id = descriptionInput.name = 'descriptionInput'+ llID;
	descriptionInput.value = '';
	descriptionInput.className = theLessonLearned;
	descriptionInput.onkeydown= function(){limitText(descriptionInput,limitCountdown,inputTextLimit); };
	descriptionInput.onkeyup= function(){limitText(descriptionInput,limitCountdown,inputTextLimit); };
	descriptionInput.style.backgroundColor = inputBackGroundColor;
	td_description.appendChild(descriptionInput);
	
	/*For some reason, the new row always show on the the SECOND row on the table, by focusing to description, it forces to scroll down
	otherwise the user needs to scroll down to bottom of table to enter data to the new row*/
	document.forms[theForm].elements[descriptionInput.id].focus();
	document.forms[theForm].elements[categoryInput.id].focus();
	
	<!---BREAK LINE--->
	var lineBreak = document.createElement('<br/>');
	lineBreak.id = 'lineBreak'+ llID;
	td_description.appendChild(lineBreak);
	td_description.appendChild(limitCountdown);
	td_description.appendChild(spanLimitText);

	<!---DISPOSITION DISPLAY --->
	var dispositionDisplay = document.createElement('span');
	dispositionDisplay.id = 'dispositionDisplay'+ llID;
	dispositionDisplay.className = theLimitText;
	dispositionDisplay.innerHTML = "TBD";
	td_disposition.appendChild(dispositionDisplay);
	

	<!---DISPOSITION--->
	var dispositionInput = document.createElement('input');
	dispositionInput.id = 'disposition'+ llID;
	dispositionInput.type = 'hidden';
	dispositionInput.value = 'TBD';
	dispositionInput.readOnly = 'readOnly';
	dispositionInput.size = '1';
	dispositionInput.className = theLessonLearned;
	td_disposition.appendChild(dispositionInput);

	<!---ACTION REQUEST CHECKBOX--->
	var actionRequestedCheckboxInput = document.createElement('input');
	actionRequestedCheckboxInput.type = 'checkbox';
	actionRequestedCheckboxInput.name = 'actionRequestedCheckboxInput';
	actionRequestedCheckboxInput.id = 'actionRequestedCheckboxInput'+ llID;
	actionRequestedCheckboxInput.onclick = function (){ showHideActionRequestedText(theForm,llID)};
	td_actionRequestedCheckbox.appendChild(actionRequestedCheckboxInput);
	
	<!---ACTION REQUEST MESSAGE--->
	var actionRequestedReminder = document.createElement('textarea');
	//actionRequestedReminder.type = 'text';
	actionRequestedReminder.id = 'actionRequestedReminderID'+ llID;
	actionRequestedReminder.className = theActionRequestedReminder;
	actionRequestedReminder.verticalAlign = 'top';
	actionRequestedReminder.value = 'Select checkbox to request an action.';
	td_actionRequested.appendChild(actionRequestedReminder);
	document.getElementById('actionRequestedReminderID'+ llID).style.display='block';


	<!---LIMIT CHARS--->
	var limitCountdown2 = document.createElement('input');
	limitCountdown2.id = limitCountdown2.name = 'limitCountdown2'+ llID;
	limitCountdown2.value = 255;
	limitCountdown2.className = theLessonLearned;
	limitCountdown2.size = 1;
	//limitCountdown2.readOnly = 'readOnly';

	<!---DISPLAY TEXT--->
	var spanLimitText2 = document.createElement('span');
	spanLimitText2.id = 'spanLimitText2'+ llID;
	spanLimitText2.className = theLimitText;
	spanLimitText2.innerHTML = "characters left.";

	<!---BREAK LINE BREAK--->
	var lineBreak2 = document.createElement('<br/>');
	lineBreak2.id = 'lineBreak2'+ llID;

	
	<!---ACTION REQUEST TEXT--->
	var actionRequestedInput = document.createElement('textarea');
	actionRequestedInput.id = 'actionRequestedInput'+ llID;
	actionRequestedInput.className = theLessonLearned;
	actionRequestedInput.onkeydown= function(){limitText(actionRequestedInput,limitCountdown2,inputTextLimit);};
	actionRequestedInput.onkeyup= function(){limitText(actionRequestedInput,limitCountdown2,inputTextLimit);};
	td_actionRequested.appendChild(actionRequestedInput);
	document.getElementById(actionRequestedInput.id).style.display='none';
	td_actionRequested.appendChild(lineBreak2);
	td_actionRequested.appendChild(limitCountdown2);
	td_actionRequested.appendChild(spanLimitText2);
	actionRequestedInput.style.backgroundColor = inputBackGroundColor;
	document.getElementById(limitCountdown2.id).style.display='none';
	document.getElementById(spanLimitText2.id).style.display='none';	
	
	document.getElementById('btn_updateLesssonLearned').disabled = false;
	
}

function approveLessonLearned(theForm,missionID)
{
	var inputs = document.getElementsByTagName('input');
	var selects = document.getElementsByTagName('select');
	var rows = document.getElementsByTagName('td');
	
	var lessonLearnedCurrentInputID = '';
	var categoryCurrentInput = '';
	var equipmentCurrentInput = '';
	var assetIDCurrentInput = '';
	var assetTypeCurrentInput = '';	
	var timelineCurrentInput = '';
	var descriptionCurrentInput = '';
	var actionRequestedCurrentInput = '';
	
	var lessonLearnedInputID = '';
	var categoryInput = '';
	var equipmentInput = '';
	var assetIDInput = '';
	var assetTypeInput = '';
	var timelineInput = '';
	var descriptionInput = '';
	var actionRequestedInput = '';
	
	var delimiters = '`';

	for (i=0; i<= inputs.length; i++)
	{		
		<!---------------------------------------------------------------------------------------------------------------------->
		<!-------------------------------------------CURRENT DATA--------------------------------------------------------------->
		<!---------------------------------------------------------------------------------------------------------------------->
		
		if(document.forms[theForm].elements['lessonLearnedCurrentInputID'+i] != null)
		{
			lessonLearnedCurrentInputID = lessonLearnedCurrentInputID+document.forms[theForm].elements['lessonLearnedCurrentInputID'+i].value +delimiters;
			categoryCurrentInput = categoryCurrentInput+document.forms[theForm].elements['categoryCurrentInput'+i].value +delimiters;
			timelineCurrentInput = timelineCurrentInput+document.forms[theForm].elements['timelineCurrentInput'+i].value +delimiters;

			<!---VALIDATE CURRENT EQUIPMENT--->
			if(document.forms[theForm].elements['equipmentCurrentInput'+i] != null)
			{
				if(document.forms[theForm].elements['equipmentCurrentInput'+i].value == '0_zz' && document.forms[theForm].elements['categoryCurrentInput'+i].value == 1)
				{
					alert('Please select equipment.');
					document.getElementById(document.forms[theForm].elements['equipmentCurrentInput'+i].id).style.borderColor='red';
					document.forms[theForm].elements['equipmentCurrentInput'+i].focus();
					return false;		
				}
				else
				{
					equipmentCurrentInput = equipmentCurrentInput+document.forms[theForm].elements['equipmentCurrentInput'+i].value +delimiters;
					myString=document.forms[theForm].elements['equipmentCurrentInput'+i].value.split("_");	
					assetIDCurrentInput = assetIDCurrentInput + myString[0] + delimiters;
					assetTypeCurrentInput = assetTypeCurrentInput + myString[1] + delimiters;					
				}
			}
		}
			
		<!---VALIDATE CURRENT DESCRIPTION--->
		if(document.forms[theForm].elements['descriptionCurrentInput'+i] != null)
		{
			if(document.forms[theForm].elements['descriptionCurrentInput'+i].value == '')
			{
				alert('Please select description.');
				document.getElementById(document.forms[theForm].elements['descriptionCurrentInput'+i].id).style.borderColor='red';
				document.forms[theForm].elements['descriptionCurrentInput'+i].focus();
				return false;
			}
			else
			{	
				document.forms[theForm].elements['descriptionCurrentInput'+i].value = document.forms[theForm].elements['descriptionCurrentInput'+i].value.replace(/`/g, ' ');
				descriptionCurrentInput = descriptionCurrentInput+document.forms[theForm].elements['descriptionCurrentInput'+i].value +delimiters;
			}
		}

		<!---VALIDATE CURRENT ACTION REQUESTED--->
		if(document.forms[theForm].elements['actionRequestedCheckboxCurrentInput'+i] != null)
		{
			if(document.forms[theForm].elements['actionRequestedCheckboxCurrentInput'+i].checked == true)
			{
				if(document.forms[theForm].elements['actionRequestedCurrentInput'+i].value == '')
				{
					alert('Please select action requested.');
					document.getElementById(document.forms[theForm].elements['actionRequestedCurrentInput'+i].id).style.borderColor='red';
					document.forms[theForm].elements['actionRequestedCurrentInput'+i].focus();
					return false;
				}
				else
				{
					document.forms[theForm].elements['actionRequestedCurrentInput'+i].value = document.forms[theForm].elements['actionRequestedCurrentInput'+i].value.replace(/`/g, ' ');
					actionRequestedCurrentInput = actionRequestedCurrentInput+document.forms[theForm].elements['actionRequestedCurrentInput'+i].value +delimiters;
				}
			}
			else
			{
				actionRequestedCurrentInput = actionRequestedCurrentInput +delimiters;
			}			
		}		
		
		<!---------------------------------------------------------------------------------------------------------------------->
		<!-----------------------------------------------NEW DATA--------------------------------------------------------------->
		<!---------------------------------------------------------------------------------------------------------------------->	
		
		<!---STORE NEW LESSONLEARNED ID in ARRAY--->
		if(document.forms[theForm].elements['lessonLearnedInputID'+i] != null)
		{
			lessonLearnedInputID = lessonLearnedInputID+document.forms[theForm].elements['lessonLearnedInputID'+i].value +delimiters;
		}

		<!---VALIDATE CATEGORY--->
		if(document.forms[theForm].elements['categoryInput'+i] != null)
		{
			if(document.forms[theForm].elements['categoryInput'+i].value == '')
			{
				alert('Please select category.');
				document.getElementById(document.forms[theForm].elements['categoryInput'+i].id).style.borderColor='red';
				document.forms[theForm].elements['categoryInput'+i].focus();
				return false;
			}

			else
			{
				categoryInput = categoryInput+document.forms[theForm].elements['categoryInput'+i].value +delimiters;	
			}

			<!---VALIDATE EQUIPMENT--->
			if(document.forms[theForm].elements['equipmentInput'+i] != null)
			{
				if(document.forms[theForm].elements['equipmentInput'+i].value == '0_zz' && document.forms[theForm].elements['categoryInput'+i].value == 1)
				{
					alert('Please select equipment.');
					document.getElementById(document.forms[theForm].elements['equipmentInput'+i].id).style.borderColor='red';
					document.forms[theForm].elements['equipmentInput'+i].focus();
					return false;		
				}
				else
				{
					equipmentInput = equipmentInput+document.forms[theForm].elements['equipmentInput'+i].value +delimiters;
					myString=document.forms[theForm].elements['equipmentInput'+i].value.split("_");	
					assetIDInput = assetIDInput + myString[0] + delimiters;
					assetTypeInput = assetTypeInput + myString[1] + delimiters;
				}
			}

			<!---VALIDATE TIME LINE--->
			if(document.forms[theForm].elements['timelineInput'+i].value == '')
			{
				alert('Please select timeline.');
				document.getElementById(document.forms[theForm].elements['timelineInput'+i].id).style.borderColor='red';
				document.forms[theForm].elements['timelineInput'+i].focus();
				return false;
			}
			else
			{
				timelineInput = timelineInput+document.forms[theForm].elements['timelineInput'+i].value +delimiters;
			}

			<!---VALIDATE DESCRIPTION--->
			
			if(document.forms[theForm].elements['descriptionInput'+i].value == '')
			{
				alert('Please select description.');
				document.getElementById(document.forms[theForm].elements['descriptionInput'+i].id).style.borderColor='red';
				document.forms[theForm].elements['descriptionInput'+i].focus();
				return false;
			}
			else
			{
				
				document.forms[theForm].elements['descriptionInput'+i].value = document.forms[theForm].elements['descriptionInput'+i].value.replace(/`/g, ' ');
				descriptionInput = descriptionInput+document.forms[theForm].elements['descriptionInput'+i].value +delimiters;
			}


			<!---VALIDATE ACTION REQUEST--->
			if(document.forms[theForm].elements['actionRequestedCheckboxInput'+i].checked == true)
			{
			if(document.forms[theForm].elements['actionRequestedInput'+i].value == '')
				{
					alert('Please select action requested.');
					document.getElementById(document.forms[theForm].elements['actionRequestedInput'+i].id).style.borderColor='red';
					document.forms[theForm].elements['actionRequestedInput'+i].focus();
					return false;
				}
				else
				{
					document.forms[theForm].elements['actionRequestedInput'+i].value = document.forms[theForm].elements['actionRequestedInput'+i].value.replace(/`/g, ' ');
					actionRequestedInput = actionRequestedInput+document.forms[theForm].elements['actionRequestedInput'+i].value +delimiters;
				}
			}
			else
			{
				actionRequestedInput = actionRequestedInput + delimiters;
			}
		}	
		
	}
	//alert(document.forms(theForm).elements('deletedLessonLearned'+missionID).value);
	//'alert(assetIDCurrentInput);alert(assetTypeCurrentInput);
	//alert(descriptionInput);

	descriptionCurrentInput = descriptionCurrentInput.replace(/#/g, '##');
	descriptionCurrentInput = descriptionCurrentInput.replace(/"/g, '&quot;');
	
	actionRequestedCurrentInput = actionRequestedCurrentInput.replace(/"/g, '&quot;');
	actionRequestedCurrentInput = actionRequestedCurrentInput.replace(/#/g, '##');
	
	descriptionInput = descriptionInput.replace(/"/g, '&quot;');
	descriptionInput = descriptionInput.replace(/#/g, '##');

	actionRequestedInput = actionRequestedInput.replace(/"/g, '&quot;');
	actionRequestedInput = actionRequestedInput.replace(/#/g, '##');
	
	var selectedDeleteLessonLearnedIDs = document.forms[theForm].elements['deletedLessonLearned'+missionID].value;

	DWREngine._execute(_cfscriptLocation, null, 'saveLessonLearned', missionID,lessonLearnedCurrentInputID, categoryCurrentInput, equipmentCurrentInput, assetIDCurrentInput, assetTypeCurrentInput, timelineCurrentInput, descriptionCurrentInput,actionRequestedCurrentInput, lessonLearnedInputID, categoryInput, equipmentInput, assetIDInput, assetTypeInput, timelineInput, descriptionInput, actionRequestedInput, selectedDeleteLessonLearnedIDs, saveLessonLearnedForm);}

function saveLessonLearnedForm(success)

{
	if(success != 'false')
	{
		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
		DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', idSelected, setBoxscoreWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', idSelected, setTCSWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', idSelected, LL_order_in,LL_categoryID_in, LL_Timeline_in, LL_Disposition_in, setMissionLessonLearnedRequest);
		DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', LLA_order_in, setMissionLessonLearnedAction);
		//getAssetGroup('at', idSelected)
		//alert(rowSelected);
/*			alert(document.getElementById('row' + rowSelected + '_2').value);
	if(document.getElementById('row' + rowSelected + '_2').value != '[LL]')
		{
			document.getElementById('row' + rowSelected + '_2').innerHTML += ' [LL]';
		}*/
		//document.getElementById('missionIDDiv').innerHTML = 'test';
		//window.location.reload( true );
		alert('Lesson Learned Worksheet has been updated.');
		formChanged = false;
		
	}else
	{	
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, setMissionLessonLearnedRequest);
		alert('There was a problem saving your worksheet.  We apologize for the inconvenience and the TRMP-T team has been alerted to the problem.')
	}
}

function removeLessonLearnedRow(row_id, lessonLearnedID, missionID, theForm)
{
	//remove the entire row
	var parent = document.getElementById(row_id).parentNode;
	parent.removeChild(document.getElementById(row_id));
	
	//Just to delete the current row in DATABASE
	if (lessonLearnedID != 0)
	{
	document.forms[theForm].elements['deletedLessonLearned'+missionID].value = document.forms(theForm).elements('deletedLessonLearned'+missionID).value +lessonLearnedID + '`';
	}
}

function showEquipment(selectedValue, row_id)
{
	if(selectedValue == 1)
	{
		document.getElementById('equipmentInput'+ row_id).style.display='inline';
	}
	else
	{
		document.getElementById('equipmentInput'+ row_id).style.display='none';
	}
}

function createCategoryDropDown(theForm,row_id)
{
	var catList = document.createElement('select');
	//catList.multiple="multiple"
	//var num_rows = document.getElementById('addLessonLearnedTable').rows.length;
	catList.onchange = function(){showEquipment(this.value,row_id);};
	
	<cfinvoke component="ajaxfunc.cfobject" 
				method="getLessonLearnedCategory"
				returnvariable="getLessonLearnedCategory"> 
	
	var catOptions = document.createElement('option');
	catOptions.value='';
	catOptions.text='';
	catList.options.add(catOptions, 0);	
	var i=1;
	<cfoutput query="getLessonLearnedCategory">
		var catOptions = document.createElement('option');
		catOptions.value='#getLessonLearnedCategory.categoryID_pk#';
		catOptions.text='#getLessonLearnedCategory.categoryName#';
		catList.options.add(catOptions, i);
		i++;
	</cfoutput>;	
	
	return catList;
}


function createTimelineDropDown()
{
	var timelineList = document.createElement('select');
	//catList.multiple="multiple"
	//var num_rows = document.getElementById('addLessonLearnedTable').rows.length;
	//ddList.onchange = function(){showOther(this.value, 'newEventName_' + num_rows, 'newOtherEventName_' + num_rows);};
	<cfinvoke component="ajaxfunc.cfobject" 
				method="getLessonLearnedTimeline"
				returnvariable="getLessonLearnedTimeline">  	

	var timelineOptions = document.createElement('option');
	timelineOptions.value='';
	timelineOptions.text='';
	timelineList.options.add(timelineOptions, 0);
	var i=1;
	<cfoutput query="getLessonLearnedTimeline">
		var timelineOptions = document.createElement('option');
		timelineOptions.value='#getLessonLearnedTimeline.timelineID_pk#';
		timelineOptions.text='#getLessonLearnedTimeline.timelineName#';
		timelineList.options.add(timelineOptions, i);
		i++;
	</cfoutput>;	
	
	return timelineList;
}


function createEquipmentDropDown(missionID)
{
	var myList = new missionsCFC();
	lessonLearnedAssetName = myList.getAssetNameDropdownList(missionID);
	  for (i=0; i<lessonLearnedAssetName["DATA"].length; i++)
	  {
	  //alert(lessonLearnedAssetName.DATA[i][0]);
	  }

	var equipmentList = document.createElement('select');
	//catList.multiple="multiple"
	//var num_rows = document.getElementById('addLessonLearnedTable').rows.length;
	//ddList.onchange = function(){showOther(this.value, 'newEventName_' + num_rows, 'newOtherEventName_' + num_rows);};

	var equipmentOptions = document.createElement('option');
	equipmentOptions.value= '0_zz';
	equipmentOptions.text='';
	equipmentList.options.add(equipmentOptions, 0);

	  for (i=0; i<lessonLearnedAssetName["DATA"].length; i++)
	  {
		var equipmentOptions = document.createElement('option');
		equipmentOptions.value=lessonLearnedAssetName.DATA[i][3];
		equipmentOptions.text=lessonLearnedAssetName.DATA[i][0];
		equipmentList.options.add(equipmentOptions, i+1);
	  }
	
	return equipmentList;
}


function showHideActionRequestedText(theForm,id, rowStatus)
{
	/*This is for the data that store in DB*/
	if(rowStatus == 'current')
		{
		if(document.forms[theForm].elements['actionRequestedCheckboxCurrentInput'+id].checked == true)
		{
			document.getElementById('actionRequestedCurrentInput'+id).style.display='inline';
			document.getElementById('actionRequestedReminderID'+id).style.display='none';
			document.getElementById('limitCountdown2'+id).style.display='inline';
			document.getElementById('limitText2'+id).style.display='inline';			
		}
		else
		{
			document.getElementById('actionRequestedCurrentInput'+id).style.display='none';
			document.getElementById('actionRequestedReminderID'+id).style.display='inline';
			document.getElementById('limitCountdown2'+id).style.display='none';
			document.getElementById('limitText2'+id).style.display='none';
		}
	}
	/*This is for the new row*/
	else
	{
		if(document.forms[theForm].elements['actionRequestedCheckboxInput'+id].checked == true)
		{
			document.getElementById('actionRequestedInput'+id).style.display='inline';
			document.getElementById('actionRequestedReminderID'+id).style.display='none';
			document.getElementById('limitCountdown2'+id).style.display='inline';
			document.getElementById('spanLimitText2'+id).style.display='inline';			
		}
		else
		{
			document.getElementById('actionRequestedInput'+id).style.display='none';
			document.getElementById('actionRequestedReminderID'+id).style.display='inline';
			document.getElementById('limitCountdown2'+id).style.display='none';
			document.getElementById('spanLimitText2'+id).style.display='none';			
		}
	}
	
}
	
	
function getEquipment(id, dataStatus)
{
	if(dataStatus == 'current')
	{
		var categoryID = document.getElementById('categoryCurrentInput'+ id).value;
		if(categoryID == 1)
		{
			document.getElementById('equipmentCurrentInput'+ id).style.display='block';
		}
		else
		{
			document.getElementById('equipmentCurrentInput'+ id).style.display='none';
		}		
	}
	else
	{
		var categoryID = document.getElementById('categoryInput'+ id).value;
		if(categoryID == 1)
		{
			document.getElementById('equipmentInput'+ id).style.display='block';
		}
		else
		{
			document.getElementById('equipmentInput'+ id).style.display='none';
		}
	}
}

function lessonLearnedActions()
{	
	document.getElementById('missionLessonLearnedForm').style.display='none';
	document.getElementById('lessonLearnedActionDiv').style.display='block';
}


function lessonLearnedRequests()
{	
	document.getElementById('missionLessonLearnedForm').style.display='block';
	document.getElementById('lessonLearnedActionDiv').style.display='none';
}

var myPopup = window.createPopup();
function showLessonLearnedDescription(tooltip, obj)
 {
 	var myLeft = window.event.clientX;
	var myTop = window.event.clientY ;
	var backGroundColor = '#ccc';
    var curleft = curtop = 0;
	//get position of element on the page
    if (obj.offsetParent)
    { 
		curleft = obj.offsetLeft;
        curtop = obj.offsetTop;		
        while (obj = obj.offsetParent) 
        {
            curleft += obj.offsetLeft;
            curtop += obj.offsetTop;
			
        }
    }
	
	//get position of element on scrolling page
	d=document;
	y=d.documentElement.scrollTop ? d.documentElement.scrollTop:d.body.scrollTop;
	
	/*    
	because the size of the LL description is variable, means the myPopup size will be variable, too.  The width will be fixed size.
	I need to create and hide a div to capture its height, then calculate the height of the DIV that displays the LL description.  
	This height will be the height of the myPopup
	*/
	var newdiv = document.createElement('div');
    newdiv.setAttribute('id', 'myDiv');
    newdiv.style.visibility = 'hidden';//hidden  visible
    newdiv.style.width = 300;
    newdiv.style.height = 'auto';
    newdiv.style.position = "absolute";
    newdiv.style.left = 10;
    newdiv.style.top = 10;
    newdiv.style.background = "#9CF";
    newdiv.style.border = "ridge 2 #E0E0E0";
    tooltipContent = '<span style=" color:#900; font-weight: normal">'+'Lesson Learned Description: ' + '</span>'+'<br />'+ tooltip;
    newdiv.innerHTML = tooltipContent;
  	document.body.appendChild(newdiv);  
//alert(curtop);
    myNewHeight = parseInt(newdiv.clientHeight);
    myNewWidth = newdiv.clientWidth;
	//alert(curtop);
	if(curtop == 0)
	{
		mytopposition = parseInt(y)+15//+25 -80	;
	}
	else
	{
		mytopposition = parseInt(curtop)-parseInt(y)+15//+25 -80	
	}
	
    myleftposition = parseInt(curleft)+30;
    //var myPopup = window.createPopup();
	myPopup.document.body.position = "relative";
    myPopup.document.body.style.border="ridge 1 gray";
    myPopup.document.body.style.backgroundColor= 'floralwhite';
    myPopup.document.body.style.textAlign="left";
    myPopup.document.body.style.paddingTop='2px';
    myPopup.document.body.style.paddingRight='8px';
	myPopup.document.body.style.paddingLeft='8px';
    myPopup.document.body.style.fontSize ='10px';
    myPopup.document.body.style.fontWeight  ="normal";
	myPopup.document.body.style.fontFamily  ='verdana';
	

	
    myPopup.document.body.innerHTML = tooltipContent;
    myPopup.show(myLeft,parseInt(myTop)+10,myNewWidth,myNewHeight,document.body);
}
 
function hideLessonLearnedDescription()
{
	myPopup.hide();

}

function compare_dates(tdm, tdp)
{	

	//process the dates to get them into date objects and compare to make sure start date is before end date		
	var thisYear = '20' + tdm.split('-')[2].substr(0,2);
	var thisYear2 = '20' + tdp.split('-')[2].substr(0,2);
	
	var thisMonth = calcMonth(tdm.split('-')[1])-1;
	var thisMonth2 = calcMonth(tdp.split('-')[1])-1;
	
	var d1 = new Date(parseInt(thisYear), parseInt(thisMonth), tdm.split('-')[0]);
	var d2 = new Date(parseInt(thisYear2), parseInt(thisMonth2), tdp.split('-')[0]);
	
	if(d1 >= d2)
	{
		return false;
	}else{
		return true;
	}
}
function updateLessonLearned(theForm)
{
	var inputs = document.getElementsByTagName('input');
	var selects = document.getElementsByTagName('select');
	var rows = document.getElementsByTagName('td');
	
	var missionCurrentID = '';
	var lessonLearnedCurrentInputID = '';
	var dispositionCurrentInputID = '';
	var actioneeCurrentInputID = '';
	var oldActioneeCurrentInputID = '';
	var duedateInput = '';
	var lastActionUpdateInput = '';
	var isLessonLeanredChanged = '';
	var oldLastActionByInputID = '';
	var today = new Date();
	var regexp1 = new RegExp("^((31(?! (FEB|APR|JUN|SEP|NOV)))|((30|29)(?! FEB))|(29(?= FEB (((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))))|(0?[1-9])|1\\d|2[0-8])-(JAN|FEB|MAR|MAY|APR|JUL|JUN|AUG|OCT|SEP|NOV|DEC)-([0-9][0-9])$");	
	var delimiters = '`';
	
	for (i=0; i<= inputs.length; i++)
	{	
		<!---CHECK IF THE CURRENT RWO DATA HAS BEEN CHANGED--->
		if(
		   (document.forms[theForm].elements['lessonLearnedEdit'+i] != null) && 
		   ((document.forms[theForm].elements['lessonLearnedEdit'+i].value == 1) || (document.forms[theForm].elements['lessonLearnedEdit'+i].value == 2)) && 
		   (document.forms[theForm].elements['dispositionCurrentInput'+i].value == 2)
		  )
		{
			if(document.forms[theForm].elements['actioneeCurrentInput'+i].value == 0)
			{
				alert('Actionee is required');
				document.forms[theForm].elements['actioneeCurrentInput'+i].focus();
				return false;
			}
			
			if(document.forms[theForm].elements['duedateInput'+i].value == '')
			{
				alert('Due Date is required');
				document.forms[theForm].elements['duedateInput'+i].focus();
				document.getElementById(document.forms[theForm].elements['duedateInput'+i].id).style.borderColor ='red';
				return false;
			}			
			
			<!---VALIDATE DUE DATE--->
			if(document.forms[theForm].elements['duedateInput'+i] != null)
			{	
				//alert(document.forms[theForm].elements['duedateInput'+i].value);
				if(document.forms[theForm].elements['duedateInput'+i].value !='')
				{					
					if(!validate_date(document.forms[theForm].elements['duedateInput'+i].value))
					{
						alert('You must enter a valid date in the format of dd-mmm-yy.');
						document.forms[theForm].elements['duedateInput'+i].focus();
						document.getElementById(document.forms[theForm].elements['duedateInput'+i].id).style.borderColor ='red';				
						return false;		
					}	
					
					if(!document.forms[theForm].elements['duedateInput'+i].value.toUpperCase().match(regexp1))
					{
						alert('You must enter a valid start date for this event in the format of DD-MON-YY (ex: 10-OCT-07)');
						document.forms[theForm].elements['duedateInput'+i].focus();
						document.getElementById(document.forms[theForm].elements['duedateInput'+i].id).style.borderColor ='red';
						return false;
					}
		
					if(compare_dates(document.forms[theForm].elements['duedateInput'+i].value, today.getDate() + '-' + calcMonth(today.getMonth()) + '-' + today.getYear().toString().substr(2,2)))
					{
						alert('Due Date must be today or in the future');
						document.getElementById(document.forms[theForm].elements['duedateInput'+i].id).style.borderColor ='red';
						//document.getElementById(document.forms[theForm].elements[i+2].id).style.backgroundColor='red';
						return false;
					}
				}
	
			}
		}
		
		
		<!---STORE INPUT DATA--->	//alert('test');
		if(document.forms[theForm].elements['missionCurrentID'+i] != null)
		{ 
			missionCurrentID = missionCurrentID+document.forms[theForm].elements['missionCurrentID'+i].value +delimiters;
			lessonLearnedCurrentInputID = lessonLearnedCurrentInputID+document.forms[theForm].elements['lessonLearnedCurrentInputID'+i].value +delimiters;
			dispositionCurrentInputID = dispositionCurrentInputID+document.forms[theForm].elements['dispositionCurrentInput'+i].value +delimiters;
			actioneeCurrentInputID = actioneeCurrentInputID+document.forms[theForm].elements['actioneeCurrentInput'+i].value +delimiters;
			isLessonLeanredChanged = isLessonLeanredChanged+document.forms[theForm].elements['lessonLearnedEdit'+i].value +delimiters;
			if(document.forms[theForm].elements['oldActioneeCurrentInput'+i].value != document.forms[theForm].elements['actioneeCurrentInput'+i].value)
			{
				oldActioneeCurrentInputID = oldActioneeCurrentInputID+document.forms[theForm].elements['oldActioneeCurrentInput'+i].value +delimiters;
			}
			else
			{
				//oldActioneeCurrentInputID = oldActioneeCurrentInputID+ '0' +'`';
				oldActioneeCurrentInputID = oldActioneeCurrentInputID+document.forms[theForm].elements['oldActioneeCurrentInput'+i].value +delimiters;
			}
			
			if(document.forms[theForm].elements['duedateInput'+i].value =='')
			{
				duedateInput = duedateInput +''+delimiters;
			}
			else
			{
				duedateInput = duedateInput+document.forms[theForm].elements['duedateInput'+i].value +delimiters;			
			}
			
			document.forms[theForm].elements['lastActionUpdateInput'+i].value = document.forms[theForm].elements['lastActionUpdateInput'+i].value.replace(/`/g, ' ');
			lastActionUpdateInput = lastActionUpdateInput+document.forms[theForm].elements['lastActionUpdateInput'+i].value +delimiters;

			if(document.forms[theForm].elements['oldLastActionByInput'+i] != null)
			{
				oldLastActionByInputID = oldLastActionByInputID+document.forms[theForm].elements['oldLastActionByInput'+i].value +delimiters;	
			}
			else
			{	
				oldLastActionByInputID = oldLastActionByInputID +''+delimiters;		
			}			
		}
	}
	//alert(oldActioneeCurrentInputID);
	//alert(oldActioneeCurrentInputID);
/*	alert(lessonLearnedCurrentInputID);
	alert(dispositionCurrentInputID);
	alert(duedateInput);
	alert(lastActionUpdateInput); */
	//alert(actioneeCurrentInputID);\

	lastActionUpdateInput = lastActionUpdateInput.replace(/"/g, '&quot;');
	lastActionUpdateInput = lastActionUpdateInput.replace(/#/g, '##');
	
	<!---wwww--->
	DWREngine._execute(_cfscriptLocation, null, 'updateLessonLearned', LLA_order_in, LLA_lessonLearnedID_in, LLA_categoryID_in, LLA_Timeline_in, LLA_Disposition_in, missionCurrentID,lessonLearnedCurrentInputID, dispositionCurrentInputID, actioneeCurrentInputID, duedateInput,lastActionUpdateInput, oldActioneeCurrentInputID, isLessonLeanredChanged, oldLastActionByInputID, updateLearnedForm);

}

function updateLearnedForm(success)
{
	if(success != 'false')
	{
<!---		DWREngine._execute(_cfscriptLocation, null, 'getAssetPreMissionWorksheet', idSelected, setAssetPreMissionWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, getMissionAssignRequest);
		DWREngine._execute(_cfscriptLocation, null, 'getBoxscoreWorksheet', idSelected, setBoxscoreWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSView', idSelected, setTCSWorksheet);
		DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', idSelected, LL_order_in, setMissionLessonLearnedRequest);--->
		//DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', idSelected, setMissionLessonLearnedAction);
		
		DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', LLA_order_in, LLA_lessonLearnedID_in, LLA_categoryID_in,LLA_Timeline_in, LLA_Disposition_in,setMissionLessonLearnedAction);
		//getAssetGroup('at', idSelected)
		//window.location.reload( true );
		//location.reload(true)
		alert('Lesson Learned Action has been updated');
		formChanged = false;

	}
	else
	{	
		//DWREngine._execute(_cfscriptLocation, null, 'getMissionAssignRequest', idSelected, setMissionLessonLearnedRequest);
		alert('There was a problem saving your Lesson Learned Action.  We apologize for the inconvenience and the TRMP-T team has been alerted to the problem.')
	}
}

<!---wwww--->
function showLessonLearnedActions()
{
	document.getElementById("missionDetails").style.display = "none";
	document.getElementById("newMission").style.display = "none";
	document.getElementById("pis_prd_documents").style.display = "none";
	document.getElementById("lessonLearnedActionDiv").style.display = "block";
	formChanged =  false;
}

function searchLessionLearned(recordID)
{
	LL_categoryID_in = document.getElementById('searchLLCategory').value;
	LL_Timeline_in = document.getElementById('searchTimeline').value;
	LL_Disposition_in = document.getElementById('searchDiposition').value;
	DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', recordID, LL_order_in, LL_categoryID_in, LL_Timeline_in, LL_Disposition_in,setMissionLessonLearnedRequest);
	formChanged =  false;
	

	
}
<!---wwww--->
function searchLessionLearnedAction()
{
	LLA_lessonLearnedID_in = document.getElementById('searchLessonLearnedID').value;
	LLA_categoryID_in = document.getElementById('searchLLACategoryID').value;
	LLA_Timeline_in = document.getElementById('searchLLATimelineID').value;
	LLA_Disposition_in = document.getElementById('searchLLADipositionID').value;
	DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', LLA_order_in, LLA_lessonLearnedID_in,LLA_categoryID_in,LLA_Timeline_in, LLA_Disposition_in,setMissionLessonLearnedAction);
	formChanged =  false;
}

<!---RESET SEARCH LESSON LEARNED--->
function resetSearchLessionLearned(recordID)
{
	LL_categoryID_in = 0;
	LL_Timeline_in = 0;
	LL_Disposition_in = 0;
	DWREngine._execute(_cfscriptLocation, null, 'getLessonLearned', recordID, LL_order_in, LL_categoryID_in, LL_Timeline_in, LL_Disposition_in,setMissionLessonLearnedRequest);
	formChanged =  false;
}

<!---wwww--->
function resetSearchLessionLearnedAction()
{
	LLA_lessonLearnedID_in = 0;
	LLA_categoryID_in = 0;
	LLA_Timeline_in = 0;
	LLA_Disposition_in = 0;
	DWREngine._execute(_cfscriptLocation, null, 'getLessonLearnedAction', LLA_order_in, LLA_lessonLearnedID_in,LLA_categoryID_in,LLA_Timeline_in, LLA_Disposition_in,setMissionLessonLearnedAction);
	formChanged =  false;
}

function exportLessonLearnedExcel_OLD(recordID,sortOrder)
{	
	//location.href = "inc_missionLessonLearned_html.cfm" 
<!---	var main_frame = "inc_missionLessonLearned_html.cfm";
	var cur_url = self.location.href;
	var setframes = main_frame + "?" + cur_url;
	alert(setframes);
	return false;--->
	location.href = 'inc_missionLessonLearned_html.cfm'+'?missionid_fk='+ recordID +'&LL_order_in='+ sortOrder;
	
}

function exportLessonLearnedExcel(recordID, sortOrder)
{
	var urlstring = 'inc_missionLessonLearned_html.cfm'+'?missionid_fk='+ recordID +'&LL_order_in='+ sortOrder;//+'&printExcel=1';
	
	mywinPDF = window.open(urlstring,"lessonLearnedExcelFile","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
	
}


function exportToExcelLessonLearnedAction()
{	
	//location.href = "inc_missionLessonLearned_html.cfm" 
<!---	var main_frame = "inc_missionLessonLearned_html.cfm";
	var cur_url = self.location.href;
	var setframes = main_frame + "?" + cur_url;
	alert(setframes);
	return false;--->
	//location.href = 'inc_missionLessonLearnedAction_html.cfm'+'?LLA_order_in='+ LLA_order_in +'&LLA_lessonLearnedID_in='+ LLA_lessonLearnedID_in +'&LLA_categoryID_in='+ LLA_categoryID_in+'&LLA_Timeline_in='+ LLA_Timeline_in+'&LLA_Disposition_in='+ LLA_Disposition_in;
	

	var urlstring = 'inc_missionLessonLearnedAction_html.cfm'+'?LLA_order_in='+ LLA_order_in +'&LLA_lessonLearnedID_in='+ LLA_lessonLearnedID_in +'&LLA_categoryID_in='+ LLA_categoryID_in+'&LLA_Timeline_in='+ LLA_Timeline_in+'&LLA_Disposition_in='+ LLA_Disposition_in;
	
	mywinPDF = window.open(urlstring,"lessonLearnedActionExcelFile","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
	// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
	if(mywinPDF)
	{
		mywinPDF.focus();
	}else{
		alert('You may need to allow pop-up windows for this site to function properly');
	}
	
}

function createUserNameDropDown()
{
	alert('yesy');
	var myUserList = new userListCFC();
	var myData = '';
	userName = myUserList.getActionee();
	  for (i=0; i<userName["DATA"].length; i++)
	  {
	    //alert(userName.DATA[i][0]);
		myData = myData + userName.DATA[i][3] ;
	  }

/*	var equipmentList = document.createElement('select');
	//catList.multiple="multiple"
	//var num_rows = document.getElementById('addLessonLearnedTable').rows.length;
	//ddList.onchange = function(){showOther(this.value, 'newEventName_' + num_rows, 'newOtherEventName_' + num_rows);};

	var equipmentOptions = document.createElement('option');
	equipmentOptions.value= '0_zz';
	equipmentOptions.text='';
	equipmentList.options.add(equipmentOptions, 0);

	  for (i=0; i<lessonLearnedAssetName["DATA"].length; i++)
	  {
		var equipmentOptions = document.createElement('option');
		equipmentOptions.value=lessonLearnedAssetName.DATA[i][3];
		equipmentOptions.text=lessonLearnedAssetName.DATA[i][0];
		equipmentList.options.add(equipmentOptions, i+1);
	  }*/
	alert(myData);
	return userName;
}

function keyDown()
{

	keyNumber = event.keyCode;		
	alert(keyNumber);
	return  keyNumber;


}

function lessonLearnRowStatus(id)
{
	<!---When Diposition = open, then we display Actionee , Due Date and Last Action Request--->
	if(document.getElementById('dispositionCurrentInput'+id).value == 2)
	{
		document.getElementById('actioneeCurrentInput'+id).style.display = 'inline';
		document.getElementById('duedateInputDiv'+id).style.display = 'inline';
		document.getElementById('lastActionUpdateDiv'+id).style.display = 'inline';

	}
	else if(document.getElementById('dispositionCurrentInput'+id).value == 1 || document.getElementById('dispositionCurrentInput'+id).value == 3)
	{

		document.getElementById('actioneeCurrentInput'+id).style.display = 'none';
		document.getElementById('duedateInputDiv'+id).style.display = 'none';
		document.getElementById('lastActionUpdateDiv'+id).style.display = 'none';
	}

	<!---Keep Track if any change on dispostion, actionee, and Last action update--->
	if
	(
		(
		(document.getElementById('oldLastActionUpdateInput'+id).value != document.getElementById('lastActionUpdateInput'+id).value) ||
		(document.getElementById('oldActioneeCurrentInput'+id).value != document.getElementById('actioneeCurrentInput'+id).value) ||
		(document.getElementById('oldDuedateInput'+id).value != document.getElementById('duedateInput_'+id).value)		
		)
	)
	{
		<!---This is the flag to keep track if the current row data has been changed--->
		if(document.getElementById('oldDispositionCurrentInput'+id).value == 1)
		{
			<!---If disposition goes from TBD to Open/Reject/Withdrawn--->
			document.getElementById('lessonLearnedEdit'+id).value = 1;
		}
		else
		{
			document.getElementById('lessonLearnedEdit'+id).value = 2;
		}
								   
		
	}

	<!---Keep Track if any change on dispostion, actionee, and Last action update--->
	if
		(document.getElementById('oldDispositionCurrentInput'+id).value != document.getElementById('dispositionCurrentInput'+id).value)
	{
		<!---This is the flag to keep track if the current row data has been changed--->//alert(1);
		document.getElementById('lessonLearnedEdit'+id).value = 1;
	}

/*	else
	{
		document.getElementById('lessonLearnedEdit'+id).value = 0;
	}*/

}



 <!--- function to remove the row from the ATC display --->
function removeAssetATC(ATC)
{ 
confirmed = window.confirm("Are you sure you wish to delete this document?");
if (confirmed)
{	
	DWREngine._execute(_cfscriptLocation, null, 'DeleteATC', ATC, confirmDeletedATC);
	var pRow = document.getElementById(ATC); 
	pRow.parentNode.deleteRow(pRow.sectionRowIndex);
	document.getElementById('p_hide_this').value+=ATC +','; 

}
}

function confirmDeletedATC(deleted)
{
	if(deleted)
	{
	}
}

function uploadATC(missionID)
{
	DWREngine._execute(_cfscriptLocation, null, 'getMissionTCSForm', missionID, setTCSWorksheet);	
}

//Select All or De-select All check boxes on All Events on Pre-Mission Asset tab
function selectAllEvents(totalRows)
{
	var inputs = document.getElementsByTagName('input');

	var tempStatus = '';
	for(i=0; i<inputs.length; i++)
	{
		if(document.getElementById('select_'+i+'_') != null && document.getElementById('select_'+i+'_').disabled == false)
		{	
			for(j=0; j<=totalRows; j++)
			{	
				if(document.getElementById('select_'+i+'_'+j) != null)
				{
					if(document.getElementById('selectAll').innerHTML == 'Select All')
					{
						document.getElementById('select_'+i+'_'+j).checked = true;
						document.getElementById('select_'+i+'_').checked = true;
					}
					else
					{
						document.getElementById('select_'+i+'_'+j).checked = false;
						document.getElementById('select_'+i+'_').checked = false;
					}
					
				}
			}
		}
	}
	
	if(document.getElementById('selectAll').innerHTML == 'Select All')
	{
		document.getElementById('selectAll').innerHTML = 'De-select All';
	}
	else
	{
		document.getElementById('selectAll').innerHTML = 'Select All';	
	}
}

//Reword the 'Select All' From/To De-select All'
function selectAllStatus()
{	
	var inputs = document.getElementsByTagName('input');
	var tempStatus = '';
	for(j=0; j<inputs.length; j++)
	{
		if(document.getElementById('select_'+j+'_') != null)
		{	
			tempStatus += document.getElementById('select_'+j+'_').checked + ' ';
		}
	}

	tempStatus = tempStatus.indexOf('false');
	if(tempStatus < 0)
	{
		document.getElementById('selectAll').innerHTML = 'De-select All';
	}
	else
	{
		document.getElementById('selectAll').innerHTML = 'Select All';
	}	
}

//Select All or De-select All check boxes by Event on Pre-Mission Asset tab
function selectAllByEvents(eventID)
{	
	var inputs = document.getElementsByTagName('input');
	
	for(i=0; i<inputs.length; i++)
	{	
		if(document.getElementById(eventID+i)!= null)
		{
			document.getElementById(eventID+i).checked = document.getElementById(eventID).checked;
		}
	}
	
	selectAllStatus();
}

function selectSingleEvent(columnID, eventID, totalRows)
{	//alert(columnID); alert(eventID); 
	//alert(totalRows);
	
	if (document.getElementById(columnID + eventID).checked == false) 
	{
		document.getElementById(columnID).checked = document.getElementById(columnID + eventID).checked;
	}

	tempStatus = '';

	for(i=0; i<=totalRows; i++)
	{	
		if (document.getElementById(columnID+i) != null)
		{
			tempStatus += document.getElementById(columnID+i).checked + ' ';
		}
	}

	
	tempStatus = tempStatus.indexOf('false');
	
	
	if(tempStatus < 0)
	{
		document.getElementById(columnID).checked = true;
	}
	else
	{
		document.getElementById(columnID).checked = false;
	}
	
	selectAllStatus();
}	

function preCheckAllEventStatus(counter)
{	
	var temp1='';
	var temp2='';
	var temp3=''

	for(i=0; i<document.forms('frm_eventAssets').events.length; i++)
	{
		for(j=0; j<=counter; j++)
		{	
			if(document.getElementById('select_'+i+'_'+j)!= null)
			{
				temp1 += document.getElementById('select_'+i+'_'+j).checked + ' ';
			}
		}
		temp1 = temp1.indexOf('false');
		if(document.getElementById('select_'+i+'_')!= null)
		{
			if(temp1 < 0)
			{
				document.getElementById('select_'+i+'_').checked = true;
				temp2 += document.getElementById('select_'+i+'_').checked + ' ';
				temp3 += document.getElementById('select_'+i+'_').disabled + ' ';
			}
			else
			{
				document.getElementById('select_'+i+'_').checked = false;
				temp2 += document.getElementById('select_'+i+'_').checked + ' ';
				temp3 += document.getElementById('select_'+i+'_').disabled + ' ';
			}
		}
		temp1 = '';
	}

	temp3 = temp3.indexOf('false');
	temp2 = temp2.indexOf('false');
	if (temp3 >= 0)
	{	
		if (temp2 < 0) 
		{
			document.getElementById('selectAll').innerHTML = 'De-select All';
		}
		else 
		{
			document.getElementById('selectAll').innerHTML = 'Select All';
		}
	}
	else //if all heading check boxes are disable, then we hide the "Select All"
	{
		document.getElementById('selectAll').style.display = 'none';
		document.getElementById('hideSelectAll').style.display = 'inline';
	}
}


<cfinclude template="inc_timeout.cfm">

</script>

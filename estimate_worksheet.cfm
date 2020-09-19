<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!---<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>--->

<title>Worksheet</title>

<script type="text/javascript">
	var local_formChanged = false;
	var exitMessagePage = "Your changes will be lost if you click on [Leave this page].\n \nClick on [Stay on this page] to stay on the current page.";
	var exitMessageItem = "Your changes will be lost if you press OK.\n \nPress OK to continue or Cancel to stay on the current mission.";
	var worksheetType = 'Concrete,Block,Framing';
	var editMode = 0;
	
	function confirmLeaveScreen()
	{
		try
		{
			alert(local_formChanged);
			if(local_formChanged)
			{
				//theConfirm = confirm('Your changes will be lost if you click on "Leave this page".\n \nClick on "Stay on this page" to stay on the current page.');
				return exitMessagePage;
				
			}		
		}
		catch(error)
		{
			alert('error on function confirmLeave ' + error.message)
		}
		
		return true;
		
	}
	 
	function theFormIsChanged()
	{
		local_formChanged = true;
	} 

	function closeWorksheet()
	{
		try
		{
			if(local_formChanged)
			{
				theConfirm = confirm('Your changes will be lost if you click "OK".\n \nClick "Cancel" to stay on the current page.');
				if(theConfirm)
				{
					local_formChanged = false;
					window.close();
				}
					
				
			}
			else			
			window.close();
					
		}
		catch(error)
		{
			alert('error on function closeWorksheet ' + error.message)
		}
	
		
	}

	function saveWorksheet()
	{
		try
		{
			local_formChanged = false;
			window.close();
					
		}
		catch(error)
		{
			alert('error on function saveWorksheet ' + error.message)
		}
	
		
	}

	function editThisWorksheet(worksheetId,estimateId)
	{
		try
		{
			switch (worksheetId) {
				case 'Concrete':
					ColdFusion.navigate('estimate_worksheet_concrete_edit.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Concrete');
					break;
					
				case 'Block':
					ColdFusion.navigate('estimate_worksheet_block_edit.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Block');
					break;					

				case 'Frame':
					ColdFusion.navigate('estimate_worksheet_frame_edit.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Frame');
					break;	
					
			}
			disableWorksheetType(worksheetId);					
		}
		catch(error)
		{
			alert('error on function selectThisWorksheet ' + error.message)
		}
	}
		
	
	function disableWorksheetType(notThisType)
	{
		try
		{	
			document.getElementById('closeEstimateWorksheet').disabled = true;
			document.getElementById('closeEstimateWorksheet').style.color = 'gray';
			ColdFusion.Layout.disableTab('preferences','Block'); 
			ColdFusion.Layout.disableTab('preferences','Frame'); 
			ColdFusion.Layout.disableTab('preferences','Concrete'); 
			ColdFusion.Layout.enableTab('preferences', notThisType); 
			editMode = 1;	
		}
		catch(error)
		{
			alert('error on function disableWorksheetType ' + error.message)
		}
		
	}	

	function ableThisButton(notThisType)
	{
		try
		{	
			document.getElementById(notThisType).disabled = false;
			document.getElementById(notThisType).style.backgroundColor = 'gray';
			document.getElementById(notThisType).style.fontWeight = 'bold';
			document.getElementById(notThisType).style.color = 'black';
			
		}
		catch(error)
		{
			alert('error on function ableThisButton ' + error.message)
		}
		
	}

	function ableWorksheetType()
	{
		try
		{	
			document.getElementById('closeEstimateWorksheet').disabled = false;
			document.getElementById('closeEstimateWorksheet').style.color = 'black';
			ColdFusion.Layout.enableTab('preferences','Block'); 
			ColdFusion.Layout.enableTab('preferences','Frame'); 
			ColdFusion.Layout.enableTab('preferences','Concrete'); 
			editMode = 0;			
		}
		catch(error)
		{
			alert('error on function ableWorksheetType ' + error.message)
		}
		
	}

	function saveWorksheetType(worksheetId,estimateId)
	{
		try
		{	
			ableWorksheetType(worksheetId);
			switch (worksheetId) {
				case 'Concrete':
					ColdFusion.navigate('estimate_worksheet_concrete_view.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Concrete');
					break;
				case 'Block':
					ColdFusion.navigate('estimate_worksheet_block_view.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Block');
					break;					
				case 'Frame':
					ColdFusion.navigate('estimate_worksheet_frame_view.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Frame');
					break;						
			}
						
		}
		catch(error)
		{
			alert('error on function saveWorksheetType ' + error.message)
		}
		
	}

	function cancelWorksheetType(worksheetId, estimateId)
	{
		try 
		{
			ableWorksheetType(worksheetId);
			switch (worksheetId) {
				case 'Concrete':
					ColdFusion.navigate('estimate_worksheet_concrete_view.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Concrete');
					break;
				case 'Block':
					ColdFusion.navigate('estimate_worksheet_block_view.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Block');
					break;					
				case 'Frame':
					ColdFusion.navigate('estimate_worksheet_frame_view.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId, 'Frame');
					break;						
			}		
		} 
		catch (error) {
			alert('error on function cancelWorksheetType ' + error.message)
		}
	}	

	function uploadWorksheetDocument_NEW()
	{
		try 
		{
			//ColdFusion.Window.show('uploadWorksheetDocumentWindow');
			//document.getElementById('uploadWorksheetDiv').style.display = 'inline';
			//document.getElementById('uploadWorksheetDiv').style.marginTop  = '30';
			//document.getElementById('uploadWorksheetDiv').style.marginBottom = '30px';
			//ColdFusion.navigate('estimate_worksheet.cfm?worksheetId=' + worksheetId + '&estimateId=' + estimateId,);
		} 
		catch (error) {
			alert('error on function uploadWorksheetDocument ' + error.message)
		}
	}	

	function uploadWorksheetDocument(estimateID)
	{
		var urlstring = "estimate_uploadWorksheet.cfm?estimateId=" + estimateID;
		myUploadDocWindow = window.open(urlstring,"uploadDocWindow","width=800,height=200,status=1,menuBar=1,scrollBars=1,resizable=1");
		myUploadDocWindow.focus();
	
	}
	
	function saveWorksheetDocument()
	{
		try 
		{
			ColdFusion.Window.hide('uploadWorksheetDocumentWindow');
		
		} 
		catch (error) {
			alert('error on function saveWorksheetDocument ' + error.message)
		}
	}	

	function cancelWorksheetDocument()
	{
		try 
		{
			ColdFusion.Window.hide('uploadWorksheetDocumentWindow');
		
		} 
		catch (error) {
			alert('error on function cancelWorksheetDocument ' + error.message)
		}
	}	

	function doneUpload(estimateId)
	{		
		ColdFusion.navigate('estimate_worksheetList.cfm?estimateId=' +estimateId,'worksheetList');
	}	

	function cancelUploadDocument_NEW()
	{		
		//document.getElementById('uploadWorksheetDiv').style.display = 'none';
	}

	function refreshThisWorksheet(estimateId)
	{		
		//document.getElementById('uploadWorksheetDiv').style.display = 'none';
		ColdFusion.navigate('estimate_worksheet.cfm?estimateId=' +estimateId);
	}
											 		 
</script>

</head>

<body <!---onbeforeunload="return confirmLeaveScreen();"--->>
<style>
	table.uploadDocment
	{
		font-size:12px;
		width:720px;
		border:2px solid gray;
	}

	table.uploadDocment td, table.uploadDocment th
	{
		font-family:Arial;
		font-family:Tw Cen MT;
		font-size:16px;			
		padding:5px	
	}
	
	table.uploadDocment th
	{
		font-weight:bold
	}	
			
</style>   
<cfinclude template="checkAccess.cfm">
<cfparam name="url.id" default="0" >
<cfinclude template="sourceFile.cfm">
<cfinclude template="css/qpcCSS.cfm">
<cfajaximport  tags="cfwindow,cfform">

<cfif cgi.SERVER_NAME EQ 'localhost'>
	<cfset variables.uploadDocDir = 'C:\ColdFusion11\cfusion\wwwroot\qpc\workSheet\'>
<cfelse>
	<cfset variables.uploadDocDir = 'C:\Inetpub\vhosts\phamhomesite.com\qpc\workSheet\'>
</cfif>	

<div align="center" style="width:100%; border:0px solid red">
    <cfoutput>
    <table style="border-collapse: collapse; margin-top:10px; border:2px solid black; width:900px;background-color:lightGrey; margin-bottom:10px">
        <tr>
            <td style="width:200px; border:0px solid black;text-align:left; font-weight:normal;color:##800000; font-weight:normal;">
                &nbsp;Estimate Number: #url.estimateId#
            </td>
            <td style="border:0px solid black;text-align:center; font-weight:bold">Worksheet</td>
            <td style="width:200px; border:0px solid black;text-align:right">
                <input type="button" value="Close Worksheet  [x]" class="buttonsmall" id="closeEstimateWorksheet" onclick="window.close();" >
            </td>
        </tr>
    </table>

		<!---<span onclick="uploadWorksheetDocument('#url.estimateId#')">[+] Upload Worksheet</span><br />--->
       <!--- <span onclick="uploadWorksheetDocument_NEW('#url.estimateId#')">[+] Upload Worksheet NEW</span>--->
	
        	<br />
            <cfif isDefined("Form.uploadDoc")>
                 <cffile  action="upload" filefield="form.file_name" destination="#session.uploadDocDir#" mode="644" nameconflict="makeunique">
                    <cfswitch expression="#clientFileExt#">
                     <!---ACCEPTABLE FILES--->
                      <cfcase value="doc,docx,xls,xlsx,ppt,pptx,pdf" delimiters=",">
                            <cfquery name="insertNewWorksheetDocument"  datasource="#REQUEST.dataSource#" >
                                INSERT INTO worksheet(estimateID_fk, description, fileName)
                                VALUES
                                (
                                    <cfqueryparam value="#url.estimateId#" cfsqltype="cf_sql_integer">,
                                    <cfqueryparam value="# form.description#" cfsqltype="cf_sql_char">,
                                    <cfqueryparam value="#cffile.serverFile#" cfsqltype="cf_sql_char">
                                )                
                            </cfquery> 
                            <!---<img src="images/1x1_transparent.gif" onload="refreshThisWorksheet(<cfoutput>'#url.estimateId#'</cfoutput>)">--->
                      </cfcase>	
                      <cfdefaultcase>
                            <span style="color:red">Invalid format upload file.  Exceptable formats: Word, Excel, Power Point, PDF.</span>
                            <cffile action="delete" file = "#session.uploadDocDir##cffile.serverFile#">
                            <!---<img src="images/1x1_transparent.gif" onload="refreshThisWorksheet(<cfoutput>'#url.estimateId#'</cfoutput>)">--->
                            <!---<img src="images/1x1_transparent.gif" onload="alert('Invalid format upload file.  Exceptable formats: Word, Excel, Power Point, PDF')">--->
                      </cfdefaultcase>
                    </cfswitch>
                
            </cfif>
    
            <cfform name="uploadDocForm" method="post" action="#CGI.SCRIPT_NAME#?estimateId=#url.estimateId#" enctype="multipart/form-data" style="margin-top:0px;">
                <table class="uploadDocment"  cellpadding="3">
                    <tr>
                        <th>Description:</th>
                        <td ><cfinput name="description" type="text" size="60" maxlength="150" required="yes" message="Description is required data."> (max. 150 chars)</td>
                    </tr>
                    <tr>
                        <th valign="top">File:</th>
                        <td>
                            <cfinput name="file_name" type="file" value="Upload" size="60" required="yes" message="File is required data."><br />
                            NOTICE: Accceptable format file to be uploaded: Word, Excel, Power Point, PDF.<br />				   
                        </td>
                    </tr>
                    <tr>
                    
                        <td align="center" colspan="2">
                            <cfinput name="uploadDoc" type="submit"  value="Upload" class="buttonsmall">
                            <!---<cfinput name="cancelUpload" type="button"  value="Cancel" onclick="cancelUploadDocument_NEW()" class="buttonsmall">--->
                        </td>
                    </tr>      
                </table>
                
                <!---<cfoutput><input type="hidden" name="token" id="token" value="#CSRFGenerateToken()#" size="100"></cfoutput>	--->   
            </cfform>  
            <br />
 
	</cfoutput>
    <cfquery name="getWorksheet"  datasource="#REQUEST.dataSource#" >
        SELECT	*
        FROM		worksheet
        WHERE	estimateID_fk = #url.estimateid#
    </cfquery>
    <cfdiv bind="url:estimate_worksheetList.cfm?estimateId=#url.estimateId#" id="worksheetList">

</div>    
</body>
</html>

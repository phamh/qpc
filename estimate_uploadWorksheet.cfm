<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>upload document</title>
</head>

<body>
<style>
	table.uploadDocment
	{
		font-family:Arial;
		font-size:12px
	}

	table.uploadDocment td, table.uploadDocment th
	{
		font-family:Arial;
		font-size:12px
	}
			
</style>

<script>
	function cancelUploadDocument()
	{		
/*
		ColdFusion.Window.hide("uploadDocWindow");		
		destroyWIN('uploadDocWindow');
		
*/
		window.close();
	}	

	function finishUpload(estimateId)
	{		
		//ColdFusion.navigate('estimate_worksheetList.cfm?estimateId=' +estimateId,'worksheetssList');
		window.opener.doneUpload(estimateId);
		window.close();
	}	
		
</script>

<cfinclude template="sourceFile.cfm">
<cfif isDefined("Form.uploadDoc")>
	 <cffile action="upload" filefield="form.file_name" destination="#session.uploadDocDir#" mode="644" nameconflict="makeunique">
	  <!---<cffile action="delete" file = "C:/inetpub/wwwroot_HP/Test/worksheets/#cffile.serverFile#"> --->
	  
<!---	<cfdump var="#cffile.serverFile#"><br>
	<cfdump var="#clientFileExt#"><br>
	<cfdump var="#form.file_name#">
	<cfset fileName = "#cffile.serverFile#"><br>
	<cfdump var="#fileName#">--->
	<!---<cfdump var="#form.description#">--->
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
                <img src="images/1x1_transparent.gif" onload="finishUpload(<cfoutput>'#url.estimateId#'</cfoutput>)"> 
              
          </cfcase>	
          <cfdefaultcase>
          		<span style="color:red">invalid format upload file</span>
                <cffile action="delete" file = "#session.uploadDocDir##cffile.serverFile#">
          
          </cfdefaultcase>
        </cfswitch>
	
</cfif>

<div style="border:0px solid gray; width:100%;text-align:center">

	<cfform name="uploadDocForm" method="post" action="#CGI.SCRIPT_NAME#?estimateId=#url.estimateId#" enctype="multipart/form-data" style="margin-top:0px;">
		<table class="uploadDocment">
			<tr>
				<th>Description:</th>
				<td class="smaller"><cfinput name="description" type="text" size="60" maxlength="150">(max. 150 chars)</td>
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
					<cfinput name="uploadDoc" type="submit"  value="Upload">
					<cfinput name="cancelUpload" type="button"  value="Cancel" onclick="cancelUploadDocument()">
				</td>
			</tr>      
		</table>
		
		<!---<cfoutput><input type="hidden" name="token" id="token" value="#CSRFGenerateToken()#" size="100"></cfoutput>	--->   
	</cfform>
</div>
</body>
</html>
<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">
<cfinclude template="estimateJS.cfm">

<cfquery name="getWorksheet"  datasource="#REQUEST.dataSource#" >
    SELECT	*
    FROM		worksheet
    WHERE	estimateID_fk = #url.estimateid#
</cfquery>

<cfif getWorksheet.recordCount>
<table style="border:1px solid gray; width:900px; border-collapse:collapse">
    <tr bgcolor="#CCCCCC">
        <th style="text-align:center; font-weight:bold; width:70px; border:1px solid gray">Delete</th>
        <th style="text-align:center; font-weight:bold; width:300px; border:1px solid gray">Description</th>
        <th style="text-align:center; font-weight:bold; width:500px; border:1px solid gray">File</th>
    </tr>
    <cfoutput query="getWorksheet">
        <tr>
            <td style="padding:3px;padding-right:3px; text-align:center; border:1px solid gray">
            	<span style="color:red;font-weight:bold; cursor:pointer" onClick="deleteThisWorksheet('#autoID_pk#', '#url.estimateId#','#fileName#')">[X]</span></td>
            <td style="padding:3px;; border:1px solid gray">#description#</td>
            <td style="padding:3px;; border:1px solid gray"><a href="workSheet\#URLEncodedFormat(fileName)#" target="_blank">#fileName#</a>
            </td>
        </tr>
    </cfoutput>
</table>    
</cfif>
<cfif isDefined('session.catch') AND cgi.SERVER_NAME CONTAINS "localhost" AND 1 Eq 2>
	<cfdump var="#session.catch#">
</cfif>
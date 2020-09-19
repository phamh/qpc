<cfinclude template="sourceFile.cfm">
<cfif cgi.SERVER_NAME CONTAINS "localhost">
<div style="width:98%; margin:10px; border:0px solid red;">
error=<cfdump var="#session.errorMessage#" label="errorMessage">
</div>		
</cfif>
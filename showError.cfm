<cfif cgi.SERVER_NAME CONTAINS "localhost">
	<cfdump var="#session.error#">
<cfelse>
	<cfoutput>
		#session.error.message#<br />
		#session.error.detail#<br />
	</cfoutput>
</cfif>
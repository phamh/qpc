<cfif (cgi.SERVER_NAME CONTAINS "localhost"  ) AND 1 EQ 1>
	<span style="font-size:11px; font-style:italic; color:#900"><cfoutput>#cgi.SCRIPT_NAME#</cfoutput></span><br />
</cfif>
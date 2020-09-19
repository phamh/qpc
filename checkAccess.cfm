

<cfif NOT isDefined('session.fullName') OR  session.fullName EQ ''>
	<cflocation  url="login.cfm">
<cfelse>
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
</cfif>

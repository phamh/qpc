  
<cfcomponent output="false">
	<!--- Set application name and Session variables  --->
  <cfset this.name="qpc">
	<cfset this.sessionManagement=true>
<!---	<cfset this.sessiontimeout = createtimespan(0,10,0,0)>--->
  <cfset this.sessiontimeout = createtimespan(0,3,0,1)>
	
	<!--- 
	Make sure the cookies are reset so the Session is closed if the user closes the browser window 
	--->
	<cfif IsDefined("Cookie.CFID") and IsDefined("Cookie.CFTOKEN")>
		<cfset localCFID = Cookie.CFID>
		<cfset localCFTOKEN = Cookie.CFTOKEN>
<!---		<cfcookie name="CFID" value="#localCFID#">
		<cfcookie name="CFTOKEN" value="#localCFTOKEN#">--->
	</cfif>

	
	<cffunction name="onRequestStart" returntype="boolean" output="true">				
		<!--- Any variables set here can be used by every page. --->	
		<cfif cgi.SERVER_NAME CONTAINS 'localhost' OR cgi.SERVER_NAME CONTAINS 'test'>
			<cfset REQUEST.dataSource="qpc"><!---qpc_test --->
		<cfelse>
			<cfset REQUEST.dataSource="qpc">
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="onRequestEnd" returntype="boolean" output="true">
		<cfreturn true>
	</cffunction>
 
 	<cffunction name="onError" returnType="void"> 
	    <cfargument name="Exception" required=true/> 
	    <cfargument name="EventName" type="String" required=true/> 
	    
	    <cfset error.mailTo = application.siteemail>
		<cfset error.dateTime = DateTimeFormat(now(), "mm-dd-yyyy HH:nn:SS")>
		<cfset error.remoteAddress = cgi.remote_addr>
		<cfset error.browser = cgi.http_user_agent>
		<cfset error.template = cgi.script_name>
		<cfset error.querystring = cgi.query_string>
		<cfset error.httpReferer = cgi.http_referer>
		<cfset error.diagnostics = exception.message & "<br/>" & exception.detail>
		
	    <cfif Arguments.Exception.type EQ "pptError">
			<cfinclude template="err_pptGeneration.cfm">
		<cfelse>
			<cfinclude template="err_request.cfm">
		</cfif>
		
		<cfset writeErrorLog(arguments.exception, arguments.eventName, error)>
	</cffunction>
	       
</cfcomponent>
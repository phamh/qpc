<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<title>QP Construction, Inc.</title>

<cfajaximport tags="cfform,cfdiv,cfinput-datefield,cfwindow,cflayout-tab, cfwindow,cftextarea">

<link rel="stylesheet" type="text/css" href="jscalendar-1.0/calendar-brown.css">

<!-- main calendar program -->
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
   adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="jscalendar-1.0/calendar-setup.js"></script>

</head>
<body onbeforeunload="return confirmLeaveScreen();">

<cfif cgi.SERVER_NAME CONTAINS "localhost">
<cfelse>
	<cfif cgi.SERVER_PORT NEQ "443">
	  <cfset redir = 'Https://' & HTTP_HOST & PATH_INFO>
	  <cflocation url="#redir#" addtoken="No">
	</cfif>
</cfif>

<cfparam name="session.errorMessage" default="">
<cfparam name="url.pageName" default="">
<cfinclude template="css/qpcCSS.cfm">
<cfinclude template="scripts/qpcJS.cfm">
<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC">

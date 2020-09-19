<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Admin | Marshall Star</title>

<link rel="stylesheet" type="text/css" href="admin.css">
<link rel="stylesheet" type="text/css" href="../css/star_share.css">
</head>

<body>

<cfinclude template="session_variables_admin.cfm">
<cfinclude template="mimetypes.cfm">
<div id="adminBodyLayer">
	<cfif isDefined('url.pageTitle')>
    <cfset session.adminPageTitle = '#url.pageTitle#'>
  </cfif>
  
  <cfinclude template="menu_admin.cfm">
  <div id="adminContent">
  	<cfinclude template="display_page_title.cfm">


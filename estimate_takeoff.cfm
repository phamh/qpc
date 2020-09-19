<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<title>Take Off</title>

<script type="text/javascript">
	var local_formChanged = false;
	var exitMessagePage = "Your changes will be lost if you click on [Leave this page].\n \nClick on [Stay on this page] to stay on the current page.";
	var exitMessageItem = "Your changes will be lost if you press OK.\n \nPress OK to continue or Cancel to stay on the current mission.";
	
	function confirmLeave()
	{
		try
		{
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
		 		 
</script>

</head>

<body onbeforeunload="return confirmLeave();">
	<cfparam name="url.id" default="0" >
	<input type="text" size="20" onkeydown="theFormIsChanged()">
	<input type="button" onclick="closeWorksheet()" value="Cancel">
	<input type="button" onclick="saveWorksheet()" value="Save">
</body>
</html>


<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>QPC TEST  TABS</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
/*  $( function() {

    $( "#tabs" ).tabs
			    	(
				    	{
				      		collapsible: true,
				      		active: 1, // zero based
				      		refresh:0,
				      		activate: function( event, ui ) 
				      		{
				      			//ColdFusion.navigate('test2.cfm', 'employeeContentBody');
				      			
				      		},
				      		load: 1,
				    	}
			    	);
  } );
*/



	$( function() 
	{
	   //var jq = jQuery.noConflict();
	   $a( "#dob_edit" ).datepicker(
	   	{
		   	changeMonth: true,
		   	changeYear: true,
		   	yearRange: "-80:+0",
	   	}
	   	);
	});
	
  </script>
</head>
<body>
 <input id="dob_edit"></input>
   <div id="tabs" style="width:50%">
      <ul>
          <li><a href="#unit"><span>Unit Information</span></a></li>
          <li><a href="#documents"><span>Documents</span></a></li>
      </ul>
      <div id="unit">
      	<cfdiv bind="url:test2.cfm" id="employeeContentBody"> 

      </div>
      <div id="documents">
         <cfdump var="#now()#">
      </div>

    </div>
 
</body>
</html>
<cfinclude template="checkAccess.cfm">
<cfinclude template="sourceFile.cfm">

<Style>
	table.employeeTable
	{
		border:0px solid gray;
		border-collapse:collapse;
		width:600px
	}
	
	table.employeeTable th, table.employeeTable td
	{
		border:1px solid gray;
		text-align:left;
		padding:5px;
	}	
</Style>

<style>
	.ui-tooltip 
	{
	    font: normal 12px Arial;
	    box-shadow: 0 0 10px black;
	    background-color: black;
	    color: white;	
	    white-space:nowrap;
	}

     .ui-widget-header 
     {
        background:#e5e5e5;
        /*border-bottom: 2px solid gray;*/
     }
 
	.ui-dialog .ui-dialog-title
	{
	    color: black !important;
		text-align:center;
		font-size:20px;
	}		

	.ui-dialog .ui-widget{
	    font-family:Arial;
	    font-size:12px;
	}	

	.ui-dialog .ui-dialog-content 
	{
		border: 0px solid red;
		padding: 10px;
	    font-size:12px;
	    color:black;
	    background-color: #FDF8E4;
		overflow: auto;
		margin:0px;
	}

	.ui-dialog .ui-dialog-buttonpane 
	{
	    background-color: #e5e5e5;
	    border: 0px solid red;
	    margin:0px;
	    text-align:center;
	}

	/* Center the buttons */
	.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset
	{ 
	    float: none;
	}

	.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset .buttonClass 
	{
	    font-size:14px;
	    font-weight: bold;	
	    border: 1px solid gray;
	    /*width: 175px;*/
	}
	
	.ui-dialog-titlebar-close 
	{
	    visibility: visible;
	}    

	.ui-datepicker
	{
    	width: 300px;
    	height: 250px;
    	margin: 5px auto 0;
    	font: 12pt Arial, sans-serif;
	}

</style>

<script>

	editThisEmployee_NEW=function(employeeId_pk) 
	{	var errorMessage = '';
	    $("#employeeEditDiv").dialog({
	      	modal: true,
	      	width:650,
	      	height:600,
	      	show: 'slide',//scale, fold, slide, fade,explode, drop, bounce,blind
	      	hide: 'slide',
	       	draggable: true,
	       	cache: false,
	       	title: "Edit Employee",	
			buttons: 
			[
			    {	//What If button 3333
			        id : "update_button",
			        text: "Update",
			        open: function() { $(this).addClass('buttonClass') },
			        cache: false,
			        click: function() 
			        {	
						var lastName_edit = document.getElementById('lastName_edit').value;
						var firstName_edit = document.getElementById('firstName_edit').value;
						var middleName_edit = document.getElementById('middleName_edit').value;
						if((active_1_edit).checked)
						{
							var active_edit = 1;
						}
						else
							var active_edit = 0;
				
						var ssn_edit = document.getElementById('ssn_edit').value;
						var dob_edit = document.getElementById('dob_edit').value;
						var address_edit = document.getElementById('address_edit').value;
						var city_edit = document.getElementById('city_edit').value;
						var state_edit = document.getElementById('state_edit').value;
						var zipCode_edit = document.getElementById('zipCode_edit').value;
						var cellPhone_edit = document.getElementById('cellPhone_edit').value;
						var homePhone_edit = document.getElementById('homePhone_edit').value;
						theToken = document.getElementById('token').value;

						//if($('#lastName_edit').val() == '' || $('#firstName_edit').val() == '' ||  $('#ssn_edit').val() == '' ||  $('#address_edit').val() == '' ||  $('#city_edit').val() == '' ||  $('#state_edit').val() == '' ||  $('#zipCode_edit').val() == '')
						if($('#lastName_edit').val() == '')
						{
							errorMessage = 'Last name is required';
							highlightRequiredData('lastName_edit');
						}
						else
						{
							un_highlightRequiredData('lastName_edit');
						}
						
						if($('#firstName_edit').val() == '')
						{
							errorMessage = errorMessage+'\n' + 'First Name is required';
							highlightRequiredData('firstName_edit');
						}						
						else
						{
							un_highlightRequiredData('firstName_edit');
						}
						
						if($('#ssn_edit').val() == '')
						{
							highlightRequiredData('ssn_edit');
							errorMessage = errorMessage+'\n' + 'SSN is required';
						}	
						else
						{
							un_highlightRequiredData('ssn_edit');
						}
						
						if($('#address_edit').val() == '')
						{
							highlightRequiredData('address_edit');
							errorMessage = errorMessage+'\n' + 'Address is required';
						}	
						else
						{
							un_highlightRequiredData('address_edit');
						}
						

						if($('#city_edit').val() == '')
						{
							highlightRequiredData('city_edit');
							errorMessage = errorMessage+'\n' + 'City is required';
						}	
						else
						{
							un_highlightRequiredData('city_edit');
						}
						
						if($('#zipCode_edit').val() == '')
						{
							highlightRequiredData('zipCode_edit');
							errorMessage = errorMessage+'\n' + 'Zip Code is required';
						}	
						else
						{
							un_highlightRequiredData('zipCode_edit');
						}																								
						if(errorMessage != '')
						{
							//alert('Please enter the required data')
							alert(errorMessage)
							errorMessage = '';
							return false;
						}
						$.ajax({
							type:'GET',
							url: '/ajaxFunc/qpc.cfc',
							data: 
							{
								method: 'function_updateEmployee', 
								employeeId_pk: employeeId_pk,
								lastName_edit: lastName_edit,
								firstName_edit: firstName_edit,
								middleName_edit: middleName_edit,
								active_edit: active_edit,
								ssn_edit: ssn_edit,
								dob_edit: dob_edit,
								address_edit: address_edit,
								city_edit: city_edit,
								state_edit: state_edit,
								zipCode_edit: zipCode_edit,
								cellPhone_edit: cellPhone_edit,
								homePhone_edit: homePhone_edit,
								theToken: theToken,							
								
							},
							dataType: 'html',
							cache: false,
							success: function(msg )
							{
								alert(msg);
								//alert(this);
								
							},
							fail: function(){
								alert('error');	
							}
						});		
						
						alert(theToken);					
						ColdFusion.navigate('employeeContent.cfm?employeeId_pk=' + employeeId_pk, 'employeeContentBody'); 
						//$(this).dialog('destroy');
						//$(this).dialog('close');      
						   				        		      		
			       	}
			    },
						
			    {
			    	//Cancel Button
			        text: "Cancel",
			        id: "cancel_button",
			        open: function() { $(this).addClass('buttonClass') },
			        click: function() 
			        {        
						$(this).dialog('destroy');
						$(this).dialog('close'); 	
			        }
			    }
			  ],
			  
            open: function ()
            {

	        	$(this).load( "employee_edit.cfm?employeeId_pk="+encodeURI(employeeId_pk), 'dummy' + Math.random());
	        	
            }          
	    }); 
	  }		


	addNewEmployee_NEW=function() 
	{
	    $("#employeeEditDiv").dialog({
	      	modal: true,
	      	width:650,
	      	height:600,
	      	show: 'slide',//scale, fold, slide, fade,explode, drop, bounce,blind
	      	hide: 'slide',
	       	draggable: true,
	       	cache: false,
	       	title: "New Employee",	
			buttons: 
			[
			    {	//What If button 3333
			        id : "update_button",
			        text: "Update",
			        open: function() { $(this).addClass('buttonClass') },
			        click: function() 
			        {	
						if($('#lastName_edit').val() == '' || $('#firstName_edit').val() == '' ||  $('#ssn_edit').val() == '' ||  $('#address_edit').val() == '' ||  $('#city_edit').val() == '' ||  $('#state_edit').val() == '' ||  $('#zipCode_edit').val() == '')
						{
							alert('Please enter the required data');
							//highlightRequiredData('lastName_edit');
							return false;
						}
						else
						{
							//un_highlightRequiredData('lastName_edit');
						}
								
						ColdFusion.navigate('employeeContent.cfm?employeeId_pk=0', 'employeeContentBody');  
						$(this).dialog('close');        				        		      		
			       	}
			    },
						
			    {
			    	//Cancel Button
			        text: "Cancel",
			        id: "cancel_button",
			        open: function() { $(this).addClass('buttonClass') },
			        click: function() 
			        {        
						$(this).dialog('close'); 	
			        }
			    }
			  ],
			  
            open: function ()
            {

	        	$(this).load( "employee_new.cfm", 'dummy' + Math.random());
	        	
            }          
	    }); 
	  }	


	highlightRequiredData=function(id)
	{
		$('#'+id).css({"border": 'red solid 1px',"color": 'black'});	
	}

	un_highlightRequiredData=function(id)
	{
		$('#'+id).css({"border": 'gray solid 1px',"color": 'black'});	
	}	  	


	newThisEmployee=function()
	{
		
		var urlString =  'employee_new.cfm?employeeId_pk=';		
		var windowName = 'new_employee_cfWidnow';
		var windowTitle = 'New Employee';
		var theHeight = 600;
		var theWidth  = 700;
		
		openThisCfWindow(urlString, windowName, windowTitle,theHeight,theWidth);
	}
		
		  	
</script>
<div style="text-align:center; border:px solid red">    
    <cfdiv bind="url:employeeContent.cfm" id="employeeContentBody">       
</div>

<!---<cfajaxproxy cfc="ajaxFunc.qpc" jsclassname="qpcCFC">
<script>
	
	var preRow = '';
	var preRowBgColor = 'white';
	var selectedMenuIdColor = '#add8e6';	
	var newFieldColor = 'white';//'oldlace';
	var exitMessagePage = "Your changes will be lost if you click on [Leave this page].\n \nClick on [Stay on this page] to stay on the current page.";
	var theBrowser = navigator.appName;
	
	resetHeaderWidth=function()
	{
		try
		{		
			document.getElementById('header1').width = document.getElementById('data1').width;
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
	}

	highlightThisRow=function(id)
	{
		try
		{		
			document.getElementById(id).style.background = highlightBackgroundColor;
			document.getElementById(id).style.color = highlightTextColor;
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}

	}

	unhighlightThisRow=function(id,rowBackgroundColor)
	{
		try
		{		
			document.getElementById(id).style.background = rowBackgroundColor;
			document.getElementById(id).style.color = 'black';	
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}

	}
		
	selectThisMenu=function(id, currentRow, bgColor)
	{	
		//alert('preRow: ' + preRow +'<==>'+ 'currentRow: ' + currentRow);
		if(gFormChanged == true)
		{
			
		}
		
		if (preRow != currentRow) 
		{
			document.getElementById(currentRow).style.backgroundColor = selectedMenuIdColor;
			
			if (document.getElementById(preRow) != null) 
			{
				document.getElementById(preRow).style.backgroundColor = preRowBgColor;
			}
			
			preRow = currentRow;
			preRowBgColor = bgColor;
			document.getElementById('pleaseSelectEstimate').style.display = 'none';
			
			ColdFusion.navigate('estimate_view.cfm?id=' + id, 'estimateBody');
			gFormChanged = false;
		}	
	}	

	disableNewEstimateButton=function()
	{
		document.getElementById("newEstimate").disabled = document.getElementById("logout").disabled = true;
		document.getElementById("newEstimate").style.color = document.getElementById("logout").style.color ='lightGrey';
	}

	ableNewEstimateButton=function()
	{
		document.getElementById("newEstimate").disabled = document.getElementById("logout").disabled = false;
		document.getElementById("newEstimate").style.color = document.getElementById("logout").style.color ='blue';
		
	}

	disableEstimateMenu=function()
	{
		try
		{	
			document.getElementById('menuList').disabled = true;
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
					
	}

	ableEstimateMenu=function()
	{
		try
		{	
			document.getElementById('menuList').disabled = false;	
		}
		
		catch(error)
		{
			alert('error message on ableEstimateMenu: '+ error.message)
		}
	}

	lockTabs=function()
	{	
		try
		{		
			ColdFusion.Layout.disableTab('mainTab', 'Invoice');

		}
		
		catch(error)
		{
			alert('error message on lockTabs: '+ error.message)
		}	
	}
				
	newEstimate=function()
	{	
		try
		{		
			gFormChanged = true;
						
			//if(preRow != 0) document.getElementById(preRow).style.backgroundColor = preRowBgColor;
			
			ColdFusion.navigate('estimate_new.cfm?id=0', 'estimateBody');
			
			disableNewEstimateButton();
			disableEstimateMenu();
			
			document.getElementById('pleaseSelectEstimate').style.display = 'none';
			preRow = 0;
			return true;

		}
		
		catch(error)
		{
			alert('error message on fucntion newEstimate: '+ error.message);
			return false;
		}
		
	}

	cancelNewEstimate=function(id)
	{	
		try
		{		
			gFormChanged = false;
			ableNewEstimateButton();
			ableEstimateMenu();
			js_currentEstimate = document.getElementById("currentEstimate").value;
			ColdFusion.navigate('estimate_view.cfm?id=' + js_currentEstimate, 'estimateBody');
		}
		
		catch(error)
		{
			alert('error message of function cancelNewEstimate: '+ error.message)
		}
		
	}
	
	submitNewEstimate=function()
	{	
		try
		{		
			//alert('submitNewEstimate');
			var newItemArray = new Array();
			var newScopeWorkArray = new Array();
			var newAmountArray = new Array();
			var newRemarkArray = new Array();
			var requiredValueMessage = '';
			theToken = document.getElementById('token').value;
			
			if(document.getElementById('estimateStatus1').checked == true)
				var estimateStatus = 0;
			else if(document.getElementById('estimateStatus2').checked == true)
				var estimateStatus = 1;
			else
				var estimateStatus = 2;		
			
			//Gathering new item information
			var arrayIndex = 0;
			currentNewRows = document.getElementById("numberofNewItems").value;		
			for(i = 1; i <= currentNewRows; i++)
			{           
	    		if(document.getElementById("amount_"+i) != null)
				{
					if(document.getElementById("item_"+i).value == '')
					{
						requiredValueMessage = 'require';
						highlightRequiredField("item_"+i);
					}
					else
					{
						newItemArray[arrayIndex] = document.getElementById("item_"+i).value;
					}
						
					if(document.getElementById("scopeWork_"+i).value == '')
					{
						requiredValueMessage = 'require';
						highlightRequiredField("scopeWork_"+i);
					}
					else
					{
						newScopeWorkArray[arrayIndex] = document.getElementById("scopeWork_"+i).value;
					}											
											
					if(document.getElementById("amount_"+i).value == '')
					{
						requiredValueMessage = 'require';
						highlightRequiredField("amount_"+i);
					}					
					else
					{
						newAmountArray[arrayIndex] = document.getElementById("amount_"+i).value;
					}							
				}
				arrayIndex++;
				
			} 

			//Gathering new remark information
			var arrayIndex = 0;
			currentNewRemarks = document.getElementById("numberofNewRemarks").value;		
			for(i = 1; i <= currentNewRemarks; i++)
			{           
	    		if(document.getElementById("remark_"+i) != null)
				{
					if(document.getElementById("remark_"+i).value == '')
					{
						requiredValueMessage = 'require';
						highlightRequiredField("remark_"+i);
					}
					else
					{
						newRemarkArray[arrayIndex] = document.getElementById("remark_"+i).value;
					}
						
				}
				arrayIndex++;
				
			}	
	
			//validate expired days
			if(document.getElementById('expiredDays').value == '')
			{
				requiredValueMessage = 'require';
				highlightRequiredField('expiredDays');
			}
			
	
			if(requiredValueMessage != '')
			{
				alert('Please enter required field(s). ')
				gFormChanged = true;
				return false;
			}
			else
			{			
				var estimateNumber = document.getElementById('estimateNumber').value;
				var estimateDate = document.getElementById('estimateDate').value;
				var companyName = document.getElementById('companyName').value;
				var attention = document.getElementById('attention').value;
				var companyAddress = document.getElementById('companyAddress').value;
				var jobsiteAddress = document.getElementById('jobsiteAddress').value;
				var expiredDays = document.getElementById('expiredDays').value;
				var preparedBy = document.getElementById('preparedBy').value;

				var e = new qpcCFC();
				e.setHTTPMethod("POST");
				js_submitNewEstimate = e.function_submitNewEstimate(newItemArray,newScopeWorkArray, newAmountArray,newRemarkArray,estimateNumber,estimateDate,companyName,attention,companyAddress,jobsiteAddress,expiredDays,preparedBy,estimateStatus,theToken);

				if(js_submitNewEstimate == 'hacker')
				{
					var e = new qpcCFC();
					e.setHTTPMethod("POST");
					jsLogout = e.function_logout();
					gFormChanged = false;
					//location.reload('estimate.cfm');
					location.href = "hacker.cfm";
				}
				else
				{
					gFormChanged = false;
					ableNewEstimateButton();
					ableEstimateMenu();
					location.reload('estimate.cfm');
					return true;	
				}			
			}

		}
		
		catch(error)
		{
			alert('error message of function submitNewEstimate: '+ error.message)
		}
		
	}	

	deleteRow=function(rowID)
	{	//alert(rowID)
		document.getElementById(rowID).style.backgroundColor ='red';
		confirmed = window.confirm("Are you sure you wish to delete this row?");
		if (confirmed == false)
		{	
			document.getElementById(rowID).style.backgroundColor ='';
			return false;
		}
		else
		{
			document.getElementById(rowID).parentNode.deleteRow(document.getElementById(rowID).sectionRowIndex);	
		}
	}

	deleteScopeWork=function(rowID,  id)
	{	//alert(rowID)
		document.getElementById(rowID).style.backgroundColor ='red';
		confirmed = window.confirm("Are you sure you wish to delete this row?");
		if (confirmed == false)
		{	
			document.getElementById(rowID).style.backgroundColor ='';
			return false;
		}
		else
		{
			document.getElementById("numberofDeleteItems").value += id + ',';
			document.getElementById(rowID).parentNode.deleteRow(document.getElementById(rowID).sectionRowIndex);	
		}
	}


	deleteRemark=function(rowID,  id)
	{	//alert(rowID)
		document.getElementById(rowID).style.backgroundColor ='red';
		confirmed = window.confirm("Are you sure you wish to delete this row?");
		if (confirmed == false)
		{	
			document.getElementById(rowID).style.backgroundColor ='';
			return false;
		}
		else
		{
			document.getElementById("numberofDeleteRemarks").value += id + ',';
			document.getElementById(rowID).parentNode.deleteRow(document.getElementById(rowID).sectionRowIndex);	
		}
	}
	
	newItem=function(theBrowser)
	{
		try
		{
			if(theBrowser == 'ie')
			{
				var itemWidth = 20;
				var scopeWorkWidth = 100;
				var amtWidth = 12;
			}
			else
			{
				var itemWidth = 15;
				var scopeWorkWidth = 78;
				var amtWidth = 10;
			}
			document.getElementById("numberofNewItems").value++;
			rowID = document.getElementById("numberofNewItems").value;
			theTable = document.getElementById('estimateTable');
			
			//INSERT NEW ROW
			var newRow = theTable.insertRow();
			newRow.id = 'trItem_' + rowID;

			//Insert New Delete
			var td_delete = newRow.insertCell();	
			td_delete.align = 'center';
			td_delete.style.width = '100px';
			td_delete.style.borderTop = '1px solid black';
			
			var delButton = document.createElement('span');	
/*
			delButton.type = 'button';
			delButton.value = 'Delete';
*/
			delButton.innerHTML = '[X]';
			delButton.style.color = 'red';
			delButton.style.cursor = 'pointer';
			delButton.style.fontWeight = 'bold';
			//delButton.className = 'smallerInputText';
			delButton.onclick = function(){deleteRow(newRow.id)};
			td_delete.appendChild(delButton);
					
			//Insert New Item
			var td_item = newRow.insertCell();
			td_item.style.border = '1px solid black';
			td_item.style.paddingTop = td_item.style.paddingBottom =  '5px ';
			td_item.style.width = '150px';
			var inputItem = document.createElement('textarea');
			inputItem.name = inputItem.id = 'item_' + rowID;
			//inputItem.style.fontSize = '13px';
			inputItem.style.backgroundColor = newFieldColor;
			//inputItem.size = '14';
			inputItem.cols = itemWidth;
			inputItem.rows = 1;
			inputItem.onkeyup=function() {determineHeight(this);limitText(this);};
			inputItem.style.overflow = 'hidden';
			inputItem.onkeydown=function() {changeIsMade();};
			//inputItem.value = inputItem.id;
			inputItem.onclick = function(){unHighlightRequiredField(inputItem.id);};
			td_item.appendChild(inputItem);		

			//Insert New Scope of Work
			var td_scopeWork = newRow.insertCell();
			td_scopeWork.style.border = '1px solid black';
			var inputScopeWork = document.createElement('textarea');
			inputScopeWork.name = inputScopeWork.id = 'scopeWork_' + rowID;
			//inputScopeWork.style.fontSize = '13px';
			inputScopeWork.style.backgroundColor = newFieldColor;
			//inputScopeWork.size = '110';
			//inputScopeWork.value = inputScopeWork.id;
			inputScopeWork.cols = scopeWorkWidth;
			inputScopeWork.rows = 1;
			inputScopeWork.onkeyup=function() {determineHeight(this);limitText(this);};
			inputScopeWork.style.overflow = 'hidden';					
			inputScopeWork.onclick = function(){unHighlightRequiredField(inputScopeWork.id);}
			inputScopeWork.onkeydown=function() {changeIsMade();};
			td_scopeWork.appendChild(inputScopeWork);	

			//Insert New Amount
			var td_amount = newRow.insertCell();
			td_amount.style.border = '1px solid black';
			td_amount.textAlign = 'right';
			var inputAmount = document.createElement('input');
			inputAmount.name = inputAmount.id = 'amount_' + rowID;
			//inputAmount.style.fontSize = '13px';
			inputAmount.style.backgroundColor = newFieldColor;
			inputAmount.size = amtWidth;
			//inputAmount.value = '0.00';
			inputAmount.style.textAlign = 'right';
			inputAmount.onclick = function(){unHighlightRequiredField(inputAmount.id);}
			inputAmount.onkeypress = function(){return isDecimalNumber(this,event)};
			inputAmount.onblur = function(){return roundItToTwo(this.id)};
			inputAmount.onchange = function(){return calculateEstimateTotal(this.value)};
			inputAmount.onkeydown=function() {changeIsMade();};
			td_amount.appendChild(inputAmount);		
		}

		catch(error)
		{
			alert('error on function newItem: '+ error.message)
		}		
	}		

	newRemark=function(theBrowser)
	{
		try
		{
			if(theBrowser == 'ie')
			{
				var remarkWidth = 137;
			}
			else
			{
				var remarkWidth = 110;
			}
			document.getElementById("numberofNewRemarks").value++;
			rowID = document.getElementById("numberofNewRemarks").value;
			theTable = document.getElementById('remarkTable');

			//INSERT NEW ROW
			var newRow = theTable.insertRow();
			newRow.id = 'trRemark_' + rowID;

			//Insert New Delete
			var td_delete = newRow.insertCell();	
			td_delete.align = 'center';
			td_delete.style.width = '200px'
			td_delete.style.borderTop = '1px solid black';
			td_delete.style.paddingTop = td_delete.style.paddingBottom =  '5px ';
			
			var delButton = document.createElement('span');	
/*
			delButton.type = 'button';
			delButton.value = 'Delete';
*/
			delButton.innerHTML = '[X]';
			delButton.style.color = 'red';
			delButton.style.cursor = 'pointer';
			//delButton.className = 'smallerInputText';
			delButton.style.fontWeight = 'bold';
			delButton.onclick = function(){deleteRow(newRow.id)};
			td_delete.appendChild(delButton);
					
			//Insert New Item
			var td_remark = newRow.insertCell();
			td_remark.style.border = '1px solid black';
			td_remark.style.width = '890px';
			var inputRemark = document.createElement('textarea');
			inputRemark.name = inputRemark.id = 'remark_' + rowID;
			//inputRemark.style.fontFamily = 'Arial';
			//inputRemark.style.fontSize = '13px';
			inputRemark.style.backgroundColor = newFieldColor;
			inputRemark.cols = remarkWidth;
			inputRemark.rows = 1;
			inputRemark.onkeyup=function() {determineHeight(this);limitText(this);};
			inputRemark.style.overflow = 'hidden';
		
					
			//inputRemark.value = inputRemark.id;
			inputRemark.onclick = function(){unHighlightRequiredField(inputRemark.id);};
			inputRemark.onkeydown=function() {changeIsMade();};
			td_remark.appendChild(inputRemark);		
	
		}
		
		catch(error)
		{
			alert('error on function newRemark: '+ error.message)
		}	
	}	
	
	determineHeight=function(ele)
	{
		ele.style.height = (ele.scrollHeight + 4) + "px";
	}

	limitText = function(el) 
	{
		var max_len = 400;
		if (el.value.length > max_len) 
		{
			el.value = el.value.substr(0, max_len);
		}

		return true;
	}		


	deleteThisEstimate=function(id)
	{	
		try
		{		
			var theConfirm = confirm('Are you sure you want to delete this estimate?')
			var theToken = document.getElementById('token').value;
			if(theConfirm)
			{
				var e = new qpcCFC();
				e.setHTTPMethod("POST");;
				js_deleteEstimate = e.function_deleteEstimate(id,theToken);

				if(js_deleteEstimate == 'hacker')
				{
					var e = new qpcCFC();
					e.setHTTPMethod("POST");
					jsLogout = e.function_logout();
					location.href = "hacker.cfm";
				}
				else
				{
					location.reload('estimate.cfm');
				}				
			}
			else
			{
			}
			//ColdFusion.navigate('estimate_edit.cfm?id=' + id +'&estimateMode=edit', 'estimateBody');	
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
		
	}
	
	unHighlightRequiredField=function(id)
	{	
		try
		{		
			document.getElementById(id).style.backgroundColor = newFieldColor;		
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
		
	}
	
	highlightRequiredField=function(id)
	{	
		try
		{		
			document.getElementById(id).style.backgroundColor ='red'		
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
		
	}
	
	
	numeralsOnly=function(evt) 
	{
		evt = (evt) ? evt : event;
	    var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode : ((evt.which) ? evt.which : 0));
	    if (charCode > 31 && (charCode < 48 || charCode > 57)) 
		{
	        return false;
	    }
	    return true;
	}
	
	isDecimalNumber=function(sender, evt) 
	{ 
		try
		{
			var txt = sender.value; 
			var dotcontainer = txt.split('.'); 
			var charCode = (evt.which) ? evt.which : event.keyCode; 
			var len = sender.value.length; 
			var index = sender.value.indexOf('.'); 
							
			if (!(dotcontainer.length == 1 && charCode == 46) && charCode > 31 && (charCode < 48 || charCode > 57)) 
			{
				return false; 
			}
		}
		
		catch(error)
		{
			alert('error message function isDecimalNumber: ' + error.message)
		}

		return true; 
	}
	
	roundItToTwo=function(id)
	{
		try
		{			
			var theValue= Number(document.getElementById(id).value).toFixed(2);			
			document.getElementById(id).value = theValue;
		}
		
		catch(error)
		{
			alert('error message function roundItToTwo: ' + error.message)
		}		
	}
		
	PopupCenter=function(url, title, w, h) 
	{
		// Fixes dual-screen position                         Most browsers      Firefox
		var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
		var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;
	
		var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
		var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
	
		var left = ((width / 2) - (w / 2)) + dualScreenLeft;
		var top = ((height / 2) - (h / 2)) + dualScreenTop;
		var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
	
		// Puts focus on the newWindow
		if (window.focus) {
			newWindow.focus();
		}
	}


	openTakeoff=function(estimateId)
	{
		var urlstring = "estimate_takeoff.cfm?estimateId=" + estimateId;
		
		mytakeoffWindow = window.open(urlstring,"estimateTakeoff","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
		// check to make sure the window opened properly.  If not, it got shot down by the pop-up blocker
		if(mytakeoffWindow)
		{
			mytakeoffWindow.focus();
		}else{
			alert('You may need to allow pop-up windows for this site to function properly');
		}
	}	

	confirmLeave=function()
	{
		if(gFormChanged)
		{
			return exitMessagePage;
			
		}
	}

				
	changeExpiredDate=function()
	{
		try
		{
			days = document.getElementById('expiredDays').value;
			js_EstimateDate = document.getElementById('estimateDate').value;
			if(days != '' && js_EstimateDate != '')
			{
				var e = new qpcCFC();
				e.setHTTPMethod("POST");
				newExpiredDate = e.function_changeExpiredDateByEstimateDate(days,js_EstimateDate);			
				document.getElementById('expiredDate').innerHTML = newExpiredDate;
				document.getElementById('expiredDate').style.color = 'black';				
			}

		}
		
		catch(error)
		{
			alert('error message function changeExpiredDate: '+ error.message)
		}

	}	


	function calculateEstimateTotal(value)
	{
		try
		{
			var arrayIndex = 0;
			var js_estimateTotal = 0;
			var currentEditRows = document.getElementById("numberofEditItems").value;		
			for(i = 1; i <= currentEditRows; i++)
			{       
	    		if(document.getElementById("editAmount_"+i) != null)
				{	
					if(document.getElementById("editAmount_"+i).value != '')
					{
						js_estimateTotal = parseFloat(js_estimateTotal) + parseFloat(document.getElementById("editAmount_" + i).value);
					}								
				}
				arrayIndex++;
				
			} 

			var currentNewRows = document.getElementById("numberofNewItems").value;		
			for(i = 1; i <= currentNewRows; i++)
			{       
	    		if(document.getElementById("amount_"+i) != null)
				{	
					if(document.getElementById("amount_"+i).value != '')
					{
						js_estimateTotal = parseFloat(js_estimateTotal) + parseFloat(document.getElementById("amount_" + i).value);
					}								
				}
				arrayIndex++;
				
			} 
								
			document.getElementById("estimateTotal").innerHTML = js_estimateTotal.toFixed(2);	
		}
		
		catch(error)
		{
			alert('error message function calculateEstimateTotal: ' + error.message)
		}
		
		return value;
	}	
	
	function determineHeight(ele)
	{
		ele.style.height = (ele.scrollHeight + 4) + "px";
		alert('test')
	}		
	
	limitText = function(el) 
	{
	var max_len = 400;
	if (el.value.length > max_len) {
	el.value = el.value.substr(0, max_len);
	}
	//document.getElementById('char_cnt').innerHTML = el.value.length;
	//document.getElementById('chars_left').innerHTML = max_len - el.value.length;
	return true;
	}
	
	function logout()
	{
		try
		{
			window.close();
		}
		catch(error)
		{
			alert('error on function logout: '+ error.message)
		}
	}	

	changeIsMade=function()
	{
		gFormChanged = true;
		//alert('test')
	} 

	confirmLeaveEstimateScreen = function()
	{
		try
		{
			if(gFormChanged)
			{
				var e = new qpcCFC();
				e.setHTTPMethod("POST");
				jsLogout = e.function_logout();
				return exitMessagePage;
			}	
			else
				return true;	
		}
		catch(error)
		{
			alert('error on function confirmLeaveEstimateScreen ' + error.message)
		}
	
		return true;
		
	}

	deleteAllSessions=function()
	{
		try
		{
			//var  = new qpcCFC();
			//e.setHTTPMethod("POST");
			//jsKillSession = e.function_killSessions();	
		alert('deleteAllSessions')
		}
		catch(error)
		{
			alert('error on function deleteAllSessions: '+ error.message)
		}		

	}
	
	convertStringToArray=function(string)
	{
		try
		{  
			var returnThisArray = new Array();
			var stringArray = string.split(',');
			for (var arrayIndex = 0; arrayIndex < stringArray.length; arrayIndex++) 
		{ 
			returnThisArray[arrayIndex] = stringArray[arrayIndex].trim();
		}
		
			alert(returnThisArray)
		
		}
		
		catch(error)
		{
			alert('error message on function convertStringToArray: '+ error.message)
		}
	}				

	deleteThisWorksheet=function(worksheetId, estimateId, fileName)
	{
		var theConfirm = confirm('Are you sure you want to delete this worksheet?')
		if(theConfirm)
		{
			var e = new qpcCFC();
			e.setHTTPMethod("POST");
			jsDeleteThisWorksheet = e.function_deleteThisWorksheet(worksheetId,fileName);
			//alert(jsDeleteThisWorksheet);
			ColdFusion.navigate('estimate_worksheetList.cfm?estimateId=' + estimateId,'worksheetList');		
		}

	}			

	mouseOver=function(id)
	{

		document.getElementById(id).style.textDecoration ='underline';
	}

	mouseOut=function(id)
	{
		document.getElementById(id).style.textDecoration ='none';
	}
	
		
</script>

--->
<!---<cfajaxproxy cfc="qpc.ajaxFunc.qpc" jsclassname="qpcCFC">--->

<script type="text/javascript" language="javascript">
	var gFormChanged = false;
	var formChanged = false;
	var exitMessageItem = "Your changes will be lost if you press OK.\n \nPress OK to continue or Cancel to stay on the current mission.";
	var exitMessagePage = "Your changes will be lost if you press OK.";
	var myDate = '';
	var preRow = '';
	var preRowBgColor = 'white';
	var selectedMenuIdColor = '#add8e6';	
	var newFieldColor = 'white';//'oldlace';
	var exitMessagePage = "Your changes will be lost if you click on [Leave this page].\n \nClick on [Stay on this page] to stay on the current page.";
	var theBrowser = navigator.appName;
		
	catchError=function()
	{	
		try
		{	
			alert('catchError');
		}
		catch(error)
		{
			alert('An error occured in function catchError: '+error.message)	
		}
		
	}
	
	
	confirmLeavePage=function()
	{
		if(formChanged)
		{
			if(confirm(exitMessagePage))
			{
				formChanged = false;
				return true;			
			}
			else
			{
				return false;	
			}
	
		}
		else
		{
			return true;	
		}
	}
	
	confirmLeaveItem=function()
	{
		if(formChanged)
		{
			if(confirm(exitMessageItem))
			{
				return false;
			}
		}
		else
		{
			return true;	
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
		
	cal_Selected=function(cal, date)
	{
		cal.sel.value = date;
		if (cal.dateClicked)
		{
			cal.callCloseHandler(); //close the calendar after user select a date
	
		}
		changeExpiredDate();
		gFormChanged = true;
		//alert(document.getElementById('estimateDate').value);
		//alert(document.getElementById('expiredDays').value);
	}
	
	//<
	//  FUNCTION Name: cal_Close(cal)
	//    Description: Close Calendar Callback
	//     Parameters: cal - calendar object
	//        Returns: 
	//  Relationships: 
	//       Comments: 
	//>
	 cal_Close=function(cal)
	{
		cal.hide();
	}
	
	//<
	//  FUNCTION Name: showCalendar(txtId, imgId)
	//    Description: Show Calendar (uses JS Calendar)
	//     Parameters: txtId - calendar text
	//				   imgId - calendar image
	//        Returns: true/false
	//  Relationships: 
	//       Comments: uses properties and methods of calendar object (cal)
	//>
	showCalendar=function(txtId, imgId)
	{
		var txt = document.getElementById(txtId);
		var img = document.getElementById(imgId);
		if (_dynarch_popupCalendar != null)
		{
			_dynarch_popupCalendar.hide();
		}
		else
		{
			var cal = new Calendar(0, null, cal_Selected(id), cal_Close, id);
	
			cal.weekNumbers = false;
			cal.showsOtherMonths = true;
			cal.setRange(1900, 2070);
			//cal.setDateFormat("%m/%d/%Y");
			cal.setDateFormat("%e-%b-%y");
			cal.create();
			_dynarch_popupCalendar = cal;
		}
		_dynarch_popupCalendar.parseDate(txt.value);
		_dynarch_popupCalendar.sel = txt;
		_dynarch_popupCalendar.showAtElement(img, "Br");
	
		return false;
	}
	
	showCalendar2=function(txtId, imgId, theForm, id)
	{	
		var txt = document.getElementById(txtId);
		var img = document.getElementById(imgId);
		
		
		if (_dynarch_popupCalendar != null)
		{
			_dynarch_popupCalendar.hide();
			
		}
		else
		{	
			var cal = new Calendar(0, null, cal_Selected, cal_Close);
	
			cal.weekNumbers = false;
			cal.showsOtherMonths = true;
			cal.setRange(1900, 2070);
			cal.setDateFormat("%b %d, %Y");
			//cal.setDateFormat("%m-%d-%Y");
			cal.create();
			_dynarch_popupCalendar = cal;
	
		}
		_dynarch_popupCalendar.parseDate(txt.value);
		_dynarch_popupCalendar.sel = txt;
		_dynarch_popupCalendar.showAtElement(img, "Br");
		
		return false;
		
	}
	
	
	confirmDeleteService = function(employeeID, endingPeriodID)
	{	
		myConfirm = confirm('Are you sure you want to delete this Service?')
		if (myConfirm)
		{
	
			var e = new nailtrapCFC();		
			e.deleteService(employeeID, endingPeriodID);
			ColdFusion.navigate('technicianListview.cfm?endingPeriodID='+endingPeriodID, 'technicianListview');
			ColdFusion.navigate('technicianService_view.cfm', 'serviceViewEdit');
			//ColdFusion.navigate('income_view.cfm?menuName=Incomes', 'incomeStatus');
			//ColdFusion.navigate('income_listview.cfm', 'incomeListview');
		}
		else
		{
			return false;	
		}
	}
	
	saveEmployeexx=function(employeeID, menuID)
	{
		var e = new nailtrapCFC();
		inputs = document.getElementsByTagName('input');
		firstName = document.getElementById('firstName').value;
		lastName = document.getElementById('lastName').value;
	
		if(document.getElementById('payrollType1').checked == true)
		{
			payrollType = 1;
		}
		else
		{
			payrollType = 2;
		}
		
		e.saveEmpoyee(employeeID, firstName,lastName,payrollType);
		formChanged = false;
		try{
		highlightMenu('employee',menuID);
		}
		catch(error)
		{
			alert(error.message);
		}
		
		ColdFusion.navigate('employee_listview.cfm?employeeID='+employeeID, 'employeeListview' );
	
		//ColdFusion.navigate('employee_view.cfm?employeeID=#employeeID_pk#&menuID=#variables.counter#', 'employeeView' );
		//ColdFusion.navigate('technicianListview.cfm?endingPeriodID='+endingPeriodID, 'technicianListview');	
		//ColdFusion.navigate('technicianService_view.cfm', 'serviceViewEdit');	
	}
	
	function selectProposalType(option)
	{	//alert('selectProposalType');
		try
		{
			if(option == 0)
			{
				document.getElementById('uploadProposal_id').style.display ='';
				document.getElementById('usingTemplate_id').style.display ='none';
			}
			else
			{
				document.getElementById('uploadProposal_id').style.display ='none';
				document.getElementById('usingTemplate_id').style.display ='';
			}
		}
		catch(error)
		{
			alert('An error occured in function selectProposalType: '+error.message)	
		}
		
	}
	
	function getCustomerInfo(customerID)
	{	var e = new qpcCFC();
		try
		{
			customerInfo = e.getCustomerInfo(customerID);
			if(customerInfo != '')
			{
				company = customerInfo.split('|')[0];
				address = customerInfo.split('|')[1];
				city = customerInfo.split('|')[2];
				state = customerInfo.split('|')[3];
				zip = customerInfo.split('|')[4];
				phone = customerInfo.split('|')[5];
				//alert(customerInfo + "\n"+company + "\n"+attn + "\n"+address + "\n"+city+ "\n"+state + "\n"+zip + "\n"+phone);
				//document.getElementById('company').value = company;			
				document.getElementById('address').value = address;
				document.getElementById('city_state_zip').value = city + ', ' + state + ' ' + zip;;
				document.getElementById('phone').value = phone;
				//document.getElementById('company2').innerHTML = company;
			}
			else
			{
				//document.getElementById('company').value = '';
				document.getElementById('address').value = '';
				document.getElementById('city_state_zip').value = '';
				document.getElementById('phone').value = '';	
				
				//document.getElementById('company2').innerHTML = '';
			}
		}
		catch(error)
		{
			alert('An error occured in function getCustomerInfo: '+error.message)	
		}
		
	}	
		
	function saveProposal()
	{	
		try
		
		{	//alert('saveProposal');
			var workDescription = '';
			var lineTotal = '';
			customerID = document.getElementById('customerID').value;
			attn = document.getElementById('attn').value;
			proposalDate = document.getElementById('proposalDate').value;
			proposalName = document.getElementById('proposalName').value;
			proposalNumber = document.getElementById('proposalNumber').value;
			proposalPhone = document.getElementById('proposalPhone').value;
			projectID = document.getElementById('projectID').value;
			
			if(ColdFusion.getElementValue('workDescription_1') != '')
			{
				workDescription +=	ColdFusion.getElementValue('workDescription_1') + '`';
				if(document.getElementById('lineTotal_1').value =='')
					document.getElementById('lineTotal_1').value = 0;
				lineTotal += document.getElementById('lineTotal_1').value + '`';
			}
	
			if(ColdFusion.getElementValue('workDescription_2') != '')
			{
				workDescription += ColdFusion.getElementValue('workDescription_2') + '`';
				if(document.getElementById('lineTotal_2').value =='')
					document.getElementById('lineTotal_2').value = 0;
				lineTotal += document.getElementById('lineTotal_2').value + '`';
			}
			
			if(ColdFusion.getElementValue('workDescription_3') != '')
			{
				workDescription +=	ColdFusion.getElementValue('workDescription_3');
				if(document.getElementById('lineTotal_3').value =='')
					document.getElementById('lineTotal_3').value = 0;			
				lineTotal += document.getElementById('lineTotal_3').value + '`';
			}
	
			if(proposalName == '')
			{
				document.getElementById('proposalName').style.borderColor = 'red';
				
				alert('Proposal Name is required.');
				document.getElementById('proposalName').focus;
				return false;
			}
			
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'attn = '+attn +"\n"+ 'proposalName = '+proposalName);
			var e = new qpcCFC();
			mySaveProposal = e.saveProposal(customerID, attn, proposalDate, proposalName,workDescription,lineTotal, proposalNumber, proposalPhone, projectID);
			
			alert(mySaveProposal);
			
			ColdFusion.navigate('project.cfm', 'template');
		}
		catch(error)
		{
			alert('An error occured in function saveProposal: '+error.message)	
		}
		
	}
	
	function updateProposal(proposalType)
	{	
		try
		
		{	//alert(proposalType);  
			var e = new qpcCFC();
			var workDescription = '';
			var lineTotal = '';
			proposalID_pk = document.getElementById('proposalID_pk').value
			customerID = document.getElementById('customerID').value;
			attn = document.getElementById('attn').value;
			proposalDate = document.getElementById('proposalDate').value;
			proposalName = document.getElementById('proposalName').value;
			proposalNumber = document.getElementById('proposalNumber').value;
			projectID = document.getElementById('projectID').value;
			
			approvedBy = document.getElementById('approvedBy').value;
			approvedDate = document.getElementById('approvedDate').value;
			estimateStartDate = document.getElementById('estimateStartDate').value;
			estimateEndDate = document.getElementById('estimateEndDate').value;
			completedDate = document.getElementById('completedDate').value;		
			proposalPhone = document.getElementById('proposalPhone').value;
			
			if(proposalType == 1)
			{	
				if(ColdFusion.getElementValue('workDescription_1') != '')
				{
					workDescription +=	ColdFusion.getElementValue('workDescription_1') + '`';
					if(document.getElementById('lineTotal_1').value =='')
						document.getElementById('lineTotal_1').value = 0;
					lineTotal += document.getElementById('lineTotal_1').value + '`';
				}
		
				if(ColdFusion.getElementValue('workDescription_2') != '')
				{
					workDescription += ColdFusion.getElementValue('workDescription_2') + '`';
					if(document.getElementById('lineTotal_2').value =='')
						document.getElementById('lineTotal_2').value = 0;
					lineTotal += document.getElementById('lineTotal_2').value + '`';
				}
				
				if(ColdFusion.getElementValue('workDescription_3') != '')
				{
					workDescription +=	ColdFusion.getElementValue('workDescription_3');
					if(document.getElementById('lineTotal_3').value =='')
						document.getElementById('lineTotal_3').value = 0;			
					lineTotal += document.getElementById('lineTotal_3').value + '`';
				}
			}
			else
			{
				workDescription =	document.getElementById('workDescription_1').value;
				lineTotal = document.getElementById('lineTotal_1').value;
			}
	
			if(proposalName == '')
			{
				document.getElementById('proposalName').style.borderColor = 'red';
				
				alert('Proposal Name is required.');
				document.getElementById('proposalName').focus;
				return false;
			}
	
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'attn = '+attn +"\n"+ 'proposalName = '+proposalName);
			
			mySaveProposal = e.updateProposal(proposalID_pk, customerID, attn, proposalDate, proposalName,workDescription,lineTotal, proposalNumber,approvedBy,approvedDate,estimateStartDate, estimateEndDate,completedDate,proposalPhone,proposalType, projectID );
			
			
			alert(mySaveProposal);
			
			//ColdFusion.navigate('proposal.cfm?proposalID=0', 'template');	
			ColdFusion.navigate('project.cfm?projectID=0', 'template');
			//ColdFusion.navigate('proposal_view.cfm?proposalID='+proposalID_pk+'&printPDF=0', 'proposalContent');
		}
		catch(error)
		{
			alert('An error occured in function updateProposal: '+error.message)	
		}
		
	}
		
	function viewProposal(proposalID)
	{	
		try
		
		{	alert('');
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note);
			var e = new qpcCFC();
			ColdFusion.navigate('proposal_content.cfm?proposalID=proposalID', 'template');
			
			
		}
		catch(error)
		{
			alert('An error occured in function viewProposal: '+error.message)	
		}
		
	}
	
	selectProposalMenu=function(id)
	{	
		try
		
		{	
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note);
	
			var e = new qpcCFC();
			tds = document.getElementsByTagName('td');
			for(i = 1; i <= (document.getElementById('number_of_proposals').value); i++)
			{
				if(document.getElementById('proposalID_'+i) != null)
				{
					document.getElementById('proposalID_'+i).style.backgroundColor = 'white';
					document.getElementById('proposalID_'+i).style.color = 'black';
				}
			}
			
			if(id != 0)
			{
				document.getElementById('proposalID_'+id).style.backgroundColor = '#006';
				document.getElementById('proposalID_'+id).style.color = 'white';
			}
			
			
		}
		catch(error)
		{
			alert('An error occured in function selectProposalMenu: '+error.message)	
		}
		
	}
	
	selectProjectMenu=function(id)
	{	
		try
		
		{	
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note);
	
			var e = new qpcCFC();
			tds = document.getElementsByTagName('td');
			for(i = 1; i <= (document.getElementById('number_of_projects').value); i++)
			{
				if(document.getElementById('projectID_'+i) != null)
				{
					document.getElementById('projectID_'+i).style.backgroundColor = 'white';
					document.getElementById('projectID_'+i).style.color = 'black';
				}
			}
			
			if(id != 0)
			{
				document.getElementById('projectID_'+id).style.backgroundColor = '#006';
				document.getElementById('projectID_'+id).style.color = 'white';
				
			}
			
			
		}
		catch(error)
		{
			alert('An error occured in function selectProjectMenu: '+error.message)	
		}
		
	}
	
	selectCustomerMenu=function(id)
	{	
		try
		
		{	
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note);
	
			var e = new qpcCFC();
			tds = document.getElementsByTagName('td');
			for(i = 1; i <= (document.getElementById('number_of_customers').value); i++)
			{
				if(document.getElementById('customerID_'+i) != null)
				{
					document.getElementById('customerID_'+i).style.backgroundColor = 'white';
					document.getElementById('customerID_'+i).style.color = 'black';
				}
			}
			
			if(id != 0)
			{
				document.getElementById('customerID_'+id).style.backgroundColor = '#006';
				document.getElementById('customerID_'+id).style.color = 'white';
			}
			
			
		}
		catch(error)
		{
			alert('An error occured in function selectCustomerMenu: '+error.message)	
		}
		
	}
	
	selectInvoiceMenu=function(id)
	{	
		try
		
		{	
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note);
	
			var e = new qpcCFC();
			tds = document.getElementsByTagName('td');
			for(i = 1; i <= (document.getElementById('number_of_invoices').value); i++)
			{
				if(document.getElementById('invoiceID_'+i) != null)
				{
					document.getElementById('invoiceID_'+i).style.backgroundColor = 'white';
					document.getElementById('invoiceID_'+i).style.color = 'black';
				}
			}
			
			if(id != 0)
			{
				document.getElementById('invoiceID_'+id).style.backgroundColor = '#006';
				document.getElementById('invoiceID_'+id).style.color = 'white';
			}
			
			
		}
		catch(error)
		{
			alert('An error occured in function selectInvoiceMenu: '+error.message)	
		}
		
	}
	
	function convertToPDF(proposalID)
	{
		try
		
		{	//alert(proposalID);
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note)
			var e = new qpcCFC();
			var urlstring = 'proposal_pdf.cfm?printPDF=1&proposalID='+proposalID ;
		
		mywinPDF = window.open(urlstring,"PDF","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
		mywinPDF.focus();
			
			
		}
		catch(error)
		{
			alert('An error occured in function convertToPDF: '+error.message)	
		}	
	}
	
	
	function convertToWord(proposalID)
	{
		try
		
		{	//alert(proposalID);
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'projectName = '+projectName +"\n"+ 'workDescription = '+workDescription +"\n"+ 'lineTotal = '+lineTotal +"\n"+ 'note = '+note)
			var e = new qpcCFC();
			var urlstring = 'proposal_word.cfm?printPDF=1&proposalID='+proposalID ;
		
		mywinWord = window.open(urlstring,"Word","width=1200,height=800,status=1,menuBar=1,scrollBars=1,resizable=1");
		mywinWord.focus();
			
			
		}
		catch(error)
		{
			alert('An error occured in function convertToPDF: '+error.message)	
		}	
	}
	
	
	function changeAttn()
	{	
		try
		{	
			document.getElementById('attn2').innerHTML = document.getElementById('attn').value;
		}
		catch(error)
		{
			alert('An error occured in function changeAttn: '+error.message)	
		}
		
	}
	
	
	function changeProposalDate()
	{	
		try
		{	alert(document.getElementById('proposalDate').value);
			month = document.getElementById('proposalDate').value.split('/')[0];
			day = document.getElementById('proposalDate').value.split('/')[1];
			year = document.getElementById('proposalDate').value.split('/')[2];
			document.getElementById('proposalNumber').value = month+day+year;
		}
		catch(error)
		{
			alert('An error occured in function changeProposalDate: '+error.message)	
		}
		
	}
		
	function validateNumber(id)
	{	
		try
		{	
			//alert(id);
			value = document.getElementById(id).value;
			if(value != '')
			{
				value = value.replace(/^\s+|\s+$/g, '');
				isValid = /^[-+]?[0-9]+(\.[0-9]+)?$/.test(value);
				if(!isValid)
				{
					document.getElementById(id).style.border = 'solid red 1px';
					document.getElementById(id).focus();
					alert('Number only '+'(example: 12, 12.00, or 12.1234).');
					return false;
				}
			}
		}
		
		catch(error)
		{
			alert('An error occured in function validateNumber: '+error.message)	
		}
		return true;
	}
	
	function calcProposalTotal()
	{
		try
		{	var lineTotal_2 = 0;
			var lineTotal_3 = 0
			//alert('calcProposalTotal');
			var lineTotal_1 = document.getElementById('lineTotal_1').value;
			if(document.getElementById('lineTotal_2') != null)
				lineTotal_2 = document.getElementById('lineTotal_2').value;
	
			if(document.getElementById('lineTotal_2') != null)
				lineTotal_3 = document.getElementById('lineTotal_3').value;
	
			//alert(lineTotal_1+'\n'+lineTotal_2+'\n'+lineTotal_3)
			//document.getElementById('proposalTotal').value =  lineTotal_1;	
			document.getElementById('proposalTotal').value =  ((lineTotal_1*1) + (lineTotal_2*1) + (lineTotal_3*1)).toFixed(2);	
	
		}
		
		catch(error)
		{
			alert('An error occured in function calcProposalTotal: '+error.message)	
		}
		return true;
	
	}
	
	function deleteProposal(proposalID, proposalType)
	{	
		try
		
		{	//alert('deleteProposal');  
			myConfirm = confirm('Are you sure you want to delete this proposal?')
			if (myConfirm)
			{
				var e = new qpcCFC();
				mySaveProposal = e.deleteProposal(proposalID, proposalType);
				alert(mySaveProposal);
				//ColdFusion.navigate('proposal.cfm', 'template');
				ColdFusion.navigate('project.cfm?projectID=0', 'template');
			}
		}
		catch(error)
		{
			alert('An error occured in function deleteProposal: '+error.message)	
		}
		
	}
	
	function clearData(id)
	{	
		try
		
		{	//alert('deleteProposal');  
			document.getElementById(id).value = '';
		}
		catch(error)
		{
			alert('An error occured in function clearData: '+error.message)	
		}
	}
	
	function validateDuplicatedProposalNumberxxx(proposalNumber)
	{
		try
		
		{	alert('validateDuplicatedProposalNumber');  
			
		}
		catch(error)
		{
			alert('An error occured in function clearData: '+error.message)	
		}
	}
	
	
	saveClient=function()
	{
		try
		
		{	//alert('saveClient');  
			var e = new qpcCFC();
			company = (document.getElementById('company_new').value);
			address = (document.getElementById('address_new').value);
			city = (document.getElementById('city_new').value);
			state = (document.getElementById('state_new').value);
			zip = (document.getElementById('zip_new').value);
			phone = (document.getElementById('phone_new').value);
			saveClient = e.saveClient(company, address, city, state, zip, phone);
			alert(saveClient);
			ColdFusion.navigate('customer.cfm', 'template');
		}
		catch(error)
		{
			alert('An error occured in function saveClient: '+error.message)	
		}
	}
	
	
	updateClient=function()
	{
		try
		
		{	//alert('saveClient');  
			var e = new qpcCFC();
			
			customerID_pk = (document.getElementById('customerID_pk').value);
			company = (document.getElementById('company_edit').value);
			address = (document.getElementById('address_edit').value);
			city = (document.getElementById('city_edit').value);
			state = (document.getElementById('state_edit').value);
			zip = (document.getElementById('zip_edit').value);
			phone = (document.getElementById('phone_edit').value);
	
			if(document.getElementById('active_edit').checked == true)
				deleteClient = 1;
			else
				deleteClient = 0
	
			updateClient = e.updateClient(customerID_pk,company, address, city, state, zip, phone, deleteClient);
			alert(updateClient);
			ColdFusion.navigate('customer.cfm', 'template');
		}
		catch(error)
		{
			alert('An error occured in function updateClient: '+error.message)	
		}
	}
	
	
	function uploadProposal()
	{	
		try
		
		{	//alert('uploadProposal');
			var workDescription = '';
			var lineTotal = '';
			var upload_proposal_file = '';
			customerID = document.getElementById('customerID').value;
			attn = document.getElementById('attn').value;
			proposalDate = document.getElementById('proposalDate').value;
			proposalName = document.getElementById('proposalName').value;
			proposalNumber = document.getElementById('proposalNumber').value;
			proposalPhone = document.getElementById('proposalPhone').value;
			projectID = document.getElementById('projectID').value;
	
			if(document.getElementById('lineTotal_1').value =='')
				document.getElementById('lineTotal_1').value = 0;
			lineTotal = document.getElementById('lineTotal_1').value;
			
			uploadedFile = document.getElementById('uploadedFile').value;
			uploadedFile = String(uploadedFile);
	
			if(proposalName == '')
			{
				document.getElementById('proposalName').style.borderColor = 'red';
				
				alert('Proposal Name is required.');
				document.getElementById('proposalName').focus;
				return false;
			}
			//alert('customerID = '+customerID +"\n"+ 'proposalDate = '+proposalDate +"\n"+ 'attn = '+attn +"\n"+ 'proposalName = '+proposalName);
			var e = new qpcCFC();
			myUploadProposal = e.uploadProposal(customerID, attn, proposalDate, proposalName,lineTotal, proposalNumber, proposalPhone, uploadedFile,projectID);
			
			alert(myUploadProposal);
			
			ColdFusion.navigate('project.cfm?projectID=0', 'template');
		}
		catch(error)
		{
			alert('An error occured in function uploadProposal: '+error.message)	
		}
		
	}
	
	function uploadProposalFile()
	{		
			//ColdFusion.Window.show('MyWindow');
			var urlstring = 'uploadProposalFile.cfm';
			
			myWindow = window.open(urlstring,"uploadDoorsFile","width=600,height=150,status=1,menuBar=1,scrollBars=1,resizable=1");
			myWindow.focus();
	}
	
	getFileName_parent=function(fileName)
	{
		//alert(fileName);	
		//alert('getFileName_parent');
		document.getElementById('uploadedFile').value = fileName;		
		myWindow.close ();
	}
	
	 getFileName_child=function(fileName)
	{
		//alert('getFileName_child');
		window.opener.getFileName_parent(fileName);
		
	}
	
	saveProject=function()
	{
		try
		{
			var e = new qpcCFC();
			alert(e);
			projectNumber = document.getElementById('projectNumber').value;
			projectName = document.getElementById('projectName').value;
			projectDate = document.getElementById('projectDate').value;		
			if(projectName == '')
			{
				document.getElementById('projectName').style.borderColor = 'red';
				alert('Project Name is required.')
				return false;
			}
			saveProject = e.saveProject(projectDate, projectNumber, projectName);		
			alert(saveProject);
			//ColdFusion.navigate('project_view.cfm?projectID=0', 'projectContent');
			ColdFusion.navigate('project.cfm?projectID=0', 'template');
		}
		catch(error)
		{
			alert('error occur on function saveProject '+ error.message);	
		}
	}
	
	updateProject=function()
	{
		try
		{
			var e = new qpcCFC();
			projectID = document.getElementById('projectID').value;
			projectNumber = document.getElementById('projectNumber').value;
			projectName = document.getElementById('projectName').value;
			projectDate = document.getElementById('projectDate').value;		
			if(projectName == '')
			{
				document.getElementById('projectName').style.borderColor = 'red';
				alert('Project Name is required.')
				return false;
			}
			updateProject = e.updateProject(projectID, projectDate, projectNumber, projectName);		
			alert(updateProject);
			//ColdFusion.navigate('project_view.cfm?projectID=0', 'projectContent');
			ColdFusion.navigate('project.cfm?projectID=0', 'template');
		}
		catch(error)
		{
			alert('error occur on function updateProject '+ error.message);	
		}
	}

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
					//location.reload('index.cfm');
					ColdFusion.navigate('index.cfm');
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

	openThisCfWindow=function(urlString, windowName, windowTitle,theHeight,theWidth)
	{
  		var windowOptions = new Object();
			//windowOptions.x=100;
			//windowOptions.y=100;
			windowOptions.height=theHeight;
			windowOptions.width=theWidth;
			windowOptions.modal=true;
			windowOptions.closable=true;
			windowOptions.draggable=true;
			windowOptions.resizable=true;
			windowOptions.center= true;

			windowOptions.refreshonshow=true;
			windowOptions.destroyonclose=true;
			windowOptions.bodystyle = 'margin-left: 0px; margin-top: 0px; padding-top: 0px; padding-left: 0px; background-color: white;'; 
			
		//ColdFusion.Window.create(windowName,windowTitle, urlString,{height:theHeight,width:theWidth,modal:true,closable:true,  draggable:true,resizable:true,center:true,initshow:true,  minheight:200,minwidth:200,destroyonclose:true})
		ColdFusion.Window.create(windowName,windowTitle, urlString,
		{
				//x: 500,
				//y: 200,
				width: theWidth,
				height: theHeight,
				destroyonclose: true,
				modal:true,
				closable: true,
				draggable: true,
				resizable: true,
				center: true,
				//initshow:true, 
				minheight:200,
				minwidth:200 ,
				bodystyle: "background-color:white; font-weight:normal; color:black; text-align:center"			
		});
	}


	closeThisCfWindow=function(windowName, url, bodyId)
	{
		if(url != '' && bodyId != '')
			ColdFusion.navigate(url, bodyId);	
			
		ColdFusion.Window.destroy(windowName);
		ColdFusion.Window.hide(windowName);
	}	

	updateDueDate=function()
	{
		try
		{
			if( document.getElementById('invoiceDate').value != '')
			{
				var e = new qpcCFC();
				e.setHTTPMethod("POST");
				var term = document.getElementById('term').value;
				var invoiceDate = document.getElementById('invoiceDate').value;
				var dueDate = e.function_addDaysToDate(invoiceDate, term);	
				document.getElementById('dueDate').value =  dueDate;				
			}
			
		}
		
		catch(error)
		{
			alert(error.message)
		}
	}	

	selectThisCustomer=function(customerId_pk)
	{
		var e = new qpcCFC();
		e.setHTTPMethod("POST");
		var theToken = document.getElementById('token').value;
		if(customerId_pk == 0)
		{
			document.getElementById('companyAddress').value = '';
			document.getElementById('companyState').value = '';
			document.getElementById('companyZip').value = '';
		}
		else
		{
			var getThisCustomerData = e.function_getThisCustomerData(customerId_pk,theToken);
			document.getElementById('companyAddress').value = getThisCustomerData[0];
			document.getElementById('companyState').value = getThisCustomerData[1];
			document.getElementById('companyZip').value = getThisCustomerData[2];		
		}
	}	
		
		
</script>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>QP Constructions, Inc.</title>

<script>
	function resetHeaderWidth()
	{
		try
		{		
			alert('before');
			document.getElementById('header1').width = document.getElementById('data1').width;
			document.getElementById('header2').width = document.getElementById('data2').width;
			alert('after');
		}
		
		catch(error)
		{
			alert('error message: '+ error.message)
		}
	}	
</script>

</head>

<body >

<table border=1>
	<tr>
		<th id="header1">header</th>
		<th id="header2">header</th>
	</tr>

</table>
<div style="border:1px solid gray; overflow:scroll; height:200px; width:373px">
	<table border=1>
		<cfloop from=1 to=200 index="i">
		<tr>
			<td id="data1" width="200px">200px</td>
			<td id="data2" width="140px">140px</td>
		</tr>
		</cfloop>
	</table>
</div>
<script>
resetHeaderWidth()
</script>	
</body>
</html>

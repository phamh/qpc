<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<style>
table.fixedHeader
{
	width: 500px;
	border-collapse: collapse;
}

table.fixedHeader thead
{
	display: blockz;
	width: 500px;
	overflow: auto;
	color: black;
	background: #000;
}

table.fixedHeader tbody
{
	display: block;
	width: 500px;
	height: 200px;
	background: pink;
	overflow: auto;
}


table.fixedHeader th, table.fixedHeader  td
{
	padding:5px;
	text-align: left;
	vertical-align: top;
	border: 1px solid #fff;
	width: 70px;
	color:red
}

table.fixedHeader th
{
	text-align:center
}
</style>
<table class="fixedHeadersw" border=1>
	<thead>
		<tr>
			<td rowspan="2">
				Header 1
			</td>
			

		</tr>
		<tr>
			<td>Header2</td>
			<td>Header2</td>
		</tr>
	</thead>
	<tbody>
		<cfloop from=1 to=100 index="i">
		<cfoutput>
		<tr>
			<td style="">#i#</td>
			<td style="">#i#</td>
			<td style="">#i#</td>
		</tr>
		</cfoutput>
		</cfloop>
	</tbody>
</table>
</body>
</html>

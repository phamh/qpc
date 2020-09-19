<cfinclude template="checkAccess.cfm">

<cfquery name="getFontsize"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		printfontsize
</cfquery>

        
<cfdocument localUrl="yes" format="PDF" margintop="#getFontsize.marginTop#" marginleft="#getFontsize.marginLeft#" marginright="#getFontsize.marginRight#" marginbottom="#getFontsize.marginBottom#">
	<cfinclude template="invoice_view.cfm" >
<!---	<cfdocumentitem type="footer" style="text-align:center; font-family:Tw Cen MT;  ">

	</cfdocumentitem>--->
</cfdocument>
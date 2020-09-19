<cfinclude template="checkAccess.cfm">
<cfquery name="getThisEstimate"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimate
	WHERE	estimateNumber =  <cfqueryparam cfsqltype="cf_sql_integer"  value=" #url.id#">
</cfquery>
<cfquery name="getFontsize"  datasource="#REQUEST.dataSource#" >
    SELECT	pdfFontSize,marginTop,marginLeft,marginRight,marginBottom,footerFontSize
	FROM		printfontsize
</cfquery>

<cfquery name="getPreparer"  datasource="#REQUEST.dataSource#" >
    SELECT	*
    FROM		userAccount
    WHERE	userAccountID_pk =  <cfqueryparam cfsqltype="cf_sql_integer"  value=" #getThisEstimate.userAccountID_fk#">
</cfquery> 
        
<cfdocument localUrl="yes" format="PDF" margintop="#getFontsize.marginTop#" marginleft="#getFontsize.marginLeft#" marginright="#getFontsize.marginRight#" marginbottom="#getFontsize.marginBottom#"> 
	<cfinclude template="estimate_view.cfm" >
	<cfdocumentitem type="footer" style="text-align:center; font-family:Tw Cen MT;  ">
<!---            <cfoutput>
                 <div style="margin-bottom:100px;margin-left:15px;font-family:Tw Cen MT; font-size:#getFontsize.footerFontSize#">
                    Sincerely,
                </div>
                
                <table border=0 style="width:100%; margin-left:10px">
                    <tr>
                            <td style="font-family:Tw Cen MT; font-size:#getFontsize.pdfFontSize#">#getPreparer.firstName# #getPreparer.lastName#</td>
                    </tr>
                      <tr>
                            <td style="font-family:Tw Cen MT; font-size:#getFontsize.pdfFontSize#"> #getPreparer.title#</td>
                    </tr>              
                      <tr>
                            <td style="font-family:Tw Cen MT; font-size:#getFontsize.pdfFontSize#"> QP Construction, Inc.</td>
                    </tr> 
                      <tr>
                            <td style="font-family:Tw Cen MT; font-size:#getFontsize.pdfFontSize#"> #getPreparer.phoneNumber#</td>
                    </tr> 
                      <tr>
                            <td style="font-family:Tw Cen MT; font-size:#getFontsize.pdfFontSize#"> #getPreparer.userName#</td>
                    </tr>                                                                                                                          
                </table>
                </cfoutput>--->
                
                <div style="text-align:center; font-family:Tw Cen MT;  margin-top:40px">
                    <b>QP Construction, Inc.</b> &bull; 503 Arch Ridge Loop &bull; Seffner, FL. 33584 &bull; Office: 727-350-5947 &bull; Fax: 877-453-7935
                </div>
			
	</cfdocumentitem>
</cfdocument>
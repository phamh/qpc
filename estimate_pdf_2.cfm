<cfquery name="getThisEstimate"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimate
	WHERE	estimateNumber = #url.id#
</cfquery>

<cfquery name="getPreparer"  datasource="#REQUEST.dataSource#" >
    SELECT	*
    FROM		userAccount
    WHERE	userAccountID_pk = '#getThisEstimate.userAccountID_fk#'
</cfquery> 
        
<cfdocument localUrl="yes" format="PDF" margintop="0.5" marginleft="0.5" marginright="0.5" marginbottom="3.3"> 
	<cfinclude template="estimate_view.cfm" >
	<cfdocumentitem type="footer" style="text-align:center; font-family:Tw Cen MT; font-size:14px; ">
                             <div style="margin-bottom:100px;margin-left:15px;font-family:Tw Cen MT; font-size:14px">
                                Sincerely,
                            </div>
            <cfoutput>
            <table border=0 style="width:100%; margin-left:10px">
                <tr>
                        <td style="font-family:Tw Cen MT; font-size:14px">#getPreparer.firstName# #getPreparer.lastName#</td>
                </tr>
                  <tr>
                        <td style="font-family:Tw Cen MT; font-size:14px"> #getPreparer.title#</td>
                </tr>              
                  <tr>
                        <td style="font-family:Tw Cen MT; font-size:14px"> QP Construction, Inc.</td>
                </tr> 
                  <tr>
                        <td style="font-family:Tw Cen MT; font-size:14px"> #getPreparer.phoneNumber#</td>
                </tr> 
                  <tr>
                        <td style="font-family:Tw Cen MT; font-size:14px"> #getPreparer.userName#</td>
                </tr>                                                                                                                          
            </table>
            </cfoutput>
            <div style="text-align:center; font-family:Tw Cen MT; font-size:14px; margin-top:40px">
            	<b>QP Construction, Inc.</b> &bull; 3350 Ulmerton Road Suite 11 &bull; Clearwater, FL. 33762 &bull; Office: 727-350-5947 &bull; Fax: 877-453-7935
            </div>
			
	</cfdocumentitem>
</cfdocument>
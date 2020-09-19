<cfinclude template="checkAccess.cfm">
<cfquery name="getEstimates" datasource="#REQUEST.dataSource#">
    SELECT 		*
    FROM		estimate
    WHERE 	deletedFlag  <>  <cfqueryparam cfsqltype="cf_sql_integer"  value="1">
</cfquery>
<cfquery name="getThisEstimateItems"  datasource="#REQUEST.dataSource#" >
    SELECT	*
	FROM		estimateScopework
</cfquery>

<div align="center" style=" text-align:center; width:100%; border:0px solid red">
    <table border="1" align="center" >
        <tr>
            <th>Estimate Number</th>
            <th>Estimate Date</th>
		<th>Expired Date</th>
            <th>Prepared By</th>
		 <th>Last Updated By</th>
		  <th>Last Updated Date</th>
            <th>Estimate Total</th>
        </tr>
        <cfset variables.total = 0>
        <cfoutput query="getEstimates">
           <cfquery name="getThisEstimateItems"  datasource="#REQUEST.dataSource#" >
                SELECT	SUM(amount) as estimateTotal
                FROM		estimateScopework
                WHERE	estimateID_fk = <cfqueryparam value="#getEstimates.estimateID_pk#" cfsqltype="cf_sql_integer">     
            </cfquery>
            <cfquery name="getPreparerName" datasource="#REQUEST.dataSource#">
                SELECT 		firstName, lastName
                FROM			userAccount
                WHERE 		userAccountID_pk  =  <cfqueryparam cfsqltype="cf_sql_integer"  value="#getEstimates.userAccountID_fk#">
            </cfquery>    
	
		<cfif getEstimates.lastUpdatedByID_fk EQ ''>
			<cfset getEstimates.lastUpdatedByID_fk = 0>
		</cfif>
            <cfquery name="getLastUpdatedBy" datasource="#REQUEST.dataSource#">
                SELECT 		firstName, lastName
                FROM			userAccount
                WHERE 		userAccountID_pk  =  <cfqueryparam cfsqltype="cf_sql_integer"  value="#getEstimates.lastUpdatedByID_fk#">
            </cfquery>  
				
		<cfif getThisEstimateItems.estimateTotal EQ ''>
			<cfset getThisEstimateItems.estimateTotal = 0>
		</cfif>
            <cfset  variables.total = variables.total + getThisEstimateItems.estimateTotal>
            <tr>
                <td>#getEstimates.estimateNumber#</td>
                <td>#dateFormat(getEstimates.estimateDate, "mmm-dd-yyyy")#</td>
		    <td>#dateFormat(DateAdd("d", EXPIREDDAYS, getEstimates.estimateDate), "mmm-dd-yyyy")#</td>
                <td>#getPreparerName.firstName# #getPreparerName.lastName#</td>
		     <td>#getLastUpdatedBy.firstName# #getLastUpdatedBy.lastName#</td>
		      <td>#dateFormat(getEstimates.lastUpdatedDate, "mmm-dd-yyyy")#</td>
                <td style="text-align:right">#DecimalFormat(getThisEstimateItems.estimateTotal)#</td>
            </tr>
        </cfoutput>
        <tr>
            <th colspan="6" style="text-align:right">Grand Total</th>
            <td style="text-align:right"><cfoutput>#DecimalFormat(variables.total)#</cfoutput></td>
        </tr>    
    </table>
    <br />
	<input type="button" value="Close" class="buttonsmall"  onclick="window.close();" >
    
</div>


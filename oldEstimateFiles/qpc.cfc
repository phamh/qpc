<cfcomponent>

<cffunction name="function_submitNewEstimate" returntype="string" access="remote">	
	<cfargument name="item" type="array">
	<cfargument name="scopeWork" type="array">
	<cfargument name="amount" type="array">
	<cfargument name="remark" type="array">

	<cfargument name="estimateNumber" type="numeric">
	<cfargument name="estimateDate" type="date">
	<cfargument name="companyName" type="string">
	<cfargument name="attention" type="string">
	<cfargument name="companyAddress" type="string">	
	<cfargument name="jobsiteAddress" type="string">
	<cfargument name="expiredDays" type="numeric">
    <cfargument name="preparedBy" type="numeric">
								
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<cfset session.newEstimateNumber = arguments.estimateNumber>
			
			<!---INSERT New Estimate ---> 
            <cfquery name="insertNewEstomate"  datasource="#REQUEST.dataSource#" >
                INSERT INTO estimate(estimateNumber, estimateDate, companyName, attention,companyAddress, jobsiteAddress, expiredDays, userAccountID_fk)
                VALUES
                (
                	<cfqueryparam value="#arguments.estimateNumber#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.estimateDate#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_char">,
                    <cfqueryparam value="#arguments.attention#" cfsqltype="cf_sql_char">,
                    <cfqueryparam value="#arguments.companyAddress#" cfsqltype="cf_sql_char">,
                    <cfqueryparam value="#arguments.jobsiteAddress#" cfsqltype="cf_sql_char">,
                    <cfqueryparam value="#arguments.expiredDays#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#arguments.preparedBy#" cfsqltype="cf_sql_integer">
                )
            </cfquery>

            <cfquery name="getLastEstimateID_PK"  datasource="#REQUEST.dataSource#" >
                SELECT  MAX(ESTIMATEID_PK) AS lastEstimateID
                FROM		estimate
            </cfquery>
                                  
            <!---INSERT New Scopework --->
            <cfloop from="1" to="#ArrayLen(item)#" index="i">
                <cfquery name="insertNewScopeWorkLineItems"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimateScopework(estimateID_fk, item, scopeWork, amount)
                    VALUES
                    (
                        <cfqueryparam value="#getLastEstimateID_PK.lastEstimateID#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="# item[i]#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#scopeWork[i]#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#amount[i]#" cfsqltype="cf_sql_float">
                    )                
                </cfquery> 
			</cfloop>

            <!---INSERT New Remark Line Items --->
            <cfloop from="1" to="#ArrayLen(remark)#" index="i">
                <cfquery name="insertNewRemarkLineItems"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimateRemark(estimateID_fk, remark)
                    VALUES
                    (
                        <cfqueryparam value="#getLastEstimateID_PK.lastEstimateID#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#remark[i]#" cfsqltype="cf_sql_char">
                    )                
                </cfquery>             
			</cfloop>
						
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn arguments.estimateNumber>
</cffunction>

<cffunction name="function_updateEstimate" returntype="string" access="remote">

	<cfargument name="estimateId" type="numeric">
	<cfargument name="estimateNumber" type="numeric">
	<cfargument name="estimateDate" type="date">
	<cfargument name="companyName" type="string">
	<cfargument name="attention" type="string">
	<cfargument name="companyAddress" type="string">	
	<cfargument name="jobsiteAddress" type="string">
	<cfargument name="expiredDays" type="numeric">
    <cfargument name="preparedBy" type="numeric">

	<cfargument name="updateTheseScopeWorkIDs" type="array">
    <cfargument name="editItem" type="array">
	<cfargument name="editScopeWork" type="array">
	<cfargument name="editAmount" type="array">
    <cfargument name="deleteTheseScopeWork" type="string">
    
	<cfargument name="updateTheseRemarkIDs" type="array">
    <cfargument name="editRemark" type="array">
     <cfargument name="deleteTheseRemark" type="string">

	<cfargument name="newItem" type="array">
	<cfargument name="newScopeWork" type="array">
	<cfargument name="newAmount" type="array">
	<cfargument name="newRemark" type="array">	
    
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<!---UPDATE Estimate ---> 
            <cfquery name="updateEstimate"  datasource="#REQUEST.dataSource#" >
                UPDATE  estimate
                SET 	estimateDate =  <cfqueryparam value="#arguments.estimateDate#" cfsqltype="cf_sql_date">,
						companyName =  <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_char">,
                        attention =  <cfqueryparam value="#arguments.attention#" cfsqltype="cf_sql_char">,
                        companyAddress =  <cfqueryparam value="#arguments.companyAddress#" cfsqltype="cf_sql_char">,
                        jobsiteAddress =  <cfqueryparam value="#arguments.jobsiteAddress#" cfsqltype="cf_sql_char">,
                        expiredDays =  <cfqueryparam value="#arguments.expiredDays#" cfsqltype="cf_sql_integer">,                              
                        userAccountID_fk =  <cfqueryparam value="#arguments.preparedBy#" cfsqltype="cf_sql_integer">
                WHERE estimateID_pk = <cfqueryparam value="#arguments.estimateId#" cfsqltype="cf_sql_integer">            
            </cfquery>			

            <!---UPDATE SCOPE WORKS --->
            <cfloop from="1" to="#ArrayLen(updateTheseScopeWorkIDs)#" index="i">
                <cfquery name="updateScopeWorkLineItems"  datasource="#REQUEST.dataSource#" >
                    UPDATE 	estimateScopework
                    SET				item = <cfqueryparam value="#arguments.editItem[i]#" cfsqltype="cf_sql_char">,
                    					scopeWork = <cfqueryparam value="#arguments.editScopeWork[i]#" cfsqltype="cf_sql_char">,
                                        amount = <cfqueryparam value="#arguments.editAmount[i]#" cfsqltype="cf_sql_float">
 					WHERE		estimateID_fk =  <cfqueryparam value="#arguments.estimateId#" cfsqltype="cf_sql_integer">    AND
                    					auto_ID =  <cfqueryparam value="#arguments.updateTheseScopeWorkIDs[i]#" cfsqltype="cf_sql_integer">
                    					         
                </cfquery> 
			</cfloop>
 
             <!---INSERT New Scopework --->
            <cfloop from="1" to="#ArrayLen(newItem)#" index="i">
                <cfquery name="insertNewScopeWorkLineItems"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimateScopework(estimateID_fk, item, scopeWork, amount)
                    VALUES
                    (
                        <cfqueryparam value="#arguments.estimateId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="# newItem[i]#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#newScopeWork[i]#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#newAmount[i]#" cfsqltype="cf_sql_float">
                    )                
                </cfquery> 
			</cfloop>
             
              <!---DELETE SCOPE WORKS --->
            <cfloop list="#deleteTheseScopeWork#" index="i">
                <cfquery name="deleteScopeWorkLineItems"  datasource="#REQUEST.dataSource#" >
                    DELETE 	FROM	estimateScopework
                    WHERE	auto_ID =  <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">                    					         
                </cfquery> 
			</cfloop>
  
            <!---UPDATE REMAKRS --->
            <cfloop from="1" to="#ArrayLen(updateTheseRemarkIDs)#" index="i">
                <cfquery name="updateRemarkLineitems"  datasource="#REQUEST.dataSource#" >
                    UPDATE 	estimateRemark
                    SET				remark = <cfqueryparam value="#arguments.editRemark[i]#" cfsqltype="cf_sql_char">
 					WHERE		estimateID_fk =  <cfqueryparam value="#arguments.estimateId#" cfsqltype="cf_sql_integer">    AND
                    					auto_ID =  <cfqueryparam value="#arguments.updateTheseRemarkIDs[i]#" cfsqltype="cf_sql_integer">
                    					         
                </cfquery> 
			</cfloop>            
 
             <!---INSERT New Remark Line Items --->
            <cfloop from="1" to="#ArrayLen(newRemark)#" index="i">
                <cfquery name="insertNewRemarkLineItems"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimateRemark(estimateID_fk, remark)
                    VALUES
                    (
                        <cfqueryparam value="#arguments.estimateId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#newRemark[i]#" cfsqltype="cf_sql_char">
                    )                
                </cfquery>             
			</cfloop>
            
             <!---DELETE REMAKRS --->
             <cfloop list="#deleteTheseRemark#" index="i">
                <cfquery name="deleteRemarkLineItems"  datasource="#REQUEST.dataSource#" >
                    DELETE 	FROM	estimateRemark
                    WHERE	auto_ID =  <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">                    					         
                </cfquery> 
			</cfloop>           
                                                      
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn session.catch.message>
</cffunction>

<cffunction name="function_deleteEstimate" returntype="string" access="remote">
	<cfargument name="estimateID_pk" type="numeric">

	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<!---Delete Estimate ---> 
                 <cfquery name="deleteEstimate"  datasource="#REQUEST.dataSource#" >
                    UPDATE	estimate
                    SET 		deletedFlag = 1
                    WHERE	estimateID_pk =  <cfqueryparam value="#arguments.estimateID_pk#" cfsqltype="cf_sql_integer">                    					         
                </cfquery> 
                
            <!---delete SCOPE WORKS --->
<!---                <cfquery name="deleteScopeWorkLineItems"  datasource="#REQUEST.dataSource#" >
                    DELETE 	FROM	estimateScopework
                    WHERE	auto_ID =  <cfqueryparam value="#arguments.estimateID_pk#" cfsqltype="cf_sql_integer">                    					         
                </cfquery>---> 
  
            <!---DELETE REMAKRS --->
<!---                <cfquery name="deleteRemarkLineItems"  datasource="#REQUEST.dataSource#" >
                    DELETE 	FROM	estimateRemark
                    WHERE	auto_ID =  <cfqueryparam value="#arguments.estimateID_pk#" cfsqltype="cf_sql_integer">                    					         
                </cfquery> --->
                                  
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn session.catch.message>
</cffunction>

<cffunction name="function_changeExpiredDateByDays_OLD" returntype="string" access="remote">
	<cfargument name="days" type="numeric">
	<cfargument name="estimateDate" type="date">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<cfset variables.newExpiredDate = dateFormat(dateAdd("d", days, estimateDate ), "mmm-dd-yyyy")>
           
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn variables.newExpiredDate>
</cffunction>

<cffunction name="function_changeExpiredDateByEstimateDate" returntype="string" access="remote">
	<cfargument name="days" type="numeric">
	<cfargument name="estimateDate" type="date">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<cfset variables.newExpiredDate = dateFormat(dateAdd("d", days, estimateDate ), "mmm-dd-yyyy")>
           
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn variables.newExpiredDate>
</cffunction>

<cffunction name="function_logout" returntype="string" access="remote">

	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>

            <cfset exists= structdelete(session, 'userName', true)/>  
            <cfset exists= structdelete(session, 'fullName', true)/>
            <cfset exists= structdelete(session, 'password', true)/>
           
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn 'I am out.'>
</cffunction>

<cffunction name="logMeIn" returntype="numeric" access="remote">
	<cfargument name="userName" type="string">
	<cfargument name="password" type="string">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
            
            <cfquery name="validateUserLogin"  datasource="#REQUEST.dataSource#" >
                SELECT	*
                FROM		userAccount
                WHERE	userName = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_char">	AND
                                password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_char">
            </cfquery>    
        
            <cfif validateUserLogin.recordCount >
                <cfset session.userName = validateUserLogin.userName>
                <cfset session.fullName = validateUserLogin.firstName   & ' ' & validateUserLogin.lastName>
                <cfset variables.isValidLogin = 1>
            <cfelse>
            	<cfset variables.isValidLogin = 0>
            </cfif>
           
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn variables.isValidLogin>
</cffunction>

<cffunction name="function_killSessions" returntype="string" access="remote">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>

            <cfset exists= structdelete(session, 'userName', true)/>  
            <cfset exists= structdelete(session, 'fullName', true)/>
           
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn 'function_killSessions is good'>
</cffunction>

<cffunction name="function_deleteThisWorksheet" returntype="string" access="remote">
	<cfargument name="worksheetId" type="numeric">
    <cfargument name="fileName" type="string">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			
            <cfquery name="deleteThisWorksheet"  datasource="#REQUEST.dataSource#" >
                DELETE FROM		worksheet
                WHERE	autoID_pk = #arguments.worksheetId#
            </cfquery>
           
            <cffile action="delete" file = "#session.uploadDocDir##arguments.fileName#">
   
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn 'function_deleteThisWorksheet is good'>
</cffunction>	
</cfcomponent>



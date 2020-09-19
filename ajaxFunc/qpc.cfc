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
    <cfargument name="estimateStatus" type="numeric">
    <cfargument name="theToken" type="string" required="yes">
								
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<cfset session.newEstimateNumber = arguments.estimateNumber>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>   
                <!---INSERT New Estimate ---> 
                <cfquery name="insertNewEstomate"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimate(estimateNumber, estimateDate, companyName, attention,companyAddress, jobsiteAddress, expiredDays, userAccountID_fk,lastUpdatedByID_fk, lastUpdatedDate,estimateStatus)
                    VALUES
                    (
                        <cfqueryparam value="#arguments.estimateNumber#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#arguments.estimateDate#" cfsqltype="cf_sql_date">,
                        <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#arguments.attention#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#arguments.companyAddress#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#arguments.jobsiteAddress#" cfsqltype="cf_sql_char">,
                        <cfqueryparam value="#arguments.expiredDays#" cfsqltype="cf_sql_integer">,
                         <cfqueryparam value="#arguments.preparedBy#" cfsqltype="cf_sql_integer">,
                         <cfqueryparam value="#session.userAccountId#" cfsqltype="cf_sql_integer">,
                         <cfqueryparam value="#createODBCDateTime(Now())#" cfsqltype="cf_sql_date">,
                         <cfqueryparam value="#arguments.estimateStatus#" cfsqltype="cf_sql_integer">
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
		</cfif>				
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn session.catch.message>
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
	<cfargument name="estimateStatus" type="numeric">	
    	<cfargument name="theToken" type="string" required="yes">
    
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>  
				<!---UPDATE Estimate ---> 
                <cfquery name="updateEstimate"  datasource="#REQUEST.dataSource#" >
                    UPDATE  estimate
                    SET 	estimateDate =  <cfqueryparam value="#arguments.estimateDate#" cfsqltype="cf_sql_date">,
                            companyName =  <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_char">,
                            attention =  <cfqueryparam value="#arguments.attention#" cfsqltype="cf_sql_char">,
                            companyAddress =  <cfqueryparam value="#arguments.companyAddress#" cfsqltype="cf_sql_char">,
                            jobsiteAddress =  <cfqueryparam value="#arguments.jobsiteAddress#" cfsqltype="cf_sql_char">,
                            expiredDays =  <cfqueryparam value="#arguments.expiredDays#" cfsqltype="cf_sql_integer">,                              
                            userAccountID_fk =  <cfqueryparam value="#arguments.preparedBy#" cfsqltype="cf_sql_integer">,
                            lastUpdatedByID_fk =  <cfqueryparam value="#session.userAccountId#" cfsqltype="cf_sql_integer">,
                            lastUpdatedDate =  <cfqueryparam value="#createODBCDateTime(Now())#" cfsqltype="cf_sql_date">,
				    estimateStatus =  <cfqueryparam value="#arguments.estimateStatus#" cfsqltype="cf_sql_integer">
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
			 
			 </cfif>            
                                      
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
    <cfargument name="theToken" type="string" required="yes">

	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = ''>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>  
					<!---Delete Estimate ---> 
                     <cfquery name="deleteEstimate"  datasource="#REQUEST.dataSource#" >
                        UPDATE	estimate
                        SET 	deletedFlag = 1
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
			 
			 </cfif>            
        
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

<cffunction name="function_duplicate" returntype="string" access="remote">
	<cfargument name="estimateNumber" type="numeric">
	<cfargument name="theToken" type="string" required="yes">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'no error'>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>  
             
                <cfquery name="getLastEstimateNumber"  datasource="#REQUEST.dataSource#" >
                    SELECT  MAX(estimateNumber) AS lastEstimateNumber
                    FROM		estimate
                </cfquery>   
                				
				<cfset variables.nextEstimateNumber = getLastEstimateNumber.lastEstimateNumber+1>

	            <!---Get Estimate --->
                <cfquery name="duplicateEstimate"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimate(estimateNumber, companyName, attention, companyAddress, jobsiteAddress, userAccountID_fk, deletedFlag, estimateStatus,estimateDate,expiredDays )
                    SELECT 		#variables.nextEstimateNumber#, companyName, attention, companyAddress, jobsiteAddress, userAccountID_fk, 0, 0, #now()#, 0
                    FROM 		estimate
                    WHERE 		estimateNumber =  <cfqueryparam value="#arguments.estimateNumber#" cfsqltype="cf_sql_integer">               
                </cfquery> 	      
                      
	            <cfquery name="getlastEstimateId"  datasource="#REQUEST.dataSource#" >
	                SELECT	estimateID_pk
	                FROM	estimate
	                WHERE	estimateNumber = <cfqueryparam value="#arguments.estimateNumber#" cfsqltype="cf_sql_integer">
	            </cfquery>  


				<cfquery name="getEstimateNumber" datasource="#REQUEST.dataSource#">
				    SELECT 		estimateNumber, estimateID_PK
				    FROM		estimate
				    ORDER BY 	estimateID_pk DESC
				    LIMIT 1
				</cfquery>

                <!---Duplicated SCOPE WORKS--->
                <cfquery name="duplicateScopeWorks"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimateScopework(estimateID_fk, item, scopeWork, amount)
                    SELECT 		#getEstimateNumber.estimateID_pk#, item, scopeWork, amount
                    FROM 		estimateScopework
                    WHERE 		estimateID_fk =  <cfqueryparam value="#getlastEstimateId.estimateID_pk#" cfsqltype="cf_sql_integer">               
                </cfquery> 	
   
                <!---Duplicated REMAKRS--->
                <cfquery name="duplicateRemarks"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO estimateRemark(estimateID_fk, remark)
                    SELECT 		#getEstimateNumber.estimateID_pk#, remark
                    FROM 		estimateRemark
                    WHERE 		estimateID_fk =  <cfqueryparam value="#getlastEstimateId.estimateID_pk#" cfsqltype="cf_sql_integer">               
                </cfquery>                 	                         
      			 
			 </cfif>            
        
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn getlastEstimateId.estimateID_pk>
</cffunction>

<cffunction name="logMeIn" returntype="numeric" access="remote">
	<cfargument name="userName" type="string">
	<cfargument name="password" type="string">
	<cfargument name="rememberUserId" type="boolean">
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'N/A'>
            
            <cfquery name="validateUserLogin"  datasource="#REQUEST.dataSource#" >
                SELECT	*
                FROM	userAccount
                WHERE	userName = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_char">	AND
                        password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_char">
            </cfquery>  
			<cfset session.validateUserLogin = validateUserLogin>
            <cfif validateUserLogin.recordCount >
                <cfset session.userName = validateUserLogin.userName>
                <cfset session.userAccountId = validateUserLogin.userAccountID_pk>
                <cfset session.fullName = validateUserLogin.firstName   & ' ' & validateUserLogin.lastName>
                <cfset variables.isValidLogin = 1>
            <cfelse>
            	<cfset variables.isValidLogin = 0>
            </cfif>
           <cfif arguments.rememberUserId>
	     		<cfcookie name="qpcUsername" value="#arguments.userName#" expires="NEVER">
		<cfelse>
			<cfcookie name="qpcUsername" value="#arguments.userName#" expires="NOW">
	     </cfif>
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
			<cflocation url="error.cfm" >
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

<cffunction name="ssnFormat"returntype="string" >
	<cfargument name="ssn" type="string" >
	<cfset tempText = ''>
	<cfif arguments.ssn NEQ ''>
		<cfset tempText = left(arguments.ssn, 3) &'-'& mid(arguments.ssn,4,2) &'-'& right(arguments.ssn,4)>  
	</cfif>
		
	<cfreturn tempText>
</cffunction>

<cffunction name="phoneFormat"returntype="string" >
	<cfargument name="phoneNumber" type="string" >
	<cfset tempText = ''>
	<cfif arguments.phoneNumber NEQ ''>
		<cfset tempText = left(arguments.phoneNumber, 3) &'-'& mid(arguments.phoneNumber,4,3) &'-'& right(arguments.phoneNumber,4)> 
	</cfif>
	<cfreturn tempText>
</cffunction>																												
														
<cffunction name="function_updateEmployee"  access="remote" returnformat="plain" returntype="string" >
	<cfargument name="employeeId_pk" type="numeric">
	<cfargument name="lastName_edit" type="string">
	<cfargument name="firstName_edit" type="string">
	<cfargument name="middleName_edit" type="string">
	<cfargument name="active_edit" type="numeric">
	<cfargument name="ssn_edit" type="string">	
	<cfargument name="dob_edit" type="string">
	<cfargument name="address_edit" type="string">
    <cfargument name="city_edit" type="string">
	<cfargument name="state_edit" type="string">
  	<cfargument name="zipCode_edit" type="string">
	<cfargument name="cellPhone_edit" type="string">
	<cfargument name="homePhone_edit" type="string">
    <cfargument name="theToken" type="string" required="yes">   
    
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'TEST'>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>  
	            <cfquery name="updateEstimate"  datasource="#REQUEST.dataSource#" >
	                UPDATE  employee
	                SET 	firstName =  <cfqueryparam value="#arguments.firstName_edit#" cfsqltype="cf_sql_char">
	                        ,lastName =  <cfqueryparam value="#arguments.lastName_edit#" cfsqltype="cf_sql_char">   
	                        ,middleName =  <cfqueryparam value="#arguments.middleName_edit#" cfsqltype="cf_sql_char">
	                        
	                        ,activeFlag =  <cfqueryparam value="#arguments.active_edit#" cfsqltype="cf_sql_integer">
	                        
	                        <cfif arguments.ssn_edit NEQ ''>
	                        	,ssn =  <cfqueryparam value="#arguments.ssn_edit#" cfsqltype="cf_sql_integer">
             				<cfelse>
             					,ssn = NULL
	                        </cfif>

	                        <cfif arguments.dob_edit NEQ ''>
	                        	,dob =  <cfqueryparam value="#arguments.dob_edit#" cfsqltype="cf_sql_date" >
             				<cfelse>
             					,dob = NULL
	                        </cfif>
	                        
	                        <cfif arguments.address_edit NEQ ''>
	                        	,address =  <cfqueryparam value="#arguments.address_edit#" cfsqltype="cf_sql_char" >
             				<cfelse>
             					,address = NULL
	                        </cfif>

	                        <cfif arguments.city_edit NEQ ''>
	                        	,city =  <cfqueryparam value="#arguments.city_edit#" cfsqltype="cf_sql_char" >
             				<cfelse>
             					,city = NULL
	                        </cfif>
	                        	                        
	                        <cfif arguments.state_edit NEQ ''>
	                        	,state =  <cfqueryparam value="#arguments.state_edit#" cfsqltype="cf_sql_char" >
             				<cfelse>
             					,state = NULL
	                        </cfif>

	                        <cfif arguments.zipCode_edit NEQ ''>
	                        	,zipCode =  <cfqueryparam value="#arguments.zipCode_edit#" cfsqltype="cf_sql_integer" >
             				<cfelse>
             					,zipCode = NULL
	                        </cfif>


	                        <cfif arguments.cellPhone_edit NEQ ''>
	                        	,cellPhone =  <cfqueryparam value="#arguments.cellPhone_edit#"  >
             				<cfelse>
             					,cellPhone = NULL
	                        </cfif>

	                        <cfif arguments.homePhone_edit NEQ ''>
	                        	,homePhone =  <cfqueryparam value="#arguments.homePhone_edit#" >
             				<cfelse>
             					,homePhone = NULL
	                        </cfif>                   	                        	                                             	                        	                        	                        	                                                	                      
	                        
	                 WHERE employeeId_pk = <cfqueryparam value="#arguments.employeeId_pk#" cfsqltype="cf_sql_integer">       
	            </cfquery>				             
			 
			 </cfif>                     
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn session.catch.message>
</cffunction>

														
<cffunction name="function_submitNewEmployee" returntype="string" access="remote">

	<cfargument name="lastName_new" type="string">
	<cfargument name="firstName_new" type="string">
	<cfargument name="middleName_new" type="string">
	<cfargument name="active_new" type="numeric">
	<cfargument name="ssn_new" type="string">	
	<cfargument name="dob_new" type="string">
	<cfargument name="address_new" type="string">
    <cfargument name="city_new" type="string">
	<cfargument name="state_new" type="string">
  	<cfargument name="zipCode_new" type="string">
	<cfargument name="cellPhone_new" type="string">
	<cfargument name="homePhone_new" type="string">
<!---    <cfargument name="fedTax_new" type="string">
    <cfargument name="stateTax_new" type="string">
	<cfargument name="ssTax_new" type="string">
    <cfargument name="medTax_new" type="string">--->
    <cfargument name="theToken" type="string" required="yes">
 
 <!---firstName, lastName, middleName,middleName,activeFlag,ssn,dob,address,city,state,zipCode,cellPhone,homePhone,fedTax,stateTax,ficaTax,medicareTax, --->   
	<cftry>
		<cftransaction>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'no error for  function function_submitNewEmployee'>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>  
                <cfquery name="insertNewEmployee"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO employee(lastName, firstName, middleName,activeFlag,ssn,dob,address,city,state,zipCode,cellPhone,homePhone)
                    VALUES
                    (
                        <cfqueryparam value="#arguments.lastName_new#" cfsqltype="cf_sql_varchar" >
                        ,<cfqueryparam value="#arguments.firstName_new#" cfsqltype="cf_sql_varchar">
                       	,<cfqueryparam value="#arguments.middleName_new#" cfsqltype="cf_sql_varchar" >
                        ,<cfqueryparam value="#arguments.active_new#" cfsqltype="cf_sql_integer">
                        
                        <cfif arguments.ssn_new NEQ ''>
                        	,<cfqueryparam value="#arguments.ssn_new#" cfsqltype="cf_sql_integer">
         				<cfelse>
         					,NULL 
                        </cfif>                       
                        
                        <cfif arguments.dob_new NEQ ''>
                        	,<cfqueryparam value="#arguments.dob_new#" cfsqltype="cf_sql_date">
         				<cfelse>
         					,NULL
                        </cfif>  
						
						,<cfqueryparam value="#arguments.address_new#" cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#arguments.city_new#" cfsqltype="cf_sql_varchar">	
						,<cfqueryparam value="#arguments.state_new#" cfsqltype="cf_sql_varchar">	

                        <cfif arguments.zipCode_new NEQ ''>
                        	,<cfqueryparam value="#arguments.zipCode_new#" cfsqltype="cf_sql_integer" >
         				<cfelse>
         					,NULL
                        </cfif>
	                        
	                        
                        <cfif arguments.cellPhone_new NEQ ''>
                        	,<cfqueryparam value="#arguments.cellPhone_new#">
         				<cfelse>
         					,NULL
                        </cfif>

                        <cfif arguments.homePhone_new NEQ ''>
                        	,<cfqueryparam value="#arguments.homePhone_new#">
         				<cfelse>
         					,NULL
                        </cfif>
<!---                        <cfif arguments.fedTax_new NEQ ''>
                        	,<cfqueryparam value="#arguments.fedTax_new#" cfsqltype="cf_sql_float">
         				<cfelse>
         					,NULL
                        </cfif>                                                

                        <cfif arguments.stateTax_new NEQ ''>
                        	,<cfqueryparam value="#arguments.stateTax_new#" cfsqltype="cf_sql_float">
         				<cfelse>
         					,NULL
                        </cfif>   

                        <cfif arguments.ssTax_new NEQ ''>
                        	,<cfqueryparam value="#arguments.ssTax_new#" cfsqltype="cf_sql_float">
         				<cfelse>
         					,NULL
                        </cfif> 
 
                        <cfif arguments.medTax_new NEQ ''>
                        	,<cfqueryparam value="#arguments.medTax_new#" cfsqltype="cf_sql_float">
         				<cfelse>
         					,NULL
                        </cfif>--->                                                                                                
                    )
                </cfquery>			             
			 
			 </cfif>                     
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>
				
	</cftry>	
	<cfreturn session.catch.message>
</cffunction>

														
<cffunction name="function_getThisCustomerData" returntype="array" access="remote">
	<cfargument name="customerId_pk" type="numeric" >
	<cfargument name="theToken" type="string" required="yes">
	<cftry>
		<cftransaction>
			
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'no error for  function function_getThisCustomerData'>
			<cfset thisCustomerDataArray = arraynew(1)>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
            <cfelse>
				 <cfquery name="query_getThisCustomerData"  datasource="#REQUEST.dataSource#" >
				    SELECT *
				    FROM 	customer
				    WHERE	customerID_pk = <cfqueryparam value="#arguments.customerId_pk#" cfsqltype="cf_sql_integer"  > 
				
				</cfquery>    
				<cfif query_getThisCustomerData.recordCount>
		            <cfset thisCustomerDataArray[1] =  query_getThisCustomerData.address>
		            <cfset thisCustomerDataArray[2] =  query_getThisCustomerData.city>
		            <cfset thisCustomerDataArray[3] =  query_getThisCustomerData.zip>
		            <cfset session.thisCustomerDataArray = thisCustomerDataArray>
		        </cfif>        
            </cfif>           
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>	
	</cftry>
	
	<cfreturn thisCustomerDataArray>
</cffunction>	

<cffunction name="function_addDaysToDate" returntype="string" access="remote">
	<cfargument name="theDate">
	<cfargument name="days" type="numeric">
	<cftry>
		<cftransaction>
			<cfset arguments.theDate = dateFormat(arguments.theDate, 'mm/dd/yyyy')>
			<cfset sesson.date = arguments.theDate>
			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'no error for  function function_addDaysToDate'>
            <cfset dueDate = dateFormat(dateAdd("d",arguments.days,arguments.theDate),'mm/dd/yyyy')>
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>	
	</cftry>
	
	<cfreturn dueDate>
</cffunction>

<cffunction name="function_addNewInvoice" returntype="string" access="remote">
	<cfargument name="invoiceNumber" type="numeric" >
	<cfargument name="customerId" type="numeric" >
	<cfargument name="term" type="numeric" >
	<cfargument name="invoiceDate" >
	<cfargument name="project" type="string" >
	<cfargument name="location" type="string" >
	<cfargument name="serviceDateListArray" type="array">
	<cfargument name="productServiceListArray" type="array">
	<cfargument name="descriptionListArray" type="array">
	<cfargument name="amountListArray" type="array">
	<cfargument name="theToken" type="string">				

	<cftry>
		<cftransaction>

			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'no error'>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse>  
<!---                <cfset serviceDateListArray = listToArray(serviceDateList)>
                <cfset productServiceListArray = listToArray(productServiceList)>
                <cfset descriptionListArray = listToArray(descriptionList)>
                <cfset amountListArray = listToArray(amountList)>--->
            
  
                  <cfquery name="insertNewEmployee"  datasource="#REQUEST.dataSource#" >
                    INSERT INTO invoice(invoiceNumber,invoiceDate,customerId_fk,term,projectName,projectLocation)
                    VALUES
                    (
                        <cfif arguments.invoiceNumber NEQ ''>
                        	<cfqueryparam value="#arguments.invoiceNumber#" cfsqltype="cf_sql_integer" >
             			<cfelse>
             				NULL 
                        </cfif>

                        <cfif arguments.invoiceDate NEQ ''>
                        	,<cfqueryparam value="#arguments.invoiceDate#" cfsqltype="cf_sql_date" >
             			<cfelse>
             				,NULL 
                        </cfif>
                         
                         <cfif arguments.customerId NEQ ''>
                        	,<cfqueryparam value="#arguments.customerId#" cfsqltype="cf_sql_integer" >
             			<cfelse>
             				,NULL 
                        </cfif>
 
                        <cfif arguments.term NEQ ''>
                        	,<cfqueryparam value="#arguments.term#" cfsqltype="cf_sql_integer" >
             			<cfelse>
             				,NULL 
                        </cfif>

                        ,<cfqueryparam value="#arguments.project#" cfsqltype="cf_sql_varchar" >
                        ,<cfqueryparam value="#arguments.location#" cfsqltype="cf_sql_varchar" >
                                                                                                                                                                                  
                    )
                </cfquery>   

				<cfquery name="getLastInvoiceNumber"  datasource="#REQUEST.dataSource#" >
				    SELECT 	invoiceId_pk
				    FROM 	invoice
					ORDER BY INVOICEID_PK	DESC
				</cfquery>
                       
            	<cfloop from="1" to="#arrayLen(serviceDateListArray)#" index="i">
 
                     <cfquery name="insertNewInvoiceItem"  datasource="#REQUEST.dataSource#" >
                        INSERT INTO invoice_item(invoiceID_fk,serviceDate,product,description,amount)
                        VALUES
                        (
                            <cfqueryparam value="#getLastInvoiceNumber.invoiceId_pk#" cfsqltype="cf_sql_integer">
	                        <cfif serviceDateListArray[i] NEQ ''>
	                        	,<cfqueryparam value="#serviceDateListArray[i]#" cfsqltype="cf_sql_date" >
	             			<cfelse>
	             				,NULL 
	                        </cfif>

	                        ,<cfqueryparam value="#productServiceListArray[i]#" cfsqltype="cf_sql_varchar" >
	                        ,<cfqueryparam value="#descriptionListArray[i]#" cfsqltype="cf_sql_varchar" >

	                        <cfif amountListArray[i] NEQ ''>
	                        	,<cfqueryparam value="#amountListArray[i]#" cfsqltype="cf_sql_float" >
	             			<cfelse>
	             				,0 
	                        </cfif>                   
                        )                
                    </cfquery> 
                               	
            	</cfloop>
            </cfif>
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>	
	</cftry>
	
	<cfreturn session.catch.message>
</cffunction>			
									
<cffunction name="function_updateThisInvoice" returntype="string" access="remote">
	<cfargument name="invoiceId_pk" type="numeric" >
	<cfargument name="customerId" type="numeric" >
	<cfargument name="term" type="numeric" >
	<cfargument name="invoiceDate" >
	<cfargument name="project" type="string" >
	<cfargument name="location" type="string" >
	<cfargument name="serviceDateArray" type="array">
	<cfargument name="productServiceArray" type="array">
	<cfargument name="descriptionArray" type="array">
	<cfargument name="amountArray" type="array">
	<cfargument name="theToken" type="string">								
	<cfargument name="amountPaid">
	<cfargument name="datePaid">		
	<cftry>
		<cftransaction>

			<cfset session.catch = StructNew()>
			<cfset session.catch.message = 'no error on function_updateThisInvoice'>
			<cfif NOT CSRFverifyToken(arguments.theToken)>
                <cfset session.catch.message = 'hacker'>
             <cfelse> 
                <cfquery name="updateTheInvoice"  datasource="#REQUEST.dataSource#" >
                    UPDATE  invoice
                    SET 	invoiceDate =  <cfqueryparam value="#arguments.invoiceDate#" cfsqltype="cf_sql_date">,
                    		customerId_fk =  <cfqueryparam value="#arguments.customerId#" cfsqltype="cf_sql_integer">,
                    		term =  <cfqueryparam value="#arguments.term#" cfsqltype="cf_sql_integer">,
                    		projectName =  <cfqueryparam value="#arguments.project#" cfsqltype="cf_sql_char">,
                    		projectLocation =  <cfqueryparam value="#arguments.location#" cfsqltype="cf_sql_char">,
                    		<cfif arguments.amountPaid NEQ ''>
                    			amountPaid =  <cfqueryparam value="#arguments.amountPaid#" cfsqltype="cf_sql_float">,
                    		</cfif>
                    		datePaid =  <cfqueryparam value="#arguments.datePaid#" cfsqltype="cf_sql_date">
                     WHERE 	invoiceId_pk = <cfqueryparam value="#arguments.invoiceId_pk#" cfsqltype="cf_sql_integer">           
                </cfquery>
                
               <cfquery name="deletetheCurrentInvoiceItesm"  datasource="#REQUEST.dataSource#" >
                	DELETE
                	FROM	invoice_item
                	WHERE	invoiceID_fk = <cfqueryparam value="#arguments.invoiceId_pk#" cfsqltype="cf_sql_integer">  
                	
                </cfquery>
                
                <cfloop from="1" to="#arrayLen(serviceDateArray)#" index="i">
	                  <cfquery name="insertNewInvoiceItem"  datasource="#REQUEST.dataSource#" >
	                    INSERT INTO invoice_item(invoiceID_fk,serviceDate,product,description,amount)
	                    VALUES
	                    (
	                        <cfqueryparam value="#arguments.invoiceId_pk#" cfsqltype="cf_sql_integer">
	                        <cfif serviceDateArray[i] NEQ ''>
	                        	,<cfqueryparam value="#serviceDateArray[i]#" cfsqltype="cf_sql_date" >
	             			<cfelse>
	             				,NULL 
	                        </cfif>
	
	                        ,<cfqueryparam value="#productServiceArray[i]#" cfsqltype="cf_sql_varchar" >
	                        ,<cfqueryparam value="#descriptionArray[i]#" cfsqltype="cf_sql_varchar" >
	
	                        <cfif amountArray[i] NEQ ''>
	                        	,<cfqueryparam value="#amountArray[i]#" cfsqltype="cf_sql_float" >
	             			<cfelse>
	             				,0 
	                        </cfif>                   
	                    )                
	                </cfquery>                	
                </cfloop>
                             	
            </cfif>
		</cftransaction>

		<cfcatch type="any">
			<cfset session.catch = cfcatch>
			<cfset session.catch.message = cfcatch.message>
		</cfcatch>	
	</cftry>
	
	<cfreturn session.catch.message>
</cffunction>

</cfcomponent>



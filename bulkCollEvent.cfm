<cfinclude template="includes/_header.cfm">
<!--------------------------------------------------------------------------------------------------->
<cfif action is "nothing">
	<cfset title = "Change Coll Event">
	<cfset showLocality=1>
	<cfset showEvent=1>
	<cfoutput>
 		<h3>Find new collecting event</h3>
		<form name="getCol" method="post" action="bulkCollEvent.cfm">
			<input type="hidden" name="Action" value="findCollEvent">
			<input type="hidden" name="collection_object_id" value="#collection_object_id#">
			<cfinclude template="/includes/frmFindLocation_guts.cfm">	   
		</form>
	</cfoutput>
</cfif>
<!------------------------------------->
<cfif action is "findCollEvent">
	<cfoutput>
		<cf_findLocality>
		<table border>
			<tr>
				<td><b>Geog ID</b></td>
				<td><b>Locality ID</b></td>
				<td><b>&nbsp;</b></td>
				<td><b>Verb. Loc</b></td>
				<td><b>Beg. Date</b></td>
				<td><b>End Date</b></td>
				<td><b>Verb. Date</b></td>
				<td><b>Source</b></td>
				<td><b>Method</b></td>
			</tr>
			<cfset i = 1>
			<cfloop query="localityResults">
				<tr>
					<td> <a href="Locality.cfm?Action=editGeog&geog_auth_rec_id=#geog_auth_rec_id#">#geog_auth_rec_id#</a></td>
					<td><a href="editLocality.cfm?locality_id=#locality_id#">#locality_id#</a></td>
					<td>
					<form name="coll#i#" method="post" action="bulkCollEvent.cfm">
						<input type="hidden" name="collection_object_id" value="#collection_object_id#">
						<input type="hidden" name="collecting_event_id" value="#collecting_event_id#">
						<input type="hidden" name="action" value="updateCollEvent">
						<input type="submit" 
							 	value="Change ALL listed specimens to this coll event" 
								class="savBtn"
		   						onmouseover="this.className='savBtn btnhov'" 
								onmouseout="this.className='savBtn'">
					</form>
					</td>
					<td>#verbatim_locality#
						<cfif #spec_locality# neq #verbatim_locality#>
							<br><strong><em>Spec. Locality:</em></strong> #spec_locality#
						</cfif>
					</td>
					<td>#began_date#</td>
					<td>#ended_date#</td>
					<td>#verbatim_date#</td>
					<td>#collecting_source#</td>
					<td>#collecting_method#</td>
				</tr>
				<cfset i=#i#+1>
			</cfloop>
		</table>
	</cfoutput>
</cfif>
<!---------------------------------------------->

<cfquery name="specimenList" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
	 SELECT 
	 	flat.collection_object_id,
	 	flat.guid, 
		concatSingleOtherId(flat.collection_object_id,'#session.CustomOtherIdentifier#') AS CustomID,
		flat.scientific_name,
		collecting_event.collecting_event_id,
		getPreferredAgentName(specimen_event.assigned_by_agent_id) assignedBy,
    	assigned_date,
		specimen_event_remark,
		specimen_event_type,
		COLLECTING_METHOD,
		COLLECTING_SOURCE,
		VERIFICATIONSTATUS,
		habitat,
		VERBATIM_DATE,
		VERBATIM_LOCALITY,
		COLL_EVENT_REMARKS,
		BEGAN_DATE,
		ENDED_DATE,
		VERBATIM_COORDINATES,
		COLLECTING_EVENT_NAME,
		spec_locality,
		higher_geog
	FROM 
		flat,
		specimen_event,
		collecting_event,
		locality,
		geog_auth_rec
	WHERE 
		flat.collection_object_id=specimen_event.collection_object_id and
		specimen_event.collecting_event_id=collecting_event.collecting_event_id and
		collecting_event.locality_id=locality.locality_id and
		locality.geog_auth_rec_id=geog_auth_rec.geog_auth_rec_id and
		flat.collection_object_id IN (#collection_object_id#)
</cfquery>
<cfquery name="spec" dbtype="query">
	select 
		collection_object_id,
	 	guid, 
		CustomID,
		scientific_name
	from
		specimenList
	group by
		collection_object_id,
	 	guid, 
		CustomID,
		scientific_name
</cfquery>
<br><b>Specimens Being Changed:</b>
<cfoutput>
	<table width="95%" border="1">
		<tr>
			<th>Specimen</th>
			<th>#session.CustomOtherIdentifier#</th>
			<th>Accepted ID</th>
			<th>Events</th>
		</tr>
		<cfloop query="spec">
			<cfquery name="thisEvents" dbtype="query">
				select 
					collecting_event_id,
					assignedBy,
		    		assigned_date,
					specimen_event_remark,
					specimen_event_type,
					COLLECTING_METHOD,
					COLLECTING_SOURCE,
					VERIFICATIONSTATUS,
					habitat,
					VERBATIM_DATE,
					VERBATIM_LOCALITY,
					COLL_EVENT_REMARKS,
					BEGAN_DATE,
					ENDED_DATE,
					VERBATIM_COORDINATES,
					COLLECTING_EVENT_NAME,
					spec_locality,
					higher_geog
				from
					specimenList
				where
					collection_object_id=#collection_object_id#
			</cfquery>
			<tr>
				<td><a href="/guid/#guid#">#guid#</a></td>	  
				<td>#CustomID#&nbsp;</td>
				<td><i>#Scientific_Name#</i></td>
				<td>
					<cfloop query="thisEvents">
						<table border>
							<tr>
								<td align="right">specimen_event_type</td>
								<td>#specimen_event_type#</td>
							</tr>
							<tr>
								<td align="right">assignedBy/Date</td>
								<td>#assignedBy# on #assigned_date#</td>
							</tr>
							<tr>
								<td align="right">specimen_event_remark</td>
								<td>#specimen_event_remark#</td>
							</tr>
							<tr>
								<td align="right">COLLECTING_METHOD</td>
								<td>#COLLECTING_METHOD#</td>
							</tr>
							<tr>
								<td align="right">COLLECTING_SOURCE</td>
								<td>#COLLECTING_SOURCE#</td>
							</tr>
							<tr>
								<td align="right">VERIFICATIONSTATUS</td>
								<td>#VERIFICATIONSTATUS#</td>
							</tr>
							<tr>
								<td align="right">habitat</td>
								<td>#habitat#</td>
							</tr>
							<tr>
								<td align="right">VERBATIM_DATE</td>
								<td>#VERBATIM_DATE# (#BEGAN_DATE#-#ENDED_DATE#)</td>
							</tr>
							<tr>
								<td align="right">VERBATIM_LOCALITY</td>
								<td>#VERBATIM_LOCALITY#</td>
							</tr>
							<tr>
								<td align="right">COLL_EVENT_REMARKS</td>
								<td>#COLL_EVENT_REMARKS#</td>
							</tr>
							<tr>
								<td align="right">VERBATIM_COORDINATES</td>
								<td>#VERBATIM_COORDINATES#</td>
							</tr>
							<tr>
								<td align="right">COLLECTING_EVENT_NAME</td>
								<td>#COLLECTING_EVENT_NAME#</td>
							</tr>
							<tr>
								<td align="right">spec_locality</td>
								<td>#spec_locality#</td>
							</tr>
							<tr>
								<td align="right">higher_geog</td>
								<td>#higher_geog#</td>
							</tr>
						</table>
					</cfloop>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
<!----------------------------------------------------------------------------------->
<cfif action is "updateCollEvent">
	deprecated<cfabort>
<cfoutput>
	<cftransaction>
		<cfloop list="#collection_object_id#" index="i">
			<cfquery name="newCollEvent" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				UPDATE cataloged_item SET collecting_event_id = #collecting_event_id# WHERE
				collection_object_id=#i#
			</cfquery>
			<cfquery name="upEd" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				UPDATE coll_object SET
					last_edited_person_id=#session.myagentid#,
					last_edit_date=sysdate
				WHERE
					collection_object_id = #i#
			</cfquery>
		</cfloop>
	</cftransaction>
	<cflocation url="bulkCollEvent.cfm?collection_object_id=#collection_object_id#">
</cfoutput>
</cfif>
<cfinclude template="includes/_footer.cfm">
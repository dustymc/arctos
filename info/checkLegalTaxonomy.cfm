<cfoutput>
	<cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select
			taxon_term.term_type,
			taxon_term.term,
			taxon_term.position_in_classification,
			#session.username#.#table_name#.guid,
			#session.username#.#table_name#.scientific_name
		from
			#session.username#.#table_name#,
			identification,
			identification_taxonomy,
			taxon_term
		where
			#session.username#.#table_name#.collection_object_id=identification.collection_object_id and
			identification.identification_id=identification_taxonomy.identification_id and
			identification_taxonomy.taxon_name_id=taxon_term.taxon_name_id and
			taxon_term.source='Arctos Legal'
	</cfquery>
	<cfdump var=#d#>

	<cfquery name="dg" dbtype="query">
		select guid,scientific_name from d group by guid,scientific_name order by guid
	</cfquery>
	<table border>
		<tr>
			<th>GUID</th>
			<th>CurrentID</th>
			<th>ArctosLegal</th>
		</tr>
		<cfloop query="dg">
			<tr>
				<td>#guid#</td>
				<td>#scientific_name#</td>
				<cfquery name="thisC" dbtype="query">
					select term_type,term,position_in_classification from d where guid='#guid#' order by position_in_classification,term_type
				</cfquery>
				<td>
					<cfloop query="thisC">
						#term_type#=#term#<br>
					</cfloop>
				</td>

			</tr>
		</cfloop>
	</table>
</cfoutput>
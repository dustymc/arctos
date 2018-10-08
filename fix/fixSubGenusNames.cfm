<cfoutput>
	<cfquery name="d" datasource="uam_god">
		select * from taxon_name where scientific_name like '%(%'
	</cfquery>
	<cfloop query="d">
		<br>#scientific_name#
		<cfset startpos=find('(',scientific_name)>
		<cfset stoppos=find(')',scientific_name)>
		<cfset theSG=mid(scientific_name,startpos+1,stoppos-startpos-1)>
		<br>theSG: #theSG#
		<!---- exists?? --->
		<cfquery name="ag1" datasource="uam_god">
			select * from taxon_name where scientific_name='#theSG#'
		</cfquery>
		<cfif ag1.recordcount is 1>
			<br>already got one, do nothing
		<cfelse>
			<br>make a name
			<!--- pull in existing classification data when we can --->
			<cfquery name="exc" datasource="uam_god">
				select * from taxon_term where source in ('Arctos','Arctos Plants') and taxon_name_id=#d.taxon_name_id# order by POSITION_IN_CLASSIFICATION
			</cfquery>
			<cfquery name="workable" datasource="uam_god">
				select distinct classification_id from exc
			</cfquery>
			<cfif workable.recordcount is not 1>
				<br>is a mess, not going here, just make the name
			<cfelse>
				<cfdump var=#exc#>
			</cfif>

		</cfif>


	</cfloop>

</cfoutput>
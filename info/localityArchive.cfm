<cfinclude template="/includes/_header.cfm">
<cfset title="Locality Archive">
<cfoutput>
	<cfif not isdefined("locality_id")>
		bad call<cfabort>
	</cfif>
	<cfquery name="d" datasource="uam_god">
		select
			locality_archive_id,
		 	locality_id,
		 	geog_auth_rec_id,
		 	spec_locality,
		 	DEC_LAT,
		 	DEC_LONG,
			MINIMUM_ELEVATION,
			MAXIMUM_ELEVATION,
			ORIG_ELEV_UNITS,
			MIN_DEPTH,
			MAX_DEPTH,
			DEPTH_UNITS,
			MAX_ERROR_DISTANCE,
			MAX_ERROR_UNITS,
			DATUM,
			LOCALITY_REMARKS,
			GEOREFERENCE_SOURCE,
			GEOREFERENCE_PROTOCOL,
			LOCALITY_NAME,
		 	md5hash(WKT_POLYGON) polyhash,
		 	whodunit,
		 	changedate
		 from locality_archive where locality_id in (  <cfqueryparam value = "#locality_id#" CFSQLType = "CF_SQL_INTEGER"
        list = "yes"
        separator = ","> )
	</cfquery>
	<cfif d.recordcount is 0>
		No archived information found.<cfabort>
	</cfif>
	<table border>
		<tr>
			<th>ChangeDate</th>
			<th>UserID</th>
			<th>LOCALITY_ID</th>
			<th>GEOG_AUTH_REC_ID</th>
			<th>SPEC_LOCALITY</th>
			<th>LOCALITY_NAME</th>
			<th>Depth</th>
			<th>Elevation</th>
			<th>DATUM</th>
			<th>Coordinates</th>
			<th>CoordError</th>
			<th>GEOREFERENCE_PROTOCOL</th>
			<th>GEOREFERENCE_SOURCE</th>
			<th>WKT(hash)</th>
			<th>LOCALITY_REMARKS</th>
		</tr>
	<cfloop list="#locality_id#" index="lid">
		<cfquery name="orig" datasource="uam_god">
			select locality_id,
		 	geog_auth_rec_id,
		 	spec_locality,
		 	DEC_LAT,
		 	DEC_LONG,
			MINIMUM_ELEVATION,
			MAXIMUM_ELEVATION,
			ORIG_ELEV_UNITS,
			MIN_DEPTH,
			MAX_DEPTH,
			DEPTH_UNITS,
			MAX_ERROR_DISTANCE,
			MAX_ERROR_UNITS,
			DATUM,
			LOCALITY_REMARKS,
			GEOREFERENCE_SOURCE,
			GEOREFERENCE_PROTOCOL,
			LOCALITY_NAME,
		 	md5hash(WKT_POLYGON) polyhash from locality where locality_id=#lid#
		</cfquery>
		<tr>
			<td>currentData</td>
			<td>-n/a-</td>
			<td>#orig.LOCALITY_ID#</td>
			<cfset lastGeoID=orig.GEOG_AUTH_REC_ID>
			<td>#orig.GEOG_AUTH_REC_ID#</td>

			<cfset lastSpecLoc=orig.SPEC_LOCALITY>
			<td>#orig.SPEC_LOCALITY#</td>


			<cfset lastLocName=orig.LOCALITY_NAME>
			<td>#orig.LOCALITY_NAME#</td>

			<cfset lastDepth="#orig.MIN_DEPTH#-#orig.MAX_DEPTH# #orig.DEPTH_UNITS#">
			<td>#lastDepth#</td>

			<cfset lastElev="#orig.MINIMUM_ELEVATION#-#orig.MAXIMUM_ELEVATION# #orig.ORIG_ELEV_UNITS#">
			<td>#lastElev#</td>

			<cfset lastDatum=orig.DATUM>
			<td>#orig.DATUM#</td>


			<cfset lastCoords="#orig.DEC_LAT#,#orig.DEC_LONG#">
			<td>#lastCoords#</td>

			<cfset lastCoordErr="#orig.MAX_ERROR_DISTANCE#,#orig.MAX_ERROR_UNITS#">
			<td>#lastCoordErr#</td>


			<cfset lastProt=orig.GEOREFERENCE_PROTOCOL>
			<td>#orig.GEOREFERENCE_PROTOCOL#</td>

			<cfset lastSrc=orig.GEOREFERENCE_SOURCE>
			<td>#orig.GEOREFERENCE_SOURCE#</td>


			<cfset lastWKT=orig.polyhash>
			<td>#lastWKT#</td>

			<cfset lastRem=orig.LOCALITY_REMARKS>
			<td>#orig.LOCALITY_REMARKS#</td>


		</tr>
		original data:
		<cfdump var=#orig#>

		<cfquery name="thisChanges" dbtype="query">
			select * from d where locality_id=#lid# order by changedate
		</cfquery>
		changes:
		<cfdump var=#thisChanges#>
	</cfloop>


	</table>


</cfoutput>
<cfinclude template="/includes/_footer.cfm">
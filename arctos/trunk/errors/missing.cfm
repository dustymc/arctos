<!--- 
	requires httpd.conf to contain ErrorDocument 404 /errors/missing.cfm 
	Allows accepting URLs of the formats:
	 .../bla/whatever/specimen/{institution}/{collection}/{catnum}
	 .../bla/whatever/guid/{institution}:{collection}:{catnum}
--->
<cfif isdefined("cgi.REDIRECT_URL") and len(cgi.REDIRECT_URL) gt 0>
	<cfoutput>
	<cfset rdurl=cgi.REDIRECT_URL>
		
		<cfloop from="1" to="#len(rdurl)#" index="i">
			<br>
			#i#:
			#mid(rdurl,i,1)#
			:
			#asc(mid(rdurl,i,1))#
		</cfloop>
		
		<cfif rdurl contains chr(195) & chr(151)>
			<cfset rdurl=replace(rdurl,chr(195) & chr(151),chr(215))>
			----------rdurl is now #rdurl#
		</cfif>
	</cfoutput>
	<cfif listfindnocase(rdurl,'specimen',"/")>
		<cftry>
			<cfset gPos=listfindnocase(rdurl,"specimen","/")>
			<cfset	i = listgetat(rdurl,gPos+1,"/")>
			<cfset	c = listgetat(rdurl,gPos+2,"/")>
			<cfset	n = listgetat(rdurl,gPos+3,"/")>
			<cfset guid=i & ":" & c & ":" & n>
			<cfinclude template="/SpecimenDetail.cfm">
			<cfcatch>
				<cfinclude template="/errors/404.cfm">
			</cfcatch>
		</cftry>
	<cfelseif listfindnocase(rdurl,'guid',"/")>
		<cftry>
			<cfset gPos=listfindnocase(rdurl,"guid","/")>
			<cfset guid = listgetat(rdurl,gPos+1,"/")>
			<cfinclude template="/SpecimenDetail.cfm">
			<cfcatch>
				<cfinclude template="/errors/404.cfm">
			</cfcatch>
		</cftry>				
	<cfelseif listfindnocase(rdurl,'name',"/")>
		<cftry>
			<cfset gPos=listfindnocase(rdurl,"name","/")>
			<cfset scientific_name = listgetat(rdurl,gPos+1,"/")>
			<cfinclude template="/TaxonomyDetails.cfm">
			<cfcatch>
				<cfinclude template="/errors/404.cfm">
			</cfcatch>
		</cftry>		
	<cfelse>
		<!--- see if we can handle the peristent 404s elegantly --->
		<cfif cgi.SCRIPT_NAME contains "/DiGIRprov/www/DiGIR.php">
			<cfheader statuscode="301" statustext="Moved permanently">
			<cfheader name="Location" value="http://arctos.database.museum/digir/DiGIR.php"> 
		</cfif>
		<cfinclude template="/errors/404.cfm">
	</cfif>
<cfelse>
	<cfinclude template="/errors/404.cfm">
</cfif>
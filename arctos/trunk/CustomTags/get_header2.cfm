<cfset institution = "">
<cfset collection = "">
<cfset header2 = "">
<cfif isdefined("attributes.collection_id") AND len (#attributes.collection_id#) gt 0>
	<cfquery name="whatColl" datasource="#Application.web_user#">
		select collection_cde, institution_acronym
		from collection where collection_id = #attributes.collection_id#
	</cfquery>
	<cfset institution = "#whatColl.institution_acronym#">
	<cfset collection = "#whatColl.collection_cde#">
<cfelse>
	<cfif isdefined("attributes.institution")>
		<cfset institution = "#attributes.institution#">
	</cfif> 
	<cfif isdefined("attributes.collection")>
		<cfset collection = "#attributes.collection#">
	</cfif>
</cfif>
<cfif len(#institution#) gt 0 and len(#collection#) gt 0>
	<cfset instColl = "#institution##collection#">
	<cfset hasHeader="UAMHerp,UAMMamm,MSBMamm,DGRMamm,KWPEnto,UAMEnto,UAMHerb">
	<cfif listfind(hasHeader,instColl)>
		<cfset header2 = "/includes/#instColl#HeaderContent.cfm">
	<cfelse>
		<cfset header = "/includes/_header.cfm">
	</cfif>
<cfelseif len(#institution#) gt 0>
	<!--- just institutional header, see if we have one --->
	<cfset hasIHeader = "UAM">
	<cfif listfind(hasIHeader,institution)>
		<cfset header2 = "/includes/#institution#HeaderContent.cfm">
	<cfelse>
		<cfset header = "/includes/_header.cfm">
	</cfif>
<cfelse>
	<cfset header = "/includes/_header.cfm">
</cfif>
<cfset URL.headerContent = "#header2#">
<cfinclude template="/includes/_header.cfm">
<!---
<cfif len(#header2#) gt 0>
	<cfinclude template="#header2#">
</cfif>
--->
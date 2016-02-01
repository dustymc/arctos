<cfinclude template="../includes/_pickHeader.cfm">
<script>
	function pt(partFld,part_name){
		opener.$('"# ' + partFld).val(part_name);
		self.close();
</script>



<cfoutput>
<cfif len(part_name) gt 0>
	<cfset search=true>
</cfif>
<form name="s" action="findPart.cfm" method="post">
	<br>Part Name: <input type="text" name="part_name" value="#part_name#">
	<br><input type="submit" value="Find Matches">
	<input type="hidden" name="search" value="true">
	<input type="hidden" name="collCde" value="#collCde#">
	<input type="hidden" name="partFld" value="#partFld#">
</form>
<cfif isdefined("search") and search is "true">
	<!--- make sure we're searching for something --->
	<cfif len(part_name) is 0>
		<cfabort>
	</cfif>
	<cfquery name="gp" datasource="uam_god">
		select
			part_name
		from
			ctspecimen_part_name,
	    	ctspecimen_part_list_order
		where
			ctspecimen_part_name.collection_cde=trim('#collCde#') and
	  		ctspecimen_part_name.part_name =  ctspecimen_part_list_order.partname (+) and
	  		upper(part_name) like '%#ucase(part_name)#%'
		order by partname, part_name
	</cfquery>
	<cfif gp.recordcount is 0>
		Nothing Found
	<cfelseif gp.recordcount is 1>
		<script>
			pt('#partFld#','#gp.part_name#');
		</script>
	<cfelse>
		<cfloop query="gp">
			<br><a href="##" onClick="pt('#partFld#','#gp.part_name#');">#part_name#</a>
		</cfloop>
	</cfif>
</cfif>
</cfoutput>
<cfinclude template="../includes/_pickFooter.cfm">
<cfoutput>
	<cfquery name="d" datasource="uam_god">
		select preferred_name from uw_agentlast group by preferred_name
	</cfquery>
	
	<cfloop query="d">
		<cfquery name="one" datasource="uam_god">
			select * from uw_agentlast where preferred_name='#preferred_name#'
		</cfquery>
		<hr>#preferred_name#
		<cfloop query="one">
			<br>#PREFERRED_NAME#
			<br>#FIRST_NAME#
			<br>#MIDDLE_NAME#
			<br>#LAST_NAME#
			<br>#ORIG#
			<br>#PREFERRED_NAME#
			
				<cfif first_name contains ",">
					<cfset pname=LAST_NAME & ' ' & MIDDLE_NAME & ' ' &  FIRST_NAME>
				<cfelse>
					<cfset pname=FIRST_NAME  & ' ' & MIDDLE_NAME & ' ' & LAST_NAME >
				</cfif>
				<cfset pname=replace(pname,',','','all')>
				<cfset pname=replace(pname,'  ',' ','all')>
				<br>pname=#pname#
			</cfloop>
					


	</cfloop>

</cfoutput>

			
	<!----------------


	<cfhttp method="head" url="http://web.corral.tacc.utexas.edu/UAF/2008_10_15/jpegs/tn_H1175660.jpg">
			<cfdump var=#cfhttp#>
			
			
			
		
	
	<cfloop query="d">
		<cfset l=listgetat(PREFERRED_NAME,1)>
		<cfquery name="f" datasource="uam_god">
			select PREFERRED_NAME from uw_split where trim(first_NAME)='#trim(l)#' group by PREFERRED_NAME
		</cfquery>
		<cfif f.recordcount is 1>
			<cfdump var=#f#>
			
			<cfquery name="u" datasource="uam_god">
				update uw_ac set orig='#f.PREFERRED_NAME#' where PREFERRED_NAME='#PREFERRED_NAME#'
			</cfquery>
			
			<!----
			
			---->
		<cfelse>
			<br>#PREFERRED_NAME#
		</cfif>
	</cfloop>	
			
	<cfquery datasource="uam_god" name="cols">
		select * from taxonomy where 1=2		
	</cfquery>
	<cfset c=cols.columnlist>
	
	<cfset c=listdeleteat(c,listfindnocase(c,"taxon_name_id"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"VALID_CATALOG_TERM_FG"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"display_name"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"scientific_name"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"author_text"))>

	<cfset c=listdeleteat(c,listfindnocase(c,"FULL_TAXON_NAME"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"INFRASPECIFIC_RANK"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"INFRASPECIFIC_AUTHOR"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"NOMENCLATURAL_CODE"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"SOURCE_AUTHORITY"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"TAXON_REMARKS"))>
	<cfset c=listdeleteat(c,listfindnocase(c,"TAXON_STATUS"))>

	<cfloop list="#c#" index="fl">
	
		<cfloop list="#c#" index="sl">
			<cfif sl is not fl>
				
				<cfquery datasource="uam_god" name="ttt">
					select #fl#,count(*) c from taxonomy where #fl#=#sl# group by #fl#
				</cfquery>
				<cfif ttt.c gt 0>
					
					<cfdump var=#ttt#>
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>	
	
		---------->
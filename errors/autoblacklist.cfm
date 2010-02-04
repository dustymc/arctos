<CFIF isdefined("CGI.HTTP_X_Forwarded_For") and len(CGI.HTTP_X_Forwarded_For) gt 0>
	<CFSET ipaddress=CGI.HTTP_X_Forwarded_For>
<CFELSEif  isdefined("CGI.Remote_Addr") and len(CGI.Remote_Addr) gt 0>
	<CFSET ipaddress=CGI.Remote_Addr>
<cfelse>
	<cfset ipaddress='unknown'>
</CFIF>
	<cftry>
		<!---
		<cfquery name="d" datasource="uam_god">
			insert into uam.blacklist (ip) values ('#trim(ipaddress)#')
		</cfquery>
		<cfset application.blacklist=listappend(application.blacklist,trim(ipaddress))>
		---->
		bl'd
		
		<cfmail subject="Autoblacklist Success" to="#Application.PageProblemEmail#" from="blacklisted@#application.fromEmail#" type="html">
			Arctos automatically blacklisted IP
			<a href="http://network-tools.com/default.asp?prog=network&host=#ipaddress#">#ipaddress#</a>
			- <a href="#application.serverRootUrl#/Admin/blacklist.cfm?action=ins&ip=#ipaddress#">blacklist</a>
			
			<p></p>
			<cfdump var="#cgi.redirect_url#">
			<cfdump var="#cgi#">
			<cfdump var="#url#">
			<cfdump var="#form#">
			<cfdump var="#session#">
		</cfmail>
		<script>
			document.getElementById('loading').innerHTML='whatever';
		</script>
		bla bla bla stuff bla
		<cfabort>
		<cfcatch>
			<cfmail subject="Autoblacklist Fail" to="#Application.PageProblemEmail#" from="blfail@#application.fromEmail#" type="html">
				Auto-blacklisting failed.
				<br>			
				A user found a dead link! The referring site was #cgi.HTTP_REFERER#.
				<cfif isdefined("CGI.script_name")>
					<br>The missing page is #Replace(CGI.script_name, "/", "")#
				</cfif>
				<cfif isdefined("cgi.REDIRECT_URL")>
					<br>cgi.REDIRECT_URL: #cgi.REDIRECT_URL#
				</cfif>
				<cfif isdefined("session.username")>
					<br>The username is #session.username#
				</cfif>
				<br>The IP requesting the dead link was <a href="http://network-tools.com/default.asp?prog=network&host=#ipaddress#">#ipaddress#</a>
				 - <a href="http://arctos.database.museum/Admin/blacklist.cfm?action=ins&ip=#ipaddress#">blacklist</a>
				<br>This message was generated by #cgi.CF_TEMPLATE_PATH#.
				<hr><cfdump var="#cgi#">
			</cfmail>
		</cfcatch>
	</cftry>
		
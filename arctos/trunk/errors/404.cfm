<cfif not isdefined("toProperCase")>
	<cfinclude template="/includes/_header.cfm">
</cfif>
<cfoutput>
	<CFIF isdefined("CGI.HTTP_X_Forwarded_For") and len(CGI.HTTP_X_Forwarded_For) gt 0>
		<CFSET ipaddress=CGI.HTTP_X_Forwarded_For>
	<CFELSEif  isdefined("CGI.Remote_Addr") and len(CGI.Remote_Addr) gt 0>
		<CFSET ipaddress=CGI.Remote_Addr>
	<cfelse>
		<cfset ipaddress='unknown'>
	</CFIF>
	<script>
		console.log(document.location.href.pathname);
	</script>
	<cfquery name="redir" datasource="cf_dbuser">
		select new_path from redirect where upper(old_path)='#ucase(cgi.redirect_url)#'
	</cfquery>
	<br>getPageContext().getRequest().getRequestURI(): #getPageContext().getRequest().getRequestURI()#--
	<br>CGI.HTTP_X_Forwarded_For: #CGI.HTTP_X_Forwarded_For#
	<br>cgi.redirect_query_string: #cgi.redirect_query_string#
	<br>#path# versus #cgi.path#
	<cfdump var="#redir#">
	<cfdump var="#cgi.redirect_url#">
	<cfdump var="#cgi#">
	<cfdump var="#Request#">
	<cfdump var="#Server#">
	url:<cfdump var="#URL#">

<br>cgi
<CFLOOP COLLECTION="#cgi#" ITEM="VarName">
  <br>#VarName#: #cgi[VarName]#
</CFLOOP>


<br>URL
<CFLOOP COLLECTION="#URL#" ITEM="VarName">
  <br>#VarName#: #URL[VarName]#
</CFLOOP>
GetPageContext
<cfdump var="#GetPageContext()#">


GetCurrentTemplatePath
<cfdump var="#GetCurrentTemplatePath()#">


<cfif cgi.redirect_url contains "/DiGIRprov/www/DiGIR.php">
	
	
	<cfheader statuscode="301" statustext="Moved permanently">
	<cfheader name="Location" value="http://arctos.database.museum/digir/DiGIR.php">	
<cfelse>
	<cfset nono="php,dll,asp,cgi,ini,config,client,webmail,roundcubemail,roundcube,HovercardLauncher,README,cube,mail,board,zboard">
	<cfloop list="#cgi.redirect_url#" delimiters="./" index="i">
		<cfif listfindnocase(nono,i)>
			<cfinclude template="/errors/autoblacklist.cfm">
			<cfabort>
		</cfif>
	</cfloop>
	<cfheader statuscode="404" statustext="Not found">
	<cfset title="404: not found">
	<h2>
		404! The page you tried to access does not exist.
	</h2>
	<script type="text/javascript">
	  var GOOG_FIXURL_LANG = 'en';
	  var GOOG_FIXURL_SITE = 'http://arctos.database.museum/';
	</script>
<script type="text/javascript" src="http://linkhelp.clients.google.com/tbproxy/lh/wm/fixurl.js"></script>
<script type="text/javascript" language="javascript">
	function changeCollection () {
		jQuery.getJSON("/component/functions.cfc",
			{
				method : "changeexclusive_collection_id",
				tgt : '',
				returnformat : "json",
				queryformat : 'column'
			},
			function (d) {
	  			document.location='#cgi.REDIRECT_URL#';
			}		
		);
	}
</script>
	<cfif len(cgi.REDIRECT_URL) gt 0 and cgi.redirect_url contains "guid" and session.dbuser is not "pub_usr_all_all">
		<cfquery name="yourcollid" datasource="cf_dbuser">
			select collection from cf_collection where DBUSERNAME='#session.dbuser#'
		</cfquery>
		<p>
			<cfif len(session.roles) gt 0 and session.roles is not "public">
				If you are an operator, you may have to log out or ask your supervisor for more access.
			</cfif>
			You are accessing Arctos through the #yourcollid.collection# portal, and cannot access specimen data in
			other collections. You may 
			<span class="likeLink" onclick="changeCollection()">try again in the public portal</span>.
		</p>
	</cfif>	
	<p>
		If you followed a link from within Arctos, please <a href="/info/bugs.cfm">submit a bug report</a>
	 	containing any information that might help us resolve this issue.
	</p>
	<p>
		If you followed an external link, please use your back button and tell the webmaster that
		something is broken, or <a href="/info/bugs.cfm">submit a bug report</a> telling us how you got this error.
	</p>
	
	<p><a href="/TaxonomySearch">Search for Taxon Names here</a></p>
	<p><a href="/SpecimenUsage">Search for Projects and Publications here</a></p>
	<p>
		If you're trying to find specimens, you may:
		<ul>
			<li><a href="/SpecimenSearch">Search for them</a></li>
			<li>Access them by URLs of the format:
				<ul>
					<li>
						#Application.serverRootUrl#/guid/{institution}:{collection}:{catnum}
						<br>Example: #Application.serverRootUrl#/guid/UAM:Mamm:1
						<br>&nbsp;
					</li>
				</ul>
			</li>
		</ul>
		Some specimens are restricted. You may <a href="/contact.cfm">contact us</a> for more information.
		<p>
			Occasionally, a specimen is recataloged. You may be able to find them by using Other Identifiers in Specimen Search.
		</p>	
	</p>
	<cfmail subject="Dead Link" to="#Application.PageProblemEmail#" from="dead.link@#application.fromEmail#" type="html">
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
		 <p>A message has been sent to the site administrator.</p>
		 <p>
		 	Use the tabs in the header to continue navigating Arctos.
		 </p>
</cfif>
</cfoutput>
<cfinclude template="/includes/_footer.cfm">